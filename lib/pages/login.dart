import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film/pages/bottomnav.dart';
import 'package:film/pages/home.dart';
import 'package:film/pages/signup.dart';
import 'package:film/services/database.dart';
import 'package:film/services/shared__pref.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: SingleChildScrollView(
            child: LoginForm(), // يستدعي ال StatefulWidget
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email = "", password = "", myname = "", myid = "", myimage = "";
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      QuerySnapshot querySnapshot = await DatabaseMethods().getUserbyemail(email);
      myname = "${querySnapshot.docs[0]["Name"]}";
      myid = "${querySnapshot.docs[0]["Id"]}";
      myimage = "${querySnapshot.docs[0]["Image"]}";

      await SharedPreferenceHelper().saveUserImage(myimage);
      await SharedPreferenceHelper().saveUserId(myid);
      await SharedPreferenceHelper().saveUserEmail(email);
      await SharedPreferenceHelper().saveUserDisplayName(myname);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()));
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong.";
      if (e.code == "user-not-found") {
        message = "No user found for that email.";
      } else if (e.code == "wrong-password") {
        message = "Wrong password provided by user.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(fontSize: 18.0, color: Colors.black)),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Welcome!", style: TextStyle(fontSize: 24, color: Colors.white70)),
        const SizedBox(height: 8),
        const Text("Login", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 30),

        const Text("Email", style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 5),
        TextField(
          controller: mailcontroller,
          onChanged: (value) => email = value,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter Email",
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: const Icon(Icons.email, color: Colors.white),
            filled: true,
            fillColor: Colors.grey[850],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 20),
const Text("Password", style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 5),
        TextField(
          controller: passwordcontroller,
          obscureText: true,
          onChanged: (value) => password = value,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter Password",
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: const Icon(Icons.lock, color: Colors.white),
            suffixIcon: const Icon(Icons.visibility, color: Colors.white),
            filled: true,
            fillColor: Colors.grey[850],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text("Forgot Password?", style: TextStyle(color: Color(0xffedb41d))),
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpPage()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Sign Up"),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                if (mailcontroller.text != "" && passwordcontroller.text != "") {
                  setState(() {
                    email = mailcontroller.text;
                    password = passwordcontroller.text;
                  });
                  userLogin();
                }
              },
              child: Container(
                width: 170,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    "LogIn",
                    style: TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}