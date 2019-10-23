class Chat {
  String title;
  String createdAt;
  String groupPic;
  String id;

  Chat({this.id, this.title, this.createdAt, this.groupPic});

  factory Chat.fromJson(dynamic json) {
    return Chat(
      id: json['id'],
      title: json['title'],
      createdAt: json['createdAt'],
      groupPic: json['group_pic'],
    );
  }
}
