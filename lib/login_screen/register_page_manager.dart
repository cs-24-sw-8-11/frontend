import 'package:flutter/material.dart';
import 'package:frontend/custom_widgets/custom_reg_question.dart';
import 'package:http/http.dart';
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

  void navigatorPop(BuildContext context) {
    Navigator.of(context).pop();
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

  Future<Response> submitRegisterCache(BuildContext context, String token) async {
    Response res = await registerCache.submitRegisterCache(context, token);
    notifyListeners();
    return res;
  }

  Future<void> storeDataIndex(List<List<LegendEntry>> completeLegend) async {
    await registerCache.storeDataIndexes(completeLegend);
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

  String meta = '';
  List<String> legends = [];
  List<List<LegendEntry>> completeLegend = [];
  List<Question> questions = [];
  bool isDataLoading = true;
  bool isLegendLoading = true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    awaitDefaultFuture();
    awaitAllLegendFuture();
    setState(() {
      isDataLoading = false;
    });
  }

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
      body: isDataLoading
      ? const Center(child: CircularProgressIndicator())
      : rpp.state ? defaultQuestion() : const RegisterScreen()
    );
  }

  Widget defaultQuestion() {
    final rpp = Provider.of<RegisterProvider>(context);
    final int index = rpp.returnIndex();

    if (isLegendLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

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

  void fetchLegend(int index) async {
    var stringlist = createLegendStringList(index);
    setState((){
      legends = stringlist;
    });
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
    final rpp = Provider.of<RegisterProvider>(context, listen: false);
    completeLegend = await getAllLegends();
    if (mounted) {
      await rpp.storeDataIndex(completeLegend);
    }
    isLegendLoading = false;
  }
}