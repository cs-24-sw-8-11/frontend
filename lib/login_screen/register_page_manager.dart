import 'package:flutter/material.dart';
import 'package:frontend/custom_widgets/custom_reg_question.dart';
import 'package:provider/provider.dart';

import 'package:frontend/data_structures/legend.dart';
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
  void submitRegisterCache(BuildContext context, String token) {
    registerCache.submitRegisterCache(context, token);
    notifyListeners();
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

  final GlobalKey<QuestionWidgetState> questionWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    awaitDefaultFuture();
    awaitAllLegendFuture();
  }
  
  String meta = '';
  List<String> legends = [];
  late List<List<LegendEntry>> completeLegend;
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
      body: rpp.state ? defaultQuestion() : const RegisterScreen()
    );
  }

  Widget defaultQuestion() {
    final rpp = Provider.of<RegisterProvider>(context);
    final int index = rpp.returnIndex();
    fetchLegend(index);
    fetchQuestion(index);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      questionWidgetKey.currentState?.resetState();
    });

    return QuestionWidget(
      key: questionWidgetKey,
      header: "Question ${index +1 }/9",
      metatext: meta,
      index: index,
      questionID: questions[index].id,
      legends: legends,
    );
  }

//-----------------------------FUNCTION CALLS-----------------------------------

  void fetchQuestion(int index) {
    setState(() => meta = questions[index].question);
  }

  void fetchLegend(int index) {
    var stringlist = createLegendStringList(index);
    setState(() => legends = stringlist);
  }

  List<String> createLegendStringList(int index) {
    List<String> legendStrings = [];

    if (index >= 0 && index < completeLegend.length) {
      List<LegendEntry> legends = completeLegend[index];
      for (var legend in legends) {
        legendStrings.add(legend.text);
      }
    } 
    return legendStrings;
  }
    
  void awaitDefaultFuture() async {
    questions = await getDefaultQuestions();
  }

  void awaitAllLegendFuture() async {
    completeLegend = await getAllLegends();
  }
}