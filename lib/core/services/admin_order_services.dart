// import 'package:ecommerce_app/core/services/firestore_services.dart';
// import 'package:ecommerce_app/core/helper/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class OrderServices {
//   final _firestore = FirestoreServices.instance;

//   Future<void> saveOrderLocation({
//     required double latitude,
//     required double longitude,
//     required String address, // ممكن تخليه اختياري لو مش بتجيبه
//   }) async {
//     final user = FirebaseAuth.instance.currentUser!;
//     final userId = user.uid;
//     final orderId = _firestore.firestore.collection(ApiPaths.orders()).doc().id;

//     final userDoc =
//         await _firestore.firestore.doc(ApiPaths.users(userId)).get();
//     final username = userDoc.data()?['username'] ?? "Unknown";

//     final data = {
//       "order_id": orderId,
//       "user_id": userId,
//       "username": username, // 👈 إضافة الاسم هنا
//       "created_at": DateTime.now(),
//       "location": {
//         "latitude": latitude,
//         "longitude": longitude,
//         "address": address,
//       },
//     };

//     await _firestore.setData(
//       path: ApiPaths.order(orderId),
//       data: data,
//     );
//   }
// }




import 'package:ecommerce_app/core/services/firestore_services.dart';
import 'package:ecommerce_app/core/helper/constants.dart';
import 'package:ecommerce_app/features/home/data/add_to_cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderServices {
  final _firestore = FirestoreServices.instance;

  // Method لإنشاء طلب من بيانات السلة
  Future<String> createOrderFromCart({
    required List<AddToCartModel> cartItems, // بيانات السلة
    required double latitude,
    required double longitude,
    required String address,
    String? paymentMethod,
    String? notes,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userId = user.uid;
    final orderId = _firestore.firestore.collection(ApiPaths.orders()).doc().id;

    // جلب بيانات المستخدم
    final userDoc = await _firestore.firestore.doc(ApiPaths.users(userId)).get();
    final username = userDoc.data()?['username'] ?? "Unknown";
    final email = userDoc.data()?['email'] ?? user.email ?? "Unknown";
    final phone = userDoc.data()?['phone'] ?? "Unknown";

    // تحويل بيانات السلة إلى بيانات الطلب
    List<Map<String, dynamic>> orderItems = cartItems.map((cartItem) {
      return {
        'product_id': cartItem.product.id,
        'product_name': cartItem.product.name,
        'price': cartItem.product.price,
        'quantity': cartItem.quantity,
        // 'image': cartItem.product.imageUrl,
        'total_price': (cartItem.product.price * cartItem.quantity),
        'cart_item_id': cartItem.id, // للمرجعية
      };
    }).toList();

    // حساب المجموع الكلي
    double totalAmount = cartItems.fold<double>(
      0, 
      (sum, item) => sum + (item.product.price * item.quantity)
    );

    // إنشاء رقم طلب فريد
    final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

    final orderData = {
      // معلومات أساسية
      "order_id": orderNumber,
      "id": orderId,
      "user_id": userId,
      
      // بيانات العميل
      "username": username,
      "email": email,
      "phone": phone,
      
      // حالة الطلب
      "status": "pending",
      
      // بيانات المنتجات
      "items": orderItems,
      "items_count": cartItems.length,
      "total": totalAmount,
      
      // بيانات الموقع
      "location": {
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
      },
      
      // بيانات الدفع
      "payment_method": paymentMethod ?? "cash_on_delivery",
      "payment_status": "pending",
      
      // ملاحظات
      "notes": notes,
      
      // تواريخ
      "created_at": FieldValue.serverTimestamp(),
      "updated_at": FieldValue.serverTimestamp(),
    };

    // حفظ الطلب في قاعدة البيانات
    await _firestore.setData(
      path: ApiPaths.order(orderId),
      data: orderData,
    );

    // تحديث إحصائيات المستخدم
    await _updateUserOrderStats(userId);

    return orderNumber; // إرجاع رقم الطلب
  }

  // Method محدث للطريقة القديمة (للتوافق مع الكود الموجود)
  Future<void> saveOrderLocation({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userId = user.uid;
    final orderId = _firestore.firestore.collection(ApiPaths.orders()).doc().id;

    final userDoc = await _firestore.firestore.doc(ApiPaths.users(userId)).get();
    final username = userDoc.data()?['username'] ?? "Unknown";

    final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

    final data = {
      "order_id": orderNumber,
      "user_id": userId,
      "username": username,
      "status": "pending",
      "items": [],
      "items_count": 0,
      "total": 0.0,
      "created_at": FieldValue.serverTimestamp(),
      "updated_at": FieldValue.serverTimestamp(),
      "location": {
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
      },
    };

    await _firestore.setData(
      path: ApiPaths.order(orderId),
      data: data,
    );
  }

  // تحديث إحصائيات المستخدم
  Future<void> _updateUserOrderStats(String userId) async {
    try {
      final userRef = _firestore.firestore.doc(ApiPaths.users(userId));
      
      await userRef.update({
        'total_orders': FieldValue.increment(1),
        'last_order_date': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user stats: $e');
    }
  }

  // Method لتحديث حالة الطلب
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.firestore
          .collection(ApiPaths.orders())
          .doc(orderId)
          .update({
        'status': newStatus,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  // Method لجلب طلبات المستخدم
  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      final snapshot = await _firestore.firestore
          .collection(ApiPaths.orders())
          .where('user_id', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      print('Error getting user orders: $e');
      return [];
    }
  }

  // Method لجلب جميع الطلبات (للأدمن)
  Future<List<Map<String, dynamic>>> getAllOrders({String? statusFilter}) async {
    try {
      Query query = _firestore.firestore
          .collection(ApiPaths.orders())
          .orderBy('created_at', descending: true);

      if (statusFilter != null && statusFilter != 'all') {
        query = query.where('status', isEqualTo: statusFilter);
      }

      final snapshot = await query.get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      print('Error getting all orders: $e');
      return [];
    }
  }
}