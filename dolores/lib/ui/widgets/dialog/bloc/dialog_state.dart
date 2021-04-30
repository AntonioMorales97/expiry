import 'package:dolores/helpers/dolores_error.dart';
import 'package:flutter/material.dart';

@immutable
abstract class DialogState {}

class Loading extends DialogState {}

class Hiding extends DialogState {}

class Showing extends DialogState {
  final DoloresError error;

  Showing({this.error});
}
