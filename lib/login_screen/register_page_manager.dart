import 'package:flutter/material.dart';
import 'package:frontend/custom_widgets/custom_reg_question.dart';
import 'package:provider/provider.dart';

import 'package:frontend/data_structures/question.dart';
import 'package:frontend/data_structures/register_cache.dart';

import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/scripts/api_handler.dart';

import 'package:frontend/main.dart';

import 'package:frontend/login_screen/register.dart';

class RegisterProvider extends ChangeNotifier {
  int rIndex = 0;
  bool state = false;
  RegisterCache registerCache = RegisterCache();

  int returnIndex() {
    return rIndex;
  }

  bool returnState() {
    return state;
  }

  void changeState() {
    state = !state;
    notifyListeners();
  }

  void incrementIndex() {
    rIndex += 1;
    notifyListeners();
  }

  void decrementIndex() {
    rIndex -= 1;
    notifyListeners();
  }

  void updateCache(String udataitem, int index) {
    registerCache.updateCache(udataitem, index);
  }

  void clearCache() {
    registerCache.clearCache();
  }

  //Remove context later
  void submitRegisterCache(BuildContext context) {
    registerCache.submitRegisterCache(context, Provider.of<AuthProvider>(context, listen: false).fetchToken());
    notifyListeners(); // Maybe keep, depends, we'll see
  }
}


class RegisterManager extends StatefulWidget {
  const RegisterManager ({super.key});

  @override
  RegisterManagerState createState() => RegisterManagerState();
}

class RegisterManagerState extends State<RegisterManager> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterProvider(),
      child: const RegisterBody(),
    );
  }
}

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  RegisterBodyState createState() => RegisterBodyState();
}

class RegisterBodyState extends State<RegisterBody> {
  @override
  void initState() {
    super.initState();
    getDefaultQuestions().then((data) {
      questions = data;
    });
  }
  
  int _pageIndex = 0;
  String meta = '';
  late List<Question> questions;

  @override
  Widget build(BuildContext context) {
    final rpp = Provider.of<RegisterProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Handler', style: TextStyle(color: globalTextColor)),
        centerTitle: true,
        backgroundColor: globalAppBarColor,
        automaticallyImplyLeading: rpp.state ? false : true,
        iconTheme: const IconThemeData(
          color: globalnavigatorArrowColor,
        ),
      ),
      backgroundColor: globalScaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: rpp.state ? _buildBody() : const RegisterScreen()
    );
  }

  Widget _buildBody() {
    switch (_pageIndex) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
        return defaultQuestion();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget defaultQuestion() {
    final rpp = Provider.of<RegisterProvider>(context);
    final int index = rpp.returnIndex();
    fetchQuestion(index);

    return QuestionWidget(
      header: "Question ${index +1 }/9",
      metatext: meta,
      index: index,
      questionID: questions[index].id,
    );
  }

//-----------------------------FUNCTION CALLS-----------------------------------

  void fetchQuestion(int index) {
      setState(() => meta = questions[index].question);
    }

  void changePage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }
}