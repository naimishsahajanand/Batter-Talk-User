// ignore_for_file: unnecessary_this, prefer_void_to_null, unnecessary_question_mark, unnecessary_new, prefer_collection_literals

class UserMessageModel {
  bool? res;
  String? msg;
  List<AllUserMessageModel>? data;
  Pagination? pagination;

  UserMessageModel({this.res, this.msg, this.data, this.pagination});

  UserMessageModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <AllUserMessageModel>[];
      json['data'].forEach((v) {
        data!.add(new AllUserMessageModel.fromJson(v));
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class AllUserMessageModel {
  int? id;
  int? communityId;
  int? senderId;
  String? message;
  String? type;
  String? createdAt;
  String? nickname;
  String? image;

  AllUserMessageModel(
      {this.id,
      this.communityId,
      this.senderId,
      this.message,
      this.type,
      this.createdAt,
      this.nickname,
      this.image});

  AllUserMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    communityId = json['communityId'];
    senderId = json['senderId'];
    message = json['message'];
    type = json['type'];
    createdAt = json['created_at'];
    nickname = json['nickname'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['communityId'] = this.communityId;
    data['senderId'] = this.senderId;
    data['message'] = this.message;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['nickname'] = this.nickname;
    data['image'] = this.image;
    return data;
  }
}

class Pagination {
  int? total;
  int? lastPage;
  Null? prevPage;
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
