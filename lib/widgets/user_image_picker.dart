import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({
    super.key,
    // required this.onPickImage,
    required this.onPickGallery,
  });
  // final void Function(File pickedImage) onPickImage;
  final void Function(File pickedGallery) onPickGallery;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  //File? _pickedImageFile;
  File? _pickedGalleryFile;
  // void _pickimage() async {
  //   final pickedImage = await ImagePicker().pickImage(
  //     source: ImageSource.camera,
  //     imageQuality: 50,
  //     maxWidth: 150,
  //   );
  //   if (pickedImage == null) {
  //     return;
  //   }
  //   setState(() {
  //     _pickedImageFile = File(pickedImage.path);
  //     _pickedGalleryFile = null;
  //   });

  //   widget.onPickImage(_pickedImageFile!);
  // }

  void _PickGallery() async {
    final pickedGallery = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedGallery == null) {
      return;
    }
    setState(() {
      _pickedGalleryFile = File(pickedGallery.path);
   //   _pickedImageFile = null; 
    });
    widget.onPickGallery(_pickedGalleryFile!);
  }
  // _pickedImageFile != null
  //             ? FileImage(_pickedImageFile!)
  //             : (_pickedGalleryFile != null
  //                 ? FileImage(_pickedGalleryFile!)
  //                 : null),
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:  _pickedGalleryFile != null ? FileImage(_pickedGalleryFile!) : null,
        ),
        // TextButton.icon(
        //   onPressed: _pickimage,
        //   icon: const Icon(Icons.image),
        //   label: Text(
        //     'add image',
        //     style: TextStyle(
        //       color: Theme.of(context).colorScheme.primary,
        //     ),
        //   ),
        // ),
        TextButton.icon(
          onPressed: _PickGallery,
          icon: const Icon(Icons.image),
          label: Text(
            'add Gallery',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        )
      ],
    );
  }
}
