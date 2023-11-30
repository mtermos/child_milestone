// ignore_for_file: public_member_api_docs, sort_constructors_third
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:child_milestone/data/data_providers/ratings_items_list.dart';
import 'package:child_milestone/data/models/rating.dart';
import 'package:child_milestone/data/models/rating_questions.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class group2 extends StatefulWidget {
  final RatingModel ratingModel1;
  final RatingQuestion ratingQuestion1;
  final RatingModel ratingModel2;
  final RatingQuestion ratingQuestion2;
  const group2({
    Key? key,
    required this.ratingModel1,
    required this.ratingQuestion1,
    required this.ratingModel2,
    required this.ratingQuestion2,
  }) : super(key: key);

  @override
  State<group2> createState() => _group2State();
}

enum question3Enum { third1, third2, third3, third4, third5 }

enum question4Enum { fourth1, fourth2, fourth3, fourth4 }

class _group2State extends State<group2> {
  final additionalText4Controller = TextEditingController();
  question3Enum? _character3;
  question4Enum? _character4;
  int choice1 = 0;
  int choice2 = 0;

  @override
  void initState() {
    additionalText4Controller.text = widget.ratingModel2.additionalText;
    switch (widget.ratingModel1.rating) {
      case 1:
        _character3 = question3Enum.third1;
        break;
      case 2:
        _character3 = question3Enum.third2;
        break;
      case 3:
        _character3 = question3Enum.third3;
        break;
      case 4:
        _character3 = question3Enum.third4;
        break;
      case 5:
        _character3 = question3Enum.third5;
        break;
      default:
    }
    switch (widget.ratingModel2.rating) {
      case 1:
        _character4 = question4Enum.fourth1;
        break;
      case 2:
        _character4 = question4Enum.fourth2;
        break;
      case 3:
        _character4 = question4Enum.fourth3;
        break;
      case 4:
        _character4 = question4Enum.fourth4;
        break;
      default:
    }
    super.initState();
  }

  @override
  void dispose() {
    additionalText4Controller.dispose();
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
              "${AppLocalizations.of(context)!.secondly}: ${AppLocalizations.of(context)!.developmentalMaterial}",
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
                leading: Radio<question3Enum>(
                  value: question3Enum.third1,
                  groupValue: _character3,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                  ),
                  onChanged: (question3Enum? value) {
                    setState(() {
                      _character3 = value;
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
                leading: Radio<question3Enum>(
                  value: question3Enum.third2,
                  groupValue: _character3,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                  ),
                  onChanged: (question3Enum? value) {
                    setState(() {
                      _character3 = value;
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
                leading: Radio<question3Enum>(
                  value: question3Enum.third3,
                  groupValue: _character3,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                  ),
                  onChanged: (question3Enum? value) {
                    setState(() {
                      _character3 = value;
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
                leading: Radio<question3Enum>(
                  value: question3Enum.third4,
                  groupValue: _character3,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                  ),
                  onChanged: (question3Enum? value) {
                    setState(() {
                      _character3 = value;
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
                leading: Radio<question3Enum>(
                  value: question3Enum.third5,
                  groupValue: _character3,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                  ),
                  onChanged: (question3Enum? value) {
                    setState(() {
                      _character3 = value;
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
                          leading: Radio<question4Enum>(
                            value: question4Enum.fourth1,
                            groupValue: _character4,
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                            ),
                            onChanged: (question4Enum? value) {
                              setState(() {
                                _character4 = value;
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
                          leading: Radio<question4Enum>(
                            value: question4Enum.fourth2,
                            groupValue: _character4,
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                            ),
                            onChanged: (question4Enum? value) {
                              setState(() {
                                _character4 = value;
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
                          leading: Radio<question4Enum>(
                            value: question4Enum.fourth3,
                            groupValue: _character4,
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                            ),
                            onChanged: (question4Enum? value) {
                              setState(() {
                                _character4 = value;
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
                          leading: Radio<question4Enum>(
                            value: question4Enum.fourth4,
                            groupValue: _character4,
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                            ),
                            onChanged: (question4Enum? value) {
                              setState(() {
                                _character4 = value;
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
                                  controller: additionalText4Controller,
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
