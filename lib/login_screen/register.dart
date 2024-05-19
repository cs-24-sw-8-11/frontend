import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:frontend/custom_widgets/custom_diag.dart';
import 'package:frontend/custom_widgets/custom_input_field.dart';
import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/scripts/api_handler.dart';

import 'package:frontend/login_screen/register_page_manager.dart';

import 'package:frontend/main.dart';

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


  @override
  Widget build(BuildContext context) {
  final rpp = Provider.of<RegisterProvider>(context);
    return Scaffold(
      backgroundColor: globalScaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.225)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: CustomInputField(
                labeltext: 'Username',
                icondata: const Icon(Icons.person_rounded, size: 18),
                txtcontroller: registerUsernameController,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: CustomInputField(
                labeltext: 'Password',
                icondata: const Icon(Icons.lock_rounded, size: 18),
                txtcontroller: registerPasswordController,
                hiddentext: true,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: CustomInputField(
                labeltext: 'Repeat Password',
                icondata: const Icon(Icons.lock_rounded, size: 18),
                txtcontroller: registerRepeatPasswordController,
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
                    'Register',
                    style: TextStyle(color: globalTextColor),
                  )
                  : const SpinKitSquareCircle(
                    color: globalAnimationColor,
                    size: 20,
                  ),
                onPressed: () async {
                  if (registerUsernameController.text != "" && registerPasswordController.text != "" && registerRepeatPasswordController.text != "") {
                    if (!isLoading && !isTapped && (registerPasswordController.text == registerRepeatPasswordController.text)) {
                      isTapped = true;
                      dynamic httpResponse;
                      setState (() => isLoading = true);
                      if (context.mounted) {
                        httpResponse = await executeRegister(registerUsernameController.text, registerPasswordController.text);
                      }
                      if (httpResponse.statusCode == 200) {
                        if (context.mounted) {
                          Provider.of<AuthProvider>(context, listen: false).storeToken(httpResponse.body);
                          rpp.changeState();
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }
                      else {
                        setState(() => isLoading = false);
                        if (context.mounted) {
                          dialogBuilder(context, 'Failed', httpResponse.body);
                        }
                      }
                      isTapped = false;
                    }
                    else {
                      dialogBuilder(context, 'Failed', 'Passwords does not match!');
                    }
                  }
                  else {
                    dialogBuilder(context, 'Failed', 'Fields cannot be empty!');
                  }
                },
              ),
            ),
          ]
        ),
      ), 
    );
  }
}