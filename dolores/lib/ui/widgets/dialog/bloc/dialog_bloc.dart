import 'package:flutter_bloc/flutter_bloc.dart';

import 'dialog.dart';

class DialogBloc extends Bloc<DialogEvent, DialogState> {
  DialogBloc() : super(Showing());

  @override
  Stream<DialogState> mapEventToState(DialogEvent event) async* {
    if (event is Show) {
      yield* _mapShowToState(event);
    } else if (event is Hide) {
      yield* _mapHideToState(event);
    } else if (event is Load) {
      yield* _mapLoadToState(event);
    }
  }

  Stream<DialogState> _mapShowToState(Show event) async* {
    yield Showing(error: event.error);
  }

  Stream<DialogState> _mapHideToState(Hide event) async* {
    yield Hiding();
  }

  Stream<DialogState> _mapLoadToState(Load event) async* {
    yield Loading();
  }
}
