import 'package:ecommerce_app/features/profile/logic/change_password_cubit/change_pass_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  final _auth = FirebaseAuth.instance;

  Future<void> changePassword(String currentPassword, String newPassword, String confirmPassword) async {
    if (newPassword != confirmPassword) {
      emit(ChangePasswordError("Passwords do not match"));
      return;
    }

    if (newPassword.length < 6) {
      emit(ChangePasswordError("New password must be at least 6 characters"));
      return;
    }

    emit(ChangePasswordLoading());

    try {
      final user = _auth.currentUser!;
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      // Re-authenticate
      await user.reauthenticateWithCredential(cred);

      // Change password
      await user.updatePassword(newPassword);

      emit(ChangePasswordSuccess());
    } catch (e) {
      emit(ChangePasswordError("Error: ${e.toString()}"));
    }
  }
}
