// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field

import 'package:batter_talk_user/Controllers/community_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/preferances.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Screens/Bottombar_Pages/community_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNickNameScren extends StatefulWidget {
  const AddNickNameScren({super.key});

  @override
  State<AddNickNameScren> createState() => _AddNickNameScrenState();
}

class _AddNickNameScrenState extends State<AddNickNameScren> {
  CommunityController _communityController = Get.put(CommunityController());
  TextEditingController nicknamecontroller = TextEditingController();
  String usertoken = "";

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token") ?? "";
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
      backgroundColor: AppColor.BgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 200,
              width: Get.width * 0.9,
              decoration: BoxDecoration(
                color: AppColor.TextFieldColor,
                boxShadow: [
                  BoxShadow(color: AppColor.SoftTextColor, blurRadius: 5)
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CommonWidget().interText(
                    text: "Please Enter Your Name",
                    size: 20.0,
                    weight: FontWeight.w500,
                  ),
                  Container(
                    height: 50,
                    width: Get.width * 0.85,
                    decoration: BoxDecoration(
                        color: AppColor.TextFieldColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: nicknamecontroller,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Enter Your Name",
                          hintStyle: GoogleFonts.inter(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (nicknamecontroller.text.isEmpty) {
                        CommonWidget().ToastCall(context, "Please Add Name");
                      } else if (nicknamecontroller.text.length < 5) {
                        CommonWidget()
                            .ToastCall(context, "Add Atleast 5 Character");
                      } else {
                        _communityController.addnickname(context,
                            nicknamecontroller.text, usertoken.toString());
                        Preference.preference
                            .saveBool(PrefernceKey.nickname, true);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CommunityListPage()));
                      }
                    },
                    child: Container(
                      height: 40,
                      width: Get.width * 0.5,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: AppColor.ActiveBlueColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CommonWidget().interText(
                          text: "Submit",
                          color: AppColor.BgColor,
                          weight: FontWeight.w600,
                          size: 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
