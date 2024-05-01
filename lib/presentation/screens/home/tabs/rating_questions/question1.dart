// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:child_milestone/data/data_providers/ratings_items_list.dart';
import 'package:child_milestone/data/models/rating.dart';
import 'package:child_milestone/data/models/rating_questions.dart';

class question1 extends StatefulWidget {
  final RatingModel ratingModel;
  final RatingQuestion ratingQuestion;
  const question1({
    Key? key,
    required this.ratingModel,
    required this.ratingQuestion,
  }) : super(key: key);

  @override
  State<question1> createState() => _question1State();
}

enum question1Enum { first1, first2, first3, first4, first5 }

class _question1State extends State<question1> {
  question1Enum? _character;
  int choice = 0;

  @override
  void initState() {
    switch (widget.ratingModel.rating) {
      case 1:
        _character = question1Enum.first1;
        break;
      case 2:
        _character = question1Enum.first2;
        break;
      case 3:
        _character = question1Enum.first3;
        break;
      case 4:
        _character = question1Enum.first4;
        break;
      case 5:
        _character = question1Enum.first5;
        break;
      default:
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: AppText(
            text: widget.ratingQuestion.text,
            textAlign: TextAlign.start,
          ),
        ),
        const Divider(
          height: 1, // Adjust the height of the divider as needed
          thickness: 1,
          color: Colors.black, // Customize the divider color
        ),
        SizedBox(height: 5),
        ListTile(
          title: AppText(
            text: widget.ratingQuestion.choices[1]!,
            textAlign: TextAlign.right,
          ),
          visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity),
          leading: Radio<question1Enum>(
            value: question1Enum.first1,
            groupValue: _character,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
            ),
            onChanged: (question1Enum? value) {
              setState(() {
                _character = value;
                widget.ratingModel.rating = 1;
              });
            },
          ),
        ),
        ListTile(
          title: AppText(
            text: widget.ratingQuestion.choices[2]!,
            textAlign: TextAlign.right,
          ),
          visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity),
          leading: Radio<question1Enum>(
            value: question1Enum.first2,
            groupValue: _character,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
            ),
            onChanged: (question1Enum? value) {
              setState(() {
                _character = value;
                widget.ratingModel.rating = 2;
              });
            },
          ),
        ),
        ListTile(
          title: AppText(
            text: widget.ratingQuestion.choices[3]!,
            textAlign: TextAlign.right,
          ),
          visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity),
          leading: Radio<question1Enum>(
            value: question1Enum.first3,
            groupValue: _character,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
            ),
            onChanged: (question1Enum? value) {
              setState(() {
                _character = value;
                widget.ratingModel.rating = 3;
              });
            },
          ),
        ),
        ListTile(
          title: AppText(
            text: widget.ratingQuestion.choices[4]!,
            textAlign: TextAlign.right,
          ),
          visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity),
          leading: Radio<question1Enum>(
            value: question1Enum.first4,
            groupValue: _character,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
            ),
            onChanged: (question1Enum? value) {
              setState(() {
                _character = value;
                widget.ratingModel.rating = 4;
              });
            },
          ),
        ),
        ListTile(
          title: AppText(
            text: widget.ratingQuestion.choices[5]!,
            textAlign: TextAlign.right,
          ),
          visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity),
          leading: Radio<question1Enum>(
            value: question1Enum.first5,
            groupValue: _character,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
            ),
            onChanged: (question1Enum? value) {
              setState(() {
                _character = value;
                widget.ratingModel.rating = 5;
              });
            },
          ),
        ),
      ],
    );
  }
}
