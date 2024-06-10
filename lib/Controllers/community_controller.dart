// ignore_for_file: avoid_print, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings, depend_on_referenced_packages

import 'dart:convert';
import 'package:batter_talk_user/Helpers/api_endpoints.dart';
import 'package:batter_talk_user/Helpers/bottomnavbar.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Models/community_model.dart';
import 'package:batter_talk_user/Models/profile_model.dart';
import 'package:batter_talk_user/Models/user_message_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CommunityController extends GetxController {
  fetchCommunityDataApi(usertoken) async {
    final response = await http.get(
      Uri.parse(BASE_URL.Url + API_END_POINTS.allcommunity),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );

    if (response.statusCode == 200) {
      List<AllCommunityData>? allcommunitydata =
          AllCommunity.fromJson(jsonDecode(response.body)).data;

      print(response.body);
      return allcommunitydata;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  fetchjoinCommunityDataApi(usertoken) async {
    final response = await http.get(
      Uri.parse(BASE_URL.Url + API_END_POINTS.joincommunitylist),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );

    if (response.statusCode == 200) {
      List<JoinCommunityData>? allcommunitydata =
          JoinCommunity.fromJson(jsonDecode(response.body)).data;

      print(response.body);
      return allcommunitydata;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  joinCommunityDataApi(usertoken, id, context) async {
    final url =
        Uri.encodeFull(BASE_URL.Url + API_END_POINTS.joincommunity + id);
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );
    print(url);
    if (response.statusCode == 200) {
      var dataresponse =
          JoinCommunityResponse.fromJson(jsonDecode(response.body)).msg;

      print(response.body);
      return dataresponse;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  leaveCommunityDataApi(usertoken, id, context) async {
    final url =
        Uri.encodeFull(BASE_URL.Url + API_END_POINTS.leavecommunity + id);
    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );
    print(url);
    if (response.statusCode == 200) {
      var dataresponse =
          JoinCommunityResponse.fromJson(jsonDecode(response.body)).msg;

      CommonWidget().ToastCall(context, dataresponse.toString());
      Get.offAll(BottomNavBar());

      print(response.body);
      return dataresponse;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  Future<http.Response> addnickname(context, nickname, userToken) async {
    Map request = {
      "nickname": nickname,
    };

    print(request);

    final response = await http.post(
      Uri.parse(BASE_URL.Url + API_END_POINTS.addnickname),
      body: jsonEncode(request),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken,
      },
    );
    if (response.statusCode == 200) {
      var success = ProfileModel.fromJson(jsonDecode(response.body));
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

  fetchUserAllChatDataApi(usertoken, communityId, page) async {
    final response = await http.get(
      Uri.parse(
          "http://128.199.25.99:3005/api/v1/user/messages/$communityId?page=$page&perPage=500"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );

    if (response.statusCode == 200) {
      List<AllUserMessageModel>? allmessagedata =
          UserMessageModel.fromJson(jsonDecode(response.body)).data;
      print(response.body);
      return allmessagedata;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }
}
