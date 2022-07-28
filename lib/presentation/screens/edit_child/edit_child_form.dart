import 'dart:io';

import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/logic/blocs/decision/decision_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditChildForm extends StatefulWidget {
  final ChildModel child;
  const EditChildForm({Key? key, required this.child}) : super(key: key);

  @override
  State<EditChildForm> createState() => _EditChildFormState();
}

class _EditChildFormState extends State<EditChildForm> {
  static const String editChildPlusIcon =
      "assets/icons/add_child_plus_icon.svg";
  // static const String stepsIcon = "assets/icons/steps_icon.png";
  final nameController = TextEditingController();
  final durationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  CircleAvatar? profilePictureFile;
  XFile? chosenImage;

  List gender = ["Male", "Female"];

  String selectedGender = "";

  @override
  void initState() {
    chosenImage = XFile(widget.child.imagePath);
    selectedGender = widget.child.gender;
    _selectedDate = widget.child.dateOfBirth;
    nameController.text = widget.child.name;
    durationController.text = widget.child.pregnancyDuration.toString();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    durationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    final format = DateFormat("yyyy-MM-dd");

    return BlocBuilder<ChildBloc, ChildState>(
      builder: (context, state) {
        if (state is EditingChildState) {
          return AppText(text: "text");
        } else {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(
                  text: AppLocalizations.of(context)!.editChild,
                  fontSize: textScale * 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                SizedBox(height: size.height * 0.025),
                InkWell(
                  child: profilePictureFile ??
                      SvgPicture.asset(
                        editChildPlusIcon,
                        width: size.width * 0.4,
                      ),
                  onTap: () async {
                    ImagePicker picker = ImagePicker();
                    XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        chosenImage = image;
                        profilePictureFile = CircleAvatar(
                          radius: size.width * 0.2,
                          backgroundImage: Image.file(File(image.path)).image,
                        );
                      });
                    }
                  },
                ),
                SizedBox(height: size.height * 0.025),
                AppText(
                  text: AppLocalizations.of(context)!.addPhoto,
                  fontSize: textScale * 20,
                  color: Colors.black,
                ),
                SizedBox(height: size.height * 0.02),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.childsNameField),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: DateTimeField(
                    initialValue: _selectedDate,
                    decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.dateOfBirthField),
                    format: format,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime.now());
                    },
                    onChanged: (date) {
                      if (date != null) {
                        _selectedDate = date;
                      }
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: TextField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!
                            .pregnancyDurationField),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: size.width * 0.1,
                    top: size.height * 0.02,
                    right: size.width * 0.1,
                  ),
                  child: Row(
                    children: [
                      AppText(
                        text: AppLocalizations.of(context)!.genderField,
                        fontSize: textScale * 20,
                      ),
                      addRadioButton(0, AppLocalizations.of(context)!.male),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      addRadioButton(1, AppLocalizations.of(context)!.female),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      left: size.width * 0.1, right: size.width * 0.6),
                  child: AppButton(
                    label: "Edit",
                    roundness: 12,
                    onPressed: () async {
                      var snackBar = SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .enterAllFieldsSnackBar),
                      );
                      if (chosenImage == null ||
                          nameController.text == "" ||
                          durationController.text == "" ||
                          selectedGender == "") {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      // final List<String> strings = chosen_image!.path.split(".");
                      // final fileName =
                      //     basename(strings[strings.length - 2] + "." + strings.last);
                      String imagePath = "";
                      if (chosenImage!.path != widget.child.imagePath) {
                        final appDir = await getApplicationDocumentsDirectory();
                        final fileName = basename(chosenImage!.path);
                        imagePath = '${appDir.path}/$fileName';
                        await chosenImage!.saveTo(imagePath);
                      } else {
                        imagePath = widget.child.imagePath;
                      }
                      ChildModel newChild = ChildModel(
                        name: nameController.text,
                        dateOfBirth: _selectedDate,
                        imagePath: imagePath,
                        id: widget.child.id,
                        gender: selectedGender,
                        pregnancyDuration:
                            double.parse(durationController.text),
                      );
                      BlocProvider.of<ChildBloc>(context).add(EditChildEvent(
                          context: context,
                          child: newChild,
                          addNotifications:
                              widget.child.dateOfBirth != _selectedDate,
                          whenDone: () {
                            BlocProvider.of<CurrentChildCubit>(context)
                                .changeCurrentChild(newChild, () {
                              BlocProvider.of<DecisionBloc>(context).add(
                                  GetDecisionsByAgeEvent(
                                      dateOfBirth: newChild.dateOfBirth,
                                      childId: newChild.id));
                            });
                            // BlocProvider.of<ChildBloc>(context)
                            //     .add(GetAllChildrenEvent());
                            Navigator.popAndPushNamed(context, Routes.home);
                          }));
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.1),
                BlocListener<ChildBloc, ChildState>(
                  listener: (context, state) {
                    if (state is ErrorAddingChildUniqueIDState) {
                      var snackBar = SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .childsIdExistsSnackBar),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(),
                )
              ],
            ),
          );
        }
      },
    );
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<String>(
          activeColor: AppColors.primaryColor,
          value: gender[btnValue],
          groupValue: selectedGender,
          onChanged: (value) {
            setState(() {
              selectedGender = value!;
              debugPrint('selectedGender: ${selectedGender}');
            });
          },
        ),
        Text(
          title,
        )
      ],
    );
  }
}
