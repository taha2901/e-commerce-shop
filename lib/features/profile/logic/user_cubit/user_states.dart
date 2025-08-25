
// // User States
// import 'package:ecommerce_app/features/auth/data/user_data.dart';
// abstract class UserState {}

// class UserInitial extends UserState {}
// class UserLoading extends UserState {}
// class UserUpdating extends UserState {}
// class UserLoaded extends UserState {
//   final UserData user;
//   UserLoaded(this.user);
// }
// class UserUpdated extends UserState {}
// class EmailVerificationSent extends UserState {} // جديد
// class UserError extends UserState {
//   final String message;
//   UserError(this.message);
// }



import 'package:ecommerce_app/features/auth/data/user_data.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserUpdating extends UserState {}

class UserImageUpdating extends UserState {}

class UserLoaded extends UserState {
  final UserData user;
  UserLoaded(this.user);
}

class UserUpdated extends UserState {}



class UserImageDeleted extends UserState {}

class EmailVerificationSent extends UserState {}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

