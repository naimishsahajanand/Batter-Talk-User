// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names

import 'package:batter_talk_user/Controllers/community_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/community_model.dart';
import 'package:batter_talk_user/Screens/community_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommunityListPage extends StatefulWidget {
  const CommunityListPage({super.key});

  @override
  State<CommunityListPage> createState() => _CommunityListPageState();
}

class _CommunityListPageState extends State<CommunityListPage> {
  CommunityController _communityController = Get.put(CommunityController());
  int selectedIndex = 1;
  List<AllCommunityData>? loadcommunitydata;
  List<JoinCommunityData>? loadjoincommunitydata;
  bool popup = false;
  String usertoken = "";

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token") ?? "";
    });
    Datafetch();
  }

  @override
  void initState() {
    getName();
    super.initState();
  }

  Datafetch() async {
    loadcommunitydata =
        await _communityController.fetchCommunityDataApi(usertoken.toString());
    loadjoincommunitydata = await _communityController
        .fetchjoinCommunityDataApi(usertoken.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BgColor,
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.08),
            CommonWidget().interText(
              text: "Communities",
              color: AppColor.DarkGrey,
              size: 20.0,
              weight: FontWeight.w600,
            ),
            CommonWidget().interText(
              text: "Connect to People Like You",
              color: AppColor.TextColor,
              size: 15.0,
              weight: FontWeight.w600,
            ),
            SizedBox(height: Get.height * 0.02),
            Divider(
              color: Color(0xffF5F8FA),
              thickness: 4,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: selectedIndex == 1
                            ? AppColor.ActiveBlueColor
                            : AppColor.BgColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: CommonWidget().interText(
                        text: "My Community",
                        color: selectedIndex == 1
                            ? AppColor.BgColor
                            : AppColor.DarkGrey,
                        size: 15.0,
                        weight: FontWeight.w600),
                  ),
                ),
                SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: selectedIndex == 0
                            ? AppColor.ActiveBlueColor
                            : AppColor.BgColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: CommonWidget().interText(
                        text: "Explore",
                        color: selectedIndex == 0
                            ? AppColor.BgColor
                            : AppColor.DarkGrey,
                        size: 15.0,
                        weight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            selectedIndex == 0
                ? FutureBuilder(
                    future: _communityController
                        .fetchCommunityDataApi(usertoken.toString()),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (loadcommunitydata!.isEmpty) {
                        return Container(
                            width: Get.width,
                            margin: EdgeInsets.only(top: Get.height * 0.25),
                            decoration: BoxDecoration(
                                color: AppColor.BgColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: SizedBox(
                                width: Get.width * 0.75,
                                child: CommonWidget().interText(
                                    text: "No community found!",
                                    align: TextAlign.center,
                                    color: AppColor.BlackColor),
                              ),
                            ));
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: loadcommunitydata!.length,
                          itemBuilder: (context, ind) {
                            return datalist(
                                images: loadcommunitydata![ind].image,
                                name: loadcommunitydata![ind].name,
                                member: loadcommunitydata![ind].memberCount,
                                description: loadcommunitydata![ind].aboutUs,
                                ontapaction: () {
                                  _communityController.joinCommunityDataApi(
                                      usertoken.toString(),
                                      loadcommunitydata![ind].id.toString(),
                                      context);
                                  setState(() {
                                    Future.delayed(Duration(milliseconds: 200),
                                        () {
                                      Datafetch();
                                    });
                                  });
                                });
                          });
                    })
                : FutureBuilder(
                    future: _communityController
                        .fetchjoinCommunityDataApi(usertoken.toString()),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (loadjoincommunitydata!.isEmpty) {
                        return Container(
                            width: Get.width,
                            margin: EdgeInsets.only(top: Get.height * 0.25),
                            decoration: BoxDecoration(
                                color: AppColor.BgColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: SizedBox(
                                width: Get.width * 0.75,
                                child: CommonWidget().interText(
                                    text:
                                        "Please check the explore page to find Peer groups / communities",
                                    align: TextAlign.center,
                                    color: AppColor.BlackColor),
                              ),
                            ));
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: loadjoincommunitydata!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(CommunityChatScreen(),
                                    arguments: loadjoincommunitydata![index]);
                              },
                              child: datalist(
                                  images: loadjoincommunitydata![index].image,
                                  name: loadjoincommunitydata![index].name,
                                  description:
                                      loadcommunitydata![index].aboutUs,
                                  member: loadjoincommunitydata![index]
                                      .memberCount),
                            );
                          });
                    })
          ],
        ),
      ),
    );
  }

  Widget datalist({images, name, member, ontapaction, description}) {
    return Container(
      // height: 100,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.only(bottom: 8, top: 8),
      decoration: BoxDecoration(
          color: Color(0xffF5F8FA), borderRadius: BorderRadius.circular(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.SoftTextColor,
                image: DecorationImage(image: NetworkImage(images))),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: selectedIndex == 0 ? Get.width * 0.35 : Get.width * 0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonWidget().interText(
                  text: name,
                  color: AppColor.DarkGrey,
                  size: 14.0,
                  weight: FontWeight.w600,
                ),
                CommonWidget().interText(
                  text: "$member Members",
                  color: AppColor.DarkGrey,
                  size: 12.0,
                  weight: FontWeight.w400,
                ),
                CommonWidget().interText(
                  text: "$description",
                  color: AppColor.DarkGrey,
                  size: 12.0,
                  weight: FontWeight.w400,
                ),
              ],
            ),
          ),
          Spacer(),
          selectedIndex == 0
              ? GestureDetector(
                  onTap: ontapaction,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: AppColor.ActiveBlueColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: CommonWidget().interText(
                        text: "Join group ->",
                        size: 12.0,
                        color: AppColor.BgColor,
                        weight: FontWeight.w500),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
