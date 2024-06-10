// // ignore_for_file: prefer__ructors, prefer__literals_to_create_immutables, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, await_only_futures, avoid_print, sort_child_properties_last, prefer_const_constructors, sized_box_for_whitespace, prefer_const_declarations, prefer_const_constructors_in_immutables

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:batter_talk_user/Helpers/utility.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class VideoCallPage extends StatefulWidget {
//   VideoCallPage({super.key});

//   @override
//   State<VideoCallPage> createState() => _VideoCallPageState();
// }

// class _VideoCallPageState extends State<VideoCallPage> {
//   late RtcEngine _engine;
//   bool _localUserJoined = false;
//   int? _remoteUid;
//   bool muted = false;
//   void _onCallEnd(BuildContext context) {
//     Navigator.pop(context);
//   }

//   initAgora() async {
//     requestPermission();
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(RtcEngineContext(
//       appId: "9e15b123fda34622b76d758f90e0fd69",
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
//     VideoEncoderConfiguration videoConfig = const VideoEncoderConfiguration(
//         mirrorMode: VideoMirrorModeType.videoMirrorModeAuto,
//         frameRate: 10,
//         bitrate: standardBitrate,
//         dimensions: VideoDimensions(width: 640, height: 360),
//         orientationMode: OrientationMode.orientationModeAdaptive,
//         degradationPreference: DegradationPreference.maintainBalanced);
//     _engine.setVideoEncoderConfiguration(videoConfig);
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
//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await _engine.enableVideo();
//     await _engine.startPreview();
//     await _engine.joinChannel(
//       token: CallToken.calltoken,
//       channelId: 'My New Project',
//       uid: 0,
//       options: ChannelMediaOptions(
//         defaultVideoStreamType: VideoStreamType.videoStreamLow,
//         isAudioFilterable: true,
//         audioDelayMs: 10,
//       ),
//     );
//   }

//   @override
//   void initState() {
//     initAgora();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _dispose();
//     super.dispose();
//   }

//   Future<void> _dispose() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }

//   Future<void> requestPermission() async {
//     final permission = Permission.camera;

//     if (await permission.isDenied) {
//       final result = await permission.request();

//       if (result.isGranted) {
//         await permission.status.isGranted;
//       } else if (result.isDenied) {
//         await permission.request();
//       } else if (result.isPermanentlyDenied) {
//         await permission.status.isPermanentlyDenied;
//       }
//     }
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
//           connection: RtcConnection(channelId: "My New Project"),
//         ),
//       );
//     } else {
//       return Text(
//         'Please wait for Other user to join',
//         textAlign: TextAlign.center,
//       );
//     }
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
// }
