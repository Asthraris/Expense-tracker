import 'package:flutter/material.dart';
import 'package:poorometer/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'simple_bloc_observer.dart';
import 'package:bloc/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(const Poorometer());
}
