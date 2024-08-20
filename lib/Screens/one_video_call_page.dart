// ignore_for_file: prefer__ructors, prefer__literals_to_create_immutables, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, await_only_futures, avoid_print, sort_child_properties_last, prefer_const_constructors, sized_box_for_whitespace, prefer_const_declarations, prefer_const_constructors_in_immutables, unused_field

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OneVideoCallPage extends StatefulWidget {
  OneVideoCallPage({super.key});

  @override
  State<OneVideoCallPage> createState() => _OneVideoCallPageState();
}

class _OneVideoCallPageState extends State<OneVideoCallPage> {
  late RtcEngine _engine;
  bool _localUserJoined = false;
  int? _remoteUid;
  bool muted = false;
  String usertoken = "";
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

// appId: "81c16bcc2d114903badaea8634aadf02",
  // appId: "be34b8af1cc64071bc0e9bc9b9beef49",
  initAgora() async {
    // requestPermission();
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: "9e15b123fda34622b76d758f90e0fd69",
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    VideoEncoderConfiguration videoConfig = const VideoEncoderConfiguration(
        mirrorMode: VideoMirrorModeType.videoMirrorModeAuto,
        frameRate: 10,
        bitrate: standardBitrate,
        dimensions: VideoDimensions(width: 640, height: 360),
        orientationMode: OrientationMode.orientationModeAdaptive,
        degradationPreference: DegradationPreference.maintainBalanced);
    _engine.setVideoEncoderConfiguration(videoConfig);
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
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
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();

    await _engine.startPreview();
    await _engine.joinChannel(
      token: CallToken.calltoken,
      channelId: 'My New Project 3',
      // channelId: 'My New Project',
      uid: 0,
      options: ChannelMediaOptions(
        defaultVideoStreamType: VideoStreamType.videoStreamHigh,
        isAudioFilterable: true,
        audioDelayMs: 10,
      ),
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
    final permission = Permission.camera;

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
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(uid: 0),
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
            ),
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
        ],
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: "My New Project 3"),
          // connection: RtcConnection(channelId: "My New Project"),
        ),
      );
    } else {
      return Text(
        'Please wait for Other user to join',
        textAlign: TextAlign.center,
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

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:batter_talk_user/Helpers/common_widget.dart'; // Adjust the import as needed
// import 'package:batter_talk_user/Helpers/utility.dart'; // Adjust the import as needed

// class OneVideoCallPage extends StatefulWidget {
//   OneVideoCallPage({super.key});

//   @override
//   State<OneVideoCallPage> createState() => _OneVideoCallPageState();
// }

// class _OneVideoCallPageState extends State<OneVideoCallPage> {
//   late RtcEngine _engine;
//   bool _localUserJoined = false;
//   int? _remoteUid;
//   bool muted = false;
//   String usertoken = "";

//   @override
//   void initState() {
//     super.initState();
//     getName();
//     initAgora();
//   }

//   Future<void> getName() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     setState(() {
//       usertoken = pref.getString("token") ?? "";
//     });
//   }

//   Future<void> initAgora() async {
//     // Request necessary permissions
//     await requestPermission();

//     // Create RTC engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(RtcEngineContext(
//       appId: "9e15b123fda34622b76d758f90e0fd69",
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));

//     // Set up video configuration
//     VideoEncoderConfiguration videoConfig = VideoEncoderConfiguration(
//       mirrorMode: VideoMirrorModeType.videoMirrorModeAuto,
//       frameRate: 10,
//       bitrate: 800,
//       dimensions: VideoDimensions(width: 640, height: 360),
//       orientationMode: OrientationMode.orientationModeAdaptive,
//       degradationPreference: DegradationPreference.maintainBalanced,
//     );
//     await _engine.setVideoEncoderConfiguration(videoConfig);

//     // Register event handlers
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("local user ${connection.localUid} joined");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint("remote user $remoteUid joined");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           debugPrint("remote user $remoteUid left channel");
//           _onCallEnd(context);
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//           debugPrint(
//               '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//         },
//       ),
//     );

//     // Set client role and enable video
//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await _engine.enableVideo();

