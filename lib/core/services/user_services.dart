
import 'package:ecommerce_app/core/helper/constants.dart';
import 'package:ecommerce_app/core/services/firestore_services.dart';
import 'package:ecommerce_app/features/auth/data/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserServices {
  final _firestoreServices = FirestoreServices.instance;

  Future<UserData> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return await _firestoreServices.getDocument<UserData>(
      path: ApiPaths.users(uid),
      builder: (data, id) => UserData.fromMap(data, id),
    );
  }

  Future<bool> updateUserData(UserData userData) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    bool sentVerification = false;

    if (currentUser == null) {
      throw Exception("No user is currently signed in.");
    }

    // ✅ تحديث displayName (الاسم الظاهر) في Authentication
    if (userData.username != currentUser.displayName) {
      await currentUser.updateDisplayName(userData.username);
    }

    // ✅ إرسال رابط تحقق لتحديث البريد الإلكتروني الجديد
    if (userData.email != currentUser.email) {
      await currentUser.verifyBeforeUpdateEmail(userData.email);
      sentVerification = true;
      debugPrint("📩 Verification link sent to ${userData.email}");
      // ملاحظة: الإيميل لن يتغير إلا بعد أن يضغط المستخدم على رابط التحقق في بريده
    }

    // ✅ تحديث البيانات في Firestore
    await _firestoreServices.setData(
      path: ApiPaths.users(userData.id),
      data: userData.toMap(),
    );
    return sentVerification;
  }
}
