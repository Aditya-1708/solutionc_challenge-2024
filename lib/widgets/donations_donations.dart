import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nourishnet/features/maps/screens/location_page.dart';

class DonationDriveContainer extends StatelessWidget {
  final String donationDriveName;
  final String timings;
  final int mealsServed;
  final VoidCallback? onTapLocation;

  const DonationDriveContainer({
    Key? key,
    required this.donationDriveName,
    required this.timings,
    required this.mealsServed,
    this.onTapLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapLocation,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    print('abhishek');
                    Get.to(() => LocationPage(
                          locationName: donationDriveName,
                        ));
                  },
                  child: Icon(Icons.location_on_outlined),
                ),
                SizedBox(width: 8),
                Text(donationDriveName),
              ],
            ),
            SizedBox(height: 8),
            Text("Timings: $timings"),
            SizedBox(height: 8),
            Text("Meals Served: $mealsServed"),
          ],
        ),
      ),
    );
  }
}
