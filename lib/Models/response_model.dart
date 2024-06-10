// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class ResponseModel {
  bool? res;
  String? msg;

  ResponseModel({this.res, this.msg});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    data['msg'] = this.msg;

    return data;
  }
}

class OtpVerificationModel {
  bool? res;
  String? msg;
  Data? data;

  OtpVerificationModel({this.res, this.msg, this.data});

  OtpVerificationModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? ragisteruser;
  String? token;

  Data({this.ragisteruser, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    ragisteruser = json['ragisteruser'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ragisteruser'] = this.ragisteruser;
    data['token'] = this.token;
    return data;
  }
}
