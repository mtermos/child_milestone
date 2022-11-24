import 'package:child_milestone/data/models/tip.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';

class TipItemWidget extends StatefulWidget {
  TipItemWidget({Key? key, required this.item}) : super(key: key);
  final TipModel item;

  @override
  _TipItemWidgetState createState() => _TipItemWidgetState();
}

class _TipItemWidgetState extends State<TipItemWidget> {
  final Color borderColor = const Color(0xffE2E2E2);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    YoutubePlayerController? _controller;
    if (widget.item.videoURL != null) {
      _controller = YoutubePlayerController(
        initialVideoId:
            YoutubePlayer.convertUrlToId(widget.item.videoURL!) ?? "",
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          showLiveFullscreenButton: false,
        ),
      );
    }
    _MyYoutubePlayerState _myYoutubePlayerState = _MyYoutubePlayerState();

    return Container(
      width: size.width * 0.6,
      height: size.width * 0.6,
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
      child: widget.item.videoURL != null
          ? Container(
              width: size.width * 0.6,
              height: size.width * 0.6,
              child: FlutterYoutubeView(
                  onViewCreated: _myYoutubePlayerState._onYoutubeCreated,
                  listener: _myYoutubePlayerState,
                  scaleMode:
                      YoutubeScaleMode.none, // <option> fitWidth, fitHeight
                  params: const YoutubeParam(
                      videoId: 'gcj2RUWQZ60',
                      showUI: false,
                      startSeconds: 0.0, // <option>
                      autoPlay: false) // <option>
                  ))

          // ? YoutubePlayer(
          //     key: ObjectKey(_controller!),
          //     controller: _controller,
          //     // actionsPadding: const EdgeInsets.only(left: 16.0),
          //     // showVideoProgressIndicator: true,
          //     bottomActions: [
          //       CurrentPosition(),
          //       const SizedBox(width: 10.0),
          //       ProgressBar(isExpanded: true),
          //       const SizedBox(width: 10.0),
          //       // RemainingDuration(),
          //       // FullScreenButton(),
          //     ],
          //   )
          : AppText(
              text: widget.item.body,
              color: Colors.black,
              fontSize: textScale * 16,
            ),
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
}

class MyYoutubePlayer extends StatefulWidget {
  MyYoutubePlayer({Key? key}) : super(key: key);

  @override
  State<MyYoutubePlayer> createState() => _MyYoutubePlayerState();
}

class _MyYoutubePlayerState extends State<MyYoutubePlayer>
    implements YouTubePlayerListener {
  double _currentVideoSecond = 0.0;
  String _playerState = "";
  late FlutterYoutubeViewController _controller;

  @override
  void onCurrentSecond(double second) {
    _currentVideoSecond = second;
  }

  @override
  void onError(String error) {}

  @override
  void onReady() {}

  @override
  void onStateChange(String state) {
    setState(() {
      _playerState = state;
    });
  }

  @override
  void onVideoDuration(double duration) {}

  void _onYoutubeCreated(FlutterYoutubeViewController controller) {
    _controller = controller;
  }

  void _loadOrCueVideo() {
    _controller.loadOrCueVideo('gcj2RUWQZ60', _currentVideoSecond);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
