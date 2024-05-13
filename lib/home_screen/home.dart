import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/custom_widgets/global_color.dart';
import 'package:frontend/custom_widgets/custom_logout.dart';
import 'package:frontend/custom_widgets/custom_predicitons.dart';
import 'package:frontend/custom_widgets/custom_question.dart';

import 'package:frontend/data_structures/question.dart';
import 'package:frontend/data_structures/user_data.dart';
import 'package:frontend/data_structures/cache.dart';
import 'package:frontend/data_structures/answer.dart';

import 'package:frontend/scripts/api_handler.dart';

import 'package:frontend/main.dart';

class HomePageProvider extends ChangeNotifier {
  Cache journalCache = Cache();
  int qIndex = 0;
  bool state = false;

  int returnIndex() {
    return qIndex;
  }

  void changeState() {
    state = !state;
    notifyListeners();
  }

  void incrementIndex() {
    qIndex += 1;
    notifyListeners();
  }

  void decrementIndex() {
    qIndex -= 1;
    notifyListeners();
  }

  void updateCache(PostAnswer answer, int index) {
    journalCache.updateCache(answer, index);
  }

  void clearCache() {
    journalCache.clearCache();
  }

  //Remove context later
  void submitJournalCache(BuildContext context) {
    journalCache.submitJournalCache(context);
    notifyListeners(); // Maybe keep, depends, we'll see
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
    final hpp = Provider.of<HomePageProvider>(context);
    switch (_pageIndex) {
      case 0:
        return homePage();
      case 1:
        return hpp.state ? questionPage() : journalPage();
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text('Welcome $_userName', style: const TextStyle(color: globalTextColor, fontSize: 25, fontWeight: FontWeight.bold))
        ),
        const Padding(
            padding: EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Text('This app allows you to make journals about the stress in your daily life.\n'
                'To do so, tap the Journals icon next to the Home icon.\n\n'
                'When you have made at least 3 journals, it becomes possible to calculate predictions of future stress levels.\n\n'
                'To view or perform those prediction calculations, tap on the Predictions icon.', style: TextStyle(color: globalTextColor, ))
        ),
    );
  }

  Widget journalPage() {
    final hpp = Provider.of<HomePageProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Padding(padding: EdgeInsets.only(top: 30)),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: globalButtonBackgroundColor,
              disabledBackgroundColor: globalButtonDisabledBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onPressed: () => hpp.changeState(),
            child: const Text("New Journal", style: TextStyle(color: globalTextColor)),
          )
        )
      ],
    );
  }

  Widget questionPage() {
    final hpp = Provider.of<HomePageProvider>(context);
    final int currentIndex = hpp.returnIndex();
    fetchQuestion(currentIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      questionWidgetKey.currentState?.resetState();
    });

    return QuestionWidget(
      key: questionWidgetKey,
      header: "Question ${currentIndex +1 }/5",
      metatext: meta,
      index: currentIndex,
      questionID: questions[currentIndex].id,
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
    GetUserData data = await getUserData(token);
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
