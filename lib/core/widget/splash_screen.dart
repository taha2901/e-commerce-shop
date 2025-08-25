// import 'package:ecommerce_app/core/utils/api_key.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ecommerce_app/features/auth/logic/auth_cubit.dart';
// import 'package:ecommerce_app/core/routings/routers.dart';
// import 'package:ecommerce_app/core/helper/constants.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthCubit, AuthState>(
//       listener: (context, state) {
//         if (state is AuthSuccess) {
//           final role = state.userData.role;
//           if (role == 'admin') {
//             ApiKeys().navigatorKey.currentState!
//                 .pushReplacementNamed(Routers.adminDashboardRoute);
//           } else if (role == 'vendor') {
//             ApiKeys().navigatorKey.currentState!
//                 .pushReplacementNamed(Routers.adminVendorRoute);
//           } else {
//             ApiKeys().navigatorKey.currentState!
//                 .pushReplacementNamed(Routers.homeRoute);
//           }
//         } else if (state is AuthInitial || state is AuthLogedout) {
//           ApiKeys().navigatorKey.currentState!.pushReplacementNamed(Routers.loginRoute);
//         }
//       },
//       child: const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }
// }
