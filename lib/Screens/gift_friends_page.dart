// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GiftFriendsScreen extends StatefulWidget {
  const GiftFriendsScreen({super.key});

  @override
  State<GiftFriendsScreen> createState() => _GiftFriendsScreenState();
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class _GiftFriendsScreenState extends State<GiftFriendsScreen> {
  String dropdownValue = list.first;

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
            text: "Gift a friend",
            color: AppColor.DarkGrey,
            weight: FontWeight.w500,
            size: 16.0),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.87,
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.02),
              Container(
                height: Get.height * 0.15,
                width: Get.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppImage.appIcon + "giftimage.png"))),
              ),
              SizedBox(height: Get.height * 0.03),
              Container(
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColor.TextFieldColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownMenu<String>(
                  // initialSelection: list.first,
                  hintText: "Gift type",
                  width: Get.width - 30,
                  onSelected: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries:
                      list.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Container(
                height: 55,
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: AppColor.TextFieldColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey)),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: "Name",
                      hintStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.w400, fontSize: 14)),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Container(
                height: 55,
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: AppColor.TextFieldColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey)),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: "Enter Phone number",
                      hintStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.w400, fontSize: 14)),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Container(
                height: 55,
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: AppColor.TextFieldColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey)),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: "Email ID",
                      hintStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.w400, fontSize: 14)),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Container(
                height: Get.height * 0.15,
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: AppColor.TextFieldColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey)),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: "Notes",
                      hintStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.w400, fontSize: 14)),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {},
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
                      text: "Gift Session",
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
      ),
    );
  }
}
