import 'package:dolores/dolores.dart';
import 'package:dolores/environment.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initEnv();
  runApp(Dolores());
}

void _initEnv() {
  Environment.init(
    flavor: BuildFlavor.development,
    dumbledoreBaseUrl: 'http://10.0.2.2:9091',
    filtchBaseUrl: 'http://10.0.2.2:9092',
  );
}
