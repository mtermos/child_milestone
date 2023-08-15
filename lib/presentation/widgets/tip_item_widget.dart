import 'dart:io';
import 'dart:typed_data';

import 'package:child_milestone/data/models/log.dart';
import 'package:child_milestone/data/models/tip.dart';
import 'package:child_milestone/logic/blocs/log/log_bloc.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdfx/pdfx.dart';
// import 'package:pdf_render/pdf_render.dart';

class TipItemWidget extends StatefulWidget {
  final TipModel item;
  const TipItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  _TipItemWidgetState createState() => _TipItemWidgetState();
}

class _TipItemWidgetState extends State<TipItemWidget> {
  final Color borderColor = const Color(0xffE2E2E2);
  final String youtubeLogo = "assets/icons/youtube.png";
  final String videoSVG = "assets/images/video.svg";
  final String documentSVG = "assets/images/document.svg";
  final String webSVG = "assets/images/web.svg";

  late Future<Uint8List?> pdfImage;

  @override
  void initState() {
    if (widget.item.documentURL != null) {
      pdfImage = imageFromPdfFile(widget.item.documentURL!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    Widget body;
    YoutubePlayerController? _controller;
    if (widget.item.videoURL != null) {
      if (widget.item.videoURL!.contains("/shorts/") ||
          widget.item.videoURL!.contains("raisingchildren.net.au")) {
        body = InkWell(
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
          onTap: () => launchUrl(Uri.parse(widget.item.videoURL!)),
        );
      } else {
        _controller = YoutubePlayerController(
          initialVideoId:
              YoutubePlayer.convertUrlToId(widget.item.videoURL!) ?? "",
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            showLiveFullscreenButton: false,
          ),
        );
        body = Column(
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
                  AppText(
                    text: AppLocalizations.of(context)!.clickToWatchOn,
                    fontSize: textScale * 18,
                  ),
                  SizedBox(width: size.width * 0.015),
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
              onTap: () {
                BlocProvider.of<LogBloc>(context).add(
                  AddLogEvent(
                    log: LogModel(
                      action: "open video",
                      description:
                          "The user clicked on the tip with id: ${widget.item.id}, period: id: ${widget.item.period}, and link of video: ${widget.item.videoURL!}",
                      takenAt: DateTime.now(),
                    ),
                  ),
                );
                launchUrl(Uri.parse(widget.item.videoURL!));
              },
            )
          ],
        );
      }
    } else if (widget.item.documentURL != null) {
      body = InkWell(
        child: Column(
          children: [
            FutureBuilder<Uint8List?>(
                future: pdfImage,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final image = snapshot.data!;
                    return Image.memory(image);
                  } else {
                    return SvgPicture.asset(
                      documentSVG,
                      width: size.width * 0.25,
                      alignment: Alignment.center,
                    );
                  }
                }),
            // SvgPicture.asset(
            //   documentSVG,
            //   width: size.width * 0.25,
            //   alignment: Alignment.center,
            // ),
            SizedBox(height: size.height * 0.01),
            AppText(
              text: AppLocalizations.of(context)!.clickToOpenDocument,
              color: Colors.black,
              fontSize: textScale * 16,
            ),
          ],
        ),
        // onTap: () => launchUrl(Uri.parse(widget.item.documentURL!)),
        onTap: () {
          BlocProvider.of<LogBloc>(context).add(
            AddLogEvent(
              log: LogModel(
                action: "open pdf",
                description:
                    "The user clicked on the tip with id: ${widget.item.id}, period: id: ${widget.item.period}, and link of pdf: ${widget.item.documentURL!}",
                takenAt: DateTime.now(),
              ),
            ),
          );
          showDialog(
            context: context,
            builder: (_) {
              return Scaffold(
                floatingActionButton: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        launchUrl(Uri.parse(widget.item.documentURL!));
                      },
                      backgroundColor: AppColors.primaryColor,
                      child: const Icon(Icons.download),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                body: SfPdfViewer.network(widget.item.documentURL!),
              );
            },
          );
        },
      );
    } else if (widget.item.webURL != null) {
      body = InkWell(
        child: Column(
          children: [
            SvgPicture.asset(
              webSVG,
              width: size.width * 0.25,
              alignment: Alignment.center,
            ),
            SizedBox(height: size.height * 0.01),
            AppText(
              text: AppLocalizations.of(context)!.clickToOpenURL,
              color: Colors.black,
              fontSize: textScale * 16,
            ),
          ],
        ),
        onTap: () => launchUrl(Uri.parse(widget.item.webURL!)),
      );
    } else {
      body = AppText(
        text: widget.item.body,
        color: Colors.black,
        fontSize: textScale * 16,
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.height * 0.015,
        horizontal: size.width * 0.05,
      ),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
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
      child: body,
      // RichText(
      //   text: TextSpan(
      //     style: TextStyle(
      //       fontSize: textScale * 16,
      //       color: Colors.black,
      //     ),
      //     children: <TextSpan>[
      //       TextSpan(),
      //     ],
      //   ),
      // ),
    );
  }

  // send pdfFile as params
  Future<Uint8List?> imageFromPdfFile(String url) async {
    final Response<List<int>> response = await Dio().get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    if (response.data == null) return null;
    Uint8List data = Uint8List.fromList(response.data!);
    final document = await PdfDocument.openData(data);
    final page = await document.getPage(1);
    final pageImage = await page.render(width: page.width, height: page.height);
    await page.close();
    return pageImage!.bytes;
  }
}
