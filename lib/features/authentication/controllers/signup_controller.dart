import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:nourishnet/features/authentication/models/donor_model.dart';
import 'package:nourishnet/features/authentication/models/user_model.dart';
import 'package:nourishnet/repository/Authentication_Repository/authentication_repository.dart';
import 'package:nourishnet/repository/Donor_Repository/donor_repository.dart';
import 'package:nourishnet/repository/User_Repository/user_repository.dart';

class SignupController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();
  late final String id = generateRandomId();
  final userRepo = Get.put(UserRepository());
  final donorRepo = Get.put(DonorRepository());

  String generateRandomId({int length = 10}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final id =
        List.generate(length, (index) => chars[random.nextInt(chars.length)]);
    return id.join();
  }

  static SignupController get instance => Get.find();

  void signup(String email, String password) {
    String? error = AuthenticationRepository.instance
        .createUserWithEmailAndPassword(email, password) as String?;
    if (error != null) {
      Get.showSnackbar(
        GetSnackBar(
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> createUser(UserModel user) async {
    signup(user.email, user.password);
    await userRepo.createUser(user);
  }

  Future<void> createDonor(DonorModel donor) async {
    signup(donor.email, donor.password);
    await donorRepo.createDonor(donor);
  }
}
