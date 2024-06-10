// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

class ProfileModel {
  bool? res;
  String? msg;
  AllProfileData? profiledata;

  ProfileModel({this.res, this.msg, this.profiledata});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    profiledata =
        json['data'] != null ? new AllProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    data['msg'] = this.msg;
    if (this.profiledata != null) {
      data['data'] = this.profiledata!.toJson();
    }
    return data;
  }
}

class AllProfileData {
  int? id;
  String? phonenumber;
  String? otp;
  String? introduction;
  String? age;
  String? gender;
  String? location;
  String? professtion;
  String? medicalissues;
  int? updatedAt;
  String? createdAt;
  String? image;
  String? email;
  int? sessions;
  String? nickname;

  AllProfileData(
      {this.id,
      this.phonenumber,
      this.otp,
      this.introduction,
      this.age,
      this.gender,
      this.location,
      this.professtion,
      this.medicalissues,
      this.updatedAt,
      this.createdAt,
      this.image,
      this.email,
      this.sessions,
      this.nickname});

  AllProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phonenumber = json['phonenumber'];
    otp = json['otp'];
    introduction = json['introduction'];
    age = json['age'];
    gender = json['gender'];
    location = json['location'];
    professtion = json['professtion'];
    medicalissues = json['medicalissues'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    image = json['image'];
    email = json['email'];
    sessions = json['sessions'];
    nickname = json['nickname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phonenumber'] = this.phonenumber;
    data['otp'] = this.otp;
    data['introduction'] = this.introduction;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['location'] = this.location;
    data['professtion'] = this.professtion;
    data['medicalissues'] = this.medicalissues;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['image'] = this.image;
    data['email'] = this.email;
    data['sessions'] = this.sessions;
    data['nickname'] = this.nickname;
    return data;
  }
}
