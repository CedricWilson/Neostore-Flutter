class ResponseOrder {
  int status;
  List<Data> data;
  String message;
  String userMsg;

  ResponseOrder({this.status, this.data, this.message, this.userMsg});

  ResponseOrder.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    userMsg = json['user_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['user_msg'] = this.userMsg;
    return data;
  }
}

class Data {
  int id;
  int cost;
  String created;

  Data({this.id, this.cost, this.created});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cost = json['cost'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cost'] = this.cost;
    data['created'] = this.created;
    return data;
  }
}
