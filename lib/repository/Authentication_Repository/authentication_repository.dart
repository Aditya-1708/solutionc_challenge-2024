import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:nourishnet/classes/role_enum.dart';
import 'dart:math';

import 'package:nourishnet/features/authentication/models/donor_model.dart';
import 'package:nourishnet/features/authentication/models/user_model.dart';
import 'package:nourishnet/features/authentication/screens/first_page.dart';
import 'package:nourishnet/features/authentication/screens/role_selection_page.dart';
import 'package:nourishnet/features/donorhome/screens/home_page.dart';
import 'package:nourishnet/features/userhome/screens/home_page.dart';
import 'package:nourishnet/repository/Authentication_Repository/exceptions/continue_with_google.dart';
import 'package:nourishnet/repository/Authentication_Repository/exceptions/signin_email_password_failure.dart';
import 'package:nourishnet/repository/Authentication_Repository/exceptions/signup_email_password_failure.dart';
import 'package:nourishnet/repository/Donor_Repository/donor_repository.dart';
import 'package:nourishnet/repository/User_Repository/user_repository.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  Future<Role> roleDecider(User user) async {
    Role? roleUser =
        await UserRepository.instance.getUserRole(user.email ?? '');
    Role? roleDonor =
        await DonorRepository.instance.getDonorRole(user.email ?? '');

    if (roleUser == Role.user ||
        (roleDonor != null && roleDonor == Role.donor)) {
      return Role.donor;
    } else {
      return Role.user;
    }
  }

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => RoleSelectionPage());
    } else {
      Role role = await roleDecider(user);
      if (role == Role.donor) {
        Get.offAll(() => DonorHomePage());
      } else {
        Get.offAll(() => UserHomePage());
      }
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SignupWithEmailAndPasswordFailure(e.code);
      print("firebase auth exception - ${ex.message}");
      throw ex;
    } catch (_) {
      const ex = SignupWithEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future<void> signinUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SigninWithEmailAndPasswordFailure(e.code);
      print("firebase auth exception - ${ex.message}");
      throw ex;
    } catch (_) {
      const ex = SigninWithEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }
  String generateRandomId({int length = 10}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final id =
        List.generate(length, (index) => chars[random.nextInt(chars.length)]);
    return id.join();
  }
  Future<void> continueWithGoogle(Role role) async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await _auth.signInWithProvider(googleAuthProvider);
      final User? user = userCredential.user;

      if (user != null) {
        String fullName = user.displayName ?? '';
        String email = user.email ?? '';
        String phoneNo = '';
        String password = '';
        String id=generateRandomId();
        print(email);
        bool emailExistsR =
            await UserRepository.instance.checkEmailExists(email);
        bool emailExistsD =
            await DonorRepository.instance.checkEmailExists(email);
        print(emailExistsR);
        print(emailExistsD);
        if ((!emailExistsR)&&(!emailExistsD)) {
          if (role == Role.donor) {
            DonorModel donorModel = DonorModel(
              id: id,
              fullName: fullName,
              email: email,
              phoneNo: phoneNo,
              password: password,
              role: role.toString(),
            );
            await DonorRepository.instance.createDonor(donorModel);
          } else {
            UserModel userModel = UserModel(
              id: id,
              fullName: fullName,
              email: email,
              phoneNo: phoneNo,
              password: password,
              role: role.toString(),
            );
            await UserRepository.instance.createUser(userModel);
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      final ex = SigninWithEmailAndPasswordFailure(e.code);
      print("firebase auth exception - ${ex.message}");
      throw ex;
    } catch (_) {
      const ex = ContinueWithGoogleFailure();
      print('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future<User?> getUser() async {
    return _auth.currentUser;
  }

  Future<void> logout() async => await _auth.signOut();
}
