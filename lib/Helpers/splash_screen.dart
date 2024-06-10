// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_this, prefer_interpolation_to_compose_strings, prefer_final_fields, unused_field, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unused_local_variable, sized_box_for_whitespace

import 'dart:async';
import 'package:batter_talk_user/Helpers/bottomnavbar.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/preferances.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () async {
      var isLogin = await Preference.preference
          .getBool(key: PrefernceKey.isUserLogin, defVal: false);
      // var isOnboard = await Preference.preference
      //     .getBool(key: PrefernceKey.isUseronboard, defVal: false);
      if (isLogin == false) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen()));
      } else if (isLogin == true) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => BottomNavBar()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 150,
            width: 150,
            child: Image.asset(AppImage.appIcon + 'BTLogo.jpg'),
          ),
          CommonWidget().interText(
              text: "Better Talk Patient", size: 18.0, weight: FontWeight.w700),
        ]),
      ),
    );
  }
}
