import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/custom_widgets/global_color.dart';
import 'package:frontend/custom_widgets/custom_logout.dart';
import 'package:frontend/custom_widgets/custom_predicitons.dart';
import 'package:frontend/custom_widgets/custom_question.dart';

import 'package:frontend/data_structures/question.dart';
import 'package:frontend/data_structures/user_data.dart';
import 'package:frontend/data_structures/cache.dart';
import 'package:frontend/data_structures/journal_data.dart';

import 'package:frontend/scripts/api_handler.dart';

import 'package:frontend/main.dart';

class HomePageProvider extends ChangeNotifier {
  int qIndex = 0;
  Cache journalCache = Cache();

  int returnIndex() {
    return qIndex;
  }

  void incrementIndex() {
    qIndex += 1;
    notifyListeners();
  }

  void decrementIndex() {
    qIndex -= 1;
    notifyListeners();
  }

  void cacheAction(String action, JournalDataObject jdo, int index) {
    switch(action) {
      case "add":
        journalCache.cacheData(jdo);
      case "edit":
        journalCache.editCache(jdo, index);
      case "clear":
        journalCache.clearCache();
    }
  }
}

class HomeScreenProviderRoute extends StatelessWidget{
  const HomeScreenProviderRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageProvider(),
      child: const HomeScreen(),
    );
  }

}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  List<Question> questions = List.empty();
  late String _apiText;
  late String _userName;
  String meta = '';

  @override
  void initState() {
    super.initState();
    _apiText = '';
    _userName = '';
    awaitFuture();
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
    final homepageProvider = Provider.of<HomePageProvider>(context);
    switch (homepageProvider.returnIndex()) {
      case 0:
        fetchQuestion(homepageProvider.returnIndex());
        return QuestionWidget(header: "Question 1/5", metatext: meta);
      case 1:
        //fetchQuestion(homepageProvider.returnIndex());
        fetchQuestion(0);
        return QuestionWidget(header: "Question 2/5", metatext: meta);
      case 2:
        //fetchQuestion(homepageProvider.returnIndex());
        fetchQuestion(0);
        return QuestionWidget(header: "Question 3/5", metatext: meta);
      case 3:
        //fetchQuestion(homepageProvider.returnIndex());
        fetchQuestion(0);
        return QuestionWidget(header: "Question 4/5", metatext: meta);
      case 4:
        //fetchQuestion(homepageProvider.returnIndex());
        fetchQuestion(0);
        return QuestionWidget(header: "Question 5/5", metatext: meta);
      default:
        return const SizedBox.shrink();
    }
  }

  void fetchQuestion(int index) {
    setState(() => meta = questions[index].question);
  }

  void awaitFuture() async {
    questions = await getDefaultQuestions();
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
    });
  }
}
