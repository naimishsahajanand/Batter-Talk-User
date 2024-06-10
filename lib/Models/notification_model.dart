// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals, prefer_void_to_null, unnecessary_question_mark

class NotificationModel {
  bool? res;
  String? msg;
  List<AllNotificationData>? allnotificationdata;
  Pagination? pagination;

  NotificationModel(
      {this.res, this.msg, this.allnotificationdata, this.pagination});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    if (json['data'] != null) {
      allnotificationdata = <AllNotificationData>[];
      json['data'].forEach((v) {
        allnotificationdata!.add(new AllNotificationData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    data['msg'] = this.msg;
    if (this.allnotificationdata != null) {
      data['data'] = this.allnotificationdata!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class AllNotificationData {
  int? id;
  Null? doctorid;
  int? userid;
  String? message;
  String? title;
  String? type;
  String? updatedAt;
  String? createdAt;
  String? date;
  String? image;

  AllNotificationData(
      {this.id,
      this.doctorid,
      this.userid,
      this.message,
      this.title,
      this.type,
      this.updatedAt,
      this.createdAt,
      this.date,
      this.image});

  AllNotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorid = json['doctorid'];
    userid = json['userid'];
    message = json['message'];
    title = json['title'];
    type = json['type'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    date = json['date'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctorid'] = this.doctorid;
    data['userid'] = this.userid;
    data['message'] = this.message;
    data['title'] = this.title;
    data['type'] = this.type;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['date'] = this.date;
    data['image'] = this.image;
    return data;
  }
}

class Pagination {
  int? total;
  int? lastPage;
  int? prevPage;
  int? nextPage;
  int? perPage;
  int? currentPage;
  int? from;
  int? to;

  Pagination(
      {this.total,
      this.lastPage,
      this.prevPage,
      this.nextPage,
      this.perPage,
      this.currentPage,
      this.from,
      this.to});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    lastPage = json['lastPage'];
    prevPage = json['prevPage'];
    nextPage = json['nextPage'];
    perPage = json['perPage'];
    currentPage = json['currentPage'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['lastPage'] = this.lastPage;
    data['prevPage'] = this.prevPage;
    data['nextPage'] = this.nextPage;
    data['perPage'] = this.perPage;
    data['currentPage'] = this.currentPage;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}
