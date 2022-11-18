// ignore: file_names
import 'package:child_milestone/data/models/rating.dart';
import 'package:child_milestone/logic/blocs/rating/rating_bloc.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/components/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppRateTab extends StatefulWidget {
  const AppRateTab({Key? key}) : super(key: key);

  @override
  _AppRateState createState() => _AppRateState();
}

class _AppRateState extends State<AppRateTab> {
  Map<int, String> ratingsMap = {
    1: "App UI rating",
    2: "Content rating",
    3: "Educational material rating"
  };

  List<RatingModel> ratingsList = [
    RatingModel(
        ratingId: 1, rating: 0, uploaded: false, takenAt: DateTime.now()),
    RatingModel(
        ratingId: 2, rating: 0, uploaded: false, takenAt: DateTime.now()),
    RatingModel(
        ratingId: 3, rating: 0, uploaded: false, takenAt: DateTime.now()),
  ];

  @override
  void initState() {
    BlocProvider.of<RatingBloc>(context).add(GetAllRatingsEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: BlocConsumer<RatingBloc, RatingState>(
          listener: (context, state) {
            if (state is AddedRatingState) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                      title: AppLocalizations.of(context)!.ratingSuccessTitle,
                      descriptions:
                          AppLocalizations.of(context)!.ratingSuccessDesc,
                      text: AppLocalizations.of(context)!.goBack,
                      img: Image.asset("assets/images/success.png"),
                    );
                  });
            }
          },
          builder: (context, state) {
            if (state is AllRatingsLoadedState) {
              for (var dbRating in state.ratings) {
                switch (dbRating.ratingId) {
                  case 1:
                    ratingsList[0] = dbRating;
                    break;
                  case 2:
                    ratingsList[1] = dbRating;
                    break;
                  case 3:
                    ratingsList[2] = dbRating;
                    break;
                  default:
                }
              }
              // ratingsList = state.ratings;
            }

            return Column(
              children: [
                SizedBox(height: size.height * 0.02),
                Container(
                  alignment: AlignmentDirectional.topStart,
                  padding: EdgeInsets.only(
                      left: size.width * 0.05, right: size.width * 0.05),
                  child: AppText(
                    text: AppLocalizations.of(context)!.appRate,
                    fontSize: textScale * 36,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: size.height * 0.015,
                    horizontal: size.width * 0.05,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(textScale * 2, textScale * 4),
                        blurRadius: textScale * 8,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: textScale * 15,
                    horizontal: textScale * 20,
                  ),
                  child: Column(
                    children: [
                      AppText(
                          text:
                              AppLocalizations.of(context)!.appInterfaceRating),
                      SizedBox(height: size.height * 0.01),
                      RatingBar.builder(
                        initialRating: ratingsList[0].rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        wrapAlignment: WrapAlignment.center,
                        itemPadding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.01),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          ratingsList[0].rating = rating;
                          ratingsList[0].takenAt = DateTime.now();
                          // ratingsList[0] = RatingModel(
                          //     ratingId: 1,
                          //     rating: rating,
                          //     uploaded: false,
                          //     takenAt: DateTime.now());
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: size.height * 0.015,
                    horizontal: size.width * 0.05,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(textScale * 2, textScale * 4),
                        blurRadius: textScale * 8,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: textScale * 15,
                    horizontal: textScale * 20,
                  ),
                  child: Column(
                    children: [
                      AppText(
                          text: AppLocalizations.of(context)!.contentRating),
                      SizedBox(height: size.height * 0.01),
                      RatingBar.builder(
                        initialRating: ratingsList[1].rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        wrapAlignment: WrapAlignment.center,
                        itemPadding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.01),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          ratingsList[1].rating = rating;
                          ratingsList[1].takenAt = DateTime.now();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: size.height * 0.015,
                    horizontal: size.width * 0.05,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(textScale * 2, textScale * 4),
                        blurRadius: textScale * 8,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: textScale * 15,
                    horizontal: textScale * 20,
                  ),
                  child: Column(
                    children: [
                      AppText(
                          text: AppLocalizations.of(context)!
                              .educationalContentRating),
                      SizedBox(height: size.height * 0.01),
                      RatingBar.builder(
                        initialRating: ratingsList[2].rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        wrapAlignment: WrapAlignment.center,
                        itemPadding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.01),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          ratingsList[2].rating = rating;
                          ratingsList[2].takenAt = DateTime.now();
                        },
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                SizedBox(height: size.height * 0.05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
                  child: AppButton(
                    label: AppLocalizations.of(context)!.rate,
                    onPressed: () {
                      for (var rating in ratingsList) {
                        BlocProvider.of<RatingBloc>(context)
                            .add(AddRatingEvent(rating: rating));
                      }
                    },
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
