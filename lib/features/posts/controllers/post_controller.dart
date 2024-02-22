import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nourishnet/features/posts/models/post_model.dart';
import 'package:nourishnet/repository/Authentication_Repository/authentication_repository.dart';
import 'package:nourishnet/repository/Donor_Repository/donor_repository.dart';
import 'package:nourishnet/repository/Post_Repository/post_repository.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class PostController extends GetxController {
  final title = TextEditingController();
  final description = TextEditingController();
  String imageURL = ""; // Add this line to define imageURL

  String generateRandomId({int length = 10}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final id =
        List.generate(length, (index) => chars[random.nextInt(chars.length)]);
    return id.join();
  }

  static PostController get instance => Get.find();

  Future<void> post(String title, String description) async {
    User? user = await AuthenticationRepository.instance.getUser();
    if (user == null) {
      // Handle the case when user is not logged in
      Get.showSnackbar(
        GetSnackBar(
          message: "User is not logged in.",
        ),
      );
      return;
    }

    String? email = user.email;
    String? ownerId = await DonorRepository.instance.getDonorID(email);
    if (ownerId == null) {
      // Handle the case when owner ID is null
      Get.showSnackbar(
        GetSnackBar(
          message: "Owner ID is null.",
        ),
      );
      return;
    }

    String id = generateRandomId();
    print(ownerId);
    PostModel post = PostModel(
      ownerId: ownerId,
      id: id,
      title: title,
      description: description,
      imageURL: imageURL,
    );
    print(post.toJson());
    String? error = PostRepository.instance.createPost(post);
    print(error! + "here");
    if (error != null) {
      Get.showSnackbar(
        GetSnackBar(
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> uploadImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('${file?.path}');
    if (file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('Images');
    Reference referenceImageToUpload = referenceDirImage.child(uniqueFileName);
    try {
      await referenceImageToUpload.putFile(File(file.path));
      imageURL = await referenceImageToUpload.getDownloadURL();
    } catch (error) {}
  }
}
