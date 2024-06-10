// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:batter_talk_user/Helpers/api_endpoints.dart';
import 'package:batter_talk_user/Models/doctor_data_model.dart';
import 'package:batter_talk_user/Models/session_booked_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DoctorDetailsController extends GetxController {
  doctordataApi(usertoken) async {
    final response = await http.get(
      Uri.parse(BASE_URL.Url + API_END_POINTS.doctorlist),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );
    if (response.statusCode == 200) {
      List<AllDoctorData>? alldoctorlistdata =
          DoctorData.fromJson(jsonDecode(response.body)).alldoctordata;

      print(response.body);
      return alldoctorlistdata;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  sessionbookApi(usertoken, id) async {
    final response = await http.get(
      Uri.parse(
          "http://128.199.25.99:3005/api/v1/user/already-session/check/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );
    if (response.statusCode == 200) {
      SessionBookedModel sessionbookeddata =
          SessionBookedModel.fromJson(jsonDecode(response.body));

      print(response.body);
      return sessionbookeddata;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }
}
