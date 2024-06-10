// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names, empty_catches, prefer_const_constructors

import 'dart:io';

import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonWidget {
  Widget mainContainer({childwidget}) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: AppColor.BgColor,
      child: childwidget,
    );
  }

  whatsapp() async {
    var androidUrl = "https://wa.me/+917013230652";
    var iosUrl = "https://wa.me/+917013230652";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl),
            mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(Uri.parse(androidUrl),
            mode: LaunchMode.externalApplication);
      }
    } on Exception {}
  }

  Widget mainContainerwithimage({childwidget}) {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
          color: AppColor.BgColor,
          image: DecorationImage(
              image: AssetImage(AppImage.appIcon + "bgimage.png"),
              fit: BoxFit.cover)),
      child: childwidget,
    );
  }

  void ToastCall(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColor.TextColor,
      duration: Duration(seconds: 1),
    ));
  }

  Widget interText(
      {text, maxline, align, size, color, weight, letterspace, wordheight}) {
    return Text(
      text,
      maxLines: maxline,
      textAlign: align,
      style: GoogleFonts.inter(
        fontSize: size,
        color: color,
        fontWeight: weight,
        height: wordheight,
        letterSpacing: letterspace,
      ),
    );
  }
}
