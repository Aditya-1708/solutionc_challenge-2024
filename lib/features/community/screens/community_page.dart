import 'package:flutter/material.dart';
import 'package:nourishnet/widgets/bottom_navbar_user.dart';
import 'package:nourishnet/widgets/post_post.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int currentPage = 2;

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
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Community',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                PostWidget(
                  title: 'Ethiopian Express',
                  location: " Gondar , Ethiopia ",
                  imagePath: 'assets/posts1.png',
                  likes: 195,
                ),
                SizedBox(height: 10),
                PostWidget(
                  title: 'dragonfire',
                  location: ' Beijing , China ',
                  imagePath: 'assets/posts2.png',
                  likes: 123,
                ),
                SizedBox(height: 10),
                PostWidget(
                  title: 'Terribilis',
                  location: " Moscow , Russia ",
                  imagePath: 'assets/posts3.png',
                  likes: 149,
                ),
                SizedBox(height: 10),
                PostWidget(
                  title: 'Olive garden',
                  location: ' NewYork , USA ',
                  imagePath: 'assets/posts4.png',
                  likes: 170,
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
        ));
  }
}
