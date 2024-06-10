// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class LocationData {
  bool? res;
  String? msg;
  List<String>? alllocationdata;

  LocationData({this.res, this.msg, this.alllocationdata});

  LocationData.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    alllocationdata = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    data['msg'] = this.msg;
    data['data'] = this.alllocationdata;
    return data;
  }
}
