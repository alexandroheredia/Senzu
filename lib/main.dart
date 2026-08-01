import 'package:firebase_auth/firebase_auth.dart';
import 'package:senzu_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:senzu_app/shared/route_generator.dart';
import 'package:senzu_app/shared/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges, 
              initialData: null,
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: primaryButtonColor,
          scaffoldBackgroundColor: primaryBackgroundColor,
          colorScheme: ColorScheme.dark(
            primary: primaryButtonColor,
            surface: const Color(0xFF1e1f38),
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