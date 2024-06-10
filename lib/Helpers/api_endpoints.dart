// ignore_for_file: camel_case_types, non_constant_identifier_names

class BASE_URL {
  // static String Url = "http://192.168.29.135:3005/api/v1/";
  static String Url = "http://128.199.25.99:3005/";
  static String Imageurl = "http://128.199.25.99:3005//upload/";
}

class API_END_POINTS {
  static String register = "api/v1/user/register";
  static String gender = "api/v1/setting/genderlist";
  static String locationlist = "api/v1/setting/locationlist";
  static String qualificationlist = "api/v1/setting/qualificationslist";
  static String reviewlist = "api/v1/reviews/list";
  static String doctorlist = "api/v1/user/doctor/list";
  static String updateprofile = "api/v1/user/profile/updates";
  static String userprofiledetail = "api/v1/user/profile/details";
  static String usergeneraldetail = "api/v1/user/profile/generaldetails/update";
  static String userprofessionaldetail =
      "api/v1/user/profile/professionaldetails/update";
  static String usermedicaldetail = "api/v1/user/profile/medicaldetails/update";
  static String userfeedback = "api/v1/user/feedback";
  static String userdoctordetail = "api/v1/user/doctor/details/1";
  static String usersessionplanlist = "api/v1/user/sessionplan/list";
  static String userSendOTP = "api/v1/user/sendotp";
  static String otpverification = "api/v1/user/otp/verification";
  static String sessionBuy = "api/v1/user/sessionplan/buy";
  static String booksession = "api/v1/user/booksession";
  static String appoinmentList = "api/v1/user/book-session/list";
  static String allcommunity = "api/v1/user/community";
  static String joincommunitylist = "api/v1/user/join-community/list";
  static String joincommunity = "api/v1/user/community-join/";
  static String leavecommunity = "api/v1/user/leave-community/";
  static String addnickname = "api/v1/user/nickname";
  static String sessionBuyList = "api/v1/user/session-buy/list";
  static String useracceptsession = "api/v1/user/session-accept/";
  static String userleavesession = "api/v1/user/leave-session/";
}

class SocketApi {
  static String socketUrl = 'http://128.199.25.99:3005';
}
