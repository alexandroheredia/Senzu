import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/screens/authentication/wrapper.dart';
import 'package:senzu_app/shared/design/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load .env before anything reads a config value (e.g. GEMINI_API_KEY).
  await dotenv.load();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Senzu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      // Wrapper switches on the auth state; the signed-in user's repositories
      // are exposed to every route via the derived userRepositoriesProvider.
      home: const Wrapper(),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}
