import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nourishnet/classes/role_enum.dart';
import 'package:nourishnet/features/authentication/screens/first_page.dart';
import 'package:nourishnet/widgets/app_bar.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to Nourishnet !",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20,),
            
            Image.asset(
              'assets/icon.png', // Change the path to your image
              width: 200, // Adjust the width as needed
              height: 200, // Adjust the height as needed
            ),
            const SizedBox(height: 20),
            Text(
              "Register as",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
                        const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Get.to(() => RootPage(role: Role.donor));
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.blue,
                elevation: 5,
              ),
              child: const Text(
                'Donor',
                style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 255, 255, 236)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => RootPage(role: Role.user));
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.green,
                elevation: 5,
              ),
              child: const Text(
                'User',
                style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 255, 255, 236)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
