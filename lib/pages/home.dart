import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:film/pages/detail_page.dart';

import 'package:film/services/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DocumentSnapshot> movies = [];
  String userName = "User";

  @override
  void initState() {
    super.initState();
    fetchMovies();
    fetchUserName();
  }

  Future<void> fetchMovies() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('movies').get();
    setState(() {
      movies = snapshot.docs;
    });
  }

  Future<void> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print("✅ Current UID: ${user.uid}");
        String email = user.email ?? "";
        QuerySnapshot snapshot = await DatabaseMethods().getUserbyemail(email);
        if (snapshot.docs.isNotEmpty) {
          String name = snapshot.docs[0]['Name'];
          print(" Name from Firestore by email: $name");
          setState(() {
            userName = name;
          });
        } else {
          print(" No user found with email $email");
        }
      } else {
        print(" No user is logged in.");
      }
    } catch (e) {
      print(" Error fetching user name: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: movies.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                     Row(
                         children: [
                           ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                               child: const Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 204, 151, 7),
                                 size: 40,
                                ),
                              ),
                           const SizedBox(width: 10),
                          Text(
                            "Hello, $userName",
                            style: const TextStyle(
                             color: Colors.white,
                             fontSize: 20,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                      const Spacer(),
                      InkWell(
                       onTap: () {
                        Navigator.pushReplacement(
                           context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                         );
                      },
                      child: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 30,
                     ),
                   ),
                  ],
               ),
                      const SizedBox(height: 10),
                      const Text(
                        "Welcome To",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const Row(
                        children: [
                          Text(
                            "Filmy",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Fun",
                            style: TextStyle(
                                color: Color(0xffedb41d),
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CarouselSlider(
                        options: CarouselOptions(
                            height: 200, autoPlay: true, enlargeCenterPage: true),
                        items: movies.map((movie) {
                          return Builder(
                            builder: (BuildContext context) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  movie['Image'],
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "Top Trending Movies",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 280,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: movies.map((movie) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailPage(
                                      image: movie['Image'],
                                      name: movie['Name'],
                                      shortdetail: movie['ShortDetail'],
                                      moviedetail: movie['MovieDetail'],
                                      price: movie['Price'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 220,
                                margin: const EdgeInsets.only(right: 16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        movie['Image'],
                                        height: 220,
                                        width: 220,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      margin: const EdgeInsets.only(top: 180),
                                      width: 220,
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie['Name'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            movie['ShortDetail'],
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
