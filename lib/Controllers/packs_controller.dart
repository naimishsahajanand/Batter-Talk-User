// ignore_for_file: avoid_print, prefer_const_constructors, prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:convert';

import 'package:batter_talk_user/Helpers/api_endpoints.dart';
import 'package:batter_talk_user/Helpers/bottomnavbar.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Models/appoinment_model.dart';
import 'package:batter_talk_user/Models/community_model.dart';
import 'package:batter_talk_user/Models/notification_model.dart';
import 'package:batter_talk_user/Models/response_model.dart';
import 'package:batter_talk_user/Models/session_plan_list_model.dart';
import 'package:batter_talk_user/Models/solo_chat_model.dart';
import 'package:batter_talk_user/Screens/advance_success_page.dart';
import 'package:batter_talk_user/Screens/session_timer_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PacksController extends GetxController {
  String Keyname = "";

  sessionplanlistApi(usertoken) async {
    final response = await http.get(
      Uri.parse(BASE_URL.Url + API_END_POINTS.usersessionplanlist),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );
    if (response.statusCode == 200) {
      List<AllSessionPlanList>? allsessionlistdata =
          SessionPlanList.fromJson(jsonDecode(response.body))
              .allSessionPlanList;

      print(response.body);
      return allsessionlistdata;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  sessionbuyplanlistApi(usertoken) async {
    final response = await http.get(
      Uri.parse(BASE_URL.Url + API_END_POINTS.sessionBuyList),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );
    if (response.statusCode == 200) {
      List<AllSessionBuyModel>? allbuysessionlistdata =
          SessionBuyModel.fromJson(jsonDecode(response.body)).data;

      print(response.body);
      return allbuysessionlistdata;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  appoinmentdataApi(usertoken) async {
    final response = await http.get(
      Uri.parse(BASE_URL.Url + API_END_POINTS.appoinmentList),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );
    if (response.statusCode == 200) {
      List<AllAppoinmentData>? allappoinmentlistdata =
          AppoinmentModel.fromJson(jsonDecode(response.body)).allappoinmentdata;

      print(response.body);
      return allappoinmentlistdata;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  Future<http.Response> sessionBuy(context, planId, userToken) async {
    Map request = {
      "planiid": planId,
    };

    print(request);

    final response = await http.post(
      Uri.parse(BASE_URL.Url + API_END_POINTS.sessionBuy),
      body: jsonEncode(request),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken,
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

  Future<http.Response> instantbookappoinment(
      context, userToken, date, time, booktype, docid) async {
    Map request = {
      'type': booktype,
      'date': date,
      'time': time,
      'doctorid': docid,
    };

    print(request);

    final response = await http.post(
      Uri.parse(BASE_URL.Url + API_END_POINTS.booksession),
      body: jsonEncode(request),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken,
      },
    );
    if (response.statusCode == 200) {
      var success = ResponseModel.fromJson(jsonDecode(response.body));
      if (success.res == true) {
        print(response.body);
        CommonWidget().ToastCall(context, success.msg.toString());
        Get.to(SessionTimer());
      } else {
        print(response.body);
        CommonWidget().ToastCall(context, success.msg.toString());
      }
      return response;
    } else {
      throw Exception('No Data');
    }
  }

  Future<http.Response> advancebookappoinment(
      context, userToken, date, time, booktype, docid) async {
    Map request = {
      'type': booktype,
      'date': date,
      'time': time,
      'doctorid': docid,
    };

    print(request);

    final response = await http.post(
      Uri.parse(BASE_URL.Url + API_END_POINTS.booksession),
      body: jsonEncode(request),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken,
      },
    );
    if (response.statusCode == 200) {
      var success = ResponseModel.fromJson(jsonDecode(response.body));
      if (success.res == true) {
        print(response.body);
        CommonWidget().ToastCall(context, success.msg.toString());
        Get.to(AdvanceSuccessPage());
      } else {
        print(response.body);
        CommonWidget().ToastCall(context, success.msg.toString());
      }
      return response;
    } else {
      throw Exception('No Data');
    }
  }

  useracceptsessionApi(usertoken, id, context) async {
    final response = await http.get(
      Uri.parse(BASE_URL.Url + API_END_POINTS.useracceptsession + id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );
    if (response.statusCode == 200) {
      var success = JoinCommunityResponse.fromJson(jsonDecode(response.body));
      CommonWidget().ToastCall(context, success.msg.toString());

      print(response.body);
      return success;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  fetchUserSoloChatDataApi(usertoken, sessionid, page) async {
    final response = await http.get(
      Uri.parse(
          "http://128.199.25.99:3005/api/v1/user/session-chat/$sessionid?page=$page&perPage=100"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );
    if (response.statusCode == 200) {
      List<AllSoloChatModel>? allmessagedata =
          SoloChatModel.fromJson(jsonDecode(response.body)).allSoloChatModel;
      // print("AllChat${response.body}");
      return allmessagedata;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  cencelsessiontApi(usertoken, id, context) async {
    final url =
        Uri.encodeFull(BASE_URL.Url + API_END_POINTS.userleavesession + id);
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

      CommonWidget().ToastCall(context, dataresponse.toString());

      print("INNNNN :: ");
      // Get.offAll(BottomNavBar());

      print(response.body);
      return dataresponse;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  cencelappoinmentApi(id, usertoken, context) async {
    final url = Uri.encodeFull(
        "http://128.199.25.99:3005/api/v1/user/$id/cancel-appointment");
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

  generateRazorpayapiKey() async {
    final response = await http.get(
      Uri.parse("http://128.199.25.99:3005/api/v1/setting/key"),
    );
    if (response.statusCode == 200) {
      var key = RazorpayKeyModel.fromJson(jsonDecode(response.body)).data;

      print("========${key}");

      Keyname = key!;

      print("========name ${Keyname}");

      return response;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }

  Future<http.Response> addFeedback(
      context, userToken, docId, rate, feedback) async {
    Map request = {
      "doctorid": docId,
      "rate": rate,
      "feedback": feedback,
    };

    print(request);

    final response = await http.post(
      Uri.parse(BASE_URL.Url + API_END_POINTS.userfeedback),
      body: jsonEncode(request),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken,
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

  fetchDoctorAllnotificatiobApi(usertoken) async {
    final response = await http.get(
      Uri.parse(
          "http://128.199.25.99:3005/api/v1/user/notification?list?page=1&limit=100"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': usertoken,
      },
    );

    if (response.statusCode == 200) {
      List<AllNotificationData>? allnotifydata =
          NotificationModel.fromJson(jsonDecode(response.body))
              .allnotificationdata;
      print(response.body);
      return allnotifydata;
    } else {
      print(response.statusCode);
      throw Exception('Not Found');
    }
  }
}
