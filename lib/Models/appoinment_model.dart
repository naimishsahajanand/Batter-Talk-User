// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

class AppoinmentModel {
  bool? res;
  String? msg;
  List<AllAppoinmentData>? allappoinmentdata;

  AppoinmentModel({this.res, this.msg, this.allappoinmentdata});

  AppoinmentModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    if (json['data'] != null) {
      allappoinmentdata = <AllAppoinmentData>[];
      json['data'].forEach((v) {
        allappoinmentdata!.add(new AllAppoinmentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    data['msg'] = this.msg;
    if (this.allappoinmentdata != null) {
      data['data'] = this.allappoinmentdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllAppoinmentData {
  int? id;
  int? userid;
  int? doctorid;
  String? type;
  int? date;
  String? createdAt;
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

  AllAppoinmentData(
      {this.id,
      this.userid,
      this.doctorid,
      this.type,
      this.date,
      this.createdAt,
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

  AllAppoinmentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    doctorid = json['doctorid'];
    type = json['type'];
    date = json['date'];
    createdAt = json['created_at'];
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
    data['date'] = this.date;
    data['created_at'] = this.createdAt;
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
