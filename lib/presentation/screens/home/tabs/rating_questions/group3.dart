// ignore_for_file: public_member_api_docs, sort_constructors_third, unused_field
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/screens/home/tabs/rating_questions/question5.dart';
import 'package:child_milestone/presentation/screens/home/tabs/rating_questions/question6.dart';
import 'package:child_milestone/presentation/screens/home/tabs/rating_questions/question7.dart';
import 'package:child_milestone/presentation/screens/home/tabs/rating_questions/question8.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:child_milestone/data/models/rating.dart';
import 'package:child_milestone/data/models/rating_questions.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class group3 extends StatefulWidget {
  final RatingModel ratingModel5;
  final RatingQuestion ratingQuestion5;
  final RatingModel ratingModel6;
  final RatingQuestion ratingQuestion6;
  final RatingModel ratingModel7;
  final RatingQuestion ratingQuestion7;
  final RatingModel ratingModel8;
  final RatingQuestion ratingQuestion8;
  const group3({
    Key? key,
    required this.ratingModel5,
    required this.ratingQuestion5,
    required this.ratingModel6,
    required this.ratingQuestion6,
    required this.ratingModel7,
    required this.ratingQuestion7,
    required this.ratingModel8,
    required this.ratingQuestion8,
  }) : super(key: key);

  @override
  State<group3> createState() => _group3State();
}

enum question5Enum { fifth1, fifth2, fifth3, fifth4, fifth5 }

enum question6Enum { sixth1, sixth2, sixth3, sixth4, sixth5 }

enum question7Enum { seventh1, seventh2, seventh3, seventh4, seventh5 }

enum question8Enum {
  eighth1,
  eighth2,
  eighth3,
  eighth4,
  eighth5,
  eighth6,
  eighth7,
  eighth8
}

class _group3State extends State<group3> {
  question5Enum? _character5;
  question6Enum? _character6;
  question7Enum? _character7;
  question8Enum? _character8;
  int choice5 = 0;
  int choice6 = 0;
  int choice7 = 0;
  int choice8 = 0;

