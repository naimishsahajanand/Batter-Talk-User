// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AudioRoomsScreen extends StatelessWidget {
  const AudioRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.BgColor,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColor.BlackColor,
            statusBarIconBrightness: Brightness.light),
        title: CommonWidget().interText(
            text: "Audio Rooms", size: 20.0, weight: FontWeight.w700),
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
      ),
      backgroundColor: AppColor.BgColor,
      body: CommonWidget().mainContainer(
          childwidget: Column(
        children: [
          Divider(
            color: Color(0xffF5F8FA),
            thickness: 4,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return dataBoX();
              },
              itemCount: 10,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            ),
          )
        ],
      )),
    );
  }

  Widget dataBoX() {
    return Container(
      width: Get.width,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(top: 15, bottom: 15, left: 20),
      decoration: BoxDecoration(
          color: AppColor.BorderColor, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.SoftTextColor,
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"),
                        fit: BoxFit.cover)),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CommonWidget().interText(
                          text: "Dr. jones alfred",
                          size: 18.0,
                          weight: FontWeight.w600),
                      SizedBox(width: 15),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: AppColor.ProgressColor,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.check,
                          size: 15,
                          color: AppColor.BgColor,
                        ),
                      )
                    ],
                  ),
                  CommonWidget().interText(
                      text: "Lorem Ipsum demo Texts",
                      size: 15.0,
                      weight: FontWeight.w400),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          CommonWidget().interText(
              text: "Lorem Ipsum demo Texts",
              size: 15.0,
              weight: FontWeight.w400),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              // Get.to(CallPage());
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppColor.ActiveBlueColor,
                  borderRadius: BorderRadius.circular(20)),
              child: CommonWidget().interText(
                  text: "100+ Joined",
                  color: AppColor.BgColor,
                  weight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
