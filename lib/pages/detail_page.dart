import 'package:film/pages/home.dart';
// import 'package:film/services/constant.dart';
import 'package:film/services/database.dart';
import 'package:film/services/shared__pref.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  String image, name, shortdetail, moviedetail, price;

  DetailPage({
    required this.image,
    required this.name,
    required this.shortdetail,
    required this.moviedetail,
    required this.price,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? currentdate;
  String? id;
  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  List<String> getFormattedDates() {
    final now = DateTime.now();
    final formatter = DateFormat('EEE d');
    return List.generate(7, (index) {
      final date = now.add(Duration(days: index));
      return formatter.format(date);
    });
  }

  int track = 0, quantity = 1, total = 0;
  bool eight = false, ten = false, six = false;
  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    total = int.parse(widget.price);
    getthesharedpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dates = getFormattedDates();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xff1e232c),
      body: Stack(
        children: [
          SizedBox(
            height: screenHeight * 0.55,
            width: screenWidth,
            child: Image.asset(widget.image, fit: BoxFit.cover),
          ),
        Positioned(
  top: 40,
  left: 20,
  child: Material(
    elevation: 3.0,
    borderRadius: BorderRadius.circular(30.0),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()), // ← اسم صفحة الهوم
          );
        },
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
      ),
    ),
  ),
),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.59,
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
              decoration: const BoxDecoration(
                color: Color(0xff1e232c),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.shortdetail,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.moviedetail,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16.0,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Select Date",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dates.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              track = index;
                              currentdate = dates[index];
                              setState(() {});
                            },
                            child: Container(
                              width: 100.0,
                              margin: const EdgeInsets.only(right: 12.0),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 221, 201, 51),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:
                                      track == index
                                          ? Colors.white
                                          : const Color.fromARGB(255, 0, 0, 0),
                                  width: 4.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  dates[index],
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 12, 12, 12),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      "Select Time Slot",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTimeBox("08:00 PM", eight, () {
                          setState(() {
                            eight = true;
                            ten = false;
                            six = false;
                          });
                        }),
                        buildTimeBox("10:00 PM", ten, () {
                          setState(() {
                            ten = true;
                            eight = false;
                            six = false;
                          });
                        }),
                        buildTimeBox("06:00 PM", six, () {
                          setState(() {
                            six = true;
                            eight = false;
                            ten = false;
                          });
                        }),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                    total += int.parse(widget.price);
                                  });
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  color: Color(0xffeed51e),
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (quantity > 1) {
                                    setState(() {
                                      quantity--;
                                      total -= int.parse(widget.price);
                                    });
                                  }
                                },
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            // makePayment(context, total.toString());
                            saveBookingToFirestore(context);
                          },
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xffeed51e),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.white,
                                width: 3.0,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Total: \$${total}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  "Book Now",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeBox(String time, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child:
          selected
              ? Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xffeed51e),
                      width: 4.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    time,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 221, 201, 51),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  time,
                  style: const TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
    );
  }

  Future<void> saveBookingToFirestore(BuildContext context) async {
    try {
      if (id == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User not logged in")));
        return;
      }

      Map<String, dynamic> userMovieMap = {
        "Movie": widget.name,
        "MovieImage": widget.image,
        "Date": currentdate,
        "Time":
            eight
                ? '08:00 PM'
                : ten
                ? "10:00 PM"
                : "06:00 PM",
        "Quantity": quantity.toString(),
        "Total": total.toString(),
        "Timestamp": DateTime.now().toIso8601String(),
      };

      await DatabaseMethods().addUserBooking(userMovieMap, id!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Ticket has been booked successfully",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
      );
    } catch (e) {
      print("Booking error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}
