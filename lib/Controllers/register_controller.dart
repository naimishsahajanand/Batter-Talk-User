// ignore_for_file: avoid_print, non_constant_identifier_names, prefer_const_constructors, unused_local_variable

import 'dart:convert';

import 'package:batter_talk_user/Helpers/api_endpoints.dart';
import 'package:batter_talk_user/Helpers/bottomnavbar.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/preferances.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/gender_model.dart';
import 'package:batter_talk_user/Models/location_model.dart';
import 'package:batter_talk_user/Models/response_model.dart';
import 'package:batter_talk_user/Models/review_model.dart';
import 'package:batter_talk_user/Screens/Intros/intropage_1.dart';
import 'package:batter_talk_user/Screens/Intros/intropage_3.dart';
import 'package:batter_talk_user/Screens/Intros/intropage_4.dart';
import 'package:batter_talk_user/Screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  final phonenumbercontroller = TextEditingController();
  final otpcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final agecontroller = TextEditingController();
  var UserId = "";

  String genderdropdownValue = genderlist.first;
  String dropdownValue = locationlist.first;
  String prodropdownValue = proffesionlist.first;
  final issuecontroller = TextEditingController();

  Future<http.Response> userSignup(context, usertoken) async {
    Map request = {
      "phonenumber": phonenumbercontroller.text.trim(),
      "introduction": namecontroller.text.trim(),
      "gender": genderdropdownValue,
      "location": dropdownValue,
      "profession": prodropdownValue,
      "medicalissues": issuecontroller.text.trim(),
      "age": agecontroller.text.trim(),
    };

    print(request);

    final response = await http.post(
      Uri.parse(BASE_URL.Url + API_END_POINTS.register),
      body: jsonEncode(request),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );
    if (response.statusCode == 200) {
      var success = ResponseModel.fromJson(jsonDecode(response.body));
      if (success.res == true) {
        print(response.body);
        Preference.preference.saveBool(PrefernceKey.isUserLogin, true);
        Preference.preference.saveString("medicalissue", issuecontroller.text);

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) {
            return BottomNavBar();
          },
        ));
      } else {
        print(response.body);
        CommonWidget().ToastCall(context, success.msg.toString());
      }
      return response;
    } else {
      print(response.statusCode);
      throw Exception('No Data');
    }
  }

  Future<http.Response> userId(context, usertoken, id) async {
    Map request = {
      "playerId": id,
    };

    print(request);

    final response = await http.post(
      Uri.parse("http://128.199.25.99:3005/api/v1/user/player-id"),
      body: jsonEncode(request),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );
    if (response.statusCode == 200) {
      var success = ResponseModel.fromJson(jsonDecode(response.body));
      if (success.res == true) {
        print(response.body);
      } else {
        print(response.body);
      }
      return response;
    } else {
      print(response.statusCode);
      throw Exception('No Data');
    }
  }

  genderdataApi() async {
    final response =
        await http.get(Uri.parse(BASE_URL.Url + API_END_POINTS.gender));
    if (response.statusCode == 200) {
      List<String>? allgenderdata =
          GenderData.fromJson(jsonDecode(response.body)).genderdata;

      print(response.body);
      print(allgenderdata);
      return allgenderdata;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  locationdataApi() async {
    final response =
        await http.get(Uri.parse(BASE_URL.Url + API_END_POINTS.locationlist));
    if (response.statusCode == 200) {
      List<String>? alllocatedata =
          LocationData.fromJson(jsonDecode(response.body)).alllocationdata;

      print(response.body);
      print(alllocatedata);
      return alllocatedata;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  reviewdataApi() async {
    final response =
        await http.get(Uri.parse(BASE_URL.Url + API_END_POINTS.reviewlist));
    if (response.statusCode == 200) {
      List<AllReviewData>? allreviewdata =
          ReviewData.fromJson(jsonDecode(response.body)).allreviewData;

      print(response.body);
      return allreviewdata;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  Future<http.Response> SendOTP(context, number) async {
    Map request = {
      "phonenumber": number,
    };

    print(request);

    final response = await http.post(
      Uri.parse(BASE_URL.Url + API_END_POINTS.userSendOTP),
      body: jsonEncode(request),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var success = ResponseModel.fromJson(jsonDecode(response.body));
      if (success.res == true) {
        print(response.body);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) {
            return OtpScreen();
          },
        ));
      } else {
        print(response.body);
        CommonWidget().ToastCall(context, success.msg.toString());
      }
      return response;
    } else {
      throw Exception('No Data');
    }
  }

  Future<http.Response> resendSendOTP(context, number) async {
    Map request = {
      "phonenumber": number,
    };

    print(request);

    final response = await http.post(
      Uri.parse(BASE_URL.Url + API_END_POINTS.userSendOTP),
      body: jsonEncode(request),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var success = ResponseModel.fromJson(jsonDecode(response.body));
      if (success.res == true) {
        print(response.body);
        CommonWidget().ToastCall(context, success.msg.toString());
      } else {
        print(response.body);
        CommonWidget().ToastCall(context, success.msg.toString());
      }
      return response;
    } else {
      throw Exception('No Data');
    }
  }

  Future<http.Response> OtpVerification(context, number) async {
    Map request = {
      "phonenumber": number,
      "otp": otpcontroller.text,
    };

    print(request);

    final response = await http.post(
      Uri.parse(BASE_URL.Url + API_END_POINTS.otpverification),
      body: jsonEncode(request),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var success = OtpVerificationModel.fromJson(jsonDecode(response.body));
      var savetoken =
          OtpVerificationModel.fromJson(jsonDecode(response.body)).data;
      if (success.res == true) {
        print(response.body);

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("token", savetoken!.token.toString());

        if (savetoken.ragisteruser == false) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return IntroPage1();
            },
          ));
        } else {
          Preference.preference.saveBool(PrefernceKey.isUserLogin, true);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return BottomNavBar();
            },
          ));
        }
      } else {
        print(response.body);
        CommonWidget().ToastCall(context, success.msg.toString());
      }
      return response;
    } else {
      throw Exception('No Data');
    }
  }
}