//     // Start the preview
//     await _engine.startPreview();

//     // Join the channel
//     await _engine.joinChannel(
//       token: CallToken.calltoken,
//       channelId: 'My New Project 3',
//       uid: 0,
//       options: ChannelMediaOptions(
//         defaultVideoStreamType: VideoStreamType.videoStreamHigh,
//         isAudioFilterable: true,
//         audioDelayMs: 10,
//       ),
//     );
//   }

//   Future<void> requestPermission() async {
//     await [Permission.camera, Permission.microphone].request();
//   }

//   Future<void> _dispose() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }

//   @override
//   void dispose() {
//     _dispose();
//     super.dispose();
//   }

//   void _onCallEnd(BuildContext context) async {
//     Navigator.pop(context);
//     Get.defaultDialog(
//       barrierDismissible: false,
//       backgroundColor: AppColor.BgColor,
//       title: "Rate your session",
//       contentPadding: EdgeInsets.symmetric(horizontal: 15),
//       content: Column(
//         children: [
//           Image.asset(
//             AppImage.appIcon + "reviewvector.png",
//             width: 100,
//           ),
//           RatingBar.builder(
//             initialRating: 5,
//             minRating: 1,
//             direction: Axis.horizontal,
//             glow: false,
//             unratedColor: Colors.transparent,
//             itemCount: 5,
//             itemSize: 20,
//             itemBuilder: (context, _) => Icon(
//               Icons.star,
//               color: Colors.amber,
//             ),
//             onRatingUpdate: (rating) {},
//           ),
//           SizedBox(height: 10),
//           Container(
//             height: 70,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               color: AppColor.SoftTextColor.withOpacity(0.1),
//               border: Border.all(color: AppColor.BorderColor),
//             ),
//             child: TextFormField(
//               maxLines: 5,
//               decoration: InputDecoration(
//                 hintText: "Type in your feedback",
//                 hintStyle: GoogleFonts.inter(
//                   fontSize: 14,
//                   color: AppColor.SoftTextColor,
//                   fontWeight: FontWeight.w400,
//                 ),
//                 border: InputBorder.none,
//                 contentPadding:
//                     EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           GestureDetector(
//             onTap: () {
//               Get.back();
//             },
//             child: Container(
//               height: 45,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 color: AppColor.DarkGrey,
//               ),
//               child: Center(
//                 child: CommonWidget().interText(
//                   text: "Submit Feedback",
//                   size: 12.0,
//                   weight: FontWeight.w500,
//                   color: AppColor.BgColor,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//         ],
//       ),
//     );
//   }

//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     _engine.muteLocalAudioStream(muted);
//   }

//   void _onSwitchCamera() {
//     _engine.switchCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Center(
//             child: _remoteVideo(),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: SizedBox(
//               width: 100,
//               height: 150,
//               child: Center(
//                 child: _localUserJoined
//                     ? AgoraVideoView(
//                         controller: VideoViewController(
//                           rtcEngine: _engine,
//                           canvas: VideoCanvas(uid: 0),
//                         ),
//                       )
//                     : CircularProgressIndicator(),
//               ),
//             ),
//           ),
//           _toolbar(),
//         ],
//       ),
//     );
//   }

//   Widget _toolbar() {
//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: EdgeInsets.symmetric(vertical: 48),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           RawMaterialButton(
//             onPressed: _onToggleMute,
//             child: Icon(
//               muted ? Icons.mic_off : Icons.mic,
//               color: muted ? Colors.white : Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: muted ? Colors.blueAccent : Colors.white,
//             padding: EdgeInsets.all(12.0),
//           ),
//           RawMaterialButton(
//             onPressed: () => _onCallEnd(context),
//             child: Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 35.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.redAccent,
//             padding: EdgeInsets.all(15.0),
//           ),
//           RawMaterialButton(
//             onPressed: _onSwitchCamera,
//             child: Icon(
//               Icons.switch_camera,
//               color: Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.white,
//             padding: EdgeInsets.all(12.0),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: RtcConnection(channelId: "My New Project 3"),
//         ),
//       );
//     } else {
//       return Text(
//         'Please wait for the other user to join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }
