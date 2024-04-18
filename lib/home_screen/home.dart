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

dynamic data;

class HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;

  // Change items in list to the new different pages
  final List<Widget> _widgets = [
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
                    data = userdata;
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
                Text('$data.userName \n$data.ageGroup \n$data.occupation \n$data.userID', style: const TextStyle(color: globalTextColor),)
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: globalNavbarColor,
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

  void changePage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }
}