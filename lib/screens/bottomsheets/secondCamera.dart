// import 'dart:convert';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:image_picker/image_picker.dart';
//
// class SecondCamera extends StatefulWidget {
//   const SecondCamera({super.key});
//
//   @override
//   State<SecondCamera> createState() => _SecondCameraState();
// }
//
// class _SecondCameraState extends State<SecondCamera> {
//   final ImagePicker _picker = ImagePicker();
//   late XFile _imageFile;
//   String _base64Image = '';
//
//   Future<void> _captureImage(ImageSource source) async {
//     final pickedImage = await _picker.getImage(source: source);
//     if (pickedImage != null) {
//       setState(() {
//         _imageFile = XFile(pickedImage.path);
//         _base64Image = '';
//       });
//     }
//   }
//
//   Future<void> _convertToBase64() async {
//     if (_imageFile != null) {
//       List<int> imageBytes = await _imageFile.readAsBytes();
//       String base64Image = base64Encode(imageBytes);
//       setState(() {
//         _base64Image = base64Image;
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
