import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/custom_widgets/custom_iconbutton.dart';
import 'package:frontend/custom_widgets/custom_diag.dart';
import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/data_structures/user_data.dart';

import 'package:frontend/login_screen/register_page_manager.dart';

class QuestionWidget extends StatefulWidget {
  final String header;
  final String metatext;
  final int index;
  final String questionID;

  const QuestionWidget({super.key, required this.header, required this.metatext, required this.index, required this.questionID});

  @override
  State<QuestionWidget> createState() => QuestionWidgetState();
}

class QuestionWidgetState extends State<QuestionWidget>{
  TextEditingController txtController = TextEditingController();
  int qlength = 9;

  @override
  Widget build(BuildContext context) {
    RegisterProvider rpp = Provider.of<RegisterProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1)),
          SizedBox( // Question Container
            height: (MediaQuery.of(context).size.height)*0.2,
            width: (MediaQuery.of(context).size.width)*0.9,
            child: Column(
              children: [
                Center(
                  child: Text(
                    widget.header,
                    style: const TextStyle(
                      color: globalTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 28
                    )
                  )
                ),
                Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03)),
                Center(
                  child: Text(
                    widget.metatext,
                    style: const TextStyle(
                      color: globalTextColor,
                      fontSize: 16
                    )
                  )
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05)),
          // Dropdown goes here
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05)),
          SizedBox(
            width: (MediaQuery.of(context).size.width) * 0.75,
            child: Row( //Nav Buttons
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                rpp.returnIndex() != 0
                ? CustomIconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltipstring: "Back",
                  onPressed: () {
                    rpp.decrementIndex();
                  }
                )
                : const SizedBox.shrink(),
                const Spacer(),
                rpp.returnIndex() != qlength-1
                ? CustomIconButton(
                  icon: const Icon(Icons.arrow_forward),
                  tooltipstring: "Next",
                  onPressed: () {
                    if (txtController.text != "") {
                      rpp.updateCache(PostUserData(widget.questionID, txtController.text, rpp.returnIndex()));
                      rpp.incrementIndex();
                    }
                    else {
                      dialogBuilder(context, "Error", "Please give both an answer and a rating before proceeding");
                    }
                  }
                )
                : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: globalButtonBackgroundColor,
                    disabledBackgroundColor: globalButtonDisabledBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    rpp.updateCache(PostUserData(widget.questionID, txtController.text, rpp.returnIndex()));
                    rpp.submitRegisterCache(context); //remove context later
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: globalTextColor),
                  )
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget renderDropdown() { //turn into dropdown
    return TextField(
      controller: txtController,
      style: const TextStyle(color: globalTextColor),
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintStyle: TextStyle(color: globalFadedTextColor),
        hintText: "Answer",
      ),
    );
  }
}