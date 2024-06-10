// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, prefer_final_fields, non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:batter_talk_user/Controllers/packs_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/appoinment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAppoinmentScreen extends StatefulWidget {
  const UserAppoinmentScreen({super.key});

  @override
  State<UserAppoinmentScreen> createState() => _UserAppoinmentScreenState();
}

class _UserAppoinmentScreenState extends State<UserAppoinmentScreen> {
  PacksController _packsController = Get.put(PacksController());
  List<AllAppoinmentData>? loadappoinmentdata;
  String usertoken = "";
  var formatdate = "";
  var date = "";

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token") ?? "";
    });
    print("++++++token==========${usertoken}");
    Datafetch();
  }

  @override
  void initState() {
    getName();
    super.initState();
  }

  Datafetch() async {
    loadappoinmentdata =
        await _packsController.appoinmentdataApi(usertoken.toString());
    setState(() {});
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
            text: "Your Appointments",
            color: AppColor.DarkGrey,
            weight: FontWeight.w500,
            size: 16.0),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.01),
          Container(
            height: 50,
            width: Get.width,
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: AppColor.TextFieldColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)),
            child: TextFormField(
              maxLength: 10,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintText: "Search a appointment",
                  suffixIcon: Icon(Icons.search, size: 30),
                  hintStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w400, fontSize: 14)),
            ),
          ),
          SizedBox(height: Get.height * 0.03),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15),
          //   child: CommonWidget().interText(
          //       text: "This week",
          //       weight: FontWeight.w500,
          //       size: 14.0,
          //       color: AppColor.DarkGrey),
          // ),
          // SizedBox(height: Get.height * 0.01),
          FutureBuilder(
              future: _packsController.appoinmentdataApi(usertoken.toString()),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (loadappoinmentdata!.isEmpty) {
                  return Center(
                    child: Container(
                        height: 50,
                        width: Get.width,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: CommonWidget().interText(
                              text: "No Data Found",
                              color: AppColor.BlackColor),
                        )),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: loadappoinmentdata!.length,
                  itemBuilder: (context, index) {
                    date = loadappoinmentdata![index].bookingDate.toString();
                    DateTime parseDate = DateFormat("yyyy-MM-dd").parse(date);
                    var inputDate = DateTime.parse(parseDate.toString());
                    var outputFormat = DateFormat('EE\n dd');
                    formatdate = outputFormat.format(inputDate);
                    return GestureDetector(
                      onTap: () {
                        // Get.to(SoloChatPage(),
                        //     arguments: loadappoinmentdata![index]);
                      },
                      child: appoimentBox(
                          appoinmenttype:
                              "${loadappoinmentdata![index].type} Appointment",
                          doctorname: loadappoinmentdata![index].introduction,
                          jobtitle:
                              loadappoinmentdata![index].jobtitle.toString(),
                          date: formatdate,
                          slottime:
                              "${loadappoinmentdata![index].startTime} - ${loadappoinmentdata![index].endTime}"),
                    );
                  },
                );
              })
        ],
      )),
    );
  }

  Widget appoimentBox({appoinmenttype, doctorname, jobtitle, date, slottime}) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: AppColor.ActiveBlueColor,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            height: Get.height * 0.12,
            width: Get.width * 0.15,
            decoration: BoxDecoration(
                color: AppColor.TextFieldColor,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: CommonWidget().interText(
                    text: date,
                    wordheight: 1.7,
                    size: 16.0,
                    weight: FontWeight.w500)),
          ),
          SizedBox(width: 10),
          SizedBox(
            height: Get.height * 0.15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CommonWidget().interText(
                  text: appoinmenttype,
                  weight: FontWeight.w600,
                  size: 14.0,
                  color: AppColor.BgColor,
                ),
                CommonWidget().interText(
                  text: slottime,
                  weight: FontWeight.w400,
                  size: 12.0,
                  color: AppColor.BgColor,
                ),
                CommonWidget().interText(
                  text: doctorname,
                  weight: FontWeight.w600,
                  size: 14.0,
                  color: AppColor.BgColor,
                ),
                CommonWidget().interText(
                  text: jobtitle,
                  weight: FontWeight.w400,
                  size: 12.0,
                  color: AppColor.BgColor,
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: Image.asset(
              AppImage.appIcon + "right.png",
              height: 25,
              color: AppColor.BgColor,
            ),
          )
        ],
      ),
    );
  }
}
