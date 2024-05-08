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
  List<Question> questions = List.empty();
  int _pageIndex = 0;
  String meta = '';
  late String _userName;

  final GlobalKey<QuestionWidgetState> questionWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _userName = '';
    awaitFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globalAppBarColor,
        title: const Center(
          child: Text('Stress Handler', style: TextStyle(color: globalTextColor))
        ),
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
        return const PredictionPage();
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
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text('Welcome $_userName', style: const TextStyle(color: globalTextColor, fontSize: 25, fontWeight: FontWeight.bold))
        ),

      ],
    ));
  }

  Widget journalPage() {
    final homepageProvider = Provider.of<HomePageProvider>(context);
    final int currentIndex = homepageProvider.returnIndex();
    fetchQuestion(currentIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      questionWidgetKey.currentState?.resetState();
    });

    return QuestionWidget(
      key: questionWidgetKey,
      header: "Question ${currentIndex +1 }/5",
      metatext: meta,
      index: currentIndex,
    );
  }

//-----------------------------FUNCTION CALLS-----------------------------------

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

  void changePage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }
}
