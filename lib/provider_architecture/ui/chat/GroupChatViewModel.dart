import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_provider_architecture/firebase/firebase_storage_util.dart';
import 'package:flutter_provider_architecture/model/chat.dart';
import 'package:flutter_provider_architecture/model/user_data.dart';
import 'package:flutter_provider_architecture/model/user_pref.dart';
import 'package:flutter_provider_architecture/provider_architecture/repository/api/ErrorResponse.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_model.dart';
import 'package:flutter_provider_architecture/shared/global_config.dart'
    as chatModel;
import 'package:image_picker/image_picker.dart';

class GroupChatViewModel extends BaseModel implements ErrorResponse {
  File imageFile;
  UserData loggedInUser;
  Chat chat = chatModel.chat;

  bool isFirst = true;

  var reference;

  void init() {
    if (isFirst) {
      initUser();
      isFirst = false;
    }
  }

  void initUser() async {
    this.reference = chatModel.fireStore
        .collection('chat')
        .document(chat.id)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
    this.loggedInUser = await UserPreferences().getUser();
    notifyListeners();
  }

  Future<void> getImage() async {
    imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);

    if (imageFile != null) {
      await uploadFile();
    }
  }

  Future<void> uploadFile() async {
    StorageUploadTask uploadTask = FirebaseStorageUtil().uploadFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

    DocumentReference docRef = await chatModel.fireStore
        .collection('chat')
        .document(chat.id)
        .collection('messages')
        .add({
      'text': '',
      'sender': loggedInUser.email,
      'createdAt': DateTime.now().toString(),
      'image': imageUrl
    });
    await chatModel.fireStore
        .collection('chat')
        .doc(chat.id)
        .collection('messages')
        .doc(docRef.documentID)
        .set({
      'userTyping': false,
      'adminTyping': false,
      'lastestMessage': '${loggedInUser.email} has sent an image',
      'userEmail': loggedInUser.email,
      'createdAt': DateTime.now().toIso8601String(),
      'isSeenByAdmin': false,
    });
  }

  updateTyping(bool status) {
    // var document = _fireStore.collection('chatRooms').document(user);

    // if (loggedInUser.email == widget.adminEmail)
    //   document.updateData({'adminTyping': status});
    // else
    //   document.updateData({'userTyping': status});
  }

  void sendMessage(String messagesText) async {
    CollectionReference collectionReference = chatModel.fireStore
        .collection('chat')
        .doc(chat.id)
        .collection('messages');

    DocumentReference docRef = collectionReference.doc();

    await collectionReference.doc(docRef.id).setData({
      'text': messagesText,
      'sender': loggedInUser.email,
      'createdAt': DateTime.now().toIso8601String(),
    });

    await collectionReference.doc(docRef.id).setData({
      'lastestMessage': messagesText,
      'userTyping': false,
      'userEmail': loggedInUser.email,
      'createdAt': DateTime.now().toIso8601String(),
      'isSeenByAdmin': false,
      'userTyping': false,
      'adminTyping': false,
      'image': ''
    });
  }

  @override
  void serverMessage(String message, bool isError) {
    showMessage(message, isError);
    setState(ViewState.Idle);
  }
}
