import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/services/firestore_services.dart';
import 'package:ecommerce_app/features/admin/logic/order/order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final FirestoreServices _firestore;

  OrdersCubit(this._firestore) : super(OrdersInitial());

  Future<void> loadOrders({String? statusFilter}) async {
    emit(OrdersLoading());
    
    try {
      Query query = _firestore.firestore
          .collection('orders')
          .orderBy('created_at', descending: true);

      if (statusFilter != null && statusFilter != 'all') {
        query = query.where('status', isEqualTo: statusFilter);
      }

      final snapshot = await query.get();
      final orders = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError('Failed to load orders: $e'));
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.firestore
          .collection('orders')
          .doc(orderId)
          .update({
        'status': newStatus,
        'updated_at': FieldValue.serverTimestamp(),
      });

      // إعادة تحميل البيانات بعد التحديث
      loadOrders();
    } catch (e) {
      emit(OrdersError('Failed to update order: $e'));
    }
  }

  Future<void> searchOrders(String query) async {
    if (query.isEmpty) {
      loadOrders();
      return;
    }

    emit(OrdersLoading());
    
    try {
      final snapshot = await _firestore.firestore
          .collection('orders')
          .where('order_id', isGreaterThanOrEqualTo: query)
          .where('order_id', isLessThan: query + 'z')
          .orderBy('order_id')
          .get();

      final orders = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError('Failed to search orders: $e'));
    }
  }
}
