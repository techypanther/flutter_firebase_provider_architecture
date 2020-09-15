import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseDatabaseUtil {
  static final FirebaseDatabaseUtil _instance =
      new FirebaseDatabaseUtil.internal();

  FirebaseDatabaseUtil.internal();

  CollectionReference users;
  CollectionReference products;
  CollectionReference wishlist;
  CollectionReference cart;
  CollectionReference orders;
  CollectionReference category;
  CollectionReference chat;
  FirebaseFirestore firestore;

  factory FirebaseDatabaseUtil() {
    return _instance;
  }

  void initState() {
     Firebase.initializeApp();
     FirebaseFirestore.instance.settings= Settings(
        persistenceEnabled: true,
        sslEnabled: true,
        cacheSizeBytes: 100000000);

    firestore = FirebaseFirestore.instance;

    users = firestore.collection('users');
    products = firestore.collection('products');
    wishlist = firestore.collection('wishlist');
    cart = firestore.collection('cart');
    orders = firestore.collection('orders');
    category = firestore.collection('category');
    chat = firestore.collection('chat');
  }
}
