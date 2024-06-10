// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, use_key_in_widget_constructors, must_be_immutable, prefer_interpolation_to_compose_strings, avoid_print, unnecessary_const, unrelated_type_equality_checks, non_constant_identifier_names, unnecessary_string_interpolations

import 'dart:async';

import 'package:batter_talk_user/Controllers/register_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  RegisterController _registerController = Get.put(RegisterController());
  String userid = "";
  String final_number = "";
  bool isLoader = false;

  int secondsRemaining = 60;
  int currentSeconds = 0;
  bool enableResend = false;

  String get timerText =>
      '${((secondsRemaining - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int? milliseconds]) {
    Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  void initState() {
    getName();
    Future.delayed(
      Duration(microseconds: 100),
      () {
        startTimeout();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    startTimeout();
    setState(() {
      enableResend = false;
    });
    super.dispose();
  }

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userid = pref.getString("userid")!;
      final_number = pref.getString("usermobilenumber")!;
      print("++++++id==========$userid");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonWidget().mainContainerwithimage(
          childwidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            SizedBox(height: Get.height * 0.07),
            Center(
              child: Image.asset(
                AppImage.appIcon + "loginimage.png",
                height: 200,
              ),
            ),
            SizedBox(height: Get.height * 0.06),
            CommonWidget()
                .interText(text: "OTP", size: 24.0, weight: FontWeight.w500),
            CommonWidget().interText(
                text: final_number.toString(),
                size: 15.0,
                weight: FontWeight.w400),
            SizedBox(height: Get.height * 0.025),
            Container(
              height: 50,
              width: Get.width,
              decoration: BoxDecoration(
                  color: AppColor.TextFieldColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey)),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                maxLength: 6,
                controller: _registerController.otpcontroller,
                decoration: InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter OTP",
                    hintStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w400, fontSize: 14)),
              ),
            ),
            SizedBox(height: 10),
            Align(
                alignment: Alignment.centerRight,
                child: enableResend
                    ? GestureDetector(
                        onTap: () {
                          _registerController.resendSendOTP(
                              context, final_number);
                        },
                        child: CommonWidget().interText(
                            text: "Resend Code",
                            weight: FontWeight.w500,
                            color: AppColor.ActiveBlueColor))
                    : CommonWidget()
                        .interText(text: "Resend OTP in ${timerText}s")),
            SizedBox(height: Get.height * 0.025),
            GestureDetector(
              onTap: () async {
                setState(() {
                  isLoader = true;
                });
                if (_registerController.otpcontroller.text.isEmpty) {
                  CommonWidget().ToastCall(context, "Please Enter OTP Number");
                  setState(() {
                    isLoader = false;
                  });
                } else if (_registerController.otpcontroller.text.length < 6) {
                  CommonWidget()
                      .ToastCall(context, "Please Enter Atlease 6 Digit");
                  setState(() {
                    isLoader = false;
                  });
                } else {
                  _registerController.OtpVerification(context, final_number);
                  setState(() {
                    isLoader = false;
                  });
                }
              },
              child: Container(
                height: 50,
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColor.DarkGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: isLoader
                      ? CircularProgressIndicator(
                          color: AppColor.BgColor,
                        )
                      : CommonWidget().interText(
                          text: "Verify OTP",
                          color: AppColor.BgColor,
                          weight: FontWeight.w600,
                          size: 14.0,
                        ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
