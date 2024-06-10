// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this, prefer_void_to_null, unnecessary_question_mark

class SoloChatModel {
  bool? res;
  String? msg;
  List<AllSoloChatModel>? allSoloChatModel;
  Pagination? pagination;

  SoloChatModel({this.res, this.msg, this.allSoloChatModel, this.pagination});

  SoloChatModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    if (json['data'] != null) {
      allSoloChatModel = <AllSoloChatModel>[];
      json['data'].forEach((v) {
        allSoloChatModel!.add(new AllSoloChatModel.fromJson(v));
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
    if (this.allSoloChatModel != null) {
      data['data'] = this.allSoloChatModel!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class AllSoloChatModel {
  int? id;
  int? sessionId;
  int? senderId;
  String? message;
  String? messageType;
  String? type;
  String? createdAt;
  String? nickname;
  String? image;
  String? introduction;

  AllSoloChatModel({
    this.id,
    this.sessionId,
    this.senderId,
    this.message,
    this.messageType,
    this.type,
    this.createdAt,
    this.nickname,
    this.image,
    this.introduction,
  });

  AllSoloChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sessionId = json['sessionId'];
    senderId = json['senderId'];
    message = json['message'];
    messageType = json['messageType'];
    type = json['type'];
    createdAt = json['created_at'];
    nickname = json['nickname'];
    image = json['image'];
    introduction = json['introduction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sessionId'] = this.sessionId;
    data['senderId'] = this.senderId;
    data['message'] = this.message;
    data['messageType'] = this.messageType;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['nickname'] = this.nickname;
    data['image'] = this.image;
    data['introduction'] = this.introduction;
    return data;
  }
}

class Pagination {
  int? total;
  int? lastPage;
  Null? prevPage;
  Null? nextPage;
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
