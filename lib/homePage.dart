import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/addTransactionPage.dart';
import 'package:project/transactionListPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int screenIndex = 0;

  final mobileScreens = [
    Homepage(),
    AddTransactionForm(),
    TransactionListPage(),
    Container()
  ];

  void signOutDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: "Logout",
      desc: "Are you sure you want to log out?",
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        FirebaseAuth.instance.signOut();
      },
      btnOkText: "Yes, Logout",
      btnCancelText: "Cancel",
      btnOkColor: Colors.green,
      btnCancelColor: Colors.red,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mobileScreens[screenIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 228, 187, 118),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  screenIndex = 0;
                });
              },
              icon: Text(
                "🏠",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  screenIndex = 1;
                });
              },
              icon: Text(
                "💵",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  screenIndex = 2;
                });
              },
              icon: Text(
                "📋",
                style: TextStyle(
                  fontSize: 30, // ปรับขนาด emoji
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                signOutDialog(context);
              },
              icon: Text(
                "🚪",
                style: TextStyle(
                  fontSize: 30, // ปรับขนาด emoji
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final user = FirebaseAuth.instance.currentUser;

  void signUserOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/budget.png',
              width: 200,
            ),
            SizedBox(height: 12),
            Text(
              "Welcome to Keptang App",
              style: GoogleFonts.bigShouldersDisplay(
                  fontSize: 25,
                  color: Color.fromARGB(255, 228, 179, 95),
                  fontWeight: FontWeight.w800),
            ),
            Text(
              "Have you saved Today?",
              style: GoogleFonts.bigShouldersDisplay(
                  fontSize: 18,
                  color: const Color.fromARGB(255, 71, 94, 91),
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
