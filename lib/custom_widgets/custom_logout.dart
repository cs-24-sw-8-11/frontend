import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/main.dart';

Widget logoutManager(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Provider.of<AuthProvider>(context, listen: false).logout();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: globalButtonBackgroundColor,
          disabledBackgroundColor: globalButtonDisabledBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(color: globalTextColor),
        ),
      ),
    );
  }