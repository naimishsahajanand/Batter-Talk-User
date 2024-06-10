// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field, unnecessary_brace_in_string_interps, avoid_print, non_constant_identifier_names

import 'package:batter_talk_user/Controllers/register_controller.dart';
import 'package:batter_talk_user/Controllers/user_update_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MadicalDetailPage extends StatefulWidget {
  const MadicalDetailPage({super.key});

  @override
  State<MadicalDetailPage> createState() => _MadicalDetailPageState();
}

class _MadicalDetailPageState extends State<MadicalDetailPage> {
  UpdateProfileController _updateProfileController =
      Get.put(UpdateProfileController());
  RegisterController _registerController = Get.put(RegisterController());
  String usertoken = "";
  AllProfileData? loadprofiledata;
  bool isLoader = true;

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token") ?? "";
    });
    print("++++++token==========${usertoken}");
    Datafetch();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Datafetch() async {
    loadprofiledata =
        await _updateProfileController.profiledataApi(usertoken.toString());
    setState(() {
      isLoader = false;
    });
    Setdata();
  }

  Setdata() {
    _registerController.issuecontroller.text =
        loadprofiledata!.medicalissues.toString();
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
            text: "Medical details",
            color: AppColor.DarkGrey,
            weight: FontWeight.w500,
            size: 16.0),
      ),
      body: Column(
        children: [
          SizedBox(height: Get.height * 0.04),
          Container(
            height: Get.height * 0.2,
            width: Get.width,
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: AppColor.TextFieldColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)),
            child: TextFormField(
              controller: _registerController.issuecontroller,
              maxLines: 20,
              readOnly: true,
              style: TextStyle(color: AppColor.BlackColor),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColor.BlackColor)),
            ),
          ),
        ],
      ),
    );
  }
}
