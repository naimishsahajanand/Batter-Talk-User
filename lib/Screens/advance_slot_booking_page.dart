// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_final_fields, non_constant_identifier_names, avoid_print, unrelated_type_equality_checks, unnecessary_brace_in_string_interps, deprecated_member_use

import 'package:batter_talk_user/Controllers/packs_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
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

// var _selectedValue = DateTime.now();

class _AdvanceSlotBookingPageState extends State<AdvanceSlotBookingPage> {
  PacksController _packsController = Get.put(PacksController());
  List selectTimeSlot = [];
  var _selectedValue = DateTime.now();
  int selectedtimeIndex = -1;
  var dateformate = "";
  DayPartController dayPartController = DayPartController();
  String userToken = "";
  String DocId = "";
  var todaydate = DateTime.now().day;
  var firstdigit = "";
  var finaldigit = 0;

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
    print("===");
    print(todaydate);
    firstdigit = todaydate.toString();
    print("===");
    print(firstdigit);
    finaldigit = int.parse(firstdigit);
    print("===");
    print(finaldigit);
    setState(() {});
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
              // height: 120,
              width: Get.width,
              padding: EdgeInsets.symmetric(vertical: 15),
              color: AppColor.SoftTextColor.withOpacity(0.1),
              child: EasyDateTimeLine(
                initialDate: DateTime.now(),
                headerProps: EasyHeaderProps(
                  showMonthPicker: false,
                  showHeader: false,
                ),
                onDateChange: (selectedDate) async {
                  _selectedValue = selectedDate;
                  dateformate = DateFormat('yyyy-MM-dd').format(_selectedValue);
                  print(dateformate);
                  firstdigit = dateformate.split("-").last;
                  print("firstdigit ${firstdigit}");
                  finaldigit = int.parse(firstdigit);
                  print("finaldigit ${finaldigit}");
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString("date", dateformate);
                  setState(() {});
                },
                dayProps: EasyDayProps(
                  dayStructure: DayStructure.dayStrDayNum,
                  inactiveDayDecoration: BoxDecoration(
                      color: AppColor.BorderColor,
                      borderRadius: BorderRadius.circular(10)),
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColor.ActiveBlueColor.withOpacity(0.8),
                          AppColor.ActiveBlueColor.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              //   child: DatePicker(
              //     _selectedValue,
              //     daysCount: 30,
              //     initialSelectedDate: DateTime.now(),
              //     selectionColor: AppColor.ActiveBlueColor,
              //     onDateChange: (date) async {
              //       _selectedValue = date;
              //       dateformate = DateFormat('yyyy-MM-dd').format(_selectedValue);
              //       print(dateformate);
              //       firstdigit = dateformate.split("-").last;
              //       print("firstdigit ${firstdigit}");
              //       finaldigit = int.parse(firstdigit);
              //       print("finaldigit ${finaldigit}");
              //       SharedPreferences pref = await SharedPreferences.getInstance();
              //       pref.setString("date", dateformate);
              //       // setState(() {});
              //     },
              //   ),
              ),
          todaydate == finaldigit ? CurrentTimeSlot() : TimeSlot(),
          Spacer(),
          GestureDetector(
            onTap: () {
              if (dateformate == "" || timeformate == "") {
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

class CurrentTimeSlot extends StatefulWidget {
  const CurrentTimeSlot({super.key});

  @override
  State<CurrentTimeSlot> createState() => _CurrentTimeSlotState();
}

class _CurrentTimeSlotState extends State<CurrentTimeSlot> {
  var dates = DateTime.now();
  var currenthour = DateTime.now().hour + 1;
  var date = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TimesSlotGridViewFromInterval(
        locale: "en",
        initTime: dates,
        crossAxisCount: 4,
        timeSlotInterval: TimeSlotInterval(
          start: TimeOfDay(hour: currenthour, minute: 00),
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

class TimeSlot extends StatefulWidget {
  const TimeSlot({super.key});

  @override
  State<TimeSlot> createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  var dates = DateTime.now();
  var currenthour = DateTime.now().hour + 1;
  var date = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TimesSlotGridViewFromInterval(
        locale: "en",
        initTime: dates,
        crossAxisCount: 4,
        timeSlotInterval: TimeSlotInterval(
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
