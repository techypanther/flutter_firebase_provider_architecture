import 'package:flutter_provider_architecture/firebase/firebase_database_util.dart';
import 'package:flutter_provider_architecture/model/chat.dart';

final fireStore = FirebaseDatabaseUtil().firestore;
const String apiKey = 'AIzaSyD7sdGfPA9SMApxOHSnTa7zhBzB04QgrDQ';
const String mapApiKey = 'AIzaSyB_b4l2VUslYiSYg6C4W4KvOm0a-bNUM6M';
const String baseUrl =
    "https://maps.googleapis.com/maps/api/place/nearbysearch/json";

int screen = 1;
int demoScreen = 1;

int animationDuration = 1300;

Chat chat = Chat(
  id: '145DRr6Wvx5o5h9rMxuE',
  createdAt: '2019-10-07T16:15:15.073521',
  groupPic:
      'https://firebasestorage.googleapis.com/v0/b/flutterproviderarchitecture.appspot.com/o/files%2Fgroup1.jpg?alt=media&token=9eb0f0dd-fd1e-4ef7-9130-945ac7828639',
  title: 'Group Chat',
);
