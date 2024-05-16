import 'package:flutter/material.dart';
import 'package:frontend/data_structures/user_data.dart';
import 'package:provider/provider.dart';

import 'package:frontend/data_structures/question.dart';
import 'package:frontend/data_structures/register_cache.dart';

import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/scripts/api_handler.dart';

import 'package:frontend/login_screen/register.dart';

class RegisterProvider extends ChangeNotifier {
  int rIndex = 0;
  bool state = false;
  RegisterCache registerCache = RegisterCache();

  int returnIndex() {
    return rIndex;
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

  void updateCache(PostUserData udata, int index) {
    registerCache.updateCache(udata, index);
  }

  void clearCache() {
    registerCache.clearCache();
  }

  //Remove context later
  void submitRegisterCache(BuildContext context) {
    registerCache.submitRegisterCache(context);
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
    //questions = getDefaultQuestions();
  }
  
  int _pageIndex = 0;
  late List<Question> questions;


  @override
  Widget build(BuildContext context) {
    final rpp = Provider.of<RegisterProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Handler', style: TextStyle(color: globalTextColor)),
        centerTitle: true,
        backgroundColor: globalAppBarColor,
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
        return defaultQuestion(_pageIndex);
      case 1:
        return defaultQuestion(_pageIndex);
      case 2:
        return defaultQuestion(_pageIndex);
      case 3:
        return defaultQuestion(_pageIndex);
      case 4:
        return defaultQuestion(_pageIndex);
      case 5:
        return defaultQuestion(_pageIndex);
      case 6:
        return defaultQuestion(_pageIndex);
      case 7:
        return defaultQuestion(_pageIndex);
      case 8:
        return defaultQuestion(_pageIndex);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget defaultQuestion(int index) {
    return SizedBox.shrink();
  }

//-----------------------------FUNCTION CALLS-----------------------------------


  void changePage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }
}