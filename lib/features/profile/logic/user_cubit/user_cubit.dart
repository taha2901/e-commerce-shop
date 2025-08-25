import 'package:ecommerce_app/core/services/user_services.dart';
import 'package:ecommerce_app/features/auth/data/user_data.dart';
import 'package:ecommerce_app/features/profile/logic/user_cubit/user_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  final UserServices _userServices = UserServices();

  Future<void> getUserData() async {
    emit(UserLoading());
    try {
      final user = await _userServices.fetchUserData();
      emit(UserLoaded(user));
    } catch (e) {
      debugPrint(e.toString());
      emit(UserError('فشل في تحميل البيانات: $e'));
    }
  }



  Future<void> updateUser(UserData userData) async {
    emit(UserUpdating());
    try {
      await _userServices.updateUserData(userData);
      emit(UserUpdated());
      getUserData(); // تحميل البيانات من جديد بعد التحديث
    } catch (e) {
      print(e.toString());
      emit(UserError('فشل في التحديث: $e'));
    }
  }
}
