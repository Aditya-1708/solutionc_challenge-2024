import 'package:flutter/material.dart';
import 'package:nourishnet/features/donate/models/donation_Model.dart';

import 'package:nourishnet/repository/Donation_Repository/donation_repository.dart';
import 'package:nourishnet/widgets/app_bar.dart';
import 'package:nourishnet/widgets/bottom_navbar_donor.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  int currentPage = 1;
  final _formKey = GlobalKey<FormState>();
  final DonationRepository _donationRepository = DonationRepository();
  late String _amountOfFood;
  late String _timings;
  late String _location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Donate',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Food Servings',
                  prefixIcon: Icon(Icons.food_bank),
                ),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount of food';
                  }
                  return null;
                },
                onSaved: (value) {
                  _amountOfFood = value!;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Timings',
                  prefixIcon: Icon(Icons.access_time),
                ),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the timings';
                  }
                  return null;
                },
                onSaved: (value) {
                  _timings = value!;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on),
                ),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _location = value!;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      DonationModel donation = DonationModel(
                        foodServings: _amountOfFood,
                        timings: _timings,
                        location: _location,
                      );
                      _donationRepository.CreateDonation(donation);
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust border radius here
                  ),
                  minWidth: double.infinity,
                  color: const Color.fromARGB(255, 89, 126, 82),
                  textColor: Colors.white,
                  child: const Text('Donate'),
                ),
              ),
            ],
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
}
