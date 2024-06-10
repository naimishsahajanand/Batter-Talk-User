// ignore_for_file: prefer__ructors, prefer__literals_to_create_immutables, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, await_only_futures, avoid_print, sort_child_properties_last, prefer_const_constructors, sized_box_for_whitespace, prefer_const_declarations, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SupportChatPage extends StatefulWidget {
  SupportChatPage({super.key});

  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  TextEditingController _messagecontroller = TextEditingController();
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
            text: "Chat with support",
            color: AppColor.DarkGrey,
            weight: FontWeight.w500,
            size: 16.0),
        actions: [
          Image.asset(
            AppImage.appIcon + "call.png",
            width: 25,
          ),
          SizedBox(width: 15)
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              width: Get.width,
              margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffE5E9F0), Color(0xffF5F8FA)]),
                  border: Border.all(color: Color(0xffE5E9F0), width: 1),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      width: Get.width * 0.7,
                      child: TextFormField(
                        controller: _messagecontroller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write a message..."),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _messagecontroller.clear();
                      },
                      child: Image.asset(
                        AppImage.appIcon + "send.png",
                        height: 22,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
