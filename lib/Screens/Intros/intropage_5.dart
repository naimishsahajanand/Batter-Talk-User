// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, prefer_final_fields, unused_field, use_key_in_widget_constructors, unnecessary_brace_in_string_interps, avoid_print

import 'package:batter_talk_user/Controllers/register_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage5 extends StatefulWidget {
  @override
  State<IntroPage5> createState() => _IntroPage5State();
}

class _IntroPage5State extends State<IntroPage5> {
  RegisterController _registerController = Get.put(RegisterController());
  String usertoken = "";

  gettoken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token")!;
    });
    print("++++++token==========${usertoken}");
  }

  @override
  void initState() {
    gettoken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColor.BlackColor,
            statusBarIconBrightness: Brightness.light),
        title: Image.asset(
          AppImage.appIcon + "logoname.png",
          width: 100,
        ),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Image.asset(
              AppImage.appIcon + "backarrow.png",
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(12),
            child: GestureDetector(
              onTap: () {
                CommonWidget().whatsapp();
              },
              child: Image.asset(
                AppImage.appIcon + "help.png",
              ),
            ),
          ),
        ],
      ),
      body: CommonWidget().mainContainer(
          childwidget: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.85,
          child: Column(
            children: [
              Container(
                height: 6,
                width: Get.width,
                color: Color(0xffF5F8FA),
                child: Stack(
                  children: [
                    Container(
                      height: 6,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: AppColor.ProgressColor,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ],
                ),
              ),
              Container(
                height: Get.height * 0.3,
                width: Get.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppImage.appIcon + "intro1.png"))),
              ),
              SizedBox(height: Get.height * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RichText(
                  text: TextSpan(
                    text: 'Are you having or had any past ',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColor.TextColor),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Medical Issues ?',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColor.ActiveBlueColor)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.025),
              Container(
                height: Get.height * 0.15,
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: AppColor.TextFieldColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey)),
                child: TextFormField(
                  controller: _registerController.issuecontroller,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      hintText: "Please Type here ...",
                      hintStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.w400, fontSize: 14)),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  _registerController.userSignup(context, usertoken);
                },
                child: Container(
                  height: 50,
                  width: Get.width,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColor.DarkGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CommonWidget().interText(
                      text: "Get Started",
                      color: AppColor.BgColor,
                      weight: FontWeight.w600,
                      size: 14.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
