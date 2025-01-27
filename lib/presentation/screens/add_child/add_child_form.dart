import 'dart:io';

import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/logic/blocs/decision/decision_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/logic/shared/functions.dart';
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
import 'package:responsive_framework/responsive_framework.dart';

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
  final _formKey = GlobalKey<FormState>();
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
    final isMOBILE = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final textScale = isMOBILE
        ? MediaQuery.of(context).size.height * 0.001
        : MediaQuery.of(context).size.height * 0.0011;

    final format = DateFormat("yyyy-MM-dd");

    return BlocConsumer<ChildBloc, ChildState>(
      listener: (context, state) {
        if (state is ErrorAddingChildState) {
          var snackBar = SnackBar(
            content:
                Text(AppLocalizations.of(context)!.checkInternetConnection),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        if (state is AddingChildState) {
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
        return Scaffold(
          backgroundColor: Color.fromRGBO(24, 233, 111, 0),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                          width: isMOBILE ? size.width * 0.4 : size.width * 0.3,
                        ),
                    onTap: () async {
                      ImagePicker picker = ImagePicker();
                      XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          chosen_image = image;
                          profilePictureFile = CircleAvatar(
                            radius:
                                isMOBILE ? size.width * 0.2 : size.width * 0.15,
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
                    child: TextFormField(
                      controller: nameController,
                      style: TextStyle(fontSize: textScale * 20),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.enterName;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.childsNameField,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: DateTimeField(
                      decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: textScale * 20),
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
                      validator: (value) {
                        if (value == null) {
                          return AppLocalizations.of(context)!.enterDate;
                        }
                        return null;
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
                    child: TextFormField(
                      controller: durationController,
                      style: TextStyle(fontSize: textScale * 20),
                      keyboardType: Platform.isIOS
                          ? const TextInputType.numberWithOptions(
                              signed: true, decimal: true)
                          : TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp('[0-9\u0660-\u0669]+')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.enterNumber;
                        }
                        int valueInt = int.parse(replaceArabicNumber(value));
                        if (valueInt < 25 || valueInt > 42) {
                          return AppLocalizations.of(context)!.enterValidNumber;
                        }
                        return null;
                      },
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
                        addRadioButton(0, AppLocalizations.of(context)!.male,
                            size, textScale, isMOBILE),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        addRadioButton(1, AppLocalizations.of(context)!.female,
                            size, textScale, isMOBILE),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        left: size.width * 0.1, right: size.width * 0.4),
                    child: TextFormField(
                      controller: idController,
                      style: TextStyle(fontSize: textScale * 20),
                      keyboardType: Platform.isIOS
                          ? const TextInputType.numberWithOptions(
                              signed: true, decimal: true)
                          : TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp('[0-9\u0660-\u0669]+')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.enterNumber;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.childsIdField),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        left: size.width * 0.1, right: size.width * 0.6),
                    child: AppButton(
                      label: "+  " + AppLocalizations.of(context)!.add,
                      roundness: 12,
                      fontSize: textScale * 20,
                      onPressed: () async {
                        var snackBar = SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .enterAllFieldsSnackBar),
                        );
                        // if (nameController.text == "" ||
                        //     durationController.text == "" ||
                        //     idController.text == "" ||) {
                        // }
                        if (!_formKey.currentState!.validate() ||
                            selected_gender == "") {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        String imagePath = "";
                        if (chosen_image != null) {
                          final appDir =
                              await getApplicationDocumentsDirectory();
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
                          id: int.parse(replaceArabicNumber(idController.text)),
                          gender: selected_gender,
                          pregnancyDuration: int.parse(
                              replaceArabicNumber(durationController.text)),
                        );
                        BlocProvider.of<ChildBloc>(context).add(AddChildEvent(
                            appLocalizations: AppLocalizations.of(context)!,
                            child: newChild,
                            addNotifications: true,
                            whenDone: () {
                              BlocProvider.of<CurrentChildCubit>(context)
                                  .changeCurrentChild(newChild, () {
                                BlocProvider.of<DecisionBloc>(context).add(
                                    GetDecisionsByAgeEvent(child: newChild));
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
            ),
          ),
        );
      },
    );
  }

  Row addRadioButton(
      int btnValue, String title, Size size, double textScale, bool isMOBILE) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Transform.scale(
          scale: isMOBILE ? 1 : 1.5,
          child: Radio<String>(
            activeColor: AppColors.primaryColor,
            value: gender[btnValue],
            groupValue: selected_gender,
            onChanged: (value) {
              setState(() {
                selected_gender = value!;
              });
            },
          ),
        ),
        SizedBox(width: isMOBILE ? 0 : size.width * 0.01),
        AppText(
          text: title,
          fontSize: textScale * 20,
        )
      ],
    );
  }
}
