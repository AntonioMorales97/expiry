import 'package:dolores/helpers/dolores_error.dart';
import 'package:equatable/equatable.dart';

abstract class DialogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Show extends DialogEvent {
  final DoloresError error;

  Show({this.error});

  @override
  List<Object> get props => [error];
}

class Hide extends DialogEvent {}

class Load extends DialogEvent {}
