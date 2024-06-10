// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, prefer_final_fields, unnecessary_brace_in_string_interps, avoid_print, non_constant_identifier_names, sized_box_for_whitespace, unrelated_type_equality_checks

import 'package:batter_talk_user/Controllers/user_update_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/preferances.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/profile_model.dart';
import 'package:batter_talk_user/Screens/Bottombar_Pages/community_list_page.dart';
import 'package:batter_talk_user/Screens/add_nickname.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  UpdateProfileController _updateProfileController =
      Get.put(UpdateProfileController());
  AllProfileData? loadprofiledata;
  String usertoken = "";
  bool isLoader = true;

  @override
  void initState() {
    getName();
    super.initState();
  }

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token")!;
    });
    print("++++++token==========${usertoken}");
    DataFetch();
  }

  DataFetch() async {
    loadprofiledata =
        await _updateProfileController.profiledataApi(usertoken.toString());
    setState(() {
      isLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BgColor,
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.08),
            CommonWidget().interText(
              text: "Welcome To,",
              color: AppColor.ActiveBlueColor,
              size: 25.0,
              weight: FontWeight.w600,
            ),
            CommonWidget().interText(
              text: "Community",
              color: AppColor.TextColor,
              size: 18.0,
              weight: FontWeight.w600,
            ),
            SizedBox(height: Get.height * 0.08),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                    var isnickname = await Preference.preference
                        .getBool(key: PrefernceKey.nickname, defVal: false);
                    if (isnickname == true) {
                      Get.to(CommunityListPage());
                    } else {
                      Get.to(AddNickNameScren());
                    }
                  },
                  child: Container(
                    height: Get.height * 0.2,
                    width: Get.width * 0.42,
                    decoration: BoxDecoration(
                        color: AppColor.BorderColor.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                              color: AppColor.TextFieldColor,
                              spreadRadius: 2,
                              blurRadius: 15)
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(AppImage.appIcon + "chatroom.png",
                            width: 70),
                        CommonWidget().interText(
                            text: "Chat Room",
                            color: AppColor.DarkGrey,
                            size: 15.0,
                            weight: FontWeight.w600)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Get.to(AudioRoomsScreen());
                    CommonWidget().ToastCall(
                        context, "This Feature Currently Not Availeble");
                  },
                  child: Container(
                    height: Get.height * 0.2,
                    width: Get.width * 0.42,
                    decoration: BoxDecoration(
                        color: AppColor.BorderColor.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                              color: AppColor.TextFieldColor,
                              spreadRadius: 2,
                              blurRadius: 15)
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(AppImage.appIcon + "liveaudio.png",
                            width: 60),
                        CommonWidget().interText(
                            text: "Live Audio Session",
                            color: AppColor.DarkGrey,
                            align: TextAlign.center,
                            size: 15.0,
                            weight: FontWeight.w600)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
