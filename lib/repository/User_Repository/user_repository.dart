import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nourishnet/classes/role_enum.dart';
import 'package:nourishnet/features/authentication/models/user_model.dart';
import 'package:nourishnet/features/userhome/screens/home_page.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  createUser(UserModel user) async {
    try {
      await _db.collection('Users').add(user.toJson()).whenComplete(() {
        Get.snackbar(
          "Success",
          "Your account has been created",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
        Get.to(const UserHomePage());
      });
    } catch (error) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      print(error.toString());
      // Return a value to fulfill the requirement of the catchError callback
      return null; // You can return null or any other appropriate value
    }
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection('Users').where("email", isEqualTo: email).get();
    final userdata = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userdata;
  }

  Future<Role?> getUserRole(String email) async {
    try {
      UserModel user=await getUserDetails(email);
      if (user.role == "Role.donor") {
        return Role.donor;
      } else if (user.role == "Role.user") {
        return Role.user;
      } else {
        return null;
      }
    } catch (error) {
      print("Error fetching user role: $error");
      return null;
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      print(error.toString());
      return false;
    }
  }
}
