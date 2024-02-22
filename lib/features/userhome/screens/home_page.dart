import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nourishnet/features/donate/models/donation_Model.dart';
import 'package:nourishnet/notification_service.dart';
import 'package:nourishnet/repository/Donation_Repository/donation_repository.dart';
import 'package:nourishnet/widgets/bottom_navbar_user.dart';
import 'package:nourishnet/widgets/custom_card.dart';
import 'package:nourishnet/widgets/donations_donations.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int currentPage = 0;
  List<DonationModel> donations = [];
  NotificationServices notificationService = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.foregroundMessage();
    notificationService.firebaseInit(context);
    notificationService.isRefreshToken();
    notificationService.getDeviceToken().then((value) {
      print("Device Token $value");
    });
    fetchDonations();
  }

  void fetchDonations() async {
    try {
      var fetchedDonations = await DonationRepository.instance.fetchDonations();
      setState(() {
        donations = fetchedDonations;
      });
    } catch (error) {
      // Handle error
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: const Text(
          'NourishNet',
          style: TextStyle(
            fontSize: 35,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              DonationDriveContainer(
                  donationDriveName: 'Taj,banglore',
                  timings: '12:00am-1:00am',
                  mealsServed: 120),
              SizedBox(
                height: 10,
              ),
              
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBarUser(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
      ),
    );
  }
}
