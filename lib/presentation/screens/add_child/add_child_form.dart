import 'dart:io';

import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
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

class AddChildForm extends StatefulWidget {
  AddChildForm({Key? key}) : super(key: key);

  @override
  State<AddChildForm> createState() => _AddChildFormState();
}

class _AddChildFormState extends State<AddChildForm> {
  static const String add_child_plus_icon =
      "assets/icons/add_child_plus_icon.svg";
  static const String steps_icon = "assets/icons/steps_icon.png";
  final nameController = TextEditingController();
  final durationController = TextEditingController();
  final idController = TextEditingController();
  DateTime _selected_date = DateTime.now();

  CircleAvatar? profile_picture_file;
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText(
            text: "Add Child",
            fontSize: textScale * 30,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: size.height * 0.025),
          InkWell(
            child: profile_picture_file ??
                SvgPicture.asset(
                  add_child_plus_icon,
                  width: size.width * 0.4,
                ),
            onTap: () async {
              ImagePicker picker = ImagePicker();
              XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setState(() {
                  chosen_image = image;
                  profile_picture_file = CircleAvatar(
                    radius: size.width * 0.2,
                    backgroundImage: Image.file(File(image.path)).image,
                  );
                });
              }
            },
          ),
          SizedBox(height: size.height * 0.025),
          AppText(
            text: "Add Photo",
            fontSize: textScale * 20,
            color: Colors.black,
          ),
          SizedBox(height: size.height * 0.02),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Child's Name"),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: DateTimeField(
              decoration: InputDecoration(labelText: "Date of Birth"),
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
                  _selected_date = date;
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
                  labelText: "Duration of Pregnancy (in weeks)"),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
                left: size.width * 0.1, top: size.height * 0.02),
            child: Row(
              children: [
                AppText(
                  text: "Gender:",
                  fontSize: textScale * 20,
                ),
                addRadioButton(0, 'Male'),
                SizedBox(
                  width: size.width * 0.05,
                ),
                addRadioButton(1, 'Female'),
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
              decoration: InputDecoration(labelText: "Child's ID"),
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
                const snackBar = SnackBar(
                  content: Text('Enter all the fields!'),
                );
                if (chosen_image == null ||
                    nameController.text == "" ||
                    durationController.text == "" ||
                    idController.text == "" ||
                    selected_gender == "") {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }

                final appDir = await getApplicationDocumentsDirectory();
                final List<String> strings = chosen_image!.path.split(".");
                final fileName =
                    basename(strings[strings.length - 2] + "." + strings.last);
                String image_path = '${appDir.path}/$fileName';
                await chosen_image!.saveTo(image_path);
                ChildModel newChild = ChildModel(
                    name: nameController.text,
                    date_of_birth: _selected_date,
                    image_path: image_path,
                    child_id: idController.text,
                    gender: selected_gender,
                    pregnancy_duration: double.parse(durationController.text));
                BlocProvider.of<ChildBloc>(context).add(AddChildEvent(
                    child: newChild,
                    whenDone: () {
                      BlocProvider.of<CurrentChildCubit>(context)
                          .change_current_child(newChild);
                      Navigator.popAndPushNamed(context, "/home");
                    }));
                // final nextState =
                //     await BlocProvider.of<ChildBloc>(context).state;
                // // print(nextState);
                // if (nextState is AddedChildState) {
                //   BlocProvider.of<CurrentChildCubit>(context)
                //       .change_current_child(newChild);
                //   Navigator.popAndPushNamed(context, "/home");
                // }
                // Navigator.pop(context);
                // Navigator.pushNamed(context, '/home');
              },
            ),
          ),
          SizedBox(height: size.height * 0.1),
          BlocListener<ChildBloc, ChildState>(
            listener: (context, state) {
              if (state is ErrorAddingChildUniqueIDState) {
                const snackBar = SnackBar(
                  content: Text('Child ID already exists'),
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
