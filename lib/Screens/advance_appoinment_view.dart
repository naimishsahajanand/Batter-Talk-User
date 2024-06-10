// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/appoinment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AdvanceAppoinmnetView extends StatefulWidget {
  const AdvanceAppoinmnetView({super.key});

  @override
  State<AdvanceAppoinmnetView> createState() => _AdvanceAppoinmnetViewState();
}

class _AdvanceAppoinmnetViewState extends State<AdvanceAppoinmnetView> {
  var data = AllAppoinmentData().obs;

  @override
  void initState() {
    data.value = Get.arguments;
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
            text: "Advance Appointment",
            color: AppColor.DarkGrey,
            weight: FontWeight.w500,
            size: 16.0),
      ),
      backgroundColor: AppColor.BgColor,
      body: Column(
        children: [
          SizedBox(height: Get.height * 0.3),
          Center(
            child: CommonWidget().interText(
                text: "Your Appointment Booked!",
                color: AppColor.BlackColor,
                size: 22.0,
                weight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'It Will Be Start At ',
              style: TextStyle(
                  color: AppColor.BlackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              children: <TextSpan>[
                TextSpan(
                    text: '${data.value.startTime}',
                    style: TextStyle(
                        color: AppColor.ActiveBlueColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700)),
                TextSpan(
                    text: ' On',
                    style: TextStyle(
                        color: AppColor.BlackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
                TextSpan(
                    text: ' ${data.value.bookingDate}',
                    style: TextStyle(
                        color: AppColor.ActiveBlueColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 50,
              width: Get.width,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: AppColor.DarkGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: CommonWidget().interText(
                  text: "Back To Homepage",
                  color: AppColor.BgColor,
                  weight: FontWeight.w600,
                  size: 14.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
