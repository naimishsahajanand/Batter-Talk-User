// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals, prefer_void_to_null, unnecessary_question_mark

class DoctorData {
  bool? res;
  String? msg;
  List<AllDoctorData>? alldoctordata;

  DoctorData({this.res, this.msg, this.alldoctordata});

  DoctorData.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    if (json['data'] != null) {
      alldoctordata = <AllDoctorData>[];
      json['data'].forEach((v) {
        alldoctordata!.add(new AllDoctorData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    data['msg'] = this.msg;
    if (this.alldoctordata != null) {
      data['data'] = this.alldoctordata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllDoctorData {
  int? id;
  String? phonenumber;
  String? otp;
  String? introduction;
  String? age;
  String? gender;
  String? about;
  String? jobtitle;
  String? experience;
  String? patientcount;
  String? qualifications;
  String? describe;
  int? updatedAt;
  String? createdAt;
  String? image;
  String? status;
  String? email;
  String? nickname;
  String? playerId;
  Null? rate;
  int? ratecount;

  AllDoctorData(
      {this.id,
      this.phonenumber,
      this.otp,
      this.introduction,
      this.age,
      this.gender,
      this.about,
      this.jobtitle,
      this.experience,
      this.patientcount,
      this.qualifications,
      this.describe,
      this.updatedAt,
      this.createdAt,
      this.image,
      this.status,
      this.email,
      this.nickname,
      this.playerId,
      this.rate,
      this.ratecount});

  AllDoctorData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phonenumber = json['phonenumber'];
    otp = json['otp'];
    introduction = json['introduction'];
    age = json['age'];
    gender = json['gender'];
    about = json['about'];
    jobtitle = json['jobtitle'];
    experience = json['experience'];
    patientcount = json['patientcount'];
    qualifications = json['qualifications'];
    describe = json['describe'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    image = json['image'];
    status = json['status'];
    email = json['email'];
    nickname = json['nickname'];
    playerId = json['playerId'];
    rate = json['rate'];
    ratecount = json['ratecount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phonenumber'] = this.phonenumber;
    data['otp'] = this.otp;
    data['introduction'] = this.introduction;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['about'] = this.about;
    data['jobtitle'] = this.jobtitle;
    data['experience'] = this.experience;
    data['patientcount'] = this.patientcount;
    data['qualifications'] = this.qualifications;
    data['describe'] = this.describe;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['image'] = this.image;
    data['status'] = this.status;
    data['email'] = this.email;
    data['nickname'] = this.nickname;
    data['playerId'] = this.playerId;
    data['rate'] = this.rate;
    data['ratecount'] = this.ratecount;
    return data;
  }
}
