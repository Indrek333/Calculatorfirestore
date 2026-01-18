import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/auth_wrapper.dart';
import 'firebase_options.dart';

const bool _useFirebaseEmulator =
    bool.fromEnvironment('USE_FIREBASE_EMULATOR');

Future<void> main() async {
  // Ensure that Flutter bindings are initialized before calling Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Await Firebase initialization directly.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, s) {
    // Log a more detailed error if initialization fails.
    developer.log(
      'Firebase initialization failed',
      name: 'myapp.main',
      error: e,
      stackTrace: s,
    );
  }

  // Configure emulators if needed.
  if (_useFirebaseEmulator) {
    final host = kIsWeb ? 'localhost' : '10.0.2.2';
    FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  }

  // Now that Firebase is initialized, run the app.
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = const Color(0xFF2A5298);

    // The FutureBuilder is no longer needed here.
    return MaterialApp(
      title: 'Kalkulaator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: null,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}
