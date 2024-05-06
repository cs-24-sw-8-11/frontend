import 'package:flutter/material.dart';

import 'package:frontend/custom_widgets/global_color.dart';
import 'package:frontend/custom_widgets/custom_logout.dart';
import 'package:frontend/custom_widgets/custom_predicitons.dart';

import 'package:frontend/data_structures/question.dart';

import 'package:frontend/custom_widgets/custom_question.dart';
import 'package:frontend/scripts/api_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  int _qIndex = 0;
  List<Question> questions = List.empty();
  late String _apiText;
  String meta = '';

  @override
  void initState() {
    super.initState();
    _apiText = '';
    awaitFuture();
  }

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
        return const Center(
          child: Text('Page 1', style: TextStyle(color: globalTextColor)),
        );
      case 1:
        return journalPage(context);
      case 2:
        return fetchPage(context, updateApiText, _apiText);
      case 3:
        return logoutManager(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget journalPage(BuildContext context) {
    switch (_qIndex) {
      case 0:
        fetchQuestion(_qIndex);
        return QuestionWidget(header: "Question 1/5", metatext: meta, parentcontext: context);
      case 1:
        fetchQuestion(_qIndex);
        return QuestionWidget(header: "Question 2/5", metatext: meta, parentcontext: context);
      case 2:
        fetchQuestion(_qIndex);
        return QuestionWidget(header: "Question 3/5", metatext: meta, parentcontext: context);
      case 3:
        fetchQuestion(_qIndex);
        return QuestionWidget(header: "Question 4/5", metatext: meta, parentcontext: context);
      case 4:
        fetchQuestion(_qIndex);
        return QuestionWidget(header: "Question 5/5", metatext: meta, parentcontext: context);
      default:
        return const SizedBox.shrink();
    }
  }

  void updateIndex(int value) {
    _qIndex = value;
  }

  void fetchQuestion(int index) {
    setState(() => meta = questions[index].question);
  }

  void awaitFuture() async {
    questions = await getDefaultQuestions();
  }

  void updateApiText(String newText) {
    setState(() {
      _apiText = newText;
    });
  }

  void changePage(int index) {
    setState(() {
      _pageIndex = index;
      if(index == 1) {
        
      }
    });
  }
}