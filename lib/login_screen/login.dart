import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:frontend/login_screen/register.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:frontend/custom_widgets/custom_input_field.dart';
import 'package:frontend/custom_widgets/global_color.dart';
import 'package:frontend/custom_widgets/custom_diag.dart';

import 'package:frontend/scripts/api_handler.dart';

import 'animation_route.dart';

import 'package:frontend/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  bool isLoading = false;
  bool isTapped = false;
  
  final loginUsernameController = TextEditingController();
  final loginPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globalAppBarColor,
        title: const Center(child: Text('Stress Handler', style: TextStyle(color: globalTextColor))),
      ),
      backgroundColor: globalScaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 200),
              child: CustomInputField(
                labeltext: 'Username',
                icondata: const Icon(Icons.person_rounded, size: 18),
                txtcontroller: loginUsernameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
              child: CustomInputField(
                labeltext: 'Password',
                icondata: const Icon(Icons.lock_rounded, size: 18),
                txtcontroller: loginPasswordController,
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
                      backgroundColor: globalButtonBackgroundColor,
                      disabledBackgroundColor: globalButtonDisabledBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: !isLoading ?
                    const Text(
                      'Log In',
                      style: TextStyle(color: globalTextColor)
                    )
                    : const SpinKitSquareCircle(
                      color: globalAnimationColor,
                      size: 20,
                    ),
                    onPressed: () async { //Make this shit into its own function
                      if (!isLoading && !isTapped) {
                        isTapped = true;
                        dynamic httpResponse;
                        setState (() => isLoading = true);
                        if (context.mounted) {
                          try{
                            httpResponse = await executeLogin(loginUsernameController.text, loginPasswordController.text).timeout(const Duration (seconds:5), onTimeout: () {
                              return Response('Unable to connect!', 408);
                            });
                          }
                          on Exception catch(ex){
                            if(ex is SocketException){
                              httpResponse = Response('Unable to connect!\nHost not found or is unreachable', 408);
                            }
                            else{
                              httpResponse = Response('Unable to connect!\n${ex.runtimeType}', 408);
                            }
                          }
                        }
                        if (httpResponse.statusCode == 200) {
                          setState (() => isLoading = false);
                          if (context.mounted) {
                            Provider.of<AuthProvider>(context, listen: false).login(httpResponse.body);
                          }
                        }
                        else {
                          setState(() => isLoading = false);
                          if (context.mounted) {
                            dialogBuilder(context, 'Failed', httpResponse.body);
                          }
                        }
                        isTapped = false;
                      }
                    },
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
                        style: const TextStyle(decoration: TextDecoration.underline, color: globalUnderlineColor),
                        recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(createRoute(const RegisterScreen()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30)
            ),
          ]
        ),
      ),
    );
  }
}