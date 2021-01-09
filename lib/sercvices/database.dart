import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static SharedPreferences sharedPreferences;

  static Future sendData(String itemName, String docName, int price) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final username = sharedPreferences.getString('usernmae');
    await firestore.collection('CartItems').doc(docName).set({
      'itemName': itemName,
      'price': price,
    });
  }
}
