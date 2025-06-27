import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserbyemail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("Email", isEqualTo: email)
        .get();
  }
    Future addUserBooking(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id).collection("Bookings")
        .add(userInfoMap);
  }

// تمت غضافتها لربط صفحة الحجوزات بالفايربيز تبعنا 
Future<Stream<QuerySnapshot>> getbookings(String id) async {
return await FirebaseFirestore.instance
.collection("users") //بتاخد اسمها نسخ لصق بالزبط زي كيف بالفاير بيز مكتوبة 
.doc(id)
.collection("Bookings") //بتاخد اسمها نسخ لصق بالزبط زي كيف بالفاير بيز مكتوبة 
. snapshots();
}






}
