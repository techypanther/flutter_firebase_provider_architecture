class Message {
  String name;
  String message;
  String profilePic;
  int createdAt;

  Message({this.name, this.message, this.profilePic, this.createdAt});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        name: json['name'],
        message: json['message'],
        profilePic: json['profile_pic'],
        createdAt: json['createdAt']);
  }
}
