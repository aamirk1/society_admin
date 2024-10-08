import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:society_admin/authScreen/common.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
      } else {
        // print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: white)),
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [lightBlueColor, blueColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight))),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 80,
              backgroundColor: Colors.blue,
              // backgroundImage: _image != null ? FileImage(_image) : AssetImage('assets/default_avatar.png'),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: _getImageFromGallery,
                child: const Text('Choose from Gallery'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
