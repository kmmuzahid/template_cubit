import 'package:cubit_template/config/bloc/app_bloc_observer.dart';
import 'package:cubit_template/config/dependency/dependency_injection.dart';
import 'package:cubit_template/my_app..dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  Bloc.observer = AppBlocObserver();

  if (kDebugMode) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      debugPrint('Flutter error: ${details.exception}');
      return const Center(child: Text('Oops, something went wrong'));
    };
  }

  WidgetsFlutterBinding.ensureInitialized();

  await init();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

Future<void> init() async {
  _diInit();
  // await Future.wait([dotenv.load()]);
}

void _diInit() {
  final dI = DependencyInjection();
  dI.dependencies();
}
