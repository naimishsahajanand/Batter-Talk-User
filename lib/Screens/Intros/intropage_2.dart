// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps, prefer_final_fields, unused_field, avoid_print, non_constant_identifier_names

import 'package:batter_talk_user/Controllers/register_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/review_model.dart';
import 'package:batter_talk_user/Screens/Intros/intropage_3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPage2 extends StatefulWidget {
  const IntroPage2({super.key});

  @override
  State<IntroPage2> createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
  int _current = 0;
  RegisterController _registerController = Get.put(RegisterController());
  PageController _pageController = PageController();

  List<AllReviewData>? loadreviewdata;
  String name = "";

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString("username")!;
    });
    print("++++++name==========${name}");
    Dataget();
  }

  Dataget() async {
    loadreviewdata = await _registerController.reviewdataApi();
  }

  PageController _scrollController = PageController();

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
              child: FutureBuilder(
                  future: _registerController.reviewdataApi(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.data == null) {
                      return Container(
                          height: 50,
                          width: Get.width,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              color: AppColor.BgColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(child: Text("No Data Found")));
                    }
                    return Column(
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
                                width: Get.width * 0.4,
                                decoration: BoxDecoration(
                                    color: AppColor.ProgressColor,
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Get.height * 0.04),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: RichText(
                            text: TextSpan(
                              text: 'Hello ',
                              style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.TextColor),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '${name}, ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.ActiveBlueColor)),
                                TextSpan(text: 'Glad to see you here'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.01),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: CommonWidget().interText(
                              text:
                                  "We're glad to see you join our 200+ member family of healthcare hero's grow",
                              size: 14.0,
                              color: AppColor.SoftTextColor,
                              weight: FontWeight.w400),
                        ),
                        SizedBox(height: Get.height * 0.1),
                        SizedBox(
                          height: Get.height * 0.36,
                          child: PageView.builder(
                              itemCount: loadreviewdata!.length,
                              controller: _pageController,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return dataSlider(
                                    name: loadreviewdata![index].name,
                                    image: loadreviewdata![index].image,
                                    review: loadreviewdata![index].review,
                                    rating: loadreviewdata![index]
                                        .rating!
                                        .toDouble());
                              }),
                        ),
                        Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: loadreviewdata!.length,
                            axisDirection: Axis.horizontal,
                            effect: SlideEffect(
                                radius: 8,
                                dotWidth: 12,
                                dotHeight: 12,
                                paintStyle: PaintingStyle.fill,
                                strokeWidth: 1.5,
                                dotColor: AppColor.BorderColor,
                                activeDotColor: AppColor.ActiveBlueColor),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.to(IntroPage3());
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
                    );
                  }),
            ),
          ),
        ));
  }

  Widget dataSlider({name, rating, image, review}) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: Get.height * 0.3,
            width: Get.width * 0.9,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(top: 25, left: 10, right: 10),
            decoration: BoxDecoration(
              color: AppColor.TextFieldColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: AppColor.TextColor.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonWidget().interText(
                    text: name,
                    size: 16.0,
                    color: AppColor.BlackColor,
                    weight: FontWeight.w500),
                SizedBox(height: 10),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  glow: false,
                  unratedColor: AppColor.DarkGrey,
                  itemCount: 5,
                  updateOnDrag: true,
                  ignoreGestures: true,
                  itemSize: 18,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                SizedBox(height: 10),
                CommonWidget().interText(
                    text: review,
                    size: 14.0,
                    color: AppColor.TextColor,
                    align: TextAlign.center,
                    maxline: 5,
                    wordheight: 2.0,
                    weight: FontWeight.w500),
              ],
            ),
          ),
        ),
        Positioned(
            left: Get.width * 0.15,
            child: Container(
              height: 55,
              width: 55,
              padding: EdgeInsets.all(5),
              child: Image.asset(AppImage.appIcon + "quote.png"),
            )),
        Positioned(
          left: Get.width * 0.4,
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.SoftTextColor,
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)),
          ),
        ),
      ],
    );
  }
}
