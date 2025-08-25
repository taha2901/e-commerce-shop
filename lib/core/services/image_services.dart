// import 'dart:io';
// import 'package:ecommerce_app/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ImageService {
//   static const String _imagePathKey = 'user_profile_image';
//   final ImagePicker _picker = ImagePicker();

//   /// اختيار مصدر الصورة (كاميرا أو معرض)
//   Future<String?> pickImageSource(ImageSource source) async {
//     try {
//       // طلب الإذن
//       await _requestPermission(source);
      
//       // اختيار الصورة
//       final XFile? image = await _picker.pickImage(
//         source: source,
//         maxWidth: 800,
//         maxHeight: 800,
//         imageQuality: 80,
//       );

//       if (image != null) {
//         // حفظ مسار الصورة
//         await _saveImagePath(image.path);
//         return image.path;
//       }
//       return null;
//     } catch (e) {
//       throw Exception('فشل في اختيار الصورة: $e');
//     }
//   }

//   /// طلب الإذن حسب المصدر
//   Future<void> _requestPermission(ImageSource source) async {
//     Permission permission = source == ImageSource.camera 
//         ? Permission.camera 
//         : Permission.photos;
    
//     if (!await permission.isGranted) {
//       await permission.request();
//     }
//   }

//   /// حفظ مسار الصورة في SharedPreferences
//   Future<void> _saveImagePath(String imagePath) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_imagePathKey, imagePath);
//   }

//   /// استرجاع مسار الصورة المحفوظة
//   Future<String?> getSavedImagePath() async {
//     final prefs = await SharedPreferences.getInstance();
//     final imagePath = prefs.getString(_imagePathKey);
    
//     // التحقق من وجود الملف
//     if (imagePath != null && File(imagePath).existsSync()) {
//       return imagePath;
//     }
//     return null;
//   }

//   /// حذف الصورة المحفوظة
//   Future<void> deleteProfileImage() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_imagePathKey);
//   }

//   /// عرض خيارات اختيار الصورة
//   static void showImageSourceDialog({
//     required BuildContext context,
//     required Function(ImageSource) onSourceSelected,
//   }) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'اختر مصدر الصورة',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildSourceOption(
//                   context: context,
//                   icon: Icons.camera_alt,
//                   title: 'الكاميرا',
//                   source: ImageSource.camera,
//                   onTap: onSourceSelected,
//                 ),
//                 _buildSourceOption(
//                   context: context,
//                   icon: Icons.photo_library,
//                   title: 'المعرض',
//                   source: ImageSource.gallery,
//                   onTap: onSourceSelected,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   static Widget _buildSourceOption({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required ImageSource source,
//     required Function(ImageSource) onTap,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pop(context);
//         onTap(source);
//       },
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: AppColors.kPrimaryColor.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(
//             color: AppColors.kPrimaryColor.withOpacity(0.3),
//           ),
//         ),
//         child: Column(
//           children: [
//             Icon(
//               icon,
//               size: 40,
//               color: AppColors.kPrimaryColor,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
