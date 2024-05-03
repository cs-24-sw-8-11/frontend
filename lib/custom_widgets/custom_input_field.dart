import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget{
  final String labeltext;
  final Icon icondata;
  final bool hiddentext;
  final TextEditingController txtcontroller;

  const CustomInputField( {super.key, required this.labeltext, required this.icondata, this.hiddentext = false, required this.txtcontroller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white70),
      obscureText: hiddentext,
      controller: txtcontroller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: labeltext,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: icondata
      ),
    );
  }
}