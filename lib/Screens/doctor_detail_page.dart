// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unnecessary_new, avoid_print, prefer_final_fields, unused_field, unused_import, non_constant_identifier_names

import 'dart:io';
import 'package:batter_talk_user/Controllers/doctor_detail_controller.dart';
import 'package:batter_talk_user/Helpers/api_endpoints.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/doctor_data_model.dart';
import 'package:batter_talk_user/Models/session_booked_model.dart';
import 'package:batter_talk_user/Screens/book_session_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorsDetailPage extends StatefulWidget {
  const DoctorsDetailPage({super.key});

  @override
  State<DoctorsDetailPage> createState() => _DoctorsDetailPageState();
}

class _DoctorsDetailPageState extends State<DoctorsDetailPage> {
  DoctorDetailsController _doctorDetailsController =
      Get.put(DoctorDetailsController());
  var data = AllDoctorData().obs;
  SessionBookedModel? sessionBookedModel;
  var usertoken = "";
  var date = "";
  var formatdate = "";
  bool isLoader = true;

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token")!;
    });
    print("++++++token==========$usertoken");
    data.value = Get.arguments;
    DataGet();
  }

  @override
  void initState() {
    getName();

    super.initState();
  }

  DataGet() async {
    sessionBookedModel = await _doctorDetailsController.sessionbookApi(
        usertoken, data.value.id.toString());
    date = data.value.createdAt!;
    DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('MMM d,yyyy');
    formatdate = outputFormat.format(inputDate);
    print(formatdate);
    setState(() {
      isLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColor.BgColor, AppColor.ActiveBlueColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: isLoader
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.07),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Platform.isAndroid
                        ? GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Icons.arrow_back),
                          )
                        : GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Icons.arrow_back_ios_new),
                          ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonWidget().interText(
                                  text: data.value.introduction == "" ||
                                          data.value.introduction == null
                                      ? ""
                                      : data.value.introduction.toString(),
                                  size: 18.0,
                                  weight: FontWeight.w500),
                              SizedBox(height: 8),
                              CommonWidget().interText(
                                  text: data.value.jobtitle == "" ||
                                          data.value.jobtitle == null
                                      ? ""
                                      : data.value.jobtitle.toString(),
                                  size: 14.0,
                                  color: AppColor.SoftTextColor,
                                  weight: FontWeight.w400),
                              SizedBox(height: 8),
                              CommonWidget().interText(
                                  text: "Join on ${formatdate.toString()}",
                                  size: 12.0,
                                  weight: FontWeight.w500),
                            ],
                          ),
                          Container(
                            height: Get.height * 0.14,
                            width: Get.width * 0.25,
                            decoration: BoxDecoration(
                                color: AppColor.SoftTextColor,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: NetworkImage(data.value.image ==
                                                "" ||
                                            data.value.image == null
                                        ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                        : data.value.image.toString()),
                                    fit: BoxFit.cover)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: Get.height * 0.7,
                    width: Get.width,
                    decoration: BoxDecoration(
                        color: AppColor.BgColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Stack(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(right: 20, left: 20, top: 25),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text: 'About\n\n',
                                        style: GoogleFonts.inter(
                                            color: AppColor.BlackColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                        children: [
                                      TextSpan(
                                          text: data.value.about == null ||
                                                  data.value.about == ""
                                              ? ""
                                              : data.value.about.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              wordSpacing: 0.3,
                                              letterSpacing: 0.5,
                                              fontWeight: FontWeight.w400,
                                              color: AppColor.SoftTextColor)),
                                    ])),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 70,
                                      width: Get.width * 0.4,
                                      decoration: BoxDecoration(
                                          color: Color(0xffF9FDFF),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: AppColor.SoftTextColor
                                                    .withOpacity(0.15),
                                                blurRadius: 5,
                                                spreadRadius: 1)
                                          ]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset(
                                              AppImage.appIcon + "forums.png",
                                              width: 35),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonWidget().interText(
                                                  text: data.value.patientcount ==
                                                              null ||
                                                          data.value
                                                                  .patientcount ==
                                                              ""
                                                      ? ""
                                                      : data.value.patientcount
                                                          .toString(),
                                                  color:
                                                      AppColor.ActiveBlueColor,
                                                  size: 16.0,
                                                  weight: FontWeight.w500),
                                              SizedBox(height: 5),
                                              CommonWidget().interText(
                                                  text: "Patients",
                                                  color: AppColor.DarkGrey,
                                                  size: 12.0,
                                                  weight: FontWeight.w400),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 70,
                                      width: Get.width * 0.4,
                                      decoration: BoxDecoration(
                                          color: Color(0xffF9FDFF),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: AppColor.SoftTextColor
                                                    .withOpacity(0.15),
                                                blurRadius: 5,
                                                spreadRadius: 1)
                                          ]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset(
                                              AppImage.appIcon + "suitcase.png",
                                              width: 35),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonWidget().interText(
                                                  text: data.value.experience ==
                                                              null ||
                                                          data.value
                                                                  .experience ==
                                                              ""
                                                      ? ""
                                                      : "${data.value.experience.toString()} Years",
                                                  color:
                                                      AppColor.ActiveBlueColor,
                                                  size: 16.0,
                                                  weight: FontWeight.w500),
                                              SizedBox(height: 5),
                                              CommonWidget().interText(
                                                  text: "Experience",
                                                  color: AppColor.DarkGrey,
                                                  size: 12.0,
                                                  weight: FontWeight.w400),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20),
                                RichText(
                                    text: TextSpan(
                                        text: 'Qualifications\n\n',
                                        style: GoogleFonts.inter(
                                            color: AppColor.BlackColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                        children: [
                                      TextSpan(
                                          text: data.value.qualifications ==
                                                      null ||
                                                  data.value.qualifications ==
                                                      ""
                                              ? ""
                                              : data.value.qualifications
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              wordSpacing: 0.3,
                                              letterSpacing: 0.5,
                                              fontWeight: FontWeight.w400,
                                              color: AppColor.SoftTextColor)),
                                    ])),
                                SizedBox(height: 20),
                                RichText(
                                    text: TextSpan(
                                        text: 'Description\n\n',
                                        style: GoogleFonts.inter(
                                            color: AppColor.BlackColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                        children: [
                                      TextSpan(
                                          text: data.value.describe == "" ||
                                                  data.value.describe == null
                                              ? ""
                                              : data.value.describe.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              wordSpacing: 0.3,
                                              letterSpacing: 0.5,
                                              color: AppColor.SoftTextColor)),
                                    ])),
                                SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              if (sessionBookedModel!.isBooked == true) {
                                CommonWidget().ToastCall(context,
                                    sessionBookedModel!.msg.toString());
                              } else {
                                Get.to(BookSessionPage(),
                                    arguments: data.value.id);
                              }
                            },
                            child: Container(
                              height: 50,
                              width: Get.width,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColor.DarkGrey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: CommonWidget().interText(
                                  text: "Book a session",
                                  color: AppColor.BgColor,
                                  weight: FontWeight.w600,
                                  size: 14.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
