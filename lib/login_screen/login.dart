import 'dart:io';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:frontend/custom_widgets/custom_input_field.dart';
import 'package:frontend/custom_widgets/global_color.dart';
import 'package:frontend/custom_widgets/custom_diag.dart';

import 'package:frontend/scripts/api_handler.dart';

import 'animation_route.dart';

import 'package:frontend/main.dart';

import 'package:frontend/login_screen/register_page_manager.dart';

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
        title: const Text('Stress Manager', style: TextStyle(color: globalTextColor)),
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
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02)),
            const Center(
              child: Text('or', style: TextStyle(color: globalButtonBackgroundColor),),
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: globalButtonBackgroundColor,
                  disabledBackgroundColor: globalButtonDisabledBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const Text('Register', style: TextStyle(color: globalTextColor)),
                onPressed: () {
                  Navigator.of(context).push(createRoute(const RegisterManager()));
                }
              ), 
            ),
          ]
        ),
      ),
    );
  }
}