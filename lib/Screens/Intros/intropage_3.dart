// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, non_constant_identifier_names, prefer_final_fields, unused_field, unnecessary_brace_in_string_interps, avoid_print, use_key_in_widget_constructors, unnecessary_null_comparison

import 'package:batter_talk_user/Controllers/register_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Screens/Intros/intropage_4.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> genderlist = <String>['Male', 'Female'];
// const List<String> agelist = <String>['20', '21', '22', '23', '24', '25', '26'];

class IntroPage3 extends StatefulWidget {
  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  RegisterController _registerController = Get.put(RegisterController());
  List<String>? loadgeenderdata;
  String name = "";

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString("username")!;
    });
    print("++++++name==========${name}");
    DataGet();
  }

  DataGet() async {
    loadgeenderdata = await _registerController.genderdataApi();
    setState(() {
      print(loadgeenderdata!.length);
    });
  }

  @override
  void initState() {
    getName();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 6,
                width: Get.width,
                color: Color(0xffF5F8FA),
                child: Stack(
                  children: [
                    Container(
                      height: 6,
                      width: Get.width * 0.6,
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
                        image: AssetImage(AppImage.appIcon + "intro3.png"))),
              ),
              SizedBox(height: Get.height * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RichText(
                  text: TextSpan(
                    text: 'Tell us about ',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColor.TextColor),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'yourself ',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColor.ActiveBlueColor)),
                      TextSpan(text: '${name} !'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.025),
              Container(
                height: 52,
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: AppColor.TextFieldColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColor.BorderColor)),
                child: TextFormField(
                  controller: _registerController.agecontroller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: "Your Age",
                      hintStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.w400, fontSize: 14)),
                ),
              ),
              SizedBox(height: Get.height * 0.025),
              Container(
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColor.TextFieldColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownMenu<String>(
                  // initialSelection: list.first,
                  hintText: "Gender",
                  width: Get.width - 30,
                  onSelected: (String? value) {
                    setState(() {
                      _registerController.genderdropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries:
                      genderlist.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  if (_registerController.agecontroller.text.isEmpty ||
                      _registerController.genderdropdownValue == null) {
                    CommonWidget().ToastCall(context, "Please Select");
                  } else {
                    Get.to(IntroPage4());
                  }
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
                      text: "Next",
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
