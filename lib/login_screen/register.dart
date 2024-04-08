import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/custom_widgets/global_color.dart';
import 'dart:async';
import '../custom_widgets/custom_input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  bool isTapped = false;

  final registerUsernameController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerRepeatPasswordController = TextEditingController();

  // @override
  // void dispose() {
  //   registerUsernameController.dispose();
  //   registerPasswordController.dispose();
  //   registerRepeatPasswordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: globalAppBarColor,
          iconTheme: const IconThemeData(
            color: globalnavigatorArrowColor,
          ),
          title: const Text('Stress Handler', style: TextStyle(color: globalTextColor)),
          centerTitle: true,
        ),
      backgroundColor: globalScaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 170),
              child: CustomInputField(
                labeltext: 'Username',
                icondata: const Icon(Icons.person_rounded, size: 18),
                txtcontroller: registerUsernameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
              child: CustomInputField(
                labeltext: 'Password',
                icondata: const Icon(Icons.lock_rounded, size: 18),
                txtcontroller: registerPasswordController,
                hiddentext: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
              child: CustomInputField(
                labeltext: 'Repeat Password',
                icondata: const Icon(Icons.lock_rounded, size: 18),
                txtcontroller: registerRepeatPasswordController,
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
                        'Register',
                        style: TextStyle(color: globalTextColor),
                      )
                      : const SpinKitSquareCircle(
                        color: globalAnimationColor,
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
            const Padding(
              padding: EdgeInsets.only(top: 30)
            ),
          ]
        ),
      ), 
    );
  }
}