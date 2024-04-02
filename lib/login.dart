import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:frontend/input_field.dart';
import 'main.dart';

class LoginWidgetState extends State<LoginWidget> {

  bool _loginUI = true;
  // Switches between Login and Register UI
  void _toggleDisplayedUI() {
    setState(() {
      _loginUI = !_loginUI;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(179, 85, 85, 85),
          title: const Center(child: Text('Stress Handler', style: TextStyle(color: Colors.white))),
        ),
      backgroundColor: Colors.black12,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _loginUI
        ? Container(
          key: const ValueKey<int>(1),
          child: Column(
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
                    onPressed: () {},
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
                          ..onTap = _toggleDisplayedUI,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]
          )
        )
        : Container (
          key: const ValueKey<int>(2),
          child: Column(
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
                  child: ElevatedButton(
                    onPressed: _toggleDisplayedUI,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white38,
                      disabledBackgroundColor: Colors.white10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white)
                    ),
                  ),
                ), 
              ),
            ]
          )
        )
      )
    );
  }
}