// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings, prefer_final_fields, unused_field, deprecated_member_use, avoid_print, unused_import, non_constant_identifier_names, unrelated_type_equality_checks, unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:io';

import 'package:batter_talk_user/Controllers/packs_controller.dart';
import 'package:batter_talk_user/Helpers/bottomnavbar.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/preferances.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/session_booked_model.dart';
import 'package:batter_talk_user/Screens/calling_page.dart';
import 'package:batter_talk_user/Screens/instant_chat_page.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstantSessionTimer extends StatefulWidget {
  const InstantSessionTimer({Key? key}) : super(key: key);

  @override
  State<InstantSessionTimer> createState() => _InstantSessionTimerState();
}

class _InstantSessionTimerState extends State<InstantSessionTimer> {
  PacksController _packsController = Get.put(PacksController());
  int _duration = 0;
  int time = 0;
  int Fix_time = 0;
  String doctorname = "";
  String usertoken = "";
  var data = SessionBookedModel().obs;
  final CountDownController _controller = CountDownController();

  // notification() {
  //   OneSignal.shared.setNotificationWillShowInForegroundHandler(
  //       (OSNotificationReceivedEvent event) {
  //     print("check ss {NV}");
  //     var NV = event.notification.title.toString();
  //     print("check ss $NV");
  //     event.complete(event.notification);
  //     if (NV == "Accept Session") {
  //       Get.to(InstantChatPage(), arguments: data.value);
  //     }
  //   });
  // }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Cancel Appoinment',
                style: GoogleFonts.inter(
                    color: AppColor.BlackColor, fontWeight: FontWeight.w600)),
            content: Text('Are You Sure Want To Cancel Appoinment',
                style: GoogleFonts.inter(
                    color: AppColor.BlackColor, fontWeight: FontWeight.w500)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No',
                    style: GoogleFonts.inter(
                        color: AppColor.DarkGrey, fontWeight: FontWeight.w400)),
              ),
              TextButton(
                onPressed: () {
                  _packsController.cencelappoinmentApi(
                      data.value.data!.id.toString(),
                      usertoken.toString(),
                      context);
                },
                child: Text('Yes',
                    style: GoogleFonts.inter(
                        color: AppColor.DarkGrey, fontWeight: FontWeight.w400)),
              ),
            ],
          ),
        ) ??
        false;
  }

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      doctorname = pref.getString("doctorname")!;
      usertoken = pref.getString("token")!;
    });
    print("++++++name==========$doctorname");
  }

  @override
  void initState() {
    getName();
    data.value = Get.arguments;
    DateTime_check();
    Future.delayed(
      Duration(microseconds: 100),
      () {
        _controller.start();
      },
    );
    super.initState();
  }

  Duration durationParse(String time) {
    final ts = DateFormat('y-MM-dd').format(DateTime.now());
    final dt = DateTime.parse('$ts $time');
    return Duration(hours: dt.hour, minutes: dt.minute, seconds: dt.second);
  }

  String calTotalTime(TimeOfDay startTime, TimeOfDay endTime) {
    double totalTime = (endTime.hour + (endTime.minute / 60)) -
        (startTime.hour + (startTime.minute / 60));
    int hours = totalTime.floor();
    int minuts = ((totalTime - totalTime.floorToDouble()) * 60).round();
    return (hours == 0)
        ? '${minuts}min'
        : (minuts == 0)
            ? '${hours}hr'
            : '${hours}hr ${minuts}min';
  }

  @override
  Widget build(BuildContext context) {
    // notification();
    print("======${_duration}");
    return WillPopScope(
      onWillPop: () {
        Get.offAll(BottomNavBar());
        return Future.delayed(Duration(microseconds: 10));
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColor.BlackColor,
              statusBarIconBrightness: Brightness.light),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Get.offAll(BottomNavBar());
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: CommonWidget().interText(
              text: doctorname.toString(),
              color: AppColor.DarkGrey,
              weight: FontWeight.w500,
              size: 16.0),
        ),
        body: Column(
          children: [
            Center(
              child: CircularCountDownTimer(
                duration: Fix_time,
                initialDuration: time,
                controller: _controller,
                width: Get.width / 1.5,
                height: Get.height / 2,
                ringColor: AppColor.ActiveBlueColor.withOpacity(0.15),
                fillColor: AppColor.DarkGrey,
                strokeWidth: 15,
                strokeCap: StrokeCap.round,
                textStyle: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                textFormat: CountdownTextFormat.MM_SS,
                isReverse: true,
                isReverseAnimation: true,
                isTimerTextShown: true,
                autoStart: true,
                onChange: (value) {
                  //  _duration = value as int;
                },
                onComplete: () {
                  Get.offAll(BottomNavBar());
                },
                timeFormatterFunction: (defaultFormatterFunction, duration) {
                  if (duration.inSeconds == 0) {
                    return "00:00";
                  } else {
                    return Function.apply(defaultFormatterFunction, [duration]);
                  }
                },
              ),
            ),
            CommonWidget().interText(
                text: "Is the waiting time for the therapist to join the chat",
                color: AppColor.SoftTextColor,
                size: 14.0,
                weight: FontWeight.w500),
            _button(onPressed: () {
              showExitPopup();
            }),
          ],
        ),
      ),
    );
  }

  Widget _button({VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: Get.width,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
            color: AppColor.DarkGrey, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: CommonWidget().interText(
              text: "Cancel Appointment",
              color: AppColor.BgColor,
              size: 12.0,
              weight: FontWeight.w500),
        ),
      ),
    );
  }

  void DateTime_check() {
    print("fixtime  two ${data.value.data!.connectEndTime}");
    DateTime nows = DateTime.now();
    String formattedDate = DateFormat("hh:mm:ss").format(nows);
    print("fixtime two $formattedDate");
    var dateTime2 = DateFormat.Hm().parse(data.value.data!.connectEndTime!);
    var StartdateTime =
        DateFormat.Hm().parse(data.value.data!.connectStartTime!);

    String current_time = formattedDate;
    String end_time = DateFormat("hh:mm:ss").format(dateTime2);
    String Api_start_time_check = DateFormat("hh:mm:ss").format(StartdateTime);
    print("fixtime current_time  $current_time");
    print("fixtime end_time  $end_time");
    print("fixtime Api_start_time_check  $Api_start_time_check");

    Duration start_d = durationParse(current_time);
    Duration Api_start_time = durationParse(Api_start_time_check);
    Duration end_d = durationParse(end_time);
    int sec = end_d.inMilliseconds - start_d.inMilliseconds;
    int Total_time = end_d.inMilliseconds - Api_start_time.inMilliseconds;
    var time_total = Total_time / 1000;
    var final_duration = sec / 1000;
    _duration = final_duration.toInt();

    time = time_total.toInt() - _duration;
    Fix_time = time_total.toInt();
    print("fixtime _duration ${_duration}");
    print("fixtime time_total ${time_total}");
    print("fixtime time ${time}");
    setState(() {});
  }
}

