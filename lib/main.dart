import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  // Login Logic goes here
  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StressManagementApp()
      ),
    );
  }
}

class StressManagementApp extends StatelessWidget {
  const StressManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: authProvider.isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}