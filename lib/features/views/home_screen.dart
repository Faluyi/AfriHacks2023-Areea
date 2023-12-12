import 'package:areea/const.dart';
import 'package:areea/features/controllers/post_controller.dart';
import 'package:areea/features/views/home_page.dart';
import 'package:areea/features/views/upload_post_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  String? userID;

  HomeScreen({
    super.key,
    this.userID,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostController postController = Get.put(PostController());

  String fullName = '';
  String email = '';
  String imageProfile =
      'https://firebasestorage.googleapis.com/v0/b/dating-app-a5c06.appspot.com/o/Place%20Holder%2Fprofile_avatar.jpg?alt=media&token=dea921b1-1228-47c2-bc7b-01fb05bd8e2d';

  retrieveUserInfo() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userID)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        if (snapshot.data()!["imageProfile"] != null) {
          setState(() {
            imageProfile = snapshot.data()!["imageProfile"];
          });
        }
        setState(() {
          fullName = snapshot.data()!["fullName"];
          email = snapshot.data()!["email"];
        });
      }
    });
  }

  int _currentIndex = 0;

  late PageController pageController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    pageController = PageController();

    retrieveUserInfo();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                fullName,
              ),
              accountEmail: Text(
                email,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(imageProfile),
              ),
              decoration: ShapeDecoration(color: Colors.blueAccent, shape: RoundedRectangleBorder())
            ),
            ListTile(
              leading: const Icon(Icons.gamepad,),
              title: const Text('Fun & Games'),
              onTap: () {
                setState(() {
                  navigationTapped;
                  Navigator.pop(context); // Close the drawer
                });
              },
            ),

            const Spacer(), // Added to push the following items to the bottom
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      backgroundColor: backGroundColor,
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: backGroundColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: primaryColor),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: primaryColor),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, color: primaryColor),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: primaryColor), label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                  Icons.account_circle_outlined, color: primaryColor),
              label: ""),
        ],
        onTap:
        navigationTapped
      ),
      body:

      PageView(
        controller: pageController,
        children: [
          HomePage(),
          HomePage(),
          UploadPostPage(),
          HomePage(),
          HomePage(),
        ],
        onPageChanged: onPageChanged,
      ),
    );
  }
}