// ================

class SessionTimer extends StatefulWidget {
  const SessionTimer({Key? key}) : super(key: key);

  @override
  State<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  PacksController _packsController = Get.put(PacksController());
  int _duration = 300;
  String doctorname = "";
  String usertoken = "";
  final CountDownController _controller = CountDownController();

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Cancel Appoinment',
                style: GoogleFonts.inter(
                    color: AppColor.BlackColor, fontWeight: FontWeight.w600)),
            content: Text('Are You Sure Want To Cancel Appoinment',
                style: GoogleFonts.inter(
                    color: AppColor.BlackColor, fontWeight: FontWeight.w500)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No',
                    style: GoogleFonts.inter(
                        color: AppColor.DarkGrey, fontWeight: FontWeight.w400)),
              ),
              TextButton(
                onPressed: () {
                  Get.offAll(BottomNavBar());
                  // _packsController.cencelappoinmentApi(data.value.data!.id.toString()
                  //     usertoken.toString(), context);
                },
                child: Text('Yes',
                    style: GoogleFonts.inter(
                        color: AppColor.DarkGrey, fontWeight: FontWeight.w400)),
              ),
            ],
          ),
        ) ??
        false;
  }

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      doctorname = pref.getString("doctorname")!;
      usertoken = pref.getString("token")!;
    });
    print("++++++name==========$doctorname");
  }

  @override
  void initState() {
    getName();
    Future.delayed(
      Duration(microseconds: 100),
      () {
        _controller.restart();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.offAll(BottomNavBar());
        return Future.delayed(Duration(microseconds: 10));
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColor.BlackColor,
              statusBarIconBrightness: Brightness.light),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Get.offAll(BottomNavBar());
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: CommonWidget().interText(
              text: doctorname.toString(),
              color: AppColor.DarkGrey,
              weight: FontWeight.w500,
              size: 16.0),
        ),
        body: Column(
          children: [
            Center(
              child: CircularCountDownTimer(
                duration: _duration,
                controller: _controller,
                initialDuration: 100,
                width: Get.width / 1.5,
                height: Get.height / 2,
                ringColor: AppColor.ActiveBlueColor.withOpacity(0.15),
                fillColor: AppColor.DarkGrey,
                strokeWidth: 15,
                strokeCap: StrokeCap.round,
                textStyle: const TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                textFormat: CountdownTextFormat.MM_SS,
                isReverse: true,
                isReverseAnimation: true,
                isTimerTextShown: true,
                autoStart: true,
                onComplete: () {},
                onChange: (String timeStamp) async {
                  print("Changes");
                },
                timeFormatterFunction: (defaultFormatterFunction, duration) {
                  // print("Changes1");
                  if (duration.inSeconds == 0) {
                    return "05:00";
                  } else {
                    return Function.apply(defaultFormatterFunction, [duration]);
                  }
                },
              ),
            ),
            CommonWidget().interText(
                text: "Is the waiting time for the therapist to join the chat",
                color: AppColor.SoftTextColor,
                size: 14.0,
                weight: FontWeight.w500),
            _button(onPressed: () {
              showExitPopup();
            }),
          ],
        ),
      ),
    );
  }

  Widget _button({VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: Get.width,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
            color: AppColor.DarkGrey, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: CommonWidget().interText(
              text: "Cancel Appointment",
              color: AppColor.BgColor,
              size: 12.0,
              weight: FontWeight.w500),
        ),
      ),
    );
  }
}
