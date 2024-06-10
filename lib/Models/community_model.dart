// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

// Response Model

class JoinCommunityResponse {
  bool? res;
  String? msg;

  JoinCommunityResponse({this.res, this.msg});

  JoinCommunityResponse.fromJson(Map<String, dynamic> json) {
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

// All Community List
class AllCommunity {
  bool? res;
  String? msg;
  List<AllCommunityData>? data;

  AllCommunity({this.res, this.msg, this.data});

  AllCommunity.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <AllCommunityData>[];
      json['data'].forEach((v) {
        data!.add(new AllCommunityData.fromJson(v));
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

class AllCommunityData {
  int? id;
  String? image;
  String? name;
  String? aboutUs;
  String? createdAt;
  int? memberCount;

  AllCommunityData(
      {this.id,
      this.image,
      this.name,
      this.aboutUs,
      this.createdAt,
      this.memberCount});

  AllCommunityData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    aboutUs = json['aboutUs'];
    createdAt = json['created_at'];
    memberCount = json['memberCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['aboutUs'] = this.aboutUs;
    data['created_at'] = this.createdAt;
    data['memberCount'] = this.memberCount;
    return data;
  }
}

// Join Community List

class JoinCommunity {
  bool? res;
  String? msg;
  List<JoinCommunityData>? data;

  JoinCommunity({this.res, this.msg, this.data});

  JoinCommunity.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <JoinCommunityData>[];
      json['data'].forEach((v) {
        data!.add(new JoinCommunityData.fromJson(v));
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

class JoinCommunityData {
  int? id;
  int? communityId;
  int? userid;
  String? createdAt;
  String? name;
  String? image;
  String? aboutUs;
  int? memberCount;

  JoinCommunityData(
      {this.id,
      this.communityId,
      this.userid,
      this.createdAt,
      this.name,
      this.image,
      this.aboutUs,
      this.memberCount});

  JoinCommunityData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    communityId = json['communityId'];
    userid = json['userid'];
    createdAt = json['created_at'];
    name = json['name'];
    image = json['image'];
    aboutUs = json['aboutUs'];
    memberCount = json['memberCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['communityId'] = this.communityId;
    data['userid'] = this.userid;
    data['created_at'] = this.createdAt;
    data['name'] = this.name;
    data['image'] = this.image;
    data['aboutUs'] = this.aboutUs;
    data['memberCount'] = this.memberCount;
    return data;
  }
}
