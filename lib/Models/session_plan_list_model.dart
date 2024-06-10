// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

class SessionPlanList {
  bool? res;
  String? msg;
  List<AllSessionPlanList>? allSessionPlanList;

  SessionPlanList({this.res, this.msg, this.allSessionPlanList});

  SessionPlanList.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    if (json['data'] != null) {
      allSessionPlanList = <AllSessionPlanList>[];
      json['data'].forEach((v) {
        allSessionPlanList!.add(new AllSessionPlanList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    data['msg'] = this.msg;
    if (this.allSessionPlanList != null) {
      data['data'] = this.allSessionPlanList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllSessionPlanList {
  int? id;
  String? image;
  String? name;
  String? prise;
  String? session;
  String? description;
  int? updatedAt;
  String? createdAt;

  AllSessionPlanList(
      {this.id,
      this.image,
      this.name,
      this.prise,
      this.session,
      this.description,
      this.updatedAt,
      this.createdAt});

  AllSessionPlanList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    prise = json['prise'];
    session = json['session'];
    description = json['description'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['prise'] = this.prise;
    data['session'] = this.session;
    data['description'] = this.description;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}
// ====== Buy Purchase Model =========

class SessionBuyModel {
  bool? res;
  String? msg;
  List<AllSessionBuyModel>? data;

  SessionBuyModel({this.res, this.msg, this.data});

  SessionBuyModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <AllSessionBuyModel>[];
      json['data'].forEach((v) {
        data!.add(new AllSessionBuyModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllSessionBuyModel {
  int? id;
  int? userid;
  int? planid;
  String? createdAt;
  String? image;
  String? name;
  String? price;
  String? session;
  String? description;

  AllSessionBuyModel(
      {this.id,
      this.userid,
      this.planid,
      this.createdAt,
      this.image,
      this.name,
      this.price,
      this.session,
      this.description});

  AllSessionBuyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    planid = json['planid'];
    createdAt = json['created_at'];
    image = json['image'];
    name = json['name'];
    price = json['price'];
    session = json['session'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['planid'] = this.planid;
    data['created_at'] = this.createdAt;
    data['image'] = this.image;
    data['name'] = this.name;
    data['price'] = this.price;
    data['session'] = this.session;
    data['description'] = this.description;
    return data;
  }
}

class RazorpayKeyModel {
  bool? res;
  String? msg;
  String? data;

  RazorpayKeyModel({this.res, this.msg, this.data});

  RazorpayKeyModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    data['msg'] = this.msg;
    data['data'] = this.data;
    return data;
  }
}
