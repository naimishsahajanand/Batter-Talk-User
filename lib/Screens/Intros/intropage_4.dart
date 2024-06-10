// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, prefer_final_fields, unnecessary_brace_in_string_interps, avoid_print, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:batter_talk_user/Controllers/register_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Screens/Intros/intropage_5.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> locationlist = <String>[
  "Chennai",
  "Mumbai",
  "Hyderabad",
  "Kolkata",
  "Delhi",
  "Bangalore",
  "Pune",
  "Agra",
  "Ahmedabad",
  "Chandigarh",
  "Jaipur",
  "Lucknow",
  "New Delhi",
  "Visakhapatnam",
  "Surat",
  "Patna",
  "Kochi",
  "Madurai",
  "Kanpur",
  "Indore",
  "Bhopal",
  "Nashik",
  "Nagpur",
  "Thiruvananthapuram"
];
const List<String> proffesionlist = <String>[
  "Student",
  "Self employed ",
  "House maker ",
  "Engineer ",
  "Doctor ",
  "Artist ",
  "Corporate Job ",
  "Lawyer ",
  "Accountant"
];

class IntroPage4 extends StatefulWidget {
  @override
  State<IntroPage4> createState() => _IntroPage4State();
}

class _IntroPage4State extends State<IntroPage4> {
  RegisterController _registerController = Get.put(RegisterController());
  List<String>? loadlocationdata;
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
    loadlocationdata = await _registerController.locationdataApi();
    setState(() {
      print(loadlocationdata!);
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
                      width: Get.width * 0.8,
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
                        image: AssetImage(AppImage.appIcon + "intro2.png"))),
              ),
              SizedBox(height: Get.height * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RichText(
                  text: TextSpan(
                    text: 'Tell us about a little more about ',
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
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColor.TextFieldColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownMenu<String>(
                  // initialSelection: list.first,
                  hintText: "Your location",
                  width: Get.width - 30,
                  onSelected: (String? value) {
                    setState(() {
                      _registerController.dropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries: locationlist
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
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
                  hintText: "Your profession",
                  width: Get.width - 30,
                  onSelected: (String? value) {
                    setState(() {
                      _registerController.prodropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries: proffesionlist
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Get.to(IntroPage5());
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
