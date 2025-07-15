import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.image});
  final void Function(File image) image;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  //    var _pickedImage = File('');

  void _pickImage() async {
    //final image = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 150);
    //if (image == null) {
    //return;
    //}

    //if (image.path.isEmpty) {
    //return;
    //}

    setState(() {
      //_pickedImage = File(image.path);
    });
    // widget.image(File(image.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          //backgroundImage: _pickedImage.path.isNotEmpty ? FileImage(File(_pickedImage.path)) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Add Image', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
