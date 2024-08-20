// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, prefer_const_constructors_in_immutables, prefer_final_fields, avoid_print, unused_field, non_constant_identifier_names, unnecessary_string_interpolations, unnecessary_new, sized_box_for_whitespace
import 'package:batter_talk_user/Controllers/doctor_detail_controller.dart';
import 'package:batter_talk_user/Controllers/packs_controller.dart';
import 'package:batter_talk_user/Controllers/register_controller.dart';
import 'package:batter_talk_user/Controllers/user_update_controller.dart';
import 'package:batter_talk_user/Helpers/api_endpoints.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/preferances.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/appoinment_model.dart';
import 'package:batter_talk_user/Models/doctor_data_model.dart';
import 'package:batter_talk_user/Models/profile_model.dart';
import 'package:batter_talk_user/Models/session_booked_model.dart';
import 'package:batter_talk_user/Screens/advance_appoinment_view.dart';
import 'package:batter_talk_user/Screens/doctor_detail_page.dart';
import 'package:batter_talk_user/Screens/instant_chat_page.dart';
import 'package:batter_talk_user/Screens/notification_page.dart';
import 'package:batter_talk_user/Screens/support_chat_page.dart';
import 'package:batter_talk_user/Screens/user_appoinment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../session_timer_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  PacksController _packsController = Get.put(PacksController());
  RegisterController _registerController = Get.put(RegisterController());
  DoctorDetailsController _doctorDetailsController =
      Get.put(DoctorDetailsController());
  UpdateProfileController _updateProfileController =
      Get.put(UpdateProfileController());
  List<AllDoctorData>? loaddoctordata;
  String imagename = "";
  var formatdate = "";
  var date = "";
  List<AllAppoinmentData>? loadappoinmentdata;
  SessionBookedModel? sessionBookedModel;
  dynamic store;
  String usertoken = "";
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  // Random random = Random();
  AllProfileData? loadprofiledata;
  bool isLoader = true;
  String userid = "";

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token")!;
      userid = pref.getString("userid")!;
    });
    print("++++++token==========$usertoken");
    DataGet();
  }

  DataGet() async {
    loadprofiledata =
        await _updateProfileController.profiledataApi(usertoken.toString());
    loadappoinmentdata =
        await _packsController.appoinmentdataApi(usertoken.toString());
    loaddoctordata =
        await _doctorDetailsController.doctordataApi(usertoken.toString());
    store = loaddoctordata;

    setState(() {
      isLoader = false;
    });
  }

  @override
  void initState() {
    getName();
    Future.delayed(
      Duration(seconds: 2),
      () {
        _registerController.userId(
            context, usertoken.toString(), userid.toString());
      },
    );
    super.initState();
  }

  void searchfilter(String quary) {
    var suggetion = loaddoctordata!.where((data) {
      final datatile = data.introduction!.toLowerCase();
      final input = quary.toLowerCase();
      return datatile.contains(input);
    }).toList();
    setState(() {
      if (searchController.text.isEmpty) {
        print('ppppppppppp');
        setState(() {
          loaddoctordata = store;
        });
      } else {
        loaddoctordata = suggetion;
      }
    });
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2)).then((value) => DataGet());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshList,
      edgeOffset: Get.height * 0.1,
      backgroundColor: AppColor.ActiveBlueColor,
      color: AppColor.BgColor,
      child: Scaffold(
        backgroundColor: AppColor.BgColor,
        body: isLoader
            ? Center(child: CircularProgressIndicator())
            : CommonWidget().mainContainer(
                childwidget: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height * 0.08),
                    // ++++++++++++++++++++++++++++++++++++++++======= Top Part =======+++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Hello ',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: AppColor.DarkGrey),
                              children: [
                                TextSpan(
                                    text: isLoader
                                        ? ""
                                        : '${loadprofiledata!.introduction.toString()} !',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: AppColor.ActiveBlueColor)),
                              ],
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.to(NotificationPage());
                            },
                            child: Image.asset(
                              AppImage.appIcon + "notifications.png",
                              height: 25,
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Get.to(SupportChatPage(), fullscreenDialog: true);
                            },
                            child: Image.asset(
                              AppImage.appIcon + "support.png",
                              height: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: CommonWidget().interText(
                          text: "Hope your doing well today",
                          size: 14.0,
                          weight: FontWeight.w400,
                          color: AppColor.SoftTextColor),
                    ),
                    // ++++++++++++++++++++++++++++++++++++++++======= Search Box =======+++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    SizedBox(height: Get.height * 0.03),
                    Container(
                      height: 50,
                      width: Get.width,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: AppColor.TextFieldColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey)),
                      child: TextFormField(
                        // onChanged: searchfilter,
                        onFieldSubmitted: searchfilter,
                        controller: searchController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            hintText: "Search a therapist",
                            suffixIcon: Icon(Icons.search, size: 30),
                            hintStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.w400, fontSize: 14)),
                      ),
                    ),
                    // ++++++++++++++++++++++++++++++++++++++++======= View All Part =======+++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    SizedBox(height: Get.height * 0.03),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonWidget().interText(
                            text: "Upcoming Appointments",
                            size: 16.0,
                            weight: FontWeight.w500,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(UserAppoinmentScreen());
                            },
                            child: CommonWidget().interText(
                              text: "View all",
                              size: 14.0,
                              color: AppColor.ActiveBlueColor,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ++++++++++++++++++++++++++++++++++++++++======= Slider Part =======+++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    SizedBox(height: Get.height * 0.02),
                    FutureBuilder(
                        future: _packsController
                            .appoinmentdataApi(usertoken.toString()),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (loadappoinmentdata!.isEmpty) {
                            return Container(
                                height: 50,
                                width: Get.width,
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                    color: AppColor.BgColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: CommonWidget().interText(
                                      text: "No Data Found",
                                      color: AppColor.BlackColor),
                                ));
                          }
                          return Container(
                            height: 125,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: loadappoinmentdata!.length.bitLength,
                              itemBuilder: (context, index) {
                                date = loadappoinmentdata![index]
                                    .bookingDate
                                    .toString();
                                DateTime parseDate =
                                    DateFormat("yyyy-MM-dd").parse(date);
                                var inputDate =
                                    DateTime.parse(parseDate.toString());
                                var outputFormat = DateFormat('EE\n dd');
                                formatdate = outputFormat.format(inputDate);
                                return isLoader
                                    ? Text("Data Fetching")
                                    : GestureDetector(
                                        onTap: () {
                                          Get.to(AdvanceAppoinmnetView(),
                                              arguments:
                                                  loadappoinmentdata![index]);
                                        },
                                        child: Container(
                                          width: loadappoinmentdata!.length == 1
                                              ? Get.width - 20
                                              : Get.width * 0.9,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: AppColor.ActiveBlueColor,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: Get.height * 0.12,
                                                width: Get.width * 0.15,
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppColor.TextFieldColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                    child: CommonWidget()
                                                        .interText(
                                                            text: formatdate,
                                                            wordheight: 1.7,
                                                            size: 16.0,
                                                            weight: FontWeight
                                                                .w500)),
                                              ),
                                              SizedBox(width: 10),
                                              SizedBox(
                                                height: Get.height * 0.15,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    CommonWidget().interText(
                                                      text:
                                                          "${loadappoinmentdata![index].type} Appointment",
                                                      weight: FontWeight.w600,
                                                      size: 14.0,
                                                      color: AppColor.BgColor,
                                                    ),
                                                    CommonWidget().interText(
                                                      text:
                                                          "${loadappoinmentdata![index].startTime} - ${loadappoinmentdata![index].endTime}",
                                                      weight: FontWeight.w400,
                                                      size: 12.0,
                                                      color: AppColor.BgColor,
                                                    ),
                                                    CommonWidget().interText(
                                                      text: loadappoinmentdata![
                                                              index]
                                                          .introduction,
                                                      weight: FontWeight.w600,
                                                      size: 14.0,
                                                      color: AppColor.BgColor,
                                                    ),
                                                    CommonWidget().interText(
                                                      text: loadappoinmentdata![
                                                              index]
                                                          .jobtitle,
                                                      weight: FontWeight.w400,
                                                      size: 12.0,
                                                      color: AppColor.BgColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 2),
                                                child: Image.asset(
                                                  AppImage.appIcon +
                                                      "right.png",
                                                  height: 25,
                                                  color: AppColor.BgColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                              },
                            ),
                          );
                        }),
                    // ++++++++++++++++++++++++++++++++++++++++======= Doctor List Part =======+++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    SizedBox(height: Get.height * 0.03),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: CommonWidget().interText(
                        text: "Our Therapist",
                        size: 16.0,
                        weight: FontWeight.w500,
                      ),
                    ),
                    // ++++++++++++++++++++++++++++++++++++++++======= Doctor List View =======+++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    FutureBuilder(
                      future: _doctorDetailsController
                          .doctordataApi(usertoken.toString()),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (loaddoctordata!.isEmpty) {
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
                          itemCount: loaddoctordata!.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 10, bottom: 80),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                sessionBookedModel =
                                    await _doctorDetailsController
                                        .sessionbookApi(usertoken,
                                            loaddoctordata![index].id);
                                print(loaddoctordata![index].id);

                                Preference.preference.saveString(
                                    "doctorname",
                                    loaddoctordata![index]
                                        .introduction
                                        .toString());

                                Preference.preference.saveString("doctorID",
                                    loaddoctordata![index].id.toString());

                                if (sessionBookedModel!.isBooked == false ||
                                    loaddoctordata![index].id !=
                                        sessionBookedModel!.data!.doctorid) {
                                  Get.to(DoctorsDetailPage(),
                                      arguments: loaddoctordata![index]);
                                } else if (loaddoctordata![index].id ==
                                        sessionBookedModel!.data!.doctorid &&
                                    sessionBookedModel!.data!.isAcceptDoctor ==
                                        false &&
                                    sessionBookedModel!.isBooked == true) {
                                  Get.to(InstantSessionTimer(),
                                      arguments: sessionBookedModel!);
                                } else if (loaddoctordata![index].id ==
                                        sessionBookedModel!.data!.doctorid &&
                                    sessionBookedModel!.data!.isAcceptDoctor ==
                                        true &&
                                    sessionBookedModel!.isBooked == true) {
                                  Get.to(InstantChatPage(),
                                      arguments: sessionBookedModel);
                                }
                              },
                              child: doctorDetailBox(
                                  doctorimage: loaddoctordata![index].image == "" ||
                                          loaddoctordata![index].image == null
                                      ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                      : BASE_URL.Imageurl +
                                          "${loaddoctordata![index].image.toString().split('/').last}",
                                  name: loaddoctordata![index].introduction == "" ||
                                          loaddoctordata![index].introduction ==
                                              null
                                      ? ""
                                      : loaddoctordata![index]
                                          .introduction
                                          .toString(),
                                  statuscolor: loaddoctordata![index].status == "online"
                                      ? AppColor.ProgressColor
                                      : Colors.red,
                                  jobtitle: loaddoctordata![index].jobtitle == null ||
                                          loaddoctordata![index].jobtitle == ""
                                      ? ""
                                      : loaddoctordata![index]
                                          .jobtitle
                                          .toString(),
                                  statustext: loaddoctordata![index].status == "online"
                                      ? "Available"
                                      : "Not-Available"),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              )),
      ),
    );
  }

  Widget doctorDetailBox(
      {doctorimage, name, jobtitle, statuscolor, statustext}) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColor.BgColor,
          boxShadow: [
            BoxShadow(
                color: AppColor.BlackColor.withOpacity(0.2),
                spreadRadius: 0.5,
                offset: Offset(0, 1),
                blurRadius: 2)
          ],
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            height: Get.height * 0.15,
            width: Get.width * 0.22,
            decoration: BoxDecoration(
                color: AppColor.SoftTextColor.withOpacity(0.2),
                image: DecorationImage(
                    image: NetworkImage(doctorimage), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(10)),
          ),
          SizedBox(width: 10),
          SizedBox(
            height: Get.height * 0.15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CommonWidget().interText(
                  text: name,
                  weight: FontWeight.w600,
                  size: 14.0,
                  color: AppColor.DarkGrey,
                ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  glow: false,
                  ignoreGestures: true,
                  updateOnDrag: true,
                  unratedColor: Colors.transparent,
                  itemCount: 5,
                  itemSize: 18,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                CommonWidget().interText(
                  text: jobtitle,
                  weight: FontWeight.w400,
                  size: 12.0,
                  color: AppColor.DarkGrey,
                ),
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: statuscolor),
                    ),
                    SizedBox(width: 5),
                    RichText(
                      text: TextSpan(
                        text: statustext,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColor.DarkGrey),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: Image.asset(AppImage.appIcon + "right.png", height: 25),
          )
        ],
      ),
    );
  }
}
