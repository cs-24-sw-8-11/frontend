import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'custom_input_field.dart';
import 'animation_route.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 30, 30, 30),
          title: const Center(child: Text('Stress Handler', style: TextStyle(color: Colors.white))),
        ),
      backgroundColor: const Color.fromARGB(255, 55, 55, 55),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 50, right: 50, top: 200),
            child: CustomInputField(
              labeltext: 'Username',
              icondata: Icon(Icons.person_rounded, size: 18)
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 50, right: 50, top: 30),
            child: CustomInputField(
              labeltext: 'Password',
              icondata: Icon(Icons.lock_rounded, size: 18),
              hiddentext: true,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
              child: ElevatedButton(
                onPressed: () { Provider.of<AuthProvider>(context, listen: false).login(); },
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
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Register',
                      style: const TextStyle(decoration: TextDecoration.underline, color: Colors.white54),
                      recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(createRoute());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      )
    );
  }
}