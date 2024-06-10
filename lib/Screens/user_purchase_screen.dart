// ignore_for_file: prefer_const_constructors, prefer_final_fields, unnecessary_brace_in_string_interps, avoid_print, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:batter_talk_user/Controllers/packs_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/session_plan_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPurchaseScreen extends StatefulWidget {
  const UserPurchaseScreen({super.key});

  @override
  State<UserPurchaseScreen> createState() => _UserPurchaseScreenState();
}

class _UserPurchaseScreenState extends State<UserPurchaseScreen> {
  PacksController _packsController = Get.put(PacksController());
  String usertoken = "";
  List<AllSessionBuyModel>? loadbuysessiondata;

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
    loadbuysessiondata =
        await _packsController.sessionbuyplanlistApi(usertoken.toString());
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
            text: "Purchase",
            color: AppColor.DarkGrey,
            weight: FontWeight.w500,
            size: 16.0),
      ),
      body: CommonWidget().mainContainer(
          childwidget: FutureBuilder(
              future: _packsController.sessionplanlistApi(usertoken.toString()),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (loadbuysessiondata!.isEmpty) {
                  return Container(
                      height: 50,
                      width: Get.width,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: AppColor.BgColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(child: Text("No Data Found")));
                }
                return ListView.builder(
                  itemCount: loadbuysessiondata!.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, ind) {
                    return Container(
                      width: Get.width * 0.95,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              AppColor.ActiveBlueColor.withOpacity(0.2),
                              AppColor.SoftTextColor.withOpacity(0.1)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: AppColor.BgColor,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              loadbuysessiondata![ind]
                                                  .image
                                                  .toString()))),
                                ),
                                SizedBox(width: 8),
                                CommonWidget().interText(
                                    text: loadbuysessiondata![ind]
                                        .name
                                        .toString(),
                                    color: AppColor.BlackColor,
                                    size: 14.0,
                                    weight: FontWeight.w500)
                              ],
                            ),
                            SizedBox(height: 8),
                            CommonWidget().interText(
                              text:
                                  "₹${loadbuysessiondata![ind].price} per session",
                              size: 14.0,
                              weight: FontWeight.w600,
                              color: AppColor.ActiveBlueColor,
                            ),
                            SizedBox(height: 8),
                            CommonWidget().interText(
                              text: loadbuysessiondata![ind]
                                  .description
                                  .toString(),
                              size: 14.0,
                              maxline: 2,
                              weight: FontWeight.w400,
                              color: AppColor.DarkGrey,
                              wordheight: 1.5,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              })),
    );
  }
}
