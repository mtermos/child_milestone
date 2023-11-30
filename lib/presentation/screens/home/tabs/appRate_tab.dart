// ignore: file_names
import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/rating.dart';
import 'package:child_milestone/data/models/rating_questions.dart';
import 'package:child_milestone/logic/blocs/rating/rating_bloc.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/components/custom_dialog.dart';
import 'package:child_milestone/data/data_providers/ratings_items_list.dart';
import 'package:child_milestone/presentation/screens/home/tabs/rating_questions/group1.dart';
import 'package:child_milestone/presentation/screens/home/tabs/rating_questions/group2.dart';
import 'package:child_milestone/presentation/screens/home/tabs/rating_questions/group3.dart';
import 'package:child_milestone/presentation/screens/home/tabs/rating_questions/welcome.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:loading_indicator/loading_indicator.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppRateTab extends StatefulWidget {
  const AppRateTab({Key? key}) : super(key: key);

  @override
  _AppRateState createState() => _AppRateState();
}

class _AppRateState extends State<AppRateTab> {
  List<RatingModel> ratingsList = [
    RatingModel(
        ratingId: 1,
        rating: 0,
        multipleRatings: "",
        additionalText: "",
        uploaded: false,
        takenAt: DateTime.now()),
    RatingModel(
        ratingId: 2,
        rating: 0,
        multipleRatings: "",
        additionalText: "",
        uploaded: false,
        takenAt: DateTime.now()),
    RatingModel(
        ratingId: 3,
        rating: 0,
        multipleRatings: "",
        additionalText: "",
        uploaded: false,
        takenAt: DateTime.now()),
    RatingModel(
        ratingId: 4,
        rating: 0,
        multipleRatings: "",
        additionalText: "",
        uploaded: false,
        takenAt: DateTime.now()),
    RatingModel(
        ratingId: 5,
        rating: 0,
        multipleRatings: "",
        additionalText: "",
        uploaded: false,
        takenAt: DateTime.now()),
    RatingModel(
        ratingId: 6,
        rating: 0,
        multipleRatings: "",
        additionalText: "",
        uploaded: false,
        takenAt: DateTime.now()),
    RatingModel(
        ratingId: 7,
        rating: 0,
        multipleRatings: "",
        additionalText: "",
        uploaded: false,
        takenAt: DateTime.now()),
    RatingModel(
        ratingId: 8,
        rating: 0,
        multipleRatings: "",
        additionalText: "",
        uploaded: false,
        takenAt: DateTime.now()),
  ];

  int currentQuestion = 0;
  int currentGroup = 0;
  bool done = false;

  List<int> answeredQuestions = [];

