import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nourishnet/classes/role_enum.dart';
import 'package:nourishnet/features/authentication/models/donor_model.dart';
import 'package:nourishnet/features/authentication/models/user_model.dart';
import 'package:nourishnet/features/donorhome/screens/home_page.dart';

class DonorRepository extends GetxController {
  static DonorRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  createDonor(DonorModel donor) async {
    try {
      await _db.collection('Donors').add(donor.toJson()).whenComplete(() {
        Get.snackbar(
          "Success",
          "Your account has been created",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
        Get.to(const DonorHomePage());
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
      return null;
    }
  }

  Future<DonorModel?> getDonorDetails(String? email) async {
    final snapshot =
        await _db.collection("Donors").where("email", isEqualTo: email).get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    if (snapshot.docs.length > 1) {
      return null;
    }

    final donordata =
        snapshot.docs.map((e) => DonorModel.fromSnapshot(e)).single;
    return donordata;
  }


  Future<Role?> getDonorRole(String? email) async {
    try {
      DonorModel? user=await getDonorDetails(email);
      if(user!.role=="Role.donor"){
        return Role.donor;
      }
      else if(user!.role=="Role.user"){
        return Role.user;
      }
      else{
        return null;
      }
      } catch (error) {
      print("Error fetching Donor role: $error");
      return null;
    }
  }

  Future<String?> getDonorID(String? email) async {
    DonorModel? donor = await getDonorDetails(email);
    print(donor!.id);
    if (donor != null) {
      return donor.id;
    } else {
      return null;
    }
  }


  Future<bool> checkEmailExists(String email) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('Donors')
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
