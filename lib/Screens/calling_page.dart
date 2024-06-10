// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, prefer_final_fields, non_constant_identifier_names, avoid_print, unused_field, await_only_futures, library_prefixes

import 'package:batter_talk_user/Controllers/packs_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/socket.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/appoinment_model.dart';
import 'package:batter_talk_user/Screens/one_call_page.dart';
import 'package:batter_talk_user/Screens/one_video_call_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AudioCallingPage extends StatefulWidget {
  const AudioCallingPage({super.key});

  @override
  State<AudioCallingPage> createState() => _AudioCallingPageState();
}

class _AudioCallingPageState extends State<AudioCallingPage> {
  PacksController _packsController = Get.put(PacksController());
  List<AllAppoinmentData>? loaddata;
  // var data = SessionBookedModel().obs;
  String usertoken = "";
  late IO.Socket socket;
  ServerStatus _serverStatus = ServerStatus.Conecting;

  @override
  void initState() {
    getName();
    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.horn,
      looping: true,
      volume: 0.7,
    );
    Future.delayed(
      Duration(seconds: 1),
      () {
        connectToServer();
      },
    );
    super.initState();
  }

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token")!;
    });
    print("++++++token==========$usertoken");
    DataFetch();
  }

  DataFetch() async {
    loaddata = await _packsController.appoinmentdataApi(usertoken.toString());
    print("loaddata============= $loaddata");
  }

  void connectToServer() async {
    print("Connected check ");

    socket = await IO.io('http://128.199.25.99:3005', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
    });
    print("Connected check 1");
    socket.emit('sessionroom', {
      // 'sessionId': data.value.data!.id,
      'sessionId': loaddata![0].id,
    });
    await socket.connect();

    print("Connected check 2");
    socket.onConnect((data) => {
          _serverStatus = ServerStatus.Online,
          print("Connected1 ======${socket.connected}"),
        });
    print("Connected check 3");

    print("Connected ======${socket.connected}");
    socket.on("chatmessage", (data) {});
  }

  // oneToOneAudioCallDecline() {
  //   socket.emit('oneToOneCallDecline', {
  //     "sessionId": data.value.data!.id,
  //     "token": usertoken.toString(),
  //     "roomId": data.value.data!.id,
  //     "senderId": data.value.data!.userid,
  //     "receiverId": data.value.data!.doctorid,
  //     "callType": "audiocall",
  //     "type": "user",
  //   });
  // }
  oneToOneAudioCallDecline() {
    socket.emit('oneToOneCallDecline', {
      "sessionId": loaddata![0].id,
      "token": usertoken.toString(),
      "roomId": loaddata![0].id,
      "senderId": loaddata![0].userid,
      "receiverId": loaddata![0].doctorid,
      "callType": "audiocall",
      "type": "user",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          AppColor.ActiveBlueColor.withOpacity(0.5),
          Colors.black87
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.2),
            CommonWidget().interText(
                text: "Incoming Call...",
                color: AppColor.BlackColor,
                size: 20.0),
            SizedBox(height: Get.height * 0.1),
            Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.BorderColor,
                    image: DecorationImage(
                        image: AssetImage(AppImage.appIcon + "user.png")))),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: () {
                        oneToOneAudioCallDecline();
                        FlutterRingtonePlayer.stop();
                        Get.back();
                      },
                      icon: Icon(
                        Icons.call_end,
                        color: AppColor.BgColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: () {
                        FlutterRingtonePlayer.stop().then((value) {
                          Get.off(OneCallPage());
                        });
                      },
                      icon: Icon(
                        Icons.call,
                        color: AppColor.BgColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class VideoCallingPage extends StatefulWidget {
  const VideoCallingPage({super.key});

  @override
  State<VideoCallingPage> createState() => _VideoCallingPageState();
}

class _VideoCallingPageState extends State<VideoCallingPage> {
  PacksController _packsController = Get.put(PacksController());
  List<AllAppoinmentData>? loaddata;
  // var data = SessionBookedModel().obs;
  String usertoken = "";
  late IO.Socket socket;
  ServerStatus _serverStatus = ServerStatus.Conecting;

  @override
  void initState() {
    getName();
    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.horn,
      looping: true,
      volume: 0.7,
    );
    Future.delayed(
      Duration(seconds: 1),
      () {
        connectToServer();
      },
    );
    super.initState();
  }

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token")!;
    });
    print("++++++token==========$usertoken");
    DataFetch();
  }

  DataFetch() async {
    loaddata = await _packsController.appoinmentdataApi(usertoken.toString());
  }

  void connectToServer() async {
    print("Connected check ");

    socket = await IO.io('http://128.199.25.99:3005', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
    });
    print("Connected check 1");
    socket.emit('sessionroom', {
      'sessionId': loaddata![0].id,
      // 'sessionId': data.value.data!.id,
    });
    await socket.connect();

    print("Connected check 2");
    socket.onConnect((data) => {
          _serverStatus = ServerStatus.Online,
          print("Connected ======${socket.connected}"),
        });
    print("Connected check 3");

    print("Connected ======${socket.connected}");
    socket.on("chatmessage", (data) {});
  }

  // oneToOneVideoCallDecline() {
  //   socket.emit('oneToOneCallDecline', {
  //     "sessionId": data.value.data!.id,
  //     "token": usertoken.toString(),
  //     "roomId": data.value.data!.id,
  //     "senderId": data.value.data!.userid,
  //     "receiverId": data.value.data!.doctorid,
  //     "callType": "videocall",
  //     "type": "user",
  //   });
  // }
  oneToOneVideoCallDecline() {
    socket.emit('oneToOneCallDecline', {
      "sessionId": loaddata![0].id,
      "token": usertoken.toString(),
      "roomId": loaddata![0].id,
      "senderId": loaddata![0].userid,
      "receiverId": loaddata![0].doctorid,
      "callType": "videocall",
      "type": "user",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          AppColor.ActiveBlueColor.withOpacity(0.5),
          Colors.black87
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.2),
            CommonWidget().interText(
                text: "Incoming Call...",
                color: AppColor.BlackColor,
                size: 20.0),
            SizedBox(height: Get.height * 0.1),
            Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.BorderColor,
                    image: DecorationImage(
                        image: AssetImage(AppImage.appIcon + "user.png")))),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: () {
                        oneToOneVideoCallDecline();
                        FlutterRingtonePlayer.stop();
                        Get.back();
                      },
                      icon: Icon(
                        Icons.call_end,
                        color: AppColor.BgColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: () {
                        FlutterRingtonePlayer.stop().then((value) {
                          Get.off(OneVideoCallPage());
                        });
                      },
                      icon: Icon(
                        Icons.call,
                        color: AppColor.BgColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
