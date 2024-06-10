// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, prefer_final_fields, unused_field, sized_box_for_whitespace, non_constant_identifier_names, avoid_print, unnecessary_brace_in_string_interps, await_only_futures, library_prefixes, unnecessary_new

import 'package:batter_talk_user/Controllers/community_controller.dart';
import 'package:batter_talk_user/Helpers/common_widget.dart';
import 'package:batter_talk_user/Helpers/socket.dart';
import 'package:batter_talk_user/Helpers/utility.dart';
import 'package:batter_talk_user/Models/community_model.dart';
import 'package:batter_talk_user/Models/user_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  CommunityController _communityController = Get.put(CommunityController());
  TextEditingController _messagecontroller = TextEditingController();
  ServerStatus _serverStatus = ServerStatus.Conecting;
  bool isLoader = true;
  var data = JoinCommunityData().obs;
  List<AllUserMessageModel>? loadusermessage;
  String usertoken = "";
  late IO.Socket socket;
  var formatdate = "";

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usertoken = pref.getString("token") ?? "";
    });
    DataFetch();
  }

  DataFetch() async {
    loadusermessage = await _communityController.fetchUserAllChatDataApi(
        usertoken, data.value.communityId.toString(), "1");
    setState(() {
      isLoader = false;
    });
  }

  @override
  void initState() {
    getName();
    data.value = Get.arguments;
    connectToServer();
    super.initState();
  }

  void connectToServer() async {
    print("Connected check ");
    print("Connected checkss ${data.value.communityId.toString()}");

    socket = await IO.io('http://128.199.25.99:3005', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
    });
    print("Connected check 1");
    socket.emit('joinRoom', {
      'communityId': data.value.communityId, // Room Id
    });
    await socket.connect();

    print("Connected check 2");
    socket.onConnect((data) => {
          _serverStatus = ServerStatus.Online,
          print("Connected ======${socket.connected}"),
        });
    print("Connected check 3");

    print("Connected ======${socket.connected}");
    socket.on("chatmessage", (data) {});
  }

  void sendMessage() {
    String message = _messagecontroller.text.trim();
    if (message.isNotEmpty) {
      socket.emit('sendmessage', {
        "communityId": data.value.communityId,
        "message": message,
        "senderId": data.value.userid,
        "type": "user"
      });
      _messagecontroller.clear();
    }
    setState(() {
      DataFetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    DataFetch();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColor.BlackColor,
            statusBarIconBrightness: Brightness.light),
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: AppColor.BlackColor),
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: AppColor.BlackColor,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(data.value.image.toString()))),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidget().interText(
                    text: data.value.name.toString(),
                    color: AppColor.DarkGrey,
                    weight: FontWeight.w600,
                    size: 15.0),
                SizedBox(height: 2),
                CommonWidget().interText(
                    text: "${data.value.memberCount.toString()} Members",
                    color: Color(0xff7C7C7C),
                    weight: FontWeight.w400,
                    size: 12.0),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                Get.defaultDialog(
                    barrierDismissible: false,
                    title: "Leave Community",
                    middleText: "Are You Sure For Exit Community?",
                    confirm: TextButton(
                        onPressed: () {
                          _communityController.leaveCommunityDataApi(
                              usertoken.toString(),
                              data.value.communityId.toString(),
                              context);
                        },
                        child: Text("Yes")),
                    cancel: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("No")));
              },
              child: Image.asset(
                AppImage.appIcon + "leave.png",
                width: 25,
              ),
            ),
          )
        ],
      ),
      backgroundColor: AppColor.BgColor,
      body: CommonWidget().mainContainer(
          childwidget: Stack(
        children: [
          Divider(
            color: Color(0xffF5F8FA),
            thickness: 4,
          ),
          Container(
            height: Get.height,
            child: isLoader || loadusermessage!.isEmpty
                ? Center(
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
                  )
                : ListView.builder(
                    itemCount: loadusermessage!.length,
                    shrinkWrap: true,
                    reverse: true,
                    padding: EdgeInsets.only(bottom: 70),
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
                          .parse(loadusermessage![index].createdAt.toString());
                      var inputDate = DateTime.parse(parseDate.toString());
                      var outputFormat = DateFormat('hh:mm a');
                      formatdate = outputFormat.format(inputDate);

                      return Align(
                        alignment: loadusermessage![index].senderId ==
                                data.value.userid
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          margin: loadusermessage![index].senderId ==
                                  data.value.userid
                              ? EdgeInsets.only(right: 15, top: 5, bottom: 5)
                              : EdgeInsets.only(left: 15, top: 5, bottom: 5),
                          width: Get.width * 0.75,
                          decoration: BoxDecoration(
                              color: Color(0xffF3F3F3),
                              border: Border.all(
                                  color: loadusermessage![index].senderId ==
                                          data.value.userid
                                      ? Color(0xffA0CFFF)
                                      : AppColor.BorderColor,
                                  width: 1),
                              borderRadius: loadusermessage![index].senderId ==
                                      data.value.userid
                                  ? BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))
                                  : BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CommonWidget().interText(
                                      text: loadusermessage![index].nickname ==
                                                  "" ||
                                              loadusermessage![index]
                                                      .nickname ==
                                                  null
                                          ? "Unknown"
                                          : loadusermessage![index].nickname,
                                      color: Color(0xff056AD0),
                                      size: 13.0,
                                      weight: FontWeight.w500),
                                  SizedBox(width: 5),
                                  loadusermessage![index].type == "doctor"
                                      ? Image.asset(
                                          AppImage.appIcon + "verified.png",
                                          width: 15)
                                      : SizedBox()
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.5,
                                    child: CommonWidget().interText(
                                        text: loadusermessage![index]
                                            .message
                                            .toString(),
                                        maxline: 50,
                                        color: AppColor.BlackColor,
                                        size: 15.0,
                                        weight: FontWeight.w500),
                                  ),
                                  CommonWidget().interText(
                                      text: loadusermessage![index].createdAt ==
                                                  "" ||
                                              loadusermessage![index]
                                                      .createdAt ==
                                                  null
                                          ? ""
                                          : formatdate,
                                      color: Color(0xff7C7C7C),
                                      size: 10.0,
                                      align: TextAlign.end,
                                      weight: FontWeight.w400),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              width: Get.width,
              margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffE5E9F0), Color(0xffF5F8FA)]),
                  border: Border.all(color: Color(0xffE5E9F0), width: 1),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    );
  }
}
