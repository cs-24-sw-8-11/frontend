import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:frontend/custom_widgets/global_color.dart';
import 'package:frontend/custom_widgets/custom_logout.dart';
import 'package:frontend/custom_widgets/custom_predictions.dart';
import 'package:frontend/custom_widgets/custom_journal.dart';

import 'package:frontend/data_structures/question.dart';
import 'package:frontend/data_structures/user_data.dart';
import 'package:frontend/data_structures/journal_cache.dart';
import 'package:frontend/data_structures/answer.dart';

import 'package:frontend/scripts/api_handler.dart';

import 'package:frontend/main.dart';

class HomePageProvider extends ChangeNotifier {
  JournalCache journalCache = JournalCache();
  int qIndex = 0;
  bool state = false;

  int returnIndex() {
    return qIndex;
  }

  void changeState() {
    state = !state;
    notifyListeners();
  }

  void resetState() {
    state = false;
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
    qIndex = 0;
  }

  Future<Response> submitJournalCache(BuildContext context, String token) async {
    Response res = await journalCache.submitJournalCache(context, token);
    notifyListeners();
    return res;
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
  List<Question> questions = [];
  int _pageIndex = 0;
  String meta = '';
  String _userName = '';
  int journalCount = 0;
  bool _isLoadingJournals = true;
  bool _isLoadingHome = true;

  final GlobalKey<JournalWidgetState> journalWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (_pageIndex == 1) {
      awaitJournalQuestions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globalAppBarColor,
        title: const Center(
          child: Text('Stress Manager', style: TextStyle(color: globalTextColor))
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

    if (_isLoadingHome) {
      return const Center(
        child: CircularProgressIndicator()
      );
    }
    
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02)),
          Text('Welcome $_userName', style: const TextStyle(color: globalTextColor, fontSize: 25, fontWeight: FontWeight.bold)),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05)),
          SizedBox(
            width: (MediaQuery.of(context).size.width * 0.9),
            child: Text(homePageTextBody(), style: const TextStyle(color: globalTextColor)),
          )
        ]
      )
    );
  }

  Widget journalPage() {
    final hpp = Provider.of<HomePageProvider>(context);

    if (_isLoadingJournals) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05)),
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
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02)),
          Center(
            child: Text('Current journal count: $journalCount', style: const TextStyle(color: globalTextColor)),
          ),
        ],
      ),
    );
  }

  Widget questionPage() {
    final hpp = Provider.of<HomePageProvider>(context);
    final int currentIndex = hpp.returnIndex();

    fetchQuestion(currentIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      journalWidgetKey.currentState?.resetState();
    });

    return JournalWidget(
      key: journalWidgetKey,
      header: "Question ${currentIndex +1 }/5",
      metatext: meta,
      index: currentIndex,
      questionID: questions[currentIndex].id,
      resetQuestionsCallback: resetQuestionsAndFetch,
    );
  }

  //-----------------------------FUNCTION CALLS-----------------------------------
  
  void fetchQuestion(int index) {
    setState(() => meta = questions[index].question);
  }

  void awaitUserNameFuture(String token) async {
    setState(() {
      _isLoadingHome = true;
    });
    
    GetUserData data = await getUserData(token);
    _userName = data.userName;
    
    setState(() {
      _isLoadingHome = false;
    });
  }

  void changePage(int index) {
    Provider.of<HomePageProvider>(context, listen: false).resetState();
    if (index == 1) {
      resetQuestions();
      awaitJournalQuestions();
    }
    
    setState(() {
      _pageIndex = index;
    });
  }

  void awaitJournalQuestions({bool flag = true}) async {
    if(flag) {
      setState(() {
        _isLoadingJournals = true;
      });
    }
    
    // questions = await getDefaultQuestions();
    questions = await getTaggedQuestions('test');
    if (mounted) {
      journalCount = await getJournalCount(Provider.of<AuthProvider>(context, listen: false).fetchToken());
    }
    
    if(flag) {
      setState(() {
        _isLoadingJournals = false;
      });
    }
  }

  void resetQuestions({bool flag = true}) {
    questions = [];
    if (flag) {
      setState(() {
        _isLoadingJournals = true;
      });
    }
  }

  void resetQuestionsAndFetch() {
    resetQuestions(flag: false);
    awaitJournalQuestions(flag: false);
  }

  String homePageTextBody() {
    return "This app allows you to make journals about the stress in your daily life.\nTo do so, tap the Journals icon next to the Home icon.\n\nWhen you have made at least 3 journals, it becomes possible to calculate predictions of future stress levels.\n\nTo view or perform those prediction calculations, tap on the Predictions icon.";
  }
}