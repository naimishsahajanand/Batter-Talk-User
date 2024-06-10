// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps, avoid_print, unused_import, deprecated_member_use

import 'package:batter_talk_user/Helpers/bottomnavbar.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvanceSuccessPage extends StatefulWidget {
  const AdvanceSuccessPage({super.key});

  @override
  State<AdvanceSuccessPage> createState() => _AdvanceSuccessPageState();
}

class _AdvanceSuccessPageState extends State<AdvanceSuccessPage> {
  var date = "";
  var time = "";

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      date = pref.getString("date") ?? "";
      time = pref.getString("time") ?? "";
    });
    print("++++++date==========${date}");
    print("++++++time==========${time}");
  }

  @override
  void initState() {
    getName();
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
        body: Column(
          children: [
            SizedBox(height: Get.height * 0.3),
            Image.asset(
              AppImage.appIcon + "success.png",
              width: Get.width * 0.5,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: CommonWidget().interText(
                    text: "Your slot has been confirmed on "
                        "${date} at "
                        "${time}"
                        " successfully",
                    align: TextAlign.center,
                    size: 14.0,
                    weight: FontWeight.w500),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Get.offAll(BottomNavBar());
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
                      text: "Go To Homepage",
                      color: AppColor.BgColor,
                      size: 14.0,
                      weight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
