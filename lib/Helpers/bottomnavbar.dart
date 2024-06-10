// ignore_for_file: use_key_in_widget_constructors, unused_import, library_private_types_in_public_api, prefer_const_constructors, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unnecessary_this, avoid_print, prefer_final_fields, unused_field, unused_element, unrelated_type_equality_checks, sort_child_properties_last, avoid_unnecessary_containers, deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Screens/Bottombar_Pages/community_page.dart';
import 'package:batter_talk_user/Screens/Bottombar_Pages/home_page.dart';
import 'package:batter_talk_user/Screens/Bottombar_Pages/packs_page.dart';
import 'package:batter_talk_user/Screens/Bottombar_Pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App',
                style: GoogleFonts.inter(
                    color: AppColor.BlackColor, fontWeight: FontWeight.w600)),
            content: Text('Are You Sure Want To Exit',
                style: GoogleFonts.inter(
                    color: AppColor.BlackColor, fontWeight: FontWeight.w500)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No',
                    style: GoogleFonts.inter(
                        color: AppColor.DarkGrey, fontWeight: FontWeight.w400)),
              ),
              TextButton(
                onPressed: () => exit(1),
                child: Text('Yes',
                    style: GoogleFonts.inter(
                        color: AppColor.DarkGrey, fontWeight: FontWeight.w400)),
              ),
            ],
          ),
        ) ??
        false;
  }

  var currentIndex = 0;

  selectedIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        extendBody: true,
        drawerEnableOpenDragGesture: false,
        bottomNavigationBar: bottomnavbar(context),
        body: Stack(
          children: [
            if (currentIndex == 0)
              HomeScreen()
            else if (currentIndex == 1)
              PackScreen()
            else if (currentIndex == 2)
              CommunityScreen()
            else
              SettingScreen(),
          ],
        ),
      ),
    );
  }

  Widget bottomnavbar(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(color: AppColor.TextFieldColor, boxShadow: [
                BoxShadow(
                    offset: Offset(1, -1),
                    blurRadius: 5,
                    color: AppColor.SoftTextColor.withOpacity(0.4))
              ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  iconButton(
                    iconImg: "home.png",
                    iconName: 'My Home',
                    currentInd: 0,
                    selectedind: 0,
                  ),
                  iconButton(
                    iconImg: "packs.png",
                    iconName: 'Packs',
                    currentInd: 1,
                    selectedind: 1,
                  ),
                  iconButton(
                    iconImg: "forums.png",
                    iconName: 'Community',
                    currentInd: 2,
                    selectedind: 2,
                  ),
                  iconButton(
                    iconImg: "setting.png",
                    iconName: 'Setting',
                    currentInd: 3,
                    selectedind: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget iconButton({page, currentInd, selectedind, iconImg, iconName}) {
    return GestureDetector(
      onTap: () {
        selectedIndex(selectedind);
      },
      child: Container(
        width: Get.width * 0.20,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              AppImage.appIcon + iconImg,
              color: currentIndex == currentInd
                  ? AppColor.ActiveBlueColor
                  : AppColor.DarkGrey,
              width: 22,
            ),
            Text(
              "$iconName",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: currentIndex == currentInd
                    ? AppColor.ActiveBlueColor
                    : AppColor.DarkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
