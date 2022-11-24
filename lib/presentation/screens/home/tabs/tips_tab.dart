import 'dart:io';

import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/tip.dart';
import 'package:child_milestone/logic/blocs/tip/tip_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/logic/shared/functions.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/widgets/tip_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TipsTab extends StatefulWidget {
  const TipsTab({Key? key}) : super(key: key);

  @override
  _TipsState createState() => _TipsState();
}

class _TipsState extends State<TipsTab> {
  ChildModel? current_child;
  List<TipModel> tipsItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Image tipsBg = Image.asset(
      "assets/images/tips_bg.png",
      alignment: Alignment.topCenter,
      width: size.width,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<CurrentChildCubit, CurrentChildState>(
        builder: (context, state) {
          if (state is CurrentChildChangedState) {
            current_child = state.new_current_child;
            BlocProvider.of<TipBloc>(context)
                .add(GetTipsByAgeEvent(child: current_child!));
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: size.width,
                  height: size.width * 0.85,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        right: 0,
                        child: tipsBg,
                      ),
                      Positioned(
                        top: size.height * 0.045,
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: size.width * 0.16,
                                ),
                                current_child != null
                                    ? CircleAvatar(
                                        radius: size.width * 0.15,
                                        backgroundColor: Colors.white,
                                        backgroundImage: current_child!
                                                    .imagePath !=
                                                ""
                                            ? Image.file(File(
                                                    current_child!.imagePath))
                                                .image
                                            : Image.asset(noImageAsset(
                                                    current_child!))
                                                .image,
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: size.width * 0.16,
                                      ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.035),
                            AppText(
                              text: AppLocalizations.of(context)!
                                  .tipsAndActivities,
                              color: Colors.white,
                              fontSize: size.height * 0.03,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<TipBloc, TipState>(
                  builder: (context, state) {
                    if (state is LoadedTipsByAgeState) {
                      tipsItems = state.tips;
                    }
                    return Column(
                        children: tipsItems.map((e) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                        ),
                        width: size.width,
                        child: TipItemWidget(
                          item: e,
                        ),
                      );
                    }).toList());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
