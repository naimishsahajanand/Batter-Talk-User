// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, prefer_final_fields, unused_field, unnecessary_brace_in_string_interps, avoid_print, non_constant_identifier_names, unnecessary_overrides, unused_local_variable, no_leading_underscores_for_local_identifiers, unnecessary_new, prefer_collection_literals, unnecessary_this, unnecessary_string_interpolations

import 'package:batter_talk_user/Controllers/packs_controller.dart';
import 'package:batter_talk_user/Controllers/user_update_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/profile_model.dart';
import 'package:batter_talk_user/Models/session_plan_list_model.dart';
import 'package:batter_talk_user/Screens/notification_page.dart';
import 'package:batter_talk_user/Screens/support_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PackScreen extends StatefulWidget {
  const PackScreen({super.key});

  @override
  State<PackScreen> createState() => _PackScreenState();
}

class _PackScreenState extends State<PackScreen>
    with SingleTickerProviderStateMixin {
  final MethodChannel _channel = MethodChannel('easebuzz');

  List<AllSessionPlanList>? loadplanlistdata;
  PacksController _packsController = Get.put(PacksController());
  UpdateProfileController _updateProfileController =
      Get.put(UpdateProfileController());
  PageController _pageController = PageController();
  String usertoken = "";
  bool isLoader = true;
  int purchaseIndex = 0;
  int _current = 0;
  AllProfileData? loadprofiledata;
  String payment_key = "";
  var razordata = RazorpayKeyModel();

  @override
  void initState() {
    getName();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token")!;
    });
    print("++++++token==========${usertoken}");
    DataFetch();
  }

  DataFetch() async {
    loadplanlistdata =
        await _packsController.sessionplanlistApi(usertoken.toString());
    loadprofiledata =
        await _updateProfileController.profiledataApi(usertoken.toString());
    setState(() {
      isLoader = false;
    });
    _packsController.generateRazorpayapiKey();
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
    _packsController.sessionBuy(
        context, loadplanlistdata![purchaseIndex].id, usertoken.toString());
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    print("========${razordata.data}");
    return Scaffold(
      backgroundColor: AppColor.BgColor,
      body: CommonWidget().mainContainer(
        childwidget: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.08),
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
              sessionBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget sessionBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.02),
          SizedBox(
            height: Get.height * 0.3,
            child: FutureBuilder(
              future: _packsController.sessionplanlistApi(usertoken.toString()),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                return PageView.builder(
                    itemCount: loadplanlistdata!.length,
                    controller: _pageController,
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      int final_amount =
                          int.parse(loadplanlistdata![index].prise.toString());
                      return sessiondata(
                          image: loadplanlistdata![index].image == "" ||
                                  loadplanlistdata![index].image == null
                              ? ""
                              : loadplanlistdata![index].image,
                          packname: loadplanlistdata![index].name == "" ||
                                  loadplanlistdata![index].name == null
                              ? ""
                              : loadplanlistdata![index].name,
                          price: loadplanlistdata![index].prise == "" ||
                                  loadplanlistdata![index].prise == null
                              ? ""
                              : loadplanlistdata![index].prise,
                          description: loadplanlistdata![index].description ==
                                      "" ||
                                  loadplanlistdata![index].description == null
                              ? ""
                              : loadplanlistdata![index].description,
                          ontapAction: () {
                            purchaseIndex = index;
                            print(_packsController.Keyname.toString());
                            Razorpay razorpay = Razorpay();
                            var options = {
                              // 'key': 'rzp_live_ILgsfZCZoFIKMb',
                              'key': _packsController.Keyname.toString(),
                              'amount': final_amount * 100,
                              'name':
                                  '${loadprofiledata!.introduction.toString()}',
                              'description': 'Fine T-Shirt',
                              'retry': {'enabled': true, 'max_count': 1},
                              'send_sms_hash': true,
                              'prefill': {
                                'contact': '8888888888',
                                'email': 'test@razorpay.com'
                              },
                              'external': {
                                'wallets': ['paytm']
                              }
                            };
                            razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                                handlePaymentErrorResponse);
                            razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                handlePaymentSuccessResponse);
                            razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                handleExternalWalletSelected);
                            razorpay.open(options);
                            print("======PurchaseIndex ${purchaseIndex}");
                            print("======final Ammount ${final_amount}");
                          }
                          // ontapAction: () {
                          //   _packsController.sessionBuy(
                          //       context,
                          //       loadplanlistdata![index].id,
                          //       usertoken.toString());
                          // },
                          );
                    });
              },
            ),
          ),
          Center(
            child: isLoader
                ? SizedBox()
                : SmoothPageIndicator(
                    controller: _pageController,
                    count: loadplanlistdata!.length,
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
          SizedBox(height: Get.height * 0.01),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: CommonWidget().interText(
                text: "How it works",
                size: 14.0,
                weight: FontWeight.w500,
                color: AppColor.DarkGrey),
          ),
          SizedBox(height: Get.height * 0.02),
          isLoader
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: CommonWidget().interText(
                      text: isLoader ? "" : loadplanlistdata![0].description,
                      size: 14.0,
                      wordheight: 1.7,
                      letterspace: 0.07,
                      weight: FontWeight.w500,
                      color: AppColor.SoftTextColor),
                ),
          SizedBox(height: 75),
        ],
      ),
    );
  }

  Widget sessiondata({image, packname, price, description, ontapAction}) {
    return Container(
      width: Get.width * 0.95,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          AppColor.ActiveBlueColor.withOpacity(0.2),
          AppColor.SoftTextColor.withOpacity(0.2)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
                      image: DecorationImage(image: NetworkImage(image))),
                ),
                SizedBox(width: 8),
                CommonWidget().interText(
                    text: packname,
                    color: AppColor.BlackColor,
                    size: 14.0,
                    weight: FontWeight.w500)
              ],
            ),
            SizedBox(height: 5),
            CommonWidget().interText(
              text: "₹${price} per session",
              size: 14.0,
              weight: FontWeight.w600,
              color: AppColor.ActiveBlueColor,
            ),
            SizedBox(height: 5),
            CommonWidget().interText(
              text: description,
              size: 14.0,
              maxline: 2,
              weight: FontWeight.w400,
              color: AppColor.DarkGrey,
              wordheight: 1.5,
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: ontapAction,
              child: Container(
                height: 30,
                width: Get.width,
                decoration: BoxDecoration(
                    color: AppColor.DarkGrey,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: CommonWidget().interText(
                      text: "Buy Now",
                      color: AppColor.BgColor,
                      size: 12.0,
                      weight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        Get.back();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
