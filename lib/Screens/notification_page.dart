// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unused_field, prefer_final_fields, unused_import, avoid_print

import 'package:batter_talk_user/Controllers/packs_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  PacksController _packsController = Get.put(PacksController());
  List<AllNotificationData>? loaddoctornotifydata;
  var date = "";
  var formatdate = "";
  String usertoken = "";
  bool isLoader = true;

  @override
  void initState() {
    getName();
    super.initState();
  }

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token") ?? "";
    });
    Datafetch();
  }

  Datafetch() async {
    loaddoctornotifydata = await _packsController
        .fetchDoctorAllnotificatiobApi(usertoken.toString());
    setState(() {
      isLoader = false;
    });
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
            text: "Notifications",
            color: AppColor.DarkGrey,
            weight: FontWeight.w500,
            size: 16.0),
      ),
      body: isLoader
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: _packsController
                  .fetchDoctorAllnotificatiobApi(usertoken.toString()),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (loaddoctornotifydata!.isEmpty) {
                  return Container(
                      height: 50,
                      width: Get.width,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: AppColor.BgColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: CommonWidget().interText(
                            text: "No Data Found", color: AppColor.BlackColor),
                      ));
                }
                return ListView.separated(
                  itemCount: loaddoctornotifydata!.length,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  itemBuilder: (context, index) {
                    date = loaddoctornotifydata![index].date.toString();
                    DateTime parseDate =
                        DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
                    var inputDate = DateTime.parse(parseDate.toString());
                    var outputFormat = DateFormat('MMM d h:mm a');
                    formatdate = outputFormat.format(inputDate);
                    print(formatdate);

                    return notificationTile(
                      message: loaddoctornotifydata![index].message,
                      image: loaddoctornotifydata![index].image == "" ||
                              loaddoctornotifydata![index].image == null
                          ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                          : loaddoctornotifydata![index].image,
                      time: formatdate,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: AppColor.SoftTextColor.withOpacity(0.3),
                    );
                  },
                );
              }),
    );
  }

  Widget notificationTile({message, image, time}) {
    return ListTile(
      tileColor: AppColor.TextFieldColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 15),
      leading: CircleAvatar(
        backgroundColor: AppColor.ProgressColor.withOpacity(0.4),
        backgroundImage: NetworkImage(image),
      ),
      title: CommonWidget().interText(
          text: message, maxline: 2, size: 14.0, weight: FontWeight.w400),
      trailing: CommonWidget().interText(
          text: time, size: 12.0, weight: FontWeight.w400, maxline: 2),
    );
  }
}
