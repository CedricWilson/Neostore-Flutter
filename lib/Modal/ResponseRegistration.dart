class ResponseRegistration {
  int status;
  String message;
  String userMsg;

  ResponseRegistration({this.status, this.message, this.userMsg});

  ResponseRegistration.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userMsg = json['user_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['user_msg'] = this.userMsg;
    return data;
  }
}
