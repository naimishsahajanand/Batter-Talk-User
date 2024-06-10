// ignore_for_file: prefer__ructors, prefer__literals_to_create_immutables, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, await_only_futures, avoid_print, sort_child_properties_last, prefer_const_constructors, sized_box_for_whitespace, prefer_const_declarations, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OneCallPage extends StatefulWidget {
  OneCallPage({super.key});

  @override
  State<OneCallPage> createState() => _OneCallPageState();
}

class _OneCallPageState extends State<OneCallPage> {
  late RtcEngine _engine;
  int? _remoteUid;
  bool muted = false;
  String usertoken = "";
  String agoraToken = "";
  // var data = AllAppoinmentData().obs;

  void _onCallEnd(BuildContext context) async {
    Navigator.pop(context);
    Get.defaultDialog(
      barrierDismissible: false,
      backgroundColor: AppColor.BgColor,
      title: "Rate your session",
      contentPadding: EdgeInsets.symmetric(horizontal: 15),
      content: Container(
        child: Column(
          children: [
            Image.asset(
              AppImage.appIcon + "reviewvector.png",
              width: 100,
            ),
            RatingBar.builder(
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              glow: false,
              unratedColor: Colors.transparent,
              itemCount: 5,
              itemSize: 20,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
            ),
            SizedBox(height: 10),
            Container(
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.SoftTextColor.withOpacity(0.1),
                  border: Border.all(color: AppColor.BorderColor)),
              child: TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                    hintText: "Type in your feedback",
                    hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColor.SoftTextColor,
                        fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 5)),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.DarkGrey,
                ),
                child: Center(
                  child: CommonWidget().interText(
                      text: "Submit Feedback",
                      size: 12.0,
                      weight: FontWeight.w500,
                      color: AppColor.BgColor),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  initAgora() async {
    requestPermission();
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: "9e15b123fda34622b76d758f90e0fd69",
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    _engine.setRecordingAudioFrameParameters(
        sampleRate: 10,
        channel: 5,
        mode: RawAudioFrameOpModeType.rawAudioFrameOpModeReadWrite,
        samplesPerCall: 10);
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {});
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          _onCallEnd(context);

          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          setState(() {});
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableAudio();
    // await _engine.startPreview();
    await _engine.joinChannel(
      token: CallToken.calltoken,
      // token: agoraToken,
      channelId: 'My New Project',
      uid: 0,
      options: ChannelMediaOptions(),
    );
  }

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token") ?? "";
    });
  }

  @override
  void initState() {
    getName();
    // data.value = Get.arguments;

    initAgora();
    super.initState();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> requestPermission() async {
    final permission = Permission.microphone;

    if (await permission.isDenied) {
      final result = await permission.request();

      if (result.isGranted) {
        await permission.status.isGranted;
      } else if (result.isDenied) {
        await permission.request();
      } else if (result.isPermanentlyDenied) {
        await permission.status.isPermanentlyDenied;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          _toolbar(),
        ],
      ),
    );
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            // onPressed: () {
            //   _engine.leaveChannel();
            //   Navigator.pop(context);
            // },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.black54,
          image:
              DecorationImage(image: AssetImage(AppImage.appIcon + "user.png")),
        ),
      );
    } else {
      return Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: Colors.black54),
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidget().interText(
                  text: "Calling...",
                  size: 35.0,
                  color: AppColor.BgColor,
                  weight: FontWeight.w700),
              CommonWidget().interText(
                  text: "Waiting For Other User",
                  size: 20.0,
                  color: AppColor.BgColor,
                  weight: FontWeight.w500),
            ],
          ),
        ),
      );
    }
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }
}
