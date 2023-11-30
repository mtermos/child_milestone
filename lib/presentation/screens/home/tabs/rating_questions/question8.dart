// ignore_for_file: public_member_api_docs, sort_constructors_eighth
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:child_milestone/data/data_providers/ratings_items_list.dart';
import 'package:child_milestone/data/models/rating.dart';
import 'package:child_milestone/data/models/rating_questions.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class question8 extends StatefulWidget {
  final RatingModel ratingModel;
  final RatingQuestion ratingQuestion;
  const question8({
    Key? key,
    required this.ratingModel,
    required this.ratingQuestion,
  }) : super(key: key);

  @override
  State<question8> createState() => _question8State();
}

class _question8State extends State<question8> {
  final additionalText8Controller = TextEditingController();
  bool isCheckedEighth1 = false;
  bool isCheckedEighth2 = false;
  bool isCheckedEighth3 = false;
  bool isCheckedEighth4 = false;
  bool isCheckedEighth5 = false;
  bool isCheckedEighth6 = false;
  bool isCheckedEighth7 = false;
  bool isCheckedEighth8 = false;
  Set<int> checkedChoices = {};

  @override
  void initState() {
    checkedChoices = stringToSet(widget.ratingModel.multipleRatings);
    isCheckedEighth1 = checkedChoices.contains(1);
    isCheckedEighth2 = checkedChoices.contains(2);
    isCheckedEighth3 = checkedChoices.contains(3);
    isCheckedEighth4 = checkedChoices.contains(4);
    isCheckedEighth5 = checkedChoices.contains(5);
    isCheckedEighth6 = checkedChoices.contains(6);
    isCheckedEighth7 = checkedChoices.contains(7);
    isCheckedEighth8 = checkedChoices.contains(8);
    additionalText8Controller.text = widget.ratingModel.additionalText;
    super.initState();
  }

  @override
  void dispose() {
    additionalText8Controller.dispose();
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
          leading: Checkbox(
            checkColor: Colors.white,
            value: isCheckedEighth1,
            onChanged: (bool? value) {
              setState(() {
                if (value != null && value) {
                  isCheckedEighth1 = true;
                  checkedChoices.add(1);
                  widget.ratingModel.rating = 1;
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                } else if (value != null && !value) {
                  isCheckedEighth1 = false;
                  checkedChoices.remove(1);
                  if (checkedChoices.isEmpty) {
                    widget.ratingModel.rating = 0;
                  }
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                }
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
          leading: Checkbox(
            checkColor: Colors.white,
            value: isCheckedEighth2,
            onChanged: (bool? value) {
              setState(() {
                if (value != null && value) {
                  isCheckedEighth2 = true;
                  checkedChoices.add(2);
                  widget.ratingModel.rating = 1;
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                } else if (value != null && !value) {
                  isCheckedEighth2 = false;
                  checkedChoices.remove(2);
                  if (checkedChoices.isEmpty) {
                    widget.ratingModel.rating = 0;
                  }
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                }
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
          leading: Checkbox(
            checkColor: Colors.white,
            value: isCheckedEighth3,
            onChanged: (bool? value) {
              setState(() {
                if (value != null && value) {
                  isCheckedEighth3 = true;
                  checkedChoices.add(3);
                  widget.ratingModel.rating = 1;
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                } else if (value != null && !value) {
                  isCheckedEighth3 = false;
                  checkedChoices.remove(3);
                  if (checkedChoices.isEmpty) {
                    widget.ratingModel.rating = 0;
                  }
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                }
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
          leading: Checkbox(
            checkColor: Colors.white,
            value: isCheckedEighth4,
            onChanged: (bool? value) {
              setState(() {
                if (value != null && value) {
                  isCheckedEighth4 = true;
                  checkedChoices.add(4);
                  widget.ratingModel.rating = 1;
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                } else if (value != null && !value) {
                  isCheckedEighth4 = false;
                  checkedChoices.remove(4);
                  if (checkedChoices.isEmpty) {
                    widget.ratingModel.rating = 0;
                  }
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                }
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
          leading: Checkbox(
            checkColor: Colors.white,
            value: isCheckedEighth5,
            onChanged: (bool? value) {
              setState(() {
                if (value != null && value) {
                  isCheckedEighth5 = true;
                  checkedChoices.add(5);
                  widget.ratingModel.rating = 1;
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                } else if (value != null && !value) {
                  isCheckedEighth5 = false;
                  checkedChoices.remove(5);
                  if (checkedChoices.isEmpty) {
                    widget.ratingModel.rating = 0;
                  }
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                }
              });
            },
          ),
        ),
        ListTile(
          title: AppText(
            text: widget.ratingQuestion.choices[6]!,
            textAlign: TextAlign.right,
          ),
          visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity),
          leading: Checkbox(
            checkColor: Colors.white,
            value: isCheckedEighth6,
            onChanged: (bool? value) {
              setState(() {
                if (value != null && value) {
                  isCheckedEighth6 = true;
                  checkedChoices.add(6);
                  widget.ratingModel.rating = 1;
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                } else if (value != null && !value) {
                  isCheckedEighth6 = false;
                  checkedChoices.remove(6);
                  if (checkedChoices.isEmpty) {
                    widget.ratingModel.rating = 0;
                  }
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                }
              });
            },
          ),
        ),
        ListTile(
          title: AppText(
            text: widget.ratingQuestion.choices[7]!,
            textAlign: TextAlign.right,
          ),
          visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity),
          leading: Checkbox(
            checkColor: Colors.white,
            value: isCheckedEighth7,
            onChanged: (bool? value) {
              setState(() {
                if (value != null && value) {
                  isCheckedEighth7 = true;
                  checkedChoices.add(7);
                  widget.ratingModel.rating = 1;
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                } else if (value != null && !value) {
                  isCheckedEighth7 = false;
                  checkedChoices.remove(7);
                  if (checkedChoices.isEmpty) {
                    widget.ratingModel.rating = 0;
                  }
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                }
              });
            },
          ),
        ),
        ListTile(
          title: AppText(
            text: widget.ratingQuestion.choices[8]!,
            textAlign: TextAlign.right,
          ),
          visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity),
          leading: Checkbox(
            checkColor: Colors.white,
            value: isCheckedEighth8,
            onChanged: (bool? value) {
              setState(() {
                if (value != null && value) {
                  isCheckedEighth8 = true;
                  checkedChoices.add(8);
                  widget.ratingModel.rating = 1;
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                } else if (value != null && !value) {
                  isCheckedEighth8 = false;
                  checkedChoices.remove(8);
                  if (checkedChoices.isEmpty) {
                    widget.ratingModel.rating = 0;
                  }
                  widget.ratingModel.multipleRatings =
                      setToString(checkedChoices);
                }
              });
            },
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: TextFormField(
            controller: additionalText8Controller,
            style: TextStyle(fontSize: textScale * 20),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.enterRatingCause;
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                widget.ratingModel.additionalText = value;
              });
            },
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.causeField,
            ),
          ),
        ),
      ],
    );
  }

  String setToString(Set<int> set) {
    String s = "";
    int i = 0;
    for (var element in set) {
      if (i == 0) {
        s += element.toString();
      } else {
        s += "-" + element.toString();
      }
      i++;
    }
    return s;
  }

  Set<int> stringToSet(String string) {
    Set<int> set = {};
    if (string == "") {
      return set;
    }
    List<String> list = string.split('-');
    for (var element in list) {
      set.add(int.parse(element));
    }
    return set;
  }
}
