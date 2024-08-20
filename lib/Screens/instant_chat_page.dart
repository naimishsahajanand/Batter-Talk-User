// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, unused_field, prefer_final_fields, avoid_print, await_only_futures, library_prefixes, prefer_interpolation_to_compose_strings, sized_box_for_whitespace, non_constant_identifier_names, deprecated_member_use, unnecessary_new, unrelated_type_equality_checks, unnecessary_brace_in_string_interps

import 'package:batter_talk_user/Controllers/packs_controller.dart';
import 'package:batter_talk_user/Helpers/bottomnavbar.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/socket.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/appoinment_model.dart';
import 'package:batter_talk_user/Models/session_booked_model.dart';
import 'package:batter_talk_user/Models/solo_chat_model.dart';
import 'package:batter_talk_user/Screens/call_page.dart';
import 'package:batter_talk_user/Screens/calling_page.dart';
import 'package:batter_talk_user/Screens/one_call_page.dart';
import 'package:batter_talk_user/Screens/one_video_call_page.dart';
import 'package:batter_talk_user/Screens/videocall_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../Controllers/doctor_detail_controller.dart';

class InstantChatPage extends StatefulWidget {
  const InstantChatPage({super.key});

  @override
  State<InstantChatPage> createState() => _InstantChatPageState();
}

