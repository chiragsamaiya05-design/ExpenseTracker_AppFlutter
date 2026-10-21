import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'auth/screens/auth_gate.dart';
import 'auth/controllers/auth_controller.dart';
import 'auth/database/user_database.dart';
import 'auth/repositories/auth_repository.dart';
import 'auth/services/auth_session.dart';
import 'auth/services/auth_api_service.dart';
import 'auth/services/auth_token_storage.dart';
import 'controllers/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite for desktop platforms.
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize the local user database.
  final userDatabase = UserDatabase();

  // Configure the FastAPI backend.
  final authApi = AuthApiService(
    baseUrl: 'http://127.0.0.1:8000/api/v1',
  );

  // Securely store the backend access token.
  final tokenStorage = AuthTokenStorage();

  // Initialize the app and inject dependencies.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(
            repository: AuthRepository(
              database: userDatabase,
              api: authApi,
              tokenStorage: tokenStorage,
            ),
            session: AuthSession(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
        ),
      ],
      child: const ExpenseTracker(),
    ),
  );
}

class ExpenseTracker extends StatelessWidget {
  const ExpenseTracker({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeController.themeMode,

      // Light theme.
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46A5),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4F46A5),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      // Dark theme.
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46A5),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF212121),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      home: const AuthGate(),
    );
  }
}