  @override
  void initState() {
    BlocProvider.of<RatingBloc>(context).add(GetAllRatingsEvent());
    currentQuestion = 0;
    done = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<RatingQuestion> questions = ratingsQuestions(context);
    List<Widget> ratingQuestionsWidgets = [
      group1(
        ratingModel1: ratingsList[0],
        ratingQuestion1: questions[0],
        ratingModel2: ratingsList[1],
        ratingQuestion2: questions[1],
      ),
      group2(
        ratingModel1: ratingsList[2],
        ratingQuestion1: questions[2],
        ratingModel2: ratingsList[3],
        ratingQuestion2: questions[3],
      ),
      group3(
        ratingModel5: ratingsList[4],
        ratingQuestion5: questions[4],
        ratingModel6: ratingsList[5],
        ratingQuestion6: questions[5],
        ratingModel7: ratingsList[6],
        ratingQuestion7: questions[6],
        ratingModel8: ratingsList[7],
        ratingQuestion8: questions[7],
      ),
      // question1(ratingModel: ratingsList[0], ratingQuestion: questions[0]),
      // question2(ratingModel: ratingsList[1], ratingQuestion: questions[1]),
      // question3(ratingModel: ratingsList[2], ratingQuestion: questions[2]),
      // question4(ratingModel: ratingsList[3], ratingQuestion: questions[3]),

      // question5(ratingModel: ratingsList[4], ratingQuestion: questions[4]),
      // question6(ratingModel: ratingsList[5], ratingQuestion: questions[5]),
      // question7(ratingModel: ratingsList[6], ratingQuestion: questions[6]),
      // question8(ratingModel: ratingsList[7], ratingQuestion: questions[7]),
    ];

    Size size = MediaQuery.of(context).size;
    final isMOBILE = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final textScale = isMOBILE
        ? MediaQuery.of(context).size.height * 0.001
        : MediaQuery.of(context).size.height * 0.0011;

    // Map<int, String> ratingsTexts = {
    //   1: AppLocalizations.of(context)!.appInterfaceRating,
    //   2: AppLocalizations.of(context)!.contentRating,
    //   3: AppLocalizations.of(context)!.educationalContentRating,
    // };
    bool _isDialogShowing = false;
    // Widget question = AppRateWelcome();

    Widget question = ratingQuestionsWidgets[0];
    if (currentQuestion > 0)
      question = ratingQuestionsWidgets[currentQuestion - 1];

    Widget button = SizedBox.shrink();

    switch (currentQuestion) {
      case 0:
        button = AppButton(
          label: AppLocalizations.of(context)!.start,
          fontSize: textScale * 24,
          // padding: EdgeInsets.symmetric(
          //     vertical: isMOBILE ? 18 : textScale * 24),
          onPressed: () {
            setState(() {
              currentQuestion = 1;
            });
          },
        );
        break;
      case 1:
        button = AppButton(
          label: AppLocalizations.of(context)!.next,
          fontSize: textScale * 24,
          onPressed: () {
            if (ratingsList[0].rating == 0 ||
                (ratingsList[0].rating == 5 && ratingsList[1].rating == 0)) {
              var snackBar = SnackBar(
                content: Text(
                    AppLocalizations.of(context)!.answerAllQuestionsSnackBar),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              return;
            }
            setState(() {
              answeredQuestions.add(currentQuestion);
              currentQuestion = 2;
              _isDialogShowing = false;
            });
            // if (questions[currentQuestion - 1].specialNextCondition ==
            //     ratingsList[currentQuestion - 1].rating) {
            //   print('SPECIALNEXT: ${currentQuestion}');
            // } else {
            //   setState(() {
            //     answeredQuestions.add(currentQuestion);
            //     currentQuestion = 2;
            //     // currentQuestion =
            //     //     questions[currentQuestion - 1]
            //     //         .regularNext;
            //   });
            // }
            // BlocProvider.of<RatingBloc>(context).add(
            //     AddRatingsEvent(ratings: ratingsList));
          },
        );
        break;
      case 2:
        button = AppButton(
          label: AppLocalizations.of(context)!.next,
          fontSize: textScale * 24,
          onPressed: () {
            if (ratingsList[2].rating == 0 ||
                (ratingsList[2].rating == 5 && ratingsList[3].rating == 0)) {
              var snackBar = SnackBar(
                content: Text(
                    AppLocalizations.of(context)!.answerAllQuestionsSnackBar),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            setState(() {
              answeredQuestions.add(currentQuestion);
              currentQuestion = 3;
              _isDialogShowing = false;
            });
          },
        );
        break;
      case 3:
        button = AppButton(
          label: AppLocalizations.of(context)!.rate,
          fontSize: textScale * 24,
          // padding: EdgeInsets.symmetric(
          //     vertical: isMOBILE ? 18 : textScale * 24),
          onPressed: () {
            if (ratingsList[4].rating == 0 ||
                ratingsList[5].rating == 0 ||
                ratingsList[6].rating == 0 ||
                ratingsList[7].rating == 0) {
              var snackBar = SnackBar(
                content: Text(
                    AppLocalizations.of(context)!.answerAllQuestionsSnackBar),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            done = true;
            _isDialogShowing = false;
            BlocProvider.of<RatingBloc>(context)
                .add(AddRatingsEvent(ratings: ratingsList));
          },
        );
        break;
      default:
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: BlocConsumer<RatingBloc, RatingState>(
          listener: (context, state) {
            if (state is AddedRatingsState && !_isDialogShowing) {
              _isDialogShowing = true;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                      title: AppLocalizations.of(context)!.ratingSuccessTitle,
                      descriptions:
                          AppLocalizations.of(context)!.ratingSuccessDesc,
                      text: AppLocalizations.of(context)!.goBack,
                      img: Image.asset("assets/images/success.png"),
                      onButtonPress: () {
                        Navigator.popAndPushNamed(context, Routes.home);
                      },
                    );
                  });
            }
          },
          builder: (context, state) {
            if (state is AllRatingsLoadingState) {
              return Center(
                child: SizedBox(
                  width: isMOBILE ? size.width * 0.35 : size.width * 0.35,
                  child: const LoadingIndicator(
                    indicatorType: Indicator.circleStrokeSpin,
                    colors: [AppColors.primaryColor],
                    strokeWidth: 4,
                    backgroundColor: Colors.white,
                    pathBackgroundColor: Colors.white,
                  ),
                ),
              );
            }
            if (state is AllRatingsLoadedState) {
              // for (var dbRating in state.ratings) {
              //   switch (dbRating.ratingId) {
              //     case 1:
              //       ratingsList[0] = dbRating;
              //       break;
              //     case 2:
              //       ratingsList[1] = dbRating;
              //       break;
              //     case 3:
              //       ratingsList[2] = dbRating;
              //       break;
              //     default:
              //   }
              // }
              // ratingsList = state.ratings;
            }

            return Column(
              children: [
                // SizedBox(height: size.height * 0.02),
                Container(
                  padding: EdgeInsets.only(
                      left: size.width * 0.05, right: size.width * 0.05),
                  child: AppText(
                    text: AppLocalizations.of(context)!.appRateTitle,
                    fontSize: textScale * 36,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                currentQuestion == 0 ? AppRateWelcome() : question,
                SizedBox(height: size.height * 0.05),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          isMOBILE ? size.width * 0.05 : size.width * 0.1),
                  child: Row(
                    children: [
                      currentQuestion > 1
                          ? SizedBox(
                              width: size.width * 0.4,
                              child: AppButton(
                                label: AppLocalizations.of(context)!.previous,
                                fontSize: textScale * 24,
                                onPressed: () {
                                  setState(() {
                                    currentQuestion =
                                        answeredQuestions.removeLast();
                                  });
                                  _isDialogShowing = false;
                                  // BlocProvider.of<RatingBloc>(context).add(
                                  //     AddRatingsEvent(ratings: ratingsList));
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                      const Expanded(child: SizedBox.shrink()),
                      SizedBox(
                        width: size.width * 0.4,
                        child: button,
                      ),
                      currentQuestion < 2
                          ? const Expanded(child: SizedBox.shrink())
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
