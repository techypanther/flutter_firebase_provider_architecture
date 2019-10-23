import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_provider_architecture/firebase/firebase_database_util.dart';
import 'package:flutter_provider_architecture/model/chat.dart';
import 'package:flutter_provider_architecture/model/user.dart';
import 'package:flutter_provider_architecture/model/user_pref.dart';
import 'package:flutter_provider_architecture/provider_architecture/repository/api/ErrorResponse.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_model.dart';

class HomeViewModel extends BaseModel implements ErrorResponse {
  List<Chat> chatList = [];
  User user;

  init() async {
    this.user = await UserPreferences().getUser();
    fetchChatList();
  }

  @override
  void serverMessage(String message, bool isError) {
    showMessage(message, isError);
    setState(ViewState.Idle);
  }

  void fetchChatList() async {
    chatList.clear();
    QuerySnapshot snapshot = await FirebaseDatabaseUtil().chat.getDocuments();
    if (snapshot.documents != null && snapshot.documents.isNotEmpty) {
      List<Chat> list = [];
      snapshot.documents.forEach((data) {
        list.add(Chat.fromJson(data.data));
      });
      chatList.addAll(list);
    }
  }
}
