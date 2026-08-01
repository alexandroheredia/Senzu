import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/screens/authentication/wrapper.dart';
import 'package:senzu_app/services/auth_service.dart';
import 'package:senzu_app/services/food_log_repository.dart';
import 'package:senzu_app/services/meal_repository.dart';
import 'package:senzu_app/services/shelf_repository.dart';
import 'package:senzu_app/shared/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        Provider<ShelfRepository>(create: (_) => ShelfRepository()),
        Provider<MealRepository>(create: (_) => MealRepository()),
        Provider<FoodLogRepository>(create: (_) => FoodLogRepository()),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges, 
              initialData: null,
        ),
      ],
      child: MaterialApp(
        home: const Wrapper(),
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: primaryButtonColor,
          scaffoldBackgroundColor: primaryBackgroundColor,
          colorScheme: const ColorScheme.dark(
            primary: primaryButtonColor,
            surface: Color(0xFF1e1f38),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: primaryBackgroundColor,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}
