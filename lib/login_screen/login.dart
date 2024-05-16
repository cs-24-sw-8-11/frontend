import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:frontend/login_screen/register.dart';
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
        title: const Text('Stress Handler', style: TextStyle(color: globalTextColor)),
        centerTitle: true,
        backgroundColor: globalAppBarColor,
      ),
      backgroundColor: globalScaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.275)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: CustomInputField(
                labeltext: 'Username',
                icondata: const Icon(Icons.person_rounded, size: 18),
                txtcontroller: loginUsernameController,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: CustomInputField(
                labeltext: 'Password',
                icondata: const Icon(Icons.lock_rounded, size: 18),
                txtcontroller: loginPasswordController,
                hiddentext: true,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.25,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: globalButtonBackgroundColor,
                  disabledBackgroundColor: globalButtonDisabledBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: !isLoading
                ? const Text(
                  'Log In',
                  style: TextStyle(color: globalTextColor)
                )
                : const SpinKitSquareCircle(
                  color: globalAnimationColor,
                  size: 20,
                ),
                onPressed: () async {
                  print(MediaQuery.of(context).size.width);
                  if (!isLoading && !isTapped) {
                    isTapped = true;
                    dynamic httpResponse;
                    setState (() => isLoading = true);
                    if (context.mounted) {
                      httpResponse = await executeLogin(loginUsernameController.text, loginPasswordController.text);
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
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02)),
            Center(
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
          ]
        ),
      ),
    );
  }
}