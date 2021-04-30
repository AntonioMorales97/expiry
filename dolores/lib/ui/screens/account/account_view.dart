import 'package:dolores/helpers/status_enum.dart';
import 'package:dolores/managers/dialog_manager.dart';
import 'package:dolores/services/dialog_service.dart';
import 'package:dolores/ui/widgets/app_drawer.dart';
import 'package:dolores/ui/widgets/change_password_dialog.dart';
import 'package:dolores/ui/widgets/dialog/bloc/dialog_bloc.dart';
import 'package:dolores/ui/widgets/dialog/bloc/dialog_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../locator.dart';
import 'bloc/accounts_bloc.dart';
import 'bloc/accounts_event.dart';
import 'bloc/accounts_state.dart';

class AccountView extends StatelessWidget {
  static const routeName = 'account';
  final _dialogService = locator<DialogService>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final accountBloc = BlocProvider.of<AccountBloc>(context, listen: false);

    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        final form = formKey.currentState;
        if (state.changePassStatus == Status.Success) form.reset();
        if (state.error != null) {
          _dialogService.showDialog(
              title: "Felmedelande",
              description: state.error.detail,
              buttonTitle: "Tillbaka");
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text('Mitt konto'),
          actions: [],
        ),
        drawer: AppDrawer(active: 'accounts'),
        floatingActionButton: state.changePassStatus == Status.Loading
            ? null
            : FloatingActionButton.extended(
                label: const Text('Byt lösenord'),
                icon: Icon(Icons.lock),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BlocProvider<AccountBloc>.value(
                        value: accountBloc,
                        child: _PasswordDialogManager(
                          title: 'Byt Lösenord',
                          oldPasswordHint: 'Skriv in gamla lösenordet',
                          passwordHint: 'Skriv in det nya lösenordet',
                          rePasswordHint: 'Skriv in lösenordet igen',
                          submitButtonText: 'LÄGG TILL',
                          onSubmit:
                              (newOldPassword, newPassword, newRePassword) {
                            accountBloc.add(ChangePassword(
                                oldPassword: newOldPassword,
                                password: newPassword,
                                rePassword: newRePassword));
                          },
                        ),
                      );
                    },
                  );
                },
              ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 0, left: 5, right: 5),
          child: state.user == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Icon(Icons.account_circle_rounded,
                        size: 120,
                        color: Theme.of(context).colorScheme.secondary),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            enabled: false,
                            textInputAction: TextInputAction.next,
                            initialValue: state.user.firstName,
                            decoration: new InputDecoration(
                              labelText: 'Förnamn',
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            enabled: false,
                            textInputAction: TextInputAction.next,
                            initialValue: state.user.lastName,
                            decoration: new InputDecoration(
                              labelText: 'Efternamn',
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            enabled: false,
                            textInputAction: TextInputAction.next,
                            initialValue: state.user.email,
                            decoration: new InputDecoration(
                              labelText: 'E-postadress',
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _PasswordDialogManager extends StatefulWidget {
  final onSubmit;
  final String title;
  final String submitButtonText;
  final String oldPasswordHint;
  final String passwordHint;
  final String rePasswordHint;

  _PasswordDialogManager({
    @required this.onSubmit,
    @required this.title,
    @required this.submitButtonText,
    this.oldPasswordHint,
    this.passwordHint,
    this.rePasswordHint,
  });

  @override
  _PasswordDialogManagerState createState() => _PasswordDialogManagerState();
}

class _PasswordDialogManagerState extends State<_PasswordDialogManager> {
  String _oldPassword;
  String _password;
  String _rePassword;

  DialogBloc _dialogBloc;

  @override
  void initState() {
    super.initState();
    _dialogBloc = DialogBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _dialogBloc.close();
  }

  void setFormData(oldPassword, password, rePassword) {
    _oldPassword = oldPassword;
    _password = password;
    _rePassword = rePassword;
  }

  bool isLoading(AccountState state) {
    return state.changePassStatus == Status.Loading ||
        state.changePassStatus == Status.Loading;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.changePassStatus == Status.Success) {
          _dialogBloc.add(Hide());
        } else if (state.changePassStatus == Status.Loading) {
          _dialogBloc.add(Load());
        } else if (state.changePassStatus == Status.Fail) {
          _dialogBloc.add(Show());
        }
      },
      builder: (context, state) {
        return BlocProvider.value(
          value: _dialogBloc,
          child: DialogManager(
            child: ChangePasswordDialog(
              initOldPassword: _oldPassword,
              initPassword: _password,
              initRePassword: _rePassword,
              oldPasswordHint: widget.oldPasswordHint,
              passwordHint: widget.passwordHint,
              rePasswordHint: widget.rePasswordHint,
              title: widget.title,
              submitButtonText: widget.submitButtonText,
              onSubmit: (newOldPassword, newPassword, newRePassword) {
                setFormData(newOldPassword, newPassword, newRePassword);
                widget.onSubmit(newOldPassword, newPassword, newRePassword);
              },
            ),
          ),
        );
      },
    );
  }
}