class _InstantChatPageState extends State<InstantChatPage> {
  PacksController _packsController = Get.put(PacksController());
  late IO.Socket socket;
  ServerStatus _serverStatus = ServerStatus.Conecting;
  TextEditingController _messagecontroller = TextEditingController();
  var data = SessionBookedModel().obs;
  List<AllAppoinmentData>? loaddata;
  List<AllSoloChatModel>? loadusermessage;
  String usertoken = "";
  String doctorId = "";
  String formatdate = "";
  bool isLoader = true;

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token") ?? "";
      doctorId = pref.getString("doctorID") ?? "";
      print(" Check=== ${doctorId}");
    });

    print("Check ONEe");
    if (Get.arguments == null) {
      print("Check 2");
      await CallSessionData_again();
      print("Check 3");
    } else {
      print("Check Else");
      data.value = Get.arguments;
      print("Check Elsess ${data.value.data!.id}");
    }
    print("Datas = =  Enter");
    DataFetch();
    connectToServer();
  }

  DataFetch() async {
    loadusermessage = await _packsController.fetchUserSoloChatDataApi(
        usertoken, data.value.data!.id.toString(), "1");
    print("Datas = =  fourth");
    loaddata = await _packsController.appoinmentdataApi(usertoken.toString());
    print("Datas = =  five");
    setState(() {
      isLoader = false;
    });
    print("Datas = =  six");
  }

  @override
  void initState() {
    getName();
    // data.value = Get.arguments;
    super.initState();
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit From Chat',
                style: GoogleFonts.inter(
                    color: AppColor.BlackColor, fontWeight: FontWeight.w600)),
            content: Text('Are You Sure Want To Exit From Chat',
                style: GoogleFonts.inter(
                    color: AppColor.BlackColor, fontWeight: FontWeight.w500)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No',
                    style: GoogleFonts.inter(
                        color: AppColor.DarkGrey, fontWeight: FontWeight.w400)),
              ),
              TextButton(
                onPressed: () async {
                  sessionleave();
                  // Navigator.of(context).pop(true);

                  await _packsController
                      .cencelsessiontApi(usertoken.toString(),
                          data.value.data!.id.toString(), context)
                      .then((e) => Get.offAll(BottomNavBar()));
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

  pageOff() {
    sessionleave();
    sendMessage();
    Future.delayed(
      Duration(seconds: 2),
      () {
        Get.offAll(BottomNavBar());
      },
    );
  }

  pageof() {
    sessionleave();
    // sendMessage();
    Future.delayed(
      Duration(microseconds: 100),
      () {
        Get.offAll(BottomNavBar());
      },
    );
  }

  void connectToServer() async {
    socket = await IO.io('http://128.199.25.99:3005', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
    });
    socket.emit('sessionroom', {
      'sessionId': data.value.data!.id,
    });
    await socket.connect();

    socket.onConnect((data) => {
          _serverStatus = ServerStatus.Online,
          print("Connected ======${socket.connected}"),
        });

    print("Connected ======${socket.connected}");
    socket.on("chatmessage", (data) {});
  }

  void sessionaccept() {
    socket.emit('sessionaccept', {
      "sessionId": data.value.data!.id,
      "senderId": data.value.data!.userid,
      "type": "user",
    });
  }

  void sessionleave() {
    socket.emit('sessionleave', {
      "sessionId": data.value.data!.id,
      "senderId": data.value.data!.userid,
      "type": "user",
    });
  }

  void sendMessage() {
    String message = _messagecontroller.text.trim();
    if (message.isNotEmpty) {
      socket.emit('sessionsendmessage', {
        "sessionId": data.value.data!.id,
        "senderId": data.value.data!.userid,
        "message": message,
        "type": "user",
        "messageType": "0",
      });
      _messagecontroller.clear();
    }
  }

  void onetooneAudioCall() {
    socket.emit('oneToOneCallConnecting', {
      "sessionId": data.value.data!.id,
      "senderId": data.value.data!.userid,
      "receiverId": data.value.data!.doctorid,
      "type": "user",
      "messageType": "2",
      "callType": "audiocall",
    });
    Get.to(OneCallPage());
  }

  void onetooneVideoCall() {
    socket.emit('oneToOneCallConnecting', {
      "sessionId": data.value.data!.id,
      "senderId": data.value.data!.userid,
      "receiverId": data.value.data!.doctorid,
      "type": "user",
      "messageType": "3",
      "callType": "videocall",
    });
    Get.to(OneVideoCallPage());
  }

  @override
  void dispose() {
    // Disconnect the socket to avoid memory leaks
    // socket.disconnect();
    // socket.close();

    // Dispose the message controller
    // _messagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("Datas = =  Build");
    DataFetch();

    return data.value.data == null
        ? Scaffold(
            body: Container(
              height: Get.height,
              width: Get.width,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : WillPopScope(
            onWillPop: () {
              if (data.value.data!.isAcceptDoctor == true &&
                  data.value.data!.isAcceptUser == false &&
                  data.value.data!.type == "Instant") {
                Navigator.of(context).pop(false);
              } else {
                showExitPopup();
              }
              return Future.delayed(Duration(microseconds: 10));
            },
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: AppColor.BlackColor,
                    statusBarIconBrightness: Brightness.light),
                centerTitle: false,
                titleSpacing: 0,
                iconTheme: IconThemeData(color: AppColor.SoftTextColor),
                backgroundColor: Colors.transparent,
                leading: IconButton(
                    onPressed: () {
                      data.value.data!.isAcceptDoctor == true &&
                              data.value.data!.isAcceptUser == false &&
                              data.value.data!.type == "Instant"
                          ? Navigator.of(context).pop(false)
                          : showExitPopup();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColor.BlackColor,
                    )),
                title: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: AppColor.BlackColor,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(data == null
                                  ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                  : data.value.data!.image == "" ||
                                          data.value.data!.image == null
                                      ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                      : data.value.data!.image.toString()),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonWidget().interText(
                            text: data.value.data!.introduction.toString(),
                            color: AppColor.DarkGrey,
                            weight: FontWeight.w700,
                            size: 16.0),
                        SizedBox(height: 2),
                        CommonWidget().interText(
                            text: data.value.data!.jobtitle.toString(),
                            color: AppColor.DarkGrey,
                            weight: FontWeight.w400,
                            size: 12.0),
                      ],
                    ),
                  ],
                ),
                actions: [
                  data.value.data!.isAcceptDoctor == true &&
                          data.value.data!.isAcceptUser == false &&
                          data.value.data!.type == "Instant"
                      ? SizedBox()
                      : GestureDetector(
                          onTap: onetooneVideoCall,
                          child: Image.asset(
                            AppImage.appIcon + "video.png",
                            width: 25,
                          ),
                        ),
                  SizedBox(width: 10),
                  data.value.data!.isAcceptDoctor == true &&
                          data.value.data!.isAcceptUser == false &&
                          data.value.data!.type == "Instant"
                      ? SizedBox()
                      : GestureDetector(
                          onTap: onetooneAudioCall,
                          child: Image.asset(
                            AppImage.appIcon + "call.png",
                            width: 25,
                          ),
                        ),
                  SizedBox(width: 10),
                  data.value.data!.isAcceptDoctor == true &&
                          data.value.data!.isAcceptUser == false &&
                          data.value.data!.type == "Instant"
                      ? SizedBox()
                      : GestureDetector(
                          onTap: showExitPopup,
                          child: Image.asset(
                            AppImage.appIcon + "leave.png",
                            width: 25,
                          ),
                        ),
                  SizedBox(width: 10),
                ],
              ),
              body: CommonWidget().mainContainer(
                  childwidget: Stack(
                children: [
                  Divider(
                    color: Color(0xffF5F8FA),
                    thickness: 4,
                  ),
                  Container(
                    height: Get.height,
                    child: isLoader
                        ? Center(child: CircularProgressIndicator())
                        : data.value.data!.isAcceptUser == false &&
                                data.value.data!.type == "Instant"
                            ? userAppoinmentWidget(context)
                            : loadusermessage!.isEmpty
                                ? waitingWidget()
                                : ListView.builder(
                                    itemCount: loadusermessage!.length,
                                    shrinkWrap: true,
                                    reverse: true,
                                    padding: EdgeInsets.only(bottom: 70),
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      DateTime parseDate =
                                          new DateFormat("yyyy-MM-dd HH:mm:ss")
                                              .parse(loadusermessage![index]
                                                  .createdAt
                                                  .toString());
                                      var inputDate =
                                          DateTime.parse(parseDate.toString());
                                      var outputFormat = DateFormat('hh:mm a');
                                      formatdate =
                                          outputFormat.format(inputDate);
                                      return loadusermessage![index].message ==
                                              "Doctor Leave From Chat"
                                          ? pageof()
                                          // pageOff()
                                          // ? Center(
                                          //     child: Text(
                                          //     loadusermessage![index]
                                          //         .message
                                          //         .toString(),
                                          //     style: TextStyle(
                                          //         fontSize: 14, color: Colors.grey),
                                          //   ))
                                          : Align(
                                              alignment: loadusermessage![index]
                                                          .senderId ==
                                                      data.value.data!.userid
                                                  ? Alignment.topRight
                                                  : Alignment.topLeft,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                margin: loadusermessage![index]
                                                            .senderId ==
                                                        data.value.data!.userid
                                                    ? EdgeInsets.only(
                                                        right: 15,
                                                        top: 5,
                                                        bottom: 5)
                                                    : EdgeInsets.only(
                                                        left: 15,
                                                        top: 5,
                                                        bottom: 5),
                                                width: Get.width * 0.75,
                                                decoration: BoxDecoration(
                                                    color: Color(0xffF3F3F3),
                                                    border: Border.all(
                                                        color: loadusermessage![index]
                                                                    .senderId ==
                                                                data.value.data!
                                                                    .userid
                                                            ? Color(0xffA0CFFF)
                                                            : AppColor
                                                                .BorderColor,
                                                        width: 1),
                                                    borderRadius: loadusermessage![index]
                                                                .senderId ==
                                                            data.value.data!
                                                                .userid
                                                        ? BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15),
                                                            topLeft:
                                                                Radius.circular(15),
                                                            bottomRight: Radius.circular(15))
                                                        : BorderRadius.only(bottomLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight: Radius.circular(15))),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CommonWidget().interText(
                                                            text: loadusermessage![index]
                                                                            .introduction ==
                                                                        "" ||
                                                                    loadusermessage![index]
                                                                            .introduction ==
                                                                        null
                                                                ? "Unknown"
                                                                : loadusermessage![
                                                                        index]
                                                                    .introduction,
                                                            color: Color(
                                                                0xff056AD0),
                                                            size: 13.0,
                                                            weight: FontWeight
                                                                .w500),
                                                        SizedBox(width: 5),
                                                        loadusermessage![index]
                                                                    .type ==
                                                                "doctor"
                                                            ? Image.asset(
                                                                AppImage.appIcon +
                                                                    "verified.png",
                                                                width: 15)
                                                            : SizedBox()
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              Get.width * 0.55,
                                                          child: CommonWidget().interText(
                                                              text: loadusermessage![
                                                                      index]
                                                                  .message
                                                                  .toString(),
                                                              maxline: 5,
                                                              color: AppColor
                                                                  .BlackColor,
                                                              size: 15.0,
                                                              weight: FontWeight
                                                                  .w500),
                                                        ),
                                                        CommonWidget().interText(
                                                            text: loadusermessage![index]
                                                                            .createdAt ==
                                                                        "" ||
                                                                    loadusermessage![index]
                                                                            .createdAt ==
                                                                        null
                                                                ? ""
                                                                : formatdate,
                                                            color: Color(
                                                                0xff7C7C7C),
                                                            size: 10.0,
                                                            align:
                                                                TextAlign.end,
                                                            weight: FontWeight
                                                                .w400),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                    }),
                  ),
                  data.value.data!.isAcceptUser == false &&
                          data.value.data!.type == "Instant"
                      ? SizedBox()
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 50,
                            width: Get.width,
                            margin: EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 10),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xffE5E9F0),
                                  Color(0xffF5F8FA)
                                ]),
                                border: Border.all(
                                    color: Color(0xffE5E9F0), width: 1),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 50,
                                    width: Get.width * 0.7,
                                    child: TextFormField(
                                      controller: _messagecontroller,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Write a message..."),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: sendMessage,
                                    child: Image.asset(
                                      AppImage.appIcon + "send.png",
                                      height: 22,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                ],
              )),
            ),
          );
  }

  Center doctorResponseWidget() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: Get.height * 0.05),
            child: Image.asset(
              AppImage.appIcon + "waiting.png",
              height: Get.height * 0.3,
            ),
          ),
          CommonWidget().interText(
              text: "Waiting For Doctor Response",
              color: AppColor.TextColor,
              weight: FontWeight.w500,
              size: 12.0),
        ],
      ),
    );
  }

  Center userAppoinmentWidget(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: Get.height * 0.05),
            child: Image.asset(
              AppImage.appIcon + "waiting.png",
              height: Get.height * 0.3,
            ),
          ),
          CommonWidget().interText(
              text: "You Doctor has arrived, Please start the session",
              color: AppColor.TextColor,
              weight: FontWeight.w500,
              size: 12.0),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              _packsController.useracceptsessionApi(usertoken.toString(),
                  data.value.data!.id.toString(), context);
              data.value.data!.isAcceptUser = true;
              sessionaccept();
              setState(() {
                isLoader = true;
                DataFetch();
              });
            },
            child: Container(
              height: 40,
              width: Get.width * 0.6,
              decoration: BoxDecoration(
                  color: AppColor.DarkGrey,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: CommonWidget().interText(
                    text: "Start Appointment",
                    color: AppColor.BgColor,
                    weight: FontWeight.w500,
                    size: 12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center waitingWidget() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: Get.height * 0.05),
            child: Image.asset(
              AppImage.appIcon + "waiting.png",
              height: Get.height * 0.3,
            ),
          ),
          CommonWidget().interText(
              text: "Waiting for the chat",
              color: AppColor.SoftTextColor,
              weight: FontWeight.w400,
              size: 14.0),
        ],
      ),
    );
  }

  DoctorDetailsController _doctorDetailsController =
      Get.put(DoctorDetailsController());

  CallSessionData_again() async {
    print("Check 4");
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token") ?? "";
      doctorId = pref.getString("doctorID") ?? "";
    });
    print("Check usertoken ${usertoken}");
    data.value =
        await _doctorDetailsController.sessionbookApi(usertoken, doctorId);
    print("Check 5");
    setState(
      () {},
    );
  }
}
