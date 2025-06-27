import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:film/pages/home.dart';
import 'package:film/pages/booking.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;
  late Home homePage;
  late Booking bookingPage;

  int currentTabIndex = 0;

  @override
  void initState() {
    homePage = const Home();
    bookingPage = const Booking();
    pages = [homePage, bookingPage];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: CurvedNavigationBar(
        index: currentTabIndex,
        backgroundColor: Colors.transparent,
        color: const Color(0xffedb41d), // الذهبي الأساسي
        buttonBackgroundColor: Colors.black,
        animationDuration: const Duration(milliseconds: 400),
        height: 60,
        items: const [
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.book, color: Colors.white, size: 30),
        ],
        onTap: (index) {
          setState(() {
            currentTabIndex = index;
          });
        },
      ),
      body: pages[currentTabIndex],
    );
  }
}
