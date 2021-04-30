import 'package:flutter/material.dart';

class ChangePasswordDialog extends StatefulWidget {
  final String title;
  final String initOldPassword;
  final String initPassword;
  final String initRePassword;
  final String oldPasswordHint;
  final String passwordHint;
  final String rePasswordHint;
  final String submitButtonText;
  final Function(String, String, String) onSubmit;

  const ChangePasswordDialog({
    this.title,
    this.oldPasswordHint,
    this.initOldPassword,
    this.initPassword,
    this.passwordHint,
    this.rePasswordHint,
    this.submitButtonText,
    @required this.onSubmit,
    this.initRePassword,
  });

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final formKey = GlobalKey<FormState>();
  String _newOldPassword;
  String _newPassword;
  String _newRePassword;
  bool _oldObscure = true;
  bool _passObscure = true;
  bool _reObscure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      buttonPadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.only(top: 20.0),
      titlePadding: EdgeInsets.only(top: 10.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32))),
      scrollable: true,
      title: Text(
        widget.title ?? '',
        textAlign: TextAlign.center,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            obscureText: _oldObscure,
                            initialValue: widget.initOldPassword,
                            decoration: InputDecoration(
                              labelText: widget.oldPasswordHint ?? '',
                              icon: IconButton(
                                icon: Icon(Icons.visibility),
                                color: _oldObscure
                                    ? Theme.of(context).iconTheme.color
                                    : Theme.of(context).colorScheme.secondary,
                                onPressed: () {
                                  setState(() {
                                    _oldObscure = !_oldObscure;
                                  });
                                },
                              ),
                            ),
                            onSaved: (value) => _newOldPassword = value,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: _passObscure,
                      initialValue: widget.initPassword,
                      onSaved: (value) => _newPassword = value,
                      decoration: new InputDecoration(
                        labelText: widget.passwordHint ?? '',
                        icon: IconButton(
                          icon: Icon(Icons.visibility),
                          color: _passObscure
                              ? Theme.of(context).iconTheme.color
                              : Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            setState(() {
                              _passObscure = !_passObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: _reObscure,
                      initialValue: widget.initRePassword,
                      onSaved: (value) => _newRePassword = value,
                      decoration: new InputDecoration(
                        labelText: widget.rePasswordHint ?? '',
                        icon: IconButton(
                          icon: Icon(Icons.visibility),
                          color: _reObscure
                              ? Theme.of(context).iconTheme.color
                              : Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            setState(() {
                              _reObscure = !_reObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              Material(
                color: Theme.of(context).buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () {
                    formKey.currentState.save();
                    widget.onSubmit(
                        _newOldPassword, _newPassword, _newRePassword);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Text(
                      widget.submitButtonText ?? '',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          letterSpacing: 2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [],
    );
  }
}
