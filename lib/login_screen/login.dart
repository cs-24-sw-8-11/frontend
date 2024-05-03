import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'animation_route.dart';
import '../custom_widgets/custom_input_field.dart';
import '../custom_widgets/global_color.dart';
import '../scripts/api_handler.dart';
import '../main.dart';
import '../custom_widgets/custom_diag.dart';

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
                          httpResponse = await executeLogin(loginUsernameController.text, loginPasswordController.text);
                        }
                        if (httpResponse.statusCode == 200) {
                          await Future.delayed(const Duration(milliseconds: 1000));
                          setState (() => isLoading = false);
                          await Future.delayed(const Duration(milliseconds: 100));
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
                          Navigator.of(context).push(createRoute());
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