import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginWidget()
    );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  LoginWidgetState createState() {
    return LoginWidgetState();
  }
}

class LoginWidgetState extends State<LoginWidget> {

  //final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(179, 85, 85, 85),
          title: const Center(child: Text('Stress Handler', style: TextStyle(color: Colors.white))),
        ),
      backgroundColor: Colors.black12,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 200),
            child: TextFormField(
              style: const TextStyle(color: Colors.white70),
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your username',
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.person_rounded, size: 18)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
            child: TextFormField(
              style: const TextStyle(color: Colors.white70),
              obscureText: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your password',
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.lock_rounded, size: 18),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white38,
                  disabledBackgroundColor: Colors.white10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white)
                ),
              ),
            ), 
          ),
        ],
      )
    );
  }
}