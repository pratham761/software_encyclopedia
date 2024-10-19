import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<(dynamic, dynamic)> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);
 
  if (file != null) {
     print('FILELEE : ${file.name}');
    return (await file.readAsBytes(), file.name);
  }
  return ('','');
}

showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}