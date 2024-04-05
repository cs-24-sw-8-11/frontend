import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'custom_input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 30, 30, 30),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text('Stress Handler', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
      backgroundColor: const Color.fromARGB(255, 55, 55, 55),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 50, right: 50, top: 170),
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
          const Padding(
            padding: EdgeInsets.only(left: 50, right: 50, top: 30),
            child: CustomInputField(
              labeltext: 'Repeat Password',
              icondata: Icon(Icons.lock_rounded, size: 18),
              hiddentext: true,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
              child: SizedBox(
                height: 34,
                width: 110,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white38,
                    disabledBackgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: !isLoading ?
                    const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    )
                    : const SpinKitSquareCircle(
                      color: Colors.white,
                      size: 20,
                    ),
                  onPressed: () async {
                    if (!isLoading && !isTapped) {
                      isTapped = true;
                      setState (() => isLoading = true);
                      await Future.delayed(const Duration(milliseconds:1000));
                      setState(() => isLoading = false);
                      await Future.delayed(const Duration(milliseconds: 500));
                      if (context.mounted) {
                        Navigator.pop(context);
                        }
                      isTapped = false;
                    }
                  },
                ),
              ) 
            ), 
          ),
        ]
      )
    );
  }
}