  @override
  void initState() {
    switch (widget.ratingModel5.rating) {
      case 1:
        _character5 = question5Enum.fifth1;
        break;
      case 2:
        _character5 = question5Enum.fifth2;
        break;
      case 3:
        _character5 = question5Enum.fifth3;
        break;
      case 4:
        _character5 = question5Enum.fifth4;
        break;
      case 5:
        _character5 = question5Enum.fifth5;
        break;
      default:
    }
    switch (widget.ratingModel6.rating) {
      case 1:
        _character6 = question6Enum.sixth1;
        break;
      case 2:
        _character6 = question6Enum.sixth2;
        break;
      case 3:
        _character6 = question6Enum.sixth3;
        break;
      case 4:
        _character6 = question6Enum.sixth4;
        break;
      case 5:
        _character6 = question6Enum.sixth5;
        break;
      default:
    }
    switch (widget.ratingModel7.rating) {
      case 1:
        _character7 = question7Enum.seventh1;
        break;
      case 2:
        _character7 = question7Enum.seventh2;
        break;
      case 3:
        _character7 = question7Enum.seventh3;
        break;
      case 4:
        _character7 = question7Enum.seventh4;
        break;
      case 5:
        _character7 = question7Enum.seventh5;
        break;
      default:
    }
    switch (widget.ratingModel8.rating) {
      case 1:
        _character8 = question8Enum.eighth1;
        break;
      case 2:
        _character8 = question8Enum.eighth2;
        break;
      case 3:
        _character8 = question8Enum.eighth3;
        break;
      case 4:
        _character8 = question8Enum.eighth4;
        break;
      case 5:
        _character8 = question8Enum.eighth5;
        break;
      case 6:
        _character8 = question8Enum.eighth6;
        break;
      case 7:
        _character8 = question8Enum.eighth7;
        break;
      case 8:
        _character8 = question8Enum.eighth8;
        break;
      default:
    }
    super.initState();
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
              "${AppLocalizations.of(context)!.thirdly}: ${AppLocalizations.of(context)!.usageMaterial}",
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
          child: Column(children: [
            question5(
              ratingModel: widget.ratingModel5,
              ratingQuestion: widget.ratingQuestion5,
            ),
            SizedBox(height: size.height * 0.05),
            const Divider(
              height: 1, // Adjust the height of the divider as needed
              thickness: 1,
              color: Colors.black, // Customize the divider color
            ),
            question6(
              ratingModel: widget.ratingModel6,
              ratingQuestion: widget.ratingQuestion6,
            ),
            SizedBox(height: size.height * 0.05),
            const Divider(
              height: 1, // Adjust the height of the divider as needed
              thickness: 1,
              color: Colors.black, // Customize the divider color
            ),
            question7(
              ratingModel: widget.ratingModel7,
              ratingQuestion: widget.ratingQuestion7,
            ),
            SizedBox(height: size.height * 0.05),
            const Divider(
              height: 1, // Adjust the height of the divider as needed
              thickness: 1,
              color: Colors.black, // Customize the divider color
            ),
            question8(
              ratingModel: widget.ratingModel8,
              ratingQuestion: widget.ratingQuestion8,
            ),
          ]
              //     Padding(
              //       padding: const EdgeInsets.all(10),
              //       child: AppText(
              //         text: widget.ratingQuestion1.text,
              //         textAlign: TextAlign.start,
              //       ),
              //     ),
              //     const Divider(
              //       height: 1, // Adjust the height of the divider as needed
              //       thickness: 1,
              //       color: Colors.black, // Customize the divider color
              //     ),
              //     ListTile(
              //       title: AppText(
              //         text: widget.ratingQuestion1.choices[1]!,
              //         textAlign: TextAlign.right,
              //       ),
              //       visualDensity: const VisualDensity(
              //           horizontal: VisualDensity.minimumDensity,
              //           vertical: VisualDensity.minimumDensity),
              //       leading: Radio<question5Enum>(
              //         value: question5Enum.third1,
              //         groupValue: _character5,
              //         visualDensity: const VisualDensity(
              //           horizontal: VisualDensity.minimumDensity,
              //         ),
              //         onChanged: (question5Enum? value) {
              //           setState(() {
              //             _character5 = value;
              //             widget.ratingModel1.rating = 1;
              //             choice1 = 1;
              //           });
              //         },
              //       ),
              //     ),
              //     ListTile(
              //       title: AppText(
              //         text: widget.ratingQuestion1.choices[2]!,
              //         textAlign: TextAlign.right,
              //       ),
              //       visualDensity: const VisualDensity(
              //           horizontal: VisualDensity.minimumDensity,
              //           vertical: VisualDensity.minimumDensity),
              //       leading: Radio<question5Enum>(
              //         value: question5Enum.third2,
              //         groupValue: _character5,
              //         visualDensity: const VisualDensity(
              //           horizontal: VisualDensity.minimumDensity,
              //         ),
              //         onChanged: (question5Enum? value) {
              //           setState(() {
              //             _character5 = value;
              //             widget.ratingModel1.rating = 2;
              //             choice1 = 2;
              //           });
              //         },
              //       ),
              //     ),
              //     ListTile(
              //       title: AppText(
              //         text: widget.ratingQuestion1.choices[3]!,
              //         textAlign: TextAlign.right,
              //       ),
              //       visualDensity: const VisualDensity(
              //           horizontal: VisualDensity.minimumDensity,
              //           vertical: VisualDensity.minimumDensity),
              //       leading: Radio<question5Enum>(
              //         value: question5Enum.third3,
              //         groupValue: _character5,
              //         visualDensity: const VisualDensity(
              //           horizontal: VisualDensity.minimumDensity,
              //         ),
              //         onChanged: (question5Enum? value) {
              //           setState(() {
              //             _character5 = value;
              //             widget.ratingModel1.rating = 3;
              //             choice1 = 3;
              //           });
              //         },
              //       ),
              //     ),
              //     ListTile(
              //       title: AppText(
              //         text: widget.ratingQuestion1.choices[4]!,
              //         textAlign: TextAlign.right,
              //       ),
              //       visualDensity: const VisualDensity(
              //           horizontal: VisualDensity.minimumDensity,
              //           vertical: VisualDensity.minimumDensity),
              //       leading: Radio<question5Enum>(
              //         value: question5Enum.third4,
              //         groupValue: _character5,
              //         visualDensity: const VisualDensity(
              //           horizontal: VisualDensity.minimumDensity,
              //         ),
              //         onChanged: (question5Enum? value) {
              //           setState(() {
              //             _character5 = value;
              //             widget.ratingModel1.rating = 4;
              //             choice1 = 4;
              //           });
              //         },
              //       ),
              //     ),
              //     ListTile(
              //       title: AppText(
              //         text: widget.ratingQuestion1.choices[5]!,
              //         textAlign: TextAlign.right,
              //       ),
              //       visualDensity: const VisualDensity(
              //           horizontal: VisualDensity.minimumDensity,
              //           vertical: VisualDensity.minimumDensity),
              //       leading: Radio<question5Enum>(
              //         value: question5Enum.third5,
              //         groupValue: _character5,
              //         visualDensity: const VisualDensity(
              //           horizontal: VisualDensity.minimumDensity,
              //         ),
              //         onChanged: (question5Enum? value) {
              //           setState(() {
              //             _character5 = value;
              //             widget.ratingModel1.rating = 5;
              //             choice1 = 5;
              //             print(
              //                 'WIDGET.RATINGMODEL.RATING: ${widget.ratingModel1.rating}');
              //           });
              //         },
              //       ),
              //     ),
              //   ]..addAll(choice1 < 5
              //       ? []
              //       : [
              //           SizedBox(height: size.height * 0.05),
              //           const Divider(
              //             height: 1, // Adjust the height of the divider as needed
              //             thickness: 1,
              //             color: Colors.black, // Customize the divider color
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.all(10),
              //             child: AppText(
              //               text: widget.ratingQuestion2.text,
              //               textAlign: TextAlign.start,
              //             ),
              //           ),
              //           const Divider(
              //             height: 1, // Adjust the height of the divider as needed
              //             thickness: 1,
              //             color: Colors.black, // Customize the divider color
              //           ),
              //           SizedBox(height: 5),
              //           ListTile(
              //             title: AppText(
              //               text: widget.ratingQuestion2.choices[1]!,
              //               textAlign: TextAlign.right,
              //             ),
              //             visualDensity: const VisualDensity(
              //                 horizontal: VisualDensity.minimumDensity,
              //                 vertical: VisualDensity.minimumDensity),
              //             leading: Radio<question4Enum>(
              //               value: question4Enum.fourth1,
              //               groupValue: _character4,
              //               visualDensity: const VisualDensity(
              //                 horizontal: VisualDensity.minimumDensity,
              //               ),
              //               onChanged: (question4Enum? value) {
              //                 setState(() {
              //                   _character4 = value;
              //                   widget.ratingModel2.rating = 1;
              //                 });
              //               },
              //             ),
              //           ),
              //           ListTile(
              //             title: AppText(
              //               text: widget.ratingQuestion2.choices[2]!,
              //               textAlign: TextAlign.right,
              //             ),
              //             visualDensity: const VisualDensity(
              //                 horizontal: VisualDensity.minimumDensity,
              //                 vertical: VisualDensity.minimumDensity),
              //             leading: Radio<question4Enum>(
              //               value: question4Enum.fourth2,
              //               groupValue: _character4,
              //               visualDensity: const VisualDensity(
              //                 horizontal: VisualDensity.minimumDensity,
              //               ),
              //               onChanged: (question4Enum? value) {
              //                 setState(() {
              //                   _character4 = value;
              //                   widget.ratingModel2.rating = 2;
              //                 });
              //               },
              //             ),
              //           ),
              //           ListTile(
              //             title: AppText(
              //               text: widget.ratingQuestion2.choices[3]!,
              //               textAlign: TextAlign.right,
              //             ),
              //             visualDensity: const VisualDensity(
              //                 horizontal: VisualDensity.minimumDensity,
              //                 vertical: VisualDensity.minimumDensity),
              //             leading: Radio<question4Enum>(
              //               value: question4Enum.fourth3,
              //               groupValue: _character4,
              //               visualDensity: const VisualDensity(
              //                 horizontal: VisualDensity.minimumDensity,
              //               ),
              //               onChanged: (question4Enum? value) {
              //                 setState(() {
              //                   _character4 = value;
              //                   widget.ratingModel2.rating = 3;
              //                 });
              //               },
              //             ),
              //           ),
              //           ListTile(
              //             title: AppText(
              //               text: widget.ratingQuestion2.choices[4]!,
              //               textAlign: TextAlign.right,
              //             ),
              //             visualDensity: const VisualDensity(
              //                 horizontal: VisualDensity.minimumDensity,
              //                 vertical: VisualDensity.minimumDensity),
              //             leading: Radio<question4Enum>(
              //               value: question4Enum.fourth4,
              //               groupValue: _character4,
              //               visualDensity: const VisualDensity(
              //                 horizontal: VisualDensity.minimumDensity,
              //               ),
              //               onChanged: (question4Enum? value) {
              //                 setState(() {
              //                   _character4 = value;
              //                   widget.ratingModel2.rating = 4;
              //                 });
              //               },
              //             ),
              //           ),
              //         ]),
              ),
        ),
      ],
    );
  }
}
