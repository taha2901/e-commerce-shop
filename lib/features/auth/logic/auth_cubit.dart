
import 'package:ecommerce_app/core/helper/constants.dart';
import 'package:ecommerce_app/core/services/auth_services.dart';
import 'package:ecommerce_app/core/services/firestore_services.dart';
import 'package:ecommerce_app/features/auth/data/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final AuthServices authServices = AuthServicesImpl();
  final firestoreServices = FirestoreServices.instance;

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(AuthLoading());
    try {
      final user =
          await authServices.loginWithEmailAndPassword(email, password);

      if (user != null) {
        final userData = await firestoreServices.getDocument<UserData>(
          path: ApiPaths.users(user.uid),
          builder: (data, id) => UserData.fromMap(data, id),
        );
        emit(AuthSuccess(userData: userData));
      } else {
        emit(AuthError(message: "فشل تسجيل الدخول"));
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg = _handleFirebaseAuthError(e);
      emit(AuthError(message: errorMsg));
    } catch (e) {
      emit(AuthError(message: "حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }

// دالة مبسطة وفعالة
  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "صيغة البريد الإلكتروني غير صحيحة.";

      case 'user-disabled':
        return "هذا الحساب تم تعطيله.";

      case 'user-not-found':
        return "البريد الإلكتروني أو كلمة المرور غير صحيحة";

      case 'wrong-password':
        return "البريد الإلكتروني أو كلمة المرور غير صحيحة";

      case 'invalid-credential':
        return "البريد الإلكتروني أو كلمة المرور غير صحيحة";

      case 'too-many-requests':
        return "عدد محاولات الدخول كثيرة، حاول مرة أخرى لاحقاً";

      case 'network-request-failed':
        return "خطأ في الاتصال بالشبكة، تأكد من اتصالك بالإنترنت";

      default:
        return "حدث خطأ في المصادقة: ${e.message ?? e.code}";
    }
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password, String username) async {
    emit(AuthLoading());
    try {
      final user =
          await authServices.registerWithEmailAndPassword(email, password);

      if (user != null) {
        final userData = UserData(
          id: user.uid,
          username: username,
          email: email,
          role: 'user',
          createdAt: DateTime.now().toIso8601String(),
        );

        await firestoreServices.setData(
          path: ApiPaths.users(user.uid),
          data: userData.toMap(),
        );

        emit(AuthSuccess(userData: userData));
      } else {
        emit(AuthError(message: "فشل إنشاء الحساب، حاول مرة أخرى"));
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg = _handleFirebaseAuthRegisterError(e);
      emit(AuthError(message: errorMsg));
    } catch (e) {
      emit(AuthError(message: "حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }

// دالة مخصصة لمعالجة أخطاء التسجيل
  String _handleFirebaseAuthRegisterError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "صيغة البريد الإلكتروني غير صحيحة.";

      case 'email-already-in-use':
        return "هذا البريد الإلكتروني مستخدم بالفعل.";

      case 'weak-password':
        return "كلمة المرور ضعيفة جداً. يجب أن تحتوي على 6 أحرف على الأقل";

      case 'operation-not-allowed':
        return "التسجيل عن طريق البريد الإلكتروني غير مفعل حالياً";

      case 'too-many-requests':
        return "عدد محاولات التسجيل كثيرة، حاول مرة أخرى لاحقاً";

      case 'network-request-failed':
        return "خطأ في الاتصال بالشبكة، تأكد من اتصالك بالإنترنت";

      default:
        return "حدث خطأ أثناء إنشاء الحساب: ${e.message ?? e.code}";
    }
  }

  Future<void> saveUserData(
      String userId, String email, String username) async {
    final userData = UserData(
      id: userId,
      username: username,
      email: email,
      role: 'user', // 👈 هنا نحدد الدور
      createdAt: DateTime.now().toIso8601String(),
    );
  }
    void checkAuth() async {
      emit(AuthChecking()); // حالة جديدة للتحقق الأولي
      final user = authServices.currentUser();
      if (user != null) {
        try {
          final userData = await firestoreServices.getDocument<UserData>(
            path: ApiPaths.users(user.uid),
            builder: (data, id) => UserData.fromMap(data, id),
          );
          emit(AuthSuccess(userData: userData));
        } catch (e) {
          emit(AuthError(message: "Error fetching user data: $e"));
        }
      } else {
        emit(AuthInitial()); // لا يوجد مستخدم مسجل دخول
      }
    }

    Future<void> logOut() async {
      emit(AuthLogingout());
      try {
        await authServices.logOut();
        emit(AuthLogedout());
      } catch (e) {
        emit(AuthLogoutError(message: "Error: $e"));
      }
    }
}
