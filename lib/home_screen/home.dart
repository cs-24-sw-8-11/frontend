import 'package:flutter/material.dart';
import 'package:frontend/custom_widgets/global_color.dart';
import 'package:frontend/data_structures/question.dart';
import 'package:frontend/scripts/journal_con.dart';
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
  late String _apiText = '';
  String meta = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globalAppBarColor,
        title: const Center(child: Text('Stress Handler', style: TextStyle(color: globalTextColor))),
      ),
      backgroundColor: globalScaffoldBackgroundColor,
      body: _buildBody(),
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

  Widget _buildBody() {
    switch (_pageIndex) {
      case 0:
        return Container(
          key: const ValueKey<int>(1),
          child: const Center(
            child: Text('Page 1', style: TextStyle(color: globalTextColor)),
          ),
        );
      case 1:
        return tempPage();
      case 2:
        return _fetchPage();
      case 3:
        return Container(
          key: const ValueKey<int>(4),
          child: Center(
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
          ),
        );
      default:
        return Container();
    }
  }

  Widget _fetchPage() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 250),
          ),
          ElevatedButton(
            onPressed: () async {
              UserData userdata = await _fetchUserData();
              setState(() {
                _apiText = '${userdata.userName} \n${userdata.ageGroup} \n${userdata.major} \n${userdata.userID}';
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
          Text(_apiText, style: const TextStyle(color: globalTextColor)),
        ],
      ),
    );
  }

  Future<UserData> _fetchUserData() async {
    String token = Provider.of<AuthProvider>(context, listen: false).fetchToken();
    return await getUserData(token);
  }

  Widget tempPage() {
    return DecisionWidget(header: "Header text goes here", metatext: meta);
  }

  void awaitFuture() async {
    List<Question> questions = await getDefaultQuestions();
    //setState(() => meta = questions[0].question);
    setState(() => meta = "I was aware of the action of my heart in the absence of physical exertion (eg, sense of heart rate increase, heart missing a beat).");
  }

  void changePage(int index) {
    setState(() {
      _pageIndex = index;
      if(index == 1) {
        awaitFuture();
      }
    });
  }
}