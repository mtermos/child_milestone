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
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddChildForm extends StatefulWidget {
  const AddChildForm({Key? key}) : super(key: key);

  @override
  State<AddChildForm> createState() => _AddChildFormState();
}

class _AddChildFormState extends State<AddChildForm> {
  static const String addChildPlusIcon = "assets/icons/add_child_plus_icon.svg";
  // static const String stepsIcon = "assets/icons/steps_icon.png";
  final nameController = TextEditingController();
  final durationController = TextEditingController();
  final idController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  CircleAvatar? profilePictureFile;
  XFile? chosen_image;

  List gender = ["Male", "Female"];

  String selected_gender = "";

  @override
  void initState() {
    super.initState();
    nameController.text = '';
    durationController.text = '';
    idController.text = '';
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    durationController.dispose();
    idController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    final format = DateFormat("yyyy-MM-dd");

    return BlocBuilder<ChildBloc, ChildState>(
      builder: (context, state) {
        if (state is AddingChildState) {
          return Center(
            child: SizedBox(
              width: size.width * 0.5,
              child: const LoadingIndicator(
                indicatorType: Indicator.ballPulse,
                colors: [AppColors.primaryColor],
                strokeWidth: 2,
                backgroundColor: Colors.white,
                pathBackgroundColor: Colors.white,
              ),
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                text: AppLocalizations.of(context)!.addChild,
                fontSize: textScale * 30,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: size.height * 0.025),
              InkWell(
                child: profilePictureFile ??
                    SvgPicture.asset(
                      addChildPlusIcon,
                      width: size.width * 0.4,
                    ),
                onTap: () async {
                  ImagePicker picker = ImagePicker();
                  XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      chosen_image = image;
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
                      labelText: AppLocalizations.of(context)!.childsNameField),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: DateTimeField(
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
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.pregnancyDurationField),
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
              SizedBox(height: size.height * 0.01),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    left: size.width * 0.1, right: size.width * 0.4),
                child: TextField(
                  controller: idController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.childsIdField),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    left: size.width * 0.1, right: size.width * 0.6),
                child: AppButton(
                  label: "+  Add",
                  roundness: 12,
                  onPressed: () async {
                    var snackBar = SnackBar(
                      content: Text(
                          AppLocalizations.of(context)!.enterAllFieldsSnackBar),
                    );
                    if (nameController.text == "" ||
                        durationController.text == "" ||
                        idController.text == "" ||
                        selected_gender == "") {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                    String imagePath = "";
                    if (chosen_image != null) {
                      final appDir = await getApplicationDocumentsDirectory();
                      // final List<String> strings = chosen_image!.path.split(".");
                      // final fileName =
                      //     basename(strings[strings.length - 2] + "." + strings.last);
                      final fileName = basename(chosen_image!.path);
                      imagePath = '${appDir.path}/$fileName';
                      await chosen_image!.saveTo(imagePath);
                    } else {
                      imagePath = "";
                    }
                    ChildModel newChild = ChildModel(
                      name: nameController.text,
                      dateOfBirth: _selectedDate,
                      imagePath: imagePath,
                      id: int.parse(idController.text),
                      gender: selected_gender,
                      pregnancyDuration: double.parse(durationController.text),
                    );
                    BlocProvider.of<ChildBloc>(context).add(AddChildEvent(
                        context: context,
                        child: newChild,
                        addNotifications: true,
                        whenDone: () {
                          BlocProvider.of<CurrentChildCubit>(context)
                              .changeCurrentChild(newChild, () {
                            BlocProvider.of<DecisionBloc>(context).add(
                                GetDecisionsByAgeEvent(
                                    dateOfBirth: newChild.dateOfBirth,
                                    childId: newChild.id));
                          });
                          Navigator.popAndPushNamed(context, Routes.home);
                        }));
                  },
                ),
              ),
              SizedBox(height: size.height * 0.1),
              BlocListener<ChildBloc, ChildState>(
                listener: (context, state) {
                  if (state is ErrorAddingChildUniqueIDState ||
                      state is ErrorAddingChildState) {
                    var snackBar = SnackBar(
                      content: Text(
                          AppLocalizations.of(context)!.childsIdExistsSnackBar),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Container(),
              )
            ],
          ),
        );
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
          groupValue: selected_gender,
          onChanged: (value) {
            setState(() {
              selected_gender = value!;
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
