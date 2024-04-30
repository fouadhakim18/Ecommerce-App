import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/firebase_consts.dart';

class FirestoreService {
  static Future<DocumentSnapshot<Map<String, dynamic>>> getUser() async {
    final doc = await firestore.collection("users").doc(currentUser!.uid).get();
    return doc;
  }

  static getProducts(String category) {
    return firestore
        .collection('products')
        .where("p_category", isEqualTo: category)
        .snapshots();
  }

  static getSubCatProducts(String title) {
    return firestore
        .collection('products')
        .where("p_subcategory", isEqualTo: title)
        .snapshots();
  }

  static getCart(uid) {
    return firestore
        .collection("cart")
        .where("added_by", isEqualTo: uid)
        .snapshots();
  }

  static deleteDoc(docId) {
    return firestore.collection("cart").doc(docId).delete();
    
  }

  static getChatMessages(docId) {
    return firestore
        .collection("chats")
        .doc(docId)
        .collection("messages")
        .orderBy("created_on", descending: true)
        .snapshots();
  }

  static getAllOrders() {
    return firestore
        .collection("orders")
        .where("order_by", isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getWishlist() {
    return firestore
        .collection("products")
        .where("p_wishlist", arrayContains: currentUser!.uid)
        .snapshots();
  }

  static getAllMessages() {
    return firestore
        .collection("chats")
        .where("fromId", isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static removeFromWishlist(docId) async {
    await firestore.collection("products").doc(docId).update({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    });
  }

  static getAllProducts() {
    return firestore.collection("products").snapshots();
  }

  static searchProducts(title) {
    return firestore.collection('products').get();
  }

  static getCartCounts() {
    return firestore
        .collection("cart")
        .where("added_by", isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getOrdersCounts() {
    return firestore
        .collection("orders")
        .where("order_by", isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getWishlistCounts() {
    return firestore
        .collection("products")
        .where("p_wishlist", arrayContains: currentUser!.uid)
        .snapshots();
  }

  static getFeaturedProducts() {
    return firestore
        .collection("products")
        .orderBy("p_wishlist".length)
        .limit(2)
        .snapshots();
  }
}
