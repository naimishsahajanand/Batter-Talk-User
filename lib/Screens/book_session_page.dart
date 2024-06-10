// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, unused_local_variable, prefer_final_fields, non_constant_identifier_names, avoid_print, unused_field

import 'package:batter_talk_user/Controllers/packs_controller.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Screens/advance_slot_booking_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helpers/common_widget.dart';

class BookSessionPage extends StatefulWidget {
  const BookSessionPage({super.key});

  @override
  State<BookSessionPage> createState() => _BookSessionPageState();
}

class _BookSessionPageState extends State<BookSessionPage> {
  PacksController _packsController = Get.put(PacksController());
  String userToken = "";
  int DoctorId = 0;

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
    DoctorId = Get.arguments;
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
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: AppColor.SoftTextColor.withOpacity(0.3))),
            child: Column(
              children: [
                Image.asset(AppImage.appIcon + "istant.png",
                    width: Get.width * 0.3),
                SizedBox(height: 10),
                CommonWidget().interText(
                    text: "Instant Appointment",
                    color: AppColor.DarkGrey,
                    weight: FontWeight.w500,
                    size: 16.0),
                SizedBox(height: 10),
                CommonWidget().interText(
                    text: "Start up an instant session with the doctor ",
                    color: AppColor.DarkGrey,
                    weight: FontWeight.w400,
                    size: 14.0),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    _packsController.instantbookappoinment(
                        context,
                        userToken.toString(),
                        DateFormat("yyyy-MM-dd").format(DateTime.now()),
                        DateFormat('hh:mm:ss a').format(DateTime.now()),
                        "Instant",
                        DoctorId.toString());
                  },
                  child: Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColor.DarkGrey,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: CommonWidget().interText(
                          text: "Book an instant appointment",
                          color: AppColor.BgColor,
                          weight: FontWeight.w500,
                          size: 12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: AppColor.SoftTextColor.withOpacity(0.3))),
            child: Column(
              children: [
                Image.asset(AppImage.appIcon + "advance.png",
                    width: Get.width * 0.3),
                SizedBox(height: 10),
                CommonWidget().interText(
                    text: "Advance Booking",
                    color: AppColor.DarkGrey,
                    weight: FontWeight.w500,
                    size: 16.0),
                SizedBox(height: 10),
                CommonWidget().interText(
                    text: "Book a session with the doctor in advance",
                    color: AppColor.DarkGrey,
                    weight: FontWeight.w400,
                    size: 14.0),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Get.to(AdvanceSlotBookingPage(),
                        arguments: DoctorId.toString());
                  },
                  child: Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColor.DarkGrey,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: CommonWidget().interText(
                          text: "Book an advance appointment",
                          color: AppColor.BgColor,
                          weight: FontWeight.w500,
                          size: 12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          // Padding(
          //   padding: EdgeInsets.only(bottom: 20),
          //   child: CommonWidget().interText(
          //       text: "*There is no instant appointment available at this time",
          //       color: AppColor.SoftTextColor,
          //       weight: FontWeight.w500,
          //       size: 12.0),
          // ),
        ],
      ),
    );
  }
}
