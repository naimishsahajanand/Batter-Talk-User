// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

class ReviewData {
  bool? res;
  String? msg;
  List<AllReviewData>? allreviewData;

  ReviewData({this.res, this.msg, this.allreviewData});

  ReviewData.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    if (json['data'] != null) {
      allreviewData = <AllReviewData>[];
      json['data'].forEach((v) {
        allreviewData!.add(new AllReviewData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    data['msg'] = this.msg;
    if (this.allreviewData != null) {
      data['data'] = this.allreviewData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllReviewData {
  int? id;
  String? name;
  String? image;
  int? rating;
  String? review;
  int? updatedAt;
  int? createdAt;

  AllReviewData(
      {this.id,
      this.name,
      this.image,
      this.rating,
      this.review,
      this.updatedAt,
      this.createdAt});

  AllReviewData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    rating = json['rating'];
    review = json['review'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}
