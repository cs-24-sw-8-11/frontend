import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/main.dart';

import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/data_structures/user_data.dart';

import 'package:frontend/scripts/api_handler.dart';

Widget fetchPage(BuildContext context, Function(String) updateApiText, apiText) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 250),
          ),
          ElevatedButton(
            onPressed: () async {
              UserData userdata = await _fetchUserData(context);
              updateApiText('${userdata.userName} \n${userdata.ageGroup} \n${userdata.major} \n${userdata.userID}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: globalButtonBackgroundColor,
              disabledBackgroundColor: globalButtonDisabledBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: const Text('Fetch', style: TextStyle(color: globalTextColor)),
          ),
          Text(apiText, style: const TextStyle(color: globalTextColor)),
        ],
      ),
    );
  }

  Future<UserData> _fetchUserData(BuildContext context) async {
    String token = Provider.of<AuthProvider>(context, listen: false).fetchToken();
    return await getUserData(token);
  }