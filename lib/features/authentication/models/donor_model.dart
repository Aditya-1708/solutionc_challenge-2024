import "package:cloud_firestore/cloud_firestore.dart";

class DonorModel {
  final String? id;
  final String fullName;
  final String email;
  final String phoneNo;
  final String password;
  final String role;

  const DonorModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNo,
    required this.password,
    required this.role,
  });

  toJson() {
    return {
      "id": id,
      "fullName": fullName,
      "email": email,
      "phoneNo": phoneNo,
      "password": password,
      "role": role,
    };
  }

  factory DonorModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return DonorModel(
        fullName: data['fullName'],
        email: data['email'],
        phoneNo: data['phoneNo'],
        password: data['password'],
        role: data['role']);
  }
}
