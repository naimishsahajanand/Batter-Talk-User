// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

class GenderData {
  bool? res;
  String? msg;
  List<String>? genderdata;

  GenderData({this.res, this.msg, this.genderdata});

  GenderData.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    genderdata = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    data['msg'] = this.msg;
    data['data'] = this.genderdata;
    return data;
  }
}
