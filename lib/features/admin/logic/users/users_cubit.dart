// features/admin/logic/admin_users_cubit/admin_users_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/core/services/admin_manage_users_services.dart';
import 'package:ecommerce_app/features/admin/logic/users/users_states.dart';
import 'package:ecommerce_app/features/auth/data/user_data.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  final ManagementUsersServices _userServices;

  UserManagementCubit(this._userServices) : super(UserManagementInitial());

  // إضافة مستخدم جديد
  Future<void> addUser(UserData user) async {
    emit(UserManagementLoading());
    try {
      await _userServices.addusers(user);
      emit(UserManagementSuccess('تمت إضافة المستخدم بنجاح'));
    } catch (e) {
      emit(UserManagementError('فشل في إضافة المستخدم: $e'));
    }
  }

  // تحديث بيانات مستخدم
  Future<void> updateUser(String userId, UserData user) async {
    emit(UserManagementLoading());
    try {
      await _userServices.updateUsers(userId, user);
      emit(UserManagementSuccess('تم تحديث بيانات المستخدم بنجاح'));
    } catch (e) {
      emit(UserManagementError('فشل في تحديث بيانات المستخدم: $e'));
    }
  }

  // حذف مستخدم
  Future<void> deleteUser(String userId) async {
    emit(UserManagementLoading());
    try {
      await _userServices.deleteUsers(userId);
      emit(UserManagementSuccess('تم حذف المستخدم بنجاح'));
    } catch (e) {
      emit(UserManagementError('فشل في حذف المستخدم: $e'));
    }
  }

  // جلب جميع المستخدمين
  Future<void> fetchAllUsers() async {
    emit(UserManagementLoading());
    try {
      final users = await _userServices.fetchAllUsers();
      emit(UserManagementLoaded(users));
    } catch (e) {
      emit(UserManagementError('فشل في جلب المستخدمين: $e'));
    }
  }

  // إعادة تعيين الحالة
  void resetState() {
    emit(UserManagementInitial());
  }
}
