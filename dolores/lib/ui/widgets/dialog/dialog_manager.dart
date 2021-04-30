import 'package:dolores/ui/widgets/dialog/bloc/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DialogManager extends StatelessWidget {
  final Widget child;

  DialogManager({@required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DialogBloc, DialogState>(
      listener: (context, state) {
        if (state is Hiding) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is Loading || state is Hiding) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary),
            ),
          );
        } else {
          return child;
        }
      },
    );
  }
}
