import 'package:flutter/material.dart';

import 'package:frontend/custom_widgets/global_color.dart';
import 'package:frontend/custom_widgets/custom_logout.dart';
import 'package:frontend/custom_widgets/custom_predicitons.dart';

import 'package:frontend/data_structures/question.dart';

import 'package:frontend/scripts/journal_con.dart';
import 'package:frontend/scripts/api_handler.dart';
import 'package:provider/provider.dart';

import 'package:frontend/main.dart';

import '../data_structures/user_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  late String _apiText;
  late String _userName;
  String meta = '';

  @override
  void initState() {
    super.initState();
    _apiText = '';
    _userName = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globalAppBarColor,
        title: const Center(
            child: Text('Stress Handler',
                style: TextStyle(color: globalTextColor))),
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
        return homePage();
      case 1:
        return journalPage();
      case 2:
        return predictionPage(context, updateApiText, _apiText);
      case 3:
        return logoutManager(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget homePage() {
    String token = Provider.of<AuthProvider>(context, listen: false).fetchToken();
    if (_userName == '') {
      awaitUserNameFuture(token);
    }
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Text('Welcome $_userName', style: const TextStyle(color: globalTextColor))
      ],
    ));
  }

  Widget journalPage() {
    return DecisionWidget(header: "Question 1/5", metatext: meta);
  }

  void awaitFuture() async {
    List<Question> questions = await getDefaultQuestions();
    setState(() => meta = questions[0].question);
    //setState(() => meta = "I was aware of the action of my heart in the absence of physical exertion (eg, sense of heart rate increase, heart missing a beat).");
  }

  void awaitUserNameFuture(String token) async {
    UserData data = await getUserData(token);
    setState(() {
      _userName = data.userName;
    });
  }

  void updateApiText(String newText) {
    setState(() {
      _apiText = newText;
    });
  }

  void changePage(int index) {
    setState(() {
      _pageIndex = index;
      if (index == 1) {
        awaitFuture();
      }
    });
  }
}
