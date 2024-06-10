// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_final_fields, use_build_context_synchronously, unnecessary_brace_in_string_interps, avoid_print, prefer_typing_uninitialized_variables, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, non_constant_identifier_names, await_only_futures, unnecessary_new, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:batter_talk_user/Controllers/register_controller.dart';
import 'package:batter_talk_user/Controllers/user_update_controller.dart';
import 'package:batter_talk_user/Helpers/api_endpoints.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/profile_model.dart';
import 'package:batter_talk_user/Screens/general_detail_page.dart';
import 'package:batter_talk_user/Screens/gift_friends_page.dart';
import 'package:batter_talk_user/Screens/login_screen.dart';
import 'package:batter_talk_user/Screens/madical_detail_page.dart';
import 'package:batter_talk_user/Screens/proffesional_detail_page.dart';
import 'package:batter_talk_user/Screens/user_appoinment_page.dart';
import 'package:batter_talk_user/Screens/user_purchase_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  UpdateProfileController _updateProfileController =
      Get.put(UpdateProfileController());
  RegisterController _registerController = Get.put(RegisterController());

  bool swichvalue = false;
  String usertoken = "";
  AllProfileData? loadprofiledata;
  File? image;
  bool isLoader = true;

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
    loadprofiledata =
        await _updateProfileController.profiledataApi(usertoken.toString());
    setState(() {
      isLoader = false;
    });
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Logout App',
                style: GoogleFonts.inter(
                    color: AppColor.BlackColor, fontWeight: FontWeight.w600)),
            content: Text('Are You Sure Want To Logout',
                style: GoogleFonts.inter(
                    color: AppColor.BlackColor, fontWeight: FontWeight.w500)),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('No',
                    style: GoogleFonts.inter(
                        color: AppColor.DarkGrey, fontWeight: FontWeight.w400)),
              ),
              TextButton(
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.clear();
                  _registerController.phonenumbercontroller.clear();
                  _registerController.otpcontroller.clear();
                  Get.offAll(LoginScreen());
                },
                child: Text('Yes',
                    style: GoogleFonts.inter(
                        color: AppColor.DarkGrey, fontWeight: FontWeight.w400)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> deleteaccountPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete Account',
                style: GoogleFonts.inter(
                    color: AppColor.BlackColor, fontWeight: FontWeight.w600)),
            content: Text(
                "You can permanently delete your account from here. if you're sure about this and you choose to move ahead, all the data connected to this account will be deleted permanently. you will not be able to retrieve it in the future.",
                style: GoogleFonts.inter(
                    color: AppColor.BlackColor, fontWeight: FontWeight.w500)),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('No',
                    style: GoogleFonts.inter(
                        color: AppColor.DarkGrey, fontWeight: FontWeight.w400)),
              ),
              TextButton(
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.clear();
                  _registerController.phonenumbercontroller.clear();
                  _registerController.otpcontroller.clear();
                  _updateProfileController.profiledeleteApi(
                      usertoken.toString(), context);
                },
                child: Text('Yes',
                    style: GoogleFonts.inter(
                        color: AppColor.DarkGrey, fontWeight: FontWeight.w400)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.BgColor,
        body: isLoader
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    SizedBox(height: Get.height * 0.08),
                    profilepart(),
                    SizedBox(height: Get.height * 0.03),
                    accountPart(),
                    SizedBox(height: 60),
                  ],
                )),
              ));
  }

  Widget profilepart() {
    return Row(
      children: [
        Stack(
          children: [
            SizedBox(
              height: 90,
              width: 90,
            ),
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.BgColor,
                  border: Border.all(
                      color: AppColor.SoftTextColor.withOpacity(0.1), width: 2),
                  boxShadow: [
                    BoxShadow(
                        color: AppColor.BlackColor.withOpacity(0.2),
                        spreadRadius: 0.5,
                        offset: Offset(1, 1),
                        blurRadius: 2)
                  ],
                  image: DecorationImage(
                      image: NetworkImage(loadprofiledata!.image == "" ||
                              loadprofiledata!.image == null ||
                              isLoader
                          ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                          : loadprofiledata!.image.toString()),
                      fit: BoxFit.cover)),
            ),
            Positioned(
              bottom: 15,
              right: 10,
              child: Container(
                height: 25,
                width: 25,
                child: GestureDetector(
                  onTap: () {
                    Get.bottomSheet(Container(
                      height: 100,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: AppColor.BorderColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Get.back();
                              final pickedFile = await ImagePicker()
                                  .pickImage(source: ImageSource.camera);

                              if (pickedFile != null) {
                                CroppedFile? croppedFile =
                                    await ImageCropper().cropImage(
                                  sourcePath: pickedFile.path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.square,
                                  ],
                                  uiSettings: [
                                    AndroidUiSettings(
                                        toolbarTitle: 'Cropper',
                                        hideBottomControls: true,
                                        backgroundColor: AppColor.BgColor,
                                        toolbarColor: AppColor.BgColor,
                                        toolbarWidgetColor: AppColor.BlackColor,
                                        initAspectRatio:
                                            CropAspectRatioPreset.square,
                                        lockAspectRatio: true),
                                  ],
                                );

                                if (croppedFile != null) {
                                  setState(() {
                                    image = File(croppedFile.path);
                                  });
                                }
                              }
                              final url = Uri.parse(
                                  BASE_URL.Url + API_END_POINTS.updateprofile);
                              final request =
                                  http.MultipartRequest('POST', url);

                              Map<String, String> headers = {
                                'Authorization': usertoken,
                                'Content-Type': 'multipart/form-data;',
                              };
                              request.headers.addAll(headers);
                              request.files.add(http.MultipartFile.fromBytes(
                                  "userprofile",
                                  await File(image!.path).readAsBytesSync(),
                                  contentType: new MediaType('image', 'jpeg'),
                                  filename: image!.path));
                              print("image path ${image!.path}");
                              final response = await request.send();
                              var responseBody =
                                  await response.stream.bytesToString();

                              final decodedMap = json.decode(responseBody);
                              print("===============${decodedMap}");
                              print('image ${decodedMap['image']}');
                              setState(() {
                                Datafetch();
                              });
                            },
                            child: Container(
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                  color: AppColor.DarkGrey.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Icon(Icons.camera_alt_outlined,
                                  color: AppColor.BgColor, size: 25),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 80,
                            color: AppColor.TextColor.withOpacity(0.5),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Get.back();
                              final pickedFile = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);

                              if (pickedFile != null) {
                                CroppedFile? croppedFile =
                                    await ImageCropper().cropImage(
                                  sourcePath: pickedFile.path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.square,
                                  ],
                                  uiSettings: [
                                    AndroidUiSettings(
                                        toolbarTitle: 'Cropper',
                                        hideBottomControls: true,
                                        backgroundColor: AppColor.BgColor,
                                        toolbarColor: AppColor.BgColor,
                                        toolbarWidgetColor: AppColor.BlackColor,
                                        initAspectRatio:
                                            CropAspectRatioPreset.square,
                                        lockAspectRatio: true),
                                  ],
                                );

                                if (croppedFile != null) {
                                  setState(() {
                                    image = File(croppedFile.path);
                                    print("image =======${image}");
                                  });
                                }
                              }
                              final url = Uri.parse(
                                  BASE_URL.Url + API_END_POINTS.updateprofile);
                              final request =
                                  http.MultipartRequest('POST', url);

                              Map<String, String> headers = {
                                'Authorization': usertoken,
                                'Content-Type': 'multipart/form-data;',
                              };
                              request.headers.addAll(headers);
                              request.files.add(http.MultipartFile.fromBytes(
                                  "userprofile",
                                  await File(image!.path).readAsBytesSync(),
                                  contentType: new MediaType('image', 'jpeg'),
                                  filename: image!.path));
                              print("image path ${image!.path}");
                              final response = await request.send();
                              var responseBody =
                                  await response.stream.bytesToString();

                              final decodedMap = json.decode(responseBody);
                              print("===============${decodedMap}");
                              // String imageurl = decodedMap['image'];
                              print('image ${decodedMap['image']}');
                              setState(() {
                                Datafetch();
                              });
                            },
                            child: Container(
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                  color: AppColor.DarkGrey.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Icon(Icons.image_outlined,
                                  color: AppColor.BgColor, size: 25),
                            ),
                          ),
                        ],
                      ),
                    ));
                  },
                  child: Icon(
                    Icons.camera_alt,
                    size: 15,
                  ),
                ),
                decoration: BoxDecoration(
                    color: AppColor.BgColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.SoftTextColor)),
              ),
            )
          ],
        ),
        CommonWidget().interText(
          text: isLoader ||
                  loadprofiledata!.introduction == null ||
                  loadprofiledata!.introduction == ""
              ? ""
              : loadprofiledata!.introduction.toString(),
          weight: FontWeight.w500,
          size: 16.0,
          color: AppColor.DarkGrey,
        )
      ],
    );
  }

  accountPart() {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              AppImage.appIcon + "user.png",
              height: 25,
            ),
            SizedBox(width: 10),
            CommonWidget().interText(
              text: "Account",
              weight: FontWeight.w500,
              size: 14.0,
              color: AppColor.BlackColor,
            ),
          ],
        ),
        Divider(
          color: AppColor.SoftTextColor,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () {
            Get.to(GeneralDetailPage());
          },
          leading: CommonWidget().interText(
              text: "General details",
              weight: FontWeight.w400,
              size: 14.0,
              color: AppColor.DarkGrey),
          trailing: Icon(Icons.arrow_forward_ios, size: 20),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () {
            Get.to(ProfessionalDetailPage());
          },
          leading: CommonWidget().interText(
              text: "Professional details",
              weight: FontWeight.w400,
              size: 14.0,
              color: AppColor.DarkGrey),
          trailing: Icon(Icons.arrow_forward_ios, size: 20),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () {
            Get.to(MadicalDetailPage());
          },
          leading: CommonWidget().interText(
              text: "Medical details",
              weight: FontWeight.w400,
              size: 14.0,
              color: AppColor.DarkGrey),
          trailing: Icon(Icons.arrow_forward_ios, size: 20),
        ),
        SizedBox(height: Get.height * 0.015),
        Row(
          children: [
            Image.asset(
              AppImage.appIcon + "notifications.png",
              color: AppColor.BlackColor,
              height: 25,
            ),
            SizedBox(width: 10),
            CommonWidget().interText(
              text: "Notifications",
              weight: FontWeight.w500,
              size: 14.0,
              color: AppColor.BlackColor,
            ),
          ],
        ),
        Divider(
          color: AppColor.SoftTextColor,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CommonWidget().interText(
              text: "Notifications",
              weight: FontWeight.w400,
              size: 14.0,
              color: AppColor.DarkGrey),
          trailing: Switch(
            value: swichvalue,
            activeColor: AppColor.BgColor,
            activeTrackColor: AppColor.ActiveBlueColor,
            onChanged: (value) {
              setState(() {
                swichvalue = value;
              });
            },
          ),
        ),
        SizedBox(height: Get.height * 0.015),
        Row(
          children: [
            Image.asset(
              AppImage.appIcon + "setting.png",
              color: AppColor.BlackColor,
              height: 25,
            ),
            SizedBox(width: 10),
            CommonWidget().interText(
              text: "General",
              weight: FontWeight.w500,
              size: 14.0,
              color: AppColor.BlackColor,
            ),
          ],
        ),
        Divider(
          color: AppColor.SoftTextColor,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CommonWidget().interText(
              text: "Available Session",
              weight: FontWeight.w400,
              size: 14.0,
              color: AppColor.DarkGrey),
          trailing: CommonWidget().interText(
              text: loadprofiledata!.sessions == null ||
                      loadprofiledata!.sessions == 0 ||
                      isLoader
                  ? ""
                  : loadprofiledata!.sessions.toString(),
              weight: FontWeight.w700,
              size: 16.0,
              color: AppColor.ActiveBlueColor),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () {
            Get.to(GiftFriendsScreen());
          },
          leading: CommonWidget().interText(
              text: "Gift a friend",
              weight: FontWeight.w400,
              size: 14.0,
              color: AppColor.DarkGrey),
          trailing: Icon(Icons.arrow_forward_ios, size: 20),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () {
            Get.to(UserAppoinmentScreen());
          },
          leading: CommonWidget().interText(
              text: "Your Appointments",
              weight: FontWeight.w400,
              size: 14.0,
              color: AppColor.DarkGrey),
          trailing: Icon(Icons.arrow_forward_ios, size: 20),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () {
            Get.to(UserPurchaseScreen());
          },
          leading: CommonWidget().interText(
              text: "Your Purchases",
              weight: FontWeight.w400,
              size: 14.0,
              color: AppColor.DarkGrey),
          trailing: Icon(Icons.arrow_forward_ios, size: 20),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CommonWidget().interText(
              text: "About us",
              weight: FontWeight.w400,
              size: 14.0,
              color: AppColor.DarkGrey),
          trailing: Icon(Icons.arrow_forward_ios, size: 20),
        ),
        ListTile(
          onTap: () {
            deleteaccountPopup();
          },
          contentPadding: EdgeInsets.zero,
          leading: CommonWidget().interText(
              text: "Delete Account",
              weight: FontWeight.w400,
              size: 14.0,
              color: Colors.red),
          trailing: Icon(Icons.arrow_forward_ios, size: 20),
        ),
        ListTile(
          onTap: () async {
            showExitPopup();
          },
          contentPadding: EdgeInsets.zero,
          leading: CommonWidget().interText(
              text: "Log Out",
              weight: FontWeight.w400,
              size: 14.0,
              color: AppColor.DarkGrey),
          trailing: Icon(Icons.arrow_forward_ios, size: 20),
        ),
      ],
    );
  }
}
