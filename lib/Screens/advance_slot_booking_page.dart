// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_final_fields, non_constant_identifier_names, avoid_print

import 'package:batter_talk_user/Controllers/packs_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Screens/advance_success_page.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_slot/controller/day_part_controller.dart';
import 'package:time_slot/model/time_slot_Interval.dart';
import 'package:time_slot/time_slot_from_interval.dart';

var timeformate = "";

class AdvanceSlotBookingPage extends StatefulWidget {
  const AdvanceSlotBookingPage({super.key});

  @override
  State<AdvanceSlotBookingPage> createState() => _AdvanceSlotBookingPageState();
}

class _AdvanceSlotBookingPageState extends State<AdvanceSlotBookingPage> {
  PacksController _packsController = Get.put(PacksController());
  List selectTimeSlot = [];
  int selectedtimeIndex = -1;
  var dateformate = "";
  var _selectedValue = DateTime.now();
  DayPartController dayPartController = DayPartController();
  String userToken = "";
  String DocId = "";

  gettoken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userToken = pref.getString("token") ?? "";
    });
    print(userToken.toString());
  }

  @override
  void initState() {
    gettoken();
    DocId = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColor.BlackColor,
            statusBarIconBrightness: Brightness.light),
        iconTheme: IconThemeData(color: AppColor.SoftTextColor),
        backgroundColor: Colors.transparent,
        title: CommonWidget().interText(
            text: "Book a session",
            color: AppColor.DarkGrey,
            weight: FontWeight.w500,
            size: 16.0),
      ),
      body: Column(
        children: [
          Container(
            height: 120,
            width: Get.width,
            padding: EdgeInsets.symmetric(vertical: 15),
            color: AppColor.SoftTextColor.withOpacity(0.1),
            child: DatePicker(
              _selectedValue,
              daysCount: 30,
              onDateChange: (date) async {
                _selectedValue = date;
                dateformate = DateFormat('yyyy-MM-dd').format(_selectedValue);
                print(dateformate);
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString("date", dateformate);
                // setState(() {});
              },
              selectionColor: AppColor.ActiveBlueColor,
            ),
          ),
          TimeSlot(),
          Spacer(),
          GestureDetector(
            onTap: () {
              if (dateformate == "" && timeformate == "") {
                CommonWidget().ToastCall(context, "Please Select TimeSlot");
              } else {
                _packsController.advancebookappoinment(
                  context,
                  userToken.toString(),
                  dateformate,
                  timeformate,
                  'Advance',
                  DocId.toString(),
                );
                Get.to(AdvanceSuccessPage());
              }
            },
            child: Container(
              height: 45,
              width: Get.width,
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              decoration: BoxDecoration(
                  color: AppColor.DarkGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: CommonWidget().interText(
                    text: "Confirm Slot",
                    color: AppColor.BgColor,
                    size: 14.0,
                    weight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeSlot extends StatefulWidget {
  const TimeSlot({super.key});

  @override
  State<TimeSlot> createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  var dates = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TimesSlotGridViewFromInterval(
        locale: "en",
        initTime: dates,
        crossAxisCount: 4,
        timeSlotInterval: const TimeSlotInterval(
          start: TimeOfDay(hour: 8, minute: 00),
          end: TimeOfDay(hour: 22, minute: 0),
          interval: Duration(hours: 1, minutes: 0),
        ),
        selectedColor: AppColor.ActiveBlueColor,
        unSelectedColor: AppColor.BorderColor.withOpacity(0.3),
        onChange: (value) async {
          dates = value;
          timeformate = DateFormat('hh:mm:ss a').format(dates);
          print(timeformate);
          setState(() {});
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString("time", timeformate);
        },
      ),
    );
  }
}
