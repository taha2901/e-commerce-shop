// features/admin/data/admin_services.dart
import 'package:ecommerce_app/core/helper/constants.dart';
import 'package:ecommerce_app/core/services/firestore_services.dart';
import 'package:ecommerce_app/features/auth/data/user_data.dart';

abstract class ManagementUsersServices {
  Future<void> addusers(UserData user);
  Future<void> updateUsers(String usersId, UserData users);
  Future<void> deleteUsers(String usersId);
  Future<List<UserData>> fetchAllUsers();
}

class ManagementUsersServicesImpl implements ManagementUsersServices {
  final FirestoreServices _firestore = FirestoreServices.instance;

  @override
  Future<void> addusers(UserData user) async {
    try {
      // نستخدم الـ ID الموجود في الموديل نفسه
      await _firestore.setData(
        path: ApiPaths.users(user.id),
        data: user.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  @override
  Future<void> updateUsers(String userId, UserData user) async {
    try {
      await _firestore.setData(
        path: ApiPaths.users(userId),
        data: user.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to update users: $e');
    }
  }

  @override
  Future<void> deleteUsers(String userId) async {
    try {
      await _firestore.deleteData(
        path: ApiPaths.users(userId),
      );
    } catch (e) {
      throw Exception('Failed to delete users: $e');
    }
  }

  @override
  Future<List<UserData>> fetchAllUsers() async {
    try {
      final users = await _firestore.getCollection<UserData>(
        path: ApiPaths.user(),
        builder: (data, documentId) => UserData.fromMap(data, documentId),
      );
      return users;
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
}