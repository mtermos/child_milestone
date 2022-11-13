import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/data_providers/milestone_categories_list.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/logic/blocs/decision/decision_bloc.dart';
import 'package:child_milestone/logic/blocs/milestone/milestone_bloc.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MilestoneSummaryItem extends StatefulWidget {
  final MilestoneItem milestoneItem;
  final ChildModel child;
  final int decision;
  final bool redFlag;
  final bool editable;
  final bool topBar;
  const MilestoneSummaryItem(
      {required this.milestoneItem,
      required this.child,
      required this.redFlag,
      required this.decision,
      required this.editable,
      this.topBar = false,
      Key? key})
      : super(key: key);

  @override
  State<MilestoneSummaryItem> createState() => _MilestoneSummaryItemState();
}

class _MilestoneSummaryItemState extends State<MilestoneSummaryItem> {
  int decision = 1;
  String category = "";
  final String youtubeLogo = "assets/icons/youtube.png";

  @override
  void initState() {
    decision = widget.decision;
    category = categories[widget.milestoneItem.category - 1].name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    const String editIcon = "assets/icons/edit_icon.svg";
    const String videoSVG = "assets/images/video.svg";
    Widget? youtubeWidget;

    YoutubePlayerController? _controller;
    if (widget.decision == -1 &&
        widget.redFlag &&
        widget.milestoneItem.videoPath != null) {
      if (widget.milestoneItem.videoPath!.contains("/shorts/") ||
          widget.milestoneItem.videoPath!.contains("raisingchildren.net.au")) {
        youtubeWidget = InkWell(
          child: Column(
            children: [
              SvgPicture.asset(
                videoSVG,
                width: size.width * 0.25,
                alignment: Alignment.center,
              ),
              SizedBox(height: size.height * 0.01),
              AppText(
                text: AppLocalizations.of(context)!.clickToWatchVideo,
                color: Colors.black,
                fontSize: textScale * 16,
              ),
            ],
          ),
          onTap: () => launchUrl(Uri.parse(widget.milestoneItem.videoPath!)),
        );
      } else {
        _controller = YoutubePlayerController(
          initialVideoId:
              YoutubePlayer.convertUrlToId(widget.milestoneItem.videoPath!) ??
                  "",
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            showLiveFullscreenButton: false,
          ),
        );
        youtubeWidget = Column(
          children: [
            YoutubePlayer(
              key: ObjectKey(_controller),
              controller: _controller,
              // actionsPadding: const EdgeInsets.only(left: 16.0),
              bottomActions: [
                CurrentPosition(),
                const SizedBox(width: 10.0),
                ProgressBar(isExpanded: true),
                const SizedBox(width: 10.0),
                // RemainingDuration(),
                // FullScreenButton(),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    youtubeLogo,
                    width: size.width * 0.2,
                  ),
                ],
              ),

              // child: AppText(
              //   text: widget.item.body,
              //   color: Colors.black,
              //   fontSize: textScale * 16,
              // ),
              onTap: () =>
                  launchUrl(Uri.parse(widget.milestoneItem.videoPath!)),
            )
          ],
        );
      }
    }
    return Container(
      width: size.width * 0.75,
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Column(
        children: [
          widget.topBar
              ? Divider(
                  thickness: textScale * 1,
                  color: Colors.black,
                )
              : const SizedBox.shrink(),
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
            children: [
              SizedBox(
                width: size.width * 0.65,
                child: AppText(
                  text: widget.milestoneItem.description,
                  textAlign: TextAlign.start,
                ),
              ),
              const Spacer(),
              widget.editable
                  ? InkWell(
                      onTap: () => {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  // title:
                                  //     AppText(text: widget.milestoneItem.description),
                                  title: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: textScale * 28,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: AppText(
                                            text: widget.decision == -1
                                                ? AppLocalizations.of(context)!
                                                    .enterDecision
                                                : AppLocalizations.of(context)!
                                                    .updateDecision,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.close,
                                        size: textScale * 28,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  titlePadding: EdgeInsets.all(0),
                                  content: Padding(
                                    padding: EdgeInsets.only(
                                        left: size.width * 0.05,
                                        right: size.width * 0.05,
                                        bottom: size.height * 0.04),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppText(
                                          text:
                                              widget.milestoneItem.description,
                                          fontSize: textScale * 26,
                                          color: AppColors.primaryColorDarker,
                                        ),
                                        widget.decision == -1 && widget.redFlag
                                            ? youtubeWidget!
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actionsPadding: EdgeInsets.only(
                                      bottom: size.height * 0.05),
                                  actions: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          decision = 1;
                                        });
                                        BlocProvider.of<DecisionBloc>(context)
                                            .add(AddDecisionEvent(
                                          decision: DecisionModel(
                                            childId: widget.child.id,
                                            milestoneId:
                                                widget.milestoneItem.id,
                                            decision: 1,
                                            takenAt: DateTime.now(),
                                          ),
                                          onSuccess: () {
                                            BlocProvider.of<MilestoneBloc>(
                                                    context)
                                                .add(
                                                    GetMilestonesForSummaryEvent(
                                                        child: widget.child,
                                                        periodId: widget
                                                            .milestoneItem
                                                            .period));
                                            Navigator.pop(context);
                                          },
                                        ));
                                      },
                                      child: Container(
                                        width: size.width * 0.15,
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6)),
                                          color: decision == 1
                                              ? Colors.green[200]
                                              : Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black54,
                                              offset: Offset(
                                                  textScale * 2, textScale * 4),
                                              blurRadius: textScale * 8,
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: textScale * 15,
                                          horizontal: textScale * 20,
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.yes,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          decision = 2;
                                        });
                                        BlocProvider.of<DecisionBloc>(context)
                                            .add(AddDecisionEvent(
                                          decision: DecisionModel(
                                            childId: widget.child.id,
                                            milestoneId:
                                                widget.milestoneItem.id,
                                            decision: 2,
                                            takenAt: DateTime.now(),
                                          ),
                                          onSuccess: () {
                                            BlocProvider.of<MilestoneBloc>(
                                                    context)
                                                .add(
                                                    GetMilestonesForSummaryEvent(
                                                        child: widget.child,
                                                        periodId: widget
                                                            .milestoneItem
                                                            .period));
                                            Navigator.pop(context);
                                          },
                                        ));
                                        // BlocProvider.of<DecisionBloc>(context).add(
                                        //     GetDecisionsByAgeEvent(
                                        //         dateOfBirth: selected_child!.dateOfBirth));
                                      },
                                      child: Container(
                                        width: size.width * 0.15,
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6)),
                                          color: decision == 2
                                              ? Colors.red[200]
                                              : Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black54,
                                              offset: Offset(
                                                  textScale * 2, textScale * 4),
                                              blurRadius: textScale * 8,
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: textScale * 15,
                                          horizontal: textScale * 20,
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.no,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          decision = 3;
                                        });
                                        BlocProvider.of<DecisionBloc>(context)
                                            .add(AddDecisionEvent(
                                                decision: DecisionModel(
                                                  childId: widget.child.id,
                                                  milestoneId:
                                                      widget.milestoneItem.id,
                                                  decision: 3,
                                                  takenAt: DateTime.now(),
                                                ),
                                                onSuccess: () {
                                                  BlocProvider.of<
                                                              MilestoneBloc>(
                                                          context)
                                                      .add(
                                                          GetMilestonesForSummaryEvent(
                                                              child:
                                                                  widget.child,
                                                              periodId: widget
                                                                  .milestoneItem
                                                                  .period));
                                                  Navigator.pop(context);
                                                }));
                                      },
                                      child: Container(
                                        width: size.width * 0.15,
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6)),
                                          color: decision == 3
                                              ? Colors.yellow[200]
                                              : Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black54,
                                              offset: Offset(
                                                  textScale * 2, textScale * 4),
                                              blurRadius: textScale * 8,
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: textScale * 15,
                                          horizontal: textScale * 20,
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.maybe,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                        // Navigator.pushNamed(context, Routes.milestone,
                        //     arguments: milestoneItem.category)
                      },
                      child: SvgPicture.asset(
                        editIcon,
                        width: size.width * 0.05,
                        alignment: Alignment.center,
                        color: Colors.black,
                      ),
                    )
                  : Container(),
            ],
          ),
          Row(
            children: [
              AppText(
                text: "نوع المتابعة: " + category,
                color: Colors.blue,
                fontSize: textScale * 16,
              ),
              SizedBox(width: size.width * 0.02),
              widget.redFlag
                  ? AppText(
                      text: "[من مرحلة عمرية سابقة]",
                      color: Colors.red,
                      fontSize: textScale * 16,
                    )
                  : SizedBox.shrink(),
            ],
          )
        ],
      ),
      // child: Text(milestoneItem.description),
    );
  }
}
