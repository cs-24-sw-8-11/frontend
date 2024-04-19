import 'package:flutter/material.dart';
import 'package:frontend/custom_widgets/global_color.dart';
import 'package:frontend/main.dart';
import 'package:provider/provider.dart';
import 'package:frontend/scripts/api_handler.dart';
import 'package:frontend/data_structures/user_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  late TextEditingController _apitxtcontroller;
  late List<Widget> _widgets;

  @override
  void initState() {
    super.initState();
    _apitxtcontroller = TextEditingController();
    _widgets = [
      Container(
        key: const ValueKey<int>(1),
        child: const Center(
          child: Text('Page 1', style: TextStyle(color: globalTextColor))
        ),
      ),
      Container (
        key: const ValueKey<int>(2),
        child: const Center(
          child: Text('Page 2', style: TextStyle(color: globalTextColor))
        ),
      ),
      Container (
        key: const ValueKey<int>(3),
        child: Center(
          child: Builder(
            builder: (BuildContext context) {
              return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 250),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      UserData userdata = await getUserData(Provider.of<AuthProvider>(context, listen: false).fetchToken());
                      setState(() {
                        _apitxtcontroller.text = '${userdata.userName} \n${userdata.ageGroup} \n${userdata.occupation} \n${userdata.userID}';
                        });
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
                  Text(_apitxtcontroller.text, style: const TextStyle(color: globalTextColor),)
                ]
              );
            },
          ),
        ),
      ),
      Container(
        key: const ValueKey<int>(4),
        child: Center(
          child: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
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
              );
            },
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: globalAppBarColor,
          title: const Center(child: Text('Stress Handler', style: TextStyle(color: globalTextColor))),
      ),
      backgroundColor: globalScaffoldBackgroundColor,
      body: _widgets.elementAt(_pageIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: changePage,
        backgroundColor: globalNavbarColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: globalNavbarColor,
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_sharp),
            label: 'Journals',
            backgroundColor: globalNavbarColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph_outlined),
            label: 'Predictions',
            backgroundColor: globalNavbarColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
            backgroundColor: globalNavbarColor,
          ),
        ],
      ),
    );
  }

  void changePage(int index) {
    if (_pageIndex != index) {
      setState(() {
        _pageIndex = index;
      });
    } 
  }
  
  @override
  void dispose() {
    _apitxtcontroller.dispose(); // Dispose controller
    super.dispose();
  }
}