// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

class SessionBookedModel {
  bool? res;
  String? msg;
  bool? isBooked;
  AllSessionBookedModel? data;

  SessionBookedModel({this.res, this.msg, this.isBooked, this.data});

  SessionBookedModel.fromJson(Map<String, dynamic> json) {
    print(" SP Json  : ${json['data']}");
    res = json['res'];
    msg = json['msg'];
    isBooked = json['isBooked'];
    data = json['data'] != null
        ? new AllSessionBookedModel.fromJson(json['data'] ?? "")
        : null;
    // data = AllSessionBookedModel.fromJson(json['data'] ?? null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    data['msg'] = this.msg;
    data['isBooked'] = this.isBooked;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AllSessionBookedModel {
  int? id;
  int? userid;
  int? doctorid;
  String? type;
  String? bookingDate;
  String? startTime;
  String? endTime;
  String? connectStartTime;
  String? connectEndTime;
  bool? isAcceptDoctor;
  bool? isAcceptUser;
  String? phonenumber;
  String? introduction;
  String? age;
  String? gender;
  String? about;
  String? jobtitle;
  String? experience;
  String? patientcount;
  String? qualifications;
  String? image;
  String? status;
  String? email;

  AllSessionBookedModel(
      {this.id,
      this.userid,
      this.doctorid,
      this.type,
      this.bookingDate,
      this.startTime,
      this.endTime,
      this.connectStartTime,
      this.connectEndTime,
      this.isAcceptDoctor,
      this.isAcceptUser,
      this.phonenumber,
      this.introduction,
      this.age,
      this.gender,
      this.about,
      this.jobtitle,
      this.experience,
      this.patientcount,
      this.qualifications,
      this.image,
      this.status,
      this.email});

  AllSessionBookedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    doctorid = json['doctorid'];
    type = json['type'];
    bookingDate = json['bookingDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    connectStartTime = json['connectStartTime'];
    connectEndTime = json['connectEndTime'];
    isAcceptDoctor = json['isAcceptDoctor'];
    isAcceptUser = json['isAcceptUser'];
    phonenumber = json['phonenumber'];
    introduction = json['introduction'];
    age = json['age'];
    gender = json['gender'];
    about = json['about'];
    jobtitle = json['jobtitle'];
    experience = json['experience'];
    patientcount = json['patientcount'];
    qualifications = json['qualifications'];
    image = json['image'];
    status = json['status'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['doctorid'] = this.doctorid;
    data['type'] = this.type;
    data['bookingDate'] = this.bookingDate;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['connectStartTime'] = this.connectStartTime;
    data['connectEndTime'] = this.connectEndTime;
    data['isAcceptDoctor'] = this.isAcceptDoctor;
    data['isAcceptUser'] = this.isAcceptUser;
    data['phonenumber'] = this.phonenumber;
    data['introduction'] = this.introduction;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['about'] = this.about;
    data['jobtitle'] = this.jobtitle;
    data['experience'] = this.experience;
    data['patientcount'] = this.patientcount;
    data['qualifications'] = this.qualifications;
    data['image'] = this.image;
    data['status'] = this.status;
    data['email'] = this.email;
    return data;
  }
}
