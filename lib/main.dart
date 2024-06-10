// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print, await_only_futures, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_declarations, prefer_interpolation_to_compose_strings

import 'package:batter_talk_user/Helpers/splash_screen.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Screens/calling_page.dart';
import 'package:batter_talk_user/Screens/instant_chat_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/route_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColor.BlackColor,
      statusBarIconBrightness: Brightness.light));
  runApp(const MyApp());
  var initializationSettingsAndroid =
      AndroidInitializationSettings(AppImage.appIcon + "BTLogo.jpg");
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("170837f3-224d-4183-8b0f-85c6f0d95b64");

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) async {
    print("check {NV}");
    var NV = await event.notification.body.toString().split(" ").last;
    print("check ss $NV");
    event.complete(event.notification);
    if (NV == "Session.") {
      print("Check in");
      Get.to(InstantChatPage());
    } else if (NV == "audiocall.") {
      Get.to(AudioCallingPage());
    } else if (NV == "videocall.") {
      Get.to(VideoCallingPage());
    } else if (NV == "Decline.") {
      Get.back();
    }
  });
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);
  requestPermission();
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}
