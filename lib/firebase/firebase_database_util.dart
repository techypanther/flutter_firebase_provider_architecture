import 'package:cloud_firestore/cloud_firestore.dart';

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
  Firestore firestore;

  factory FirebaseDatabaseUtil() {
    return _instance;
  }

  void initState() {
    Firestore.instance.settings(
        persistenceEnabled: true,
        sslEnabled: true,
        timestampsInSnapshotsEnabled: true);

    firestore = Firestore.instance;

    users = firestore.collection('users').reference();
    products = firestore.collection('products').reference();
    wishlist = firestore.collection('wishlist').reference();
    cart = firestore.collection('cart').reference();
    orders = firestore.collection('orders').reference();
    category = firestore.collection('category').reference();
    chat = firestore.collection('chat').reference();
  }
}
