import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen/login.dart';
import 'home_screen/home.dart';

void main() {
  runApp(const MyApp());
}

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  String token = '';

  // Login Logic goes here
  void login(String userToken) {
    token = userToken;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  String fetchToken() {
    return token;
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
      body: authProvider.isLoggedIn ? const HomeScreenProviderRoute() : const LoginScreen(),
    );
  }
}