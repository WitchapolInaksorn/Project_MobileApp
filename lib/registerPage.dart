import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegistPageState();
}

class _RegistPageState extends State<Registerpage> {
  final FirebaseFirestore fireStoreUser = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void showAwesomeDialog(
      BuildContext context, String title, String message, DialogType type) {
    Color btnOkColor = Colors.red;

    if (type == DialogType.success) {
      btnOkColor = Colors.green;
    } else if (type == DialogType.error) {
      btnOkColor = Colors.red;
    }

    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.bottomSlide,
      title: title,
      desc: message,
      btnOkOnPress: () {
        if (type == DialogType.success) {
          FirebaseAuth.instance.signOut();
          Navigator.pop(context);
        }
      },
      btnOkColor: btnOkColor,
    ).show();
  }

  void signUserUp() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final user = FirebaseAuth.instance.currentUser;
        fireStoreUser.collection('Users').add({
          'userId': user!.uid,
          'email': emailController.text,
          'password': passwordController.text
        });

        Navigator.pop(context);

        showAwesomeDialog(context, "Success", "Account created successfully!",
            DialogType.success);
      } else if (passwordController.text != confirmPasswordController.text) {
        Navigator.pop(context); 
        showAwesomeDialog(
            context, "Create Fail", "Passwords not match!", DialogType.error);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      String errorMessage = "Something went wrong";
      if (e.code == 'email-already-in-use') {
        errorMessage = "This email is already in use.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format (use @gmail.com)";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password should be at least 6 characters.";
      }

      showAwesomeDialog(context, "Create Fail", errorMessage, DialogType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFE9D5),
      appBar: AppBar(
        backgroundColor: Color(0xFFEFE9D5),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Create Account',
                      style: GoogleFonts.oswald(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2DAA9E)),
                    ),
                    SizedBox(height: 18),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Get started and unlock the best experience',
                            style: GoogleFonts.oswald(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 72, 197, 185)),
                          ),
                          Text(
                            'You will enjoy with keptang app ツ',
                            style: GoogleFonts.oswald(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 72, 197, 185)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        fillColor: Color(0xFFB3D8A8),
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter an email';
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        fillColor: Color(0xFFA3D1C6),
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter a password';
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        fillColor: Color(0xFF7FBFAE),
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signUserUp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 108, 192, 189),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Color.fromARGB(255, 228, 255, 252),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
