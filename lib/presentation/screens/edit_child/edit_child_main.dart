import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/screens/edit_child/edit_child_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EditChildScreen extends StatefulWidget {
  final int childId;
  const EditChildScreen({super.key, required this.childId});

  @override
  _EditChildScreenState createState() => _EditChildScreenState();
}

class _EditChildScreenState extends State<EditChildScreen> {
  ChildModel? child;

  @override
  void initState() {
    BlocProvider.of<ChildBloc>(context).add(GetChildEvent(id: widget.childId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isMOBILE = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return Container(
      color: Colors.white,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            _editChildTopBar(context, size),
            SizedBox(
              height: size.height * 0.02,
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _editChildBackground(context, size, isMOBILE),
                  ),
                  BlocBuilder<ChildBloc, ChildState>(
                    builder: (context, state) {
                      if (state is ChildLoadedState) {
                        child = state.child;
                      }
                      return child != null
                          ? EditChildForm(child: child!)
                          : AppText(text: "loading");
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _editChildTopBar(BuildContext context, Size size) {
    return Container(
      padding: EdgeInsets.only(
        left: size.width * 0.07,
        top: size.height * 0.02,
      ),
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: () {
          // Navigator.pop(context);
          Navigator.popAndPushNamed(context, Routes.home);
        },
        child: AppText(
          text: AppLocalizations.of(context)!.cancel,
          fontSize: size.height * 0.025,
        ),
      ),
    );
  }

  Widget _editChildBackground(BuildContext context, Size size, bool isMOBILE) {
    const String editChildBgItem1 = "assets/images/add_child_bg_item_1.svg";
    return SvgPicture.asset(
      editChildBgItem1,
      width: isMOBILE ? size.width * 0.5 : size.width * 0.35,
    );
  }
}
