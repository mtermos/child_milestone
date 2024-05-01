// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:child_milestone/data/data_providers/ratings_items_list.dart';
import 'package:child_milestone/data/models/rating.dart';
import 'package:child_milestone/data/models/rating_questions.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class group1 extends StatefulWidget {
  final RatingModel ratingModel1;
  final RatingQuestion ratingQuestion1;
  final RatingModel ratingModel2;
  final RatingQuestion ratingQuestion2;
  const group1({
    Key? key,
    required this.ratingModel1,
    required this.ratingQuestion1,
    required this.ratingModel2,
    required this.ratingQuestion2,
  }) : super(key: key);

  @override
  State<group1> createState() => _group1State();
}

enum question1Enum { first1, first2, first3, first4, first5 }

enum question2Enum { second1, second2, second3, second4 }

class _group1State extends State<group1> {
  final additionalText2Controller = TextEditingController();
  question1Enum? _character1;
  question2Enum? _character2;
  int choice1 = 0;
  int choice2 = 0;

  @override
  void initState() {
    additionalText2Controller.text = widget.ratingModel2.additionalText;
    switch (widget.ratingModel1.rating) {
      case 1:
        _character1 = question1Enum.first1;
        break;
      case 2:
        _character1 = question1Enum.first2;
        break;
      case 3:
        _character1 = question1Enum.first3;
        break;
      case 4:
        _character1 = question1Enum.first4;
        break;
      case 5:
        _character1 = question1Enum.first5;
        break;
      default:
    }
    switch (widget.ratingModel2.rating) {
      case 1:
        _character2 = question2Enum.second1;
        break;
      case 2:
        _character2 = question2Enum.second2;
        break;
      case 3:
        _character2 = question2Enum.second3;
        break;
      case 4:
        _character2 = question2Enum.second4;
        break;
      default:
    }
    super.initState();
  }

