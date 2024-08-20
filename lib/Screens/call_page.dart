// ignore_for_file: prefer__ructors, prefer__literals_to_create_immutables, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, await_only_futures, avoid_print, sort_child_properties_last, prefer_const_constructors, sized_box_for_whitespace, prefer_const_declarations, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CallPage extends StatefulWidget {
  CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late RtcEngine _engine;
  int? _remoteUid;
  bool muted = false;
  bool handRaiseState = false;
  List caller_list = [];
  String agoraToken = "";
  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
    setState(() {
      caller_list.remove(_remoteUid);
      print(">>>>>remove ${caller_list.length}");
    });
  }

  // appId: "81c16bcc2d114903badaea8634aadf02",
  // appId: "be34b8af1cc64071bc0e9bc9b9beef49",
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
            caller_list.add(_remoteUid);
            print(">>>>>${caller_list.length}");
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            caller_list.isEmpty ? _remoteUid = null : SizedBox();
          });
          print(">>>>>${caller_list.length}");
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          print("=======++++=====${token}");
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableAudio();
    await _engine.startPreview();
    await _engine.joinChannel(
      channelId: 'My New Project 3',
      // channelId: 'My New Project',
      token: CallToken.calltoken,
      // token: agoraToken,
      uid: 0,
      options: ChannelMediaOptions(
        audioDelayMs: 10,
      ),
    );
  }

  @override
  void initState() {
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
            child: handRaiseState
                ? Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: AppColor.DarkGrey.withOpacity(0.2),
                          shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.back_hand,
                          color: AppColor.ActiveBlueColor,
                          size: 50,
                        ),
                      ),
                    ),
                  )
                : _remoteAudio(),
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
          RawMaterialButton(
            onPressed: () {
              if (handRaiseState == false) {
                setState(() {
                  handRaiseState = true;
                  Future.delayed(
                    Duration(seconds: 2),
                    () {
                      setState(() {
                        handRaiseState = false;
                      });
                    },
                  );
                });
              }
            },
            child: Icon(
              Icons.back_hand,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  Widget _remoteAudio() {
    print("remote${_remoteUid}");
    if (_remoteUid != null) {
      return Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.ActiveBlueColor.withOpacity(0.5),
        ),
        child: GridView.builder(
          padding: EdgeInsets.only(bottom: 120, top: 120, left: 15, right: 15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
          itemCount: caller_list.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: AppColor.BlackColor,
                  image: DecorationImage(
                      image: AssetImage(AppImage.appIcon + "user.png")),
                  borderRadius: BorderRadius.circular(15)),
            );
          },
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
