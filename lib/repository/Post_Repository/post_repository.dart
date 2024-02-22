import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nourishnet/features/posts/models/post_model.dart';

class PostRepository extends GetxController {
  static PostRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  createPost(PostModel post) async {
    try {
      await _db
          .collection('Posts')
          .add(post.toJson())
          .whenComplete(() => Get.snackbar(
                "Success",
                "Your Post has been created",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.withOpacity(0.1),
                colorText: Colors.green,
              ));
    } catch (error) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      print(error.toString()+"hello");
      return null;
    }
  }

  Future<List<PostModel>> getPosts(String id) async {
    final snapshot =
        await _db.collection("Posts").where("ownerId", isEqualTo: id).get();
    final postdata =
        snapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList();
    return postdata;
  }
}
