// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, prefer_final_fields, unused_field, non_constant_identifier_names, unnecessary_brace_in_string_interps, avoid_print

import 'package:batter_talk_user/Controllers/register_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/preferances.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  RegisterController _registerController = Get.put(RegisterController());

  bool isLoader = false;
  String Final_number = "";

  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 2),
      () {
        getUserID();
      },
    );
    super.initState();
  }

  void getUserID() async {
    final status = await OneSignal.shared.getDeviceState();
    var osuserid = status?.userId;

    setState(() {
      _registerController.UserId = osuserid!;
    });
    print("=======${_registerController.UserId}");
    Preference.preference
        .saveString("userid", _registerController.UserId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonWidget().mainContainerwithimage(
          childwidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                .interText(text: "Log-In", size: 24.0, weight: FontWeight.w500),
            SizedBox(height: Get.height * 0.025),
            Container(
              // height: 50,
              width: Get.width,
              decoration: BoxDecoration(
                  color: AppColor.TextFieldColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey)),
              child: IntlPhoneField(
                controller: _registerController.phonenumbercontroller,
                keyboardType: TextInputType.phone,
                textAlignVertical: TextAlignVertical.center,
                autovalidateMode: AutovalidateMode.disabled,
                decoration: InputDecoration(
                    labelText: 'Enter Phone number',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabled: false,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    counterText: ""),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  String Number =
                      "${phone.countryCode} ${_registerController.phonenumbercontroller.text}";
                  print(Number);
                  Final_number = Number;
                },
              ),
            ),
            SizedBox(height: Get.height * 0.025),
            GestureDetector(
              onTap: () async {
                setState(() {
                  isLoader = true;
                });
                if (_registerController.phonenumbercontroller.text.isEmpty) {
                  CommonWidget()
                      .ToastCall(context, "Please Enter Phone Number");
                  setState(() {
                    isLoader = false;
                  });
                } else if (_registerController
                        .phonenumbercontroller.text.length <
                    10) {
                  CommonWidget()
                      .ToastCall(context, "Please Enter Atlease 10 Digit");
                  setState(() {
                    isLoader = false;
                  });
                } else {
                  _registerController.SendOTP(context, Final_number);
                  setState(() {
                    isLoader = false;
                  });
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString("usermobilenumber", Final_number);
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
                          text: "Send OTP",
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
