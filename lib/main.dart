import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/database/app_database.dart';
import 'package:time_tracker/features/app/ui/page/app.dart';
import 'package:time_tracker/localization/app_localization.dart';
import 'package:time_tracker/services/locator.dart';
import 'package:time_tracker/services/shared_preference.dart';
import 'package:time_tracker/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await sharedPreference.init();
  appDatabase = AppDatabase();
  appDatabase.initDao(appDatabase);
  setupLocator();
  runApp(const AppLocalization(
    supportedLocales: [Locale('en'), Locale('ru')],
    defaultLocale: Locale('en'),
    child: App(),
  ));
}
