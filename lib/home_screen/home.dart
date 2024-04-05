import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:frontend/custom_widgets/custom_input_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;

  // Change items in list to the new different pages
  final List<Widget> _widgets = [
    Container(
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
                onPressed: () {}, //Verify login and change active UI
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
                      ..onTap = () {}, //Register user to DB here
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      )
    ),
    Container (
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
                onPressed: () {},
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
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(179, 85, 85, 85),
          title: const Center(child: Text('Stress Handler', style: TextStyle(color: Colors.white))),
          actions: [
            ElevatedButton(
              onPressed: () {Navigator.pop(context); },
              child: null,
            ),
          ],
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: _widgets.elementAt(_pageIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: _toggleDisplayedUI,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_sharp),
            label: 'Journals'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph_outlined),
            label: 'Predictions'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings'
          ),
        ],
      ),
    );
  }

  void _toggleDisplayedUI(int index) {
    setState(() {
      _pageIndex = index;
    });
  }
}