  @override
  void dispose() {
    additionalText2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isMOBILE = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final textScale = isMOBILE
        ? MediaQuery.of(context).size.height * 0.001
        : MediaQuery.of(context).size.height * 0.0011;
    return Column(
      children: [
        SizedBox(height: size.height * 0.02),
        AppText(
          text:
              "${AppLocalizations.of(context)!.firstly}: ${AppLocalizations.of(context)!.educationalMaterial}",
          fontSize: textScale * 24,
        ),
        SizedBox(height: size.height * 0.02),
        Container(
          width: isMOBILE ? null : size.width * 0.6,
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
              Padding(
                padding: const EdgeInsets.all(10),
                child: AppText(
                  text: widget.ratingQuestion1.text,
                  textAlign: TextAlign.start,
                ),
              ),
              const Divider(
                height: 1, // Adjust the height of the divider as needed
                thickness: 1,
                color: Colors.black, // Customize the divider color
              ),
              ListTile(
                title: AppText(
                  text: widget.ratingQuestion1.choices[1]!,
                  textAlign: TextAlign.right,
                ),
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                leading: Radio<question1Enum>(
                  value: question1Enum.first1,
                  groupValue: _character1,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                  ),
                  onChanged: (question1Enum? value) {
                    setState(() {
                      _character1 = value;
                      widget.ratingModel1.rating = 1;
                      choice1 = 1;
                    });
                  },
                ),
              ),
              ListTile(
                title: AppText(
                  text: widget.ratingQuestion1.choices[2]!,
                  textAlign: TextAlign.right,
                ),
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                leading: Radio<question1Enum>(
                  value: question1Enum.first2,
                  groupValue: _character1,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                  ),
                  onChanged: (question1Enum? value) {
                    setState(() {
                      _character1 = value;
                      widget.ratingModel1.rating = 2;
                      choice1 = 2;
                    });
                  },
                ),
              ),
              ListTile(
                title: AppText(
                  text: widget.ratingQuestion1.choices[3]!,
                  textAlign: TextAlign.right,
                ),
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                leading: Radio<question1Enum>(
                  value: question1Enum.first3,
                  groupValue: _character1,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                  ),
                  onChanged: (question1Enum? value) {
                    setState(() {
                      _character1 = value;
                      widget.ratingModel1.rating = 3;
                      choice1 = 3;
                    });
                  },
                ),
              ),
              ListTile(
                title: AppText(
                  text: widget.ratingQuestion1.choices[4]!,
                  textAlign: TextAlign.right,
                ),
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                leading: Radio<question1Enum>(
                  value: question1Enum.first4,
                  groupValue: _character1,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                  ),
                  onChanged: (question1Enum? value) {
                    setState(() {
                      _character1 = value;
                      widget.ratingModel1.rating = 4;
                      choice1 = 4;
                    });
                  },
                ),
              ),
              ListTile(
                title: AppText(
                  text: widget.ratingQuestion1.choices[5]!,
                  textAlign: TextAlign.right,
                ),
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                leading: Radio<question1Enum>(
                  value: question1Enum.first5,
                  groupValue: _character1,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                  ),
                  onChanged: (question1Enum? value) {
                    setState(() {
                      _character1 = value;
                      widget.ratingModel1.rating = 5;
                      choice1 = 5;
                    });
                  },
                ),
              ),
            ]..addAll(
                choice1 < 5
                    ? []
                    : [
                        SizedBox(height: size.height * 0.05),
                        const Divider(
                          height:
                              1, // Adjust the height of the divider as needed
                          thickness: 1,
                          color: Colors.black, // Customize the divider color
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: AppText(
                            text: widget.ratingQuestion2.text,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const Divider(
                          height:
                              1, // Adjust the height of the divider as needed
                          thickness: 1,
                          color: Colors.black, // Customize the divider color
                        ),
                        SizedBox(height: 5),
                        ListTile(
                          title: AppText(
                            text: widget.ratingQuestion2.choices[1]!,
                            textAlign: TextAlign.right,
                          ),
                          visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity),
                          leading: Radio<question2Enum>(
                            value: question2Enum.second1,
                            groupValue: _character2,
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                            ),
                            onChanged: (question2Enum? value) {
                              setState(() {
                                _character2 = value;
                                widget.ratingModel2.rating = 1;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: AppText(
                            text: widget.ratingQuestion2.choices[2]!,
                            textAlign: TextAlign.right,
                          ),
                          visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity),
                          leading: Radio<question2Enum>(
                            value: question2Enum.second2,
                            groupValue: _character2,
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                            ),
                            onChanged: (question2Enum? value) {
                              setState(() {
                                _character2 = value;
                                widget.ratingModel2.rating = 2;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: AppText(
                            text: widget.ratingQuestion2.choices[3]!,
                            textAlign: TextAlign.right,
                          ),
                          visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity),
                          leading: Radio<question2Enum>(
                            value: question2Enum.second3,
                            groupValue: _character2,
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                            ),
                            onChanged: (question2Enum? value) {
                              setState(() {
                                _character2 = value;
                                widget.ratingModel2.rating = 3;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: AppText(
                            text: widget.ratingQuestion2.choices[4]!,
                            textAlign: TextAlign.right,
                          ),
                          visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity),
                          leading: Radio<question2Enum>(
                            value: question2Enum.second4,
                            groupValue: _character2,
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                            ),
                            onChanged: (question2Enum? value) {
                              setState(() {
                                _character2 = value;
                                widget.ratingModel2.rating = 4;
                              });
                            },
                          ),
                        ),
                        widget.ratingModel2.rating == 4
                            ? Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.1),
                                child: TextFormField(
                                  controller: additionalText2Controller,
                                  style: TextStyle(fontSize: textScale * 20),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .enterRatingCause;
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      widget.ratingModel2.additionalText =
                                          value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!
                                        .causeField,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
              ),
          ),
        ),
      ],
    );
  }
}
