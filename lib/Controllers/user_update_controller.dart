// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:convert';

import 'package:batter_talk_user/Helpers/api_endpoints.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Models/profile_model.dart';
import 'package:batter_talk_user/Screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UpdateProfileController extends GetxController {
  profiledataApi(usertoken) async {
    final response = await http.get(
      Uri.parse(BASE_URL.Url + API_END_POINTS.userprofiledetail),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );
    if (response.statusCode == 200) {
      AllProfileData? allprofiledata =
          ProfileModel.fromJson(jsonDecode(response.body)).profiledata;

      print(response.body);
      print(allprofiledata);
      return allprofiledata;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  profiledeleteApi(usertoken, context) async {
    final response = await http.get(
      Uri.parse("http://128.199.25.99:3005/api/v1/user/delete-account"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );
    if (response.statusCode == 200) {
      CommonWidget().ToastCall(context, "Account Delete Sucessfully");
      Get.offAll(LoginScreen());
      print(response.body);
      return response;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }
}
