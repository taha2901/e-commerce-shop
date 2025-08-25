import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/commerce.dart';
import 'package:ecommerce_app/core/routings/app_router.dart';
import 'package:ecommerce_app/core/utils/api_key.dart';
import 'package:ecommerce_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

// cart -> checkout -> PaymentMethodsBottomSheet -> CustomButtonBlocConsumer
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  // 1️⃣ Stripe config
  Stripe.publishableKey = ApiKeys.publicKey;

  // 2️⃣ Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3️⃣ Localization
  await EasyLocalization.ensureInitialized();

  // 4️⃣ ScreenUtil
  await ScreenUtil.ensureScreenSize();

  runApp(
    EasyLocalization(
      path: 'assets/lang',
      saveLocale: true,
      startLocale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      child: MyApp(appRouter: AppRouter()),
    ),
  );
}
