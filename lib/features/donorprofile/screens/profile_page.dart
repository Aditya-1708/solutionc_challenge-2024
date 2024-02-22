import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nourishnet/features/donorprofile/screens/profile_settings_page.dart';
import 'package:nourishnet/repository/Authentication_Repository/authentication_repository.dart';
import 'package:nourishnet/widgets/bottom_navbar_donor.dart';

class DonorProfilePage extends StatefulWidget {
  const DonorProfilePage({Key? key}) : super(key: key);

  @override
  State<DonorProfilePage> createState() => _DonorProfilePageState();
}

class _DonorProfilePageState extends State<DonorProfilePage> {
  late User? currentUser;
  String? photoUrl;
  int currentPage = 3;

  @override
  void initState() {
    super.initState();
    final authRepo = AuthenticationRepository.instance;
    currentUser = authRepo.firebaseUser.value;
    authRepo.firebaseUser.listen((user) {
      setState(() {
        currentUser = user;
        if (user != null) {
          photoUrl = user.photoURL;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: const Text(
          'NourishNet',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const DonorProfilesetting();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: currentUser != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: photoUrl != null
                              ? NetworkImage(photoUrl!)
                              : const AssetImage('assets/DonorProfilePhoto.png')
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 20),
                        Divider(
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Royal Restaurant',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'royarestaurant',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildUserDetailItem(
                      icon: Icons.phone,
                      label: 'Phone',
                      // value: currentUser!.phoneNumber ?? 'N/A',
                      value: '74******51',
                    ),
                    const SizedBox(height: 10),
                    _buildUserDetailItem(
                      icon: Icons.location_on,
                      label: 'Location',
                      value: 'Benagluru, India', // Example location
                    ),
                    const SizedBox(height: 10),
                    _buildUserDetailItem(
                      icon: Icons.date_range,
                      label: 'Joined',
                      value: 'July 2021', // Example date
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "your posts",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                    const SizedBox(height: 5),
                    Image.asset('assets/Donorp1.png', height: 300, width: 300),
                    Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                    const SizedBox(height: 5),
                    Image.asset('assets/Donorp2.png', height: 300, width: 300),
                    Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                    const SizedBox(height: 5),
                    Image.asset('assets/Donorp3.png', height: 300, width: 300),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBarDonor(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
      ),
    );
  }

  Widget _buildUserDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.blueGrey,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
