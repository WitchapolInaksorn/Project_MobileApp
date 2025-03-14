import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  void showAwesomeDialog(
      BuildContext context, String title, String message, DialogType type) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.bottomSlide,
      title: title,
      desc: message,
      btnOkOnPress: () {
        if (type == DialogType.success) {
          Navigator.pop(context);
        }
      },
      btnOkColor: type == DialogType.success ? Colors.green : Colors.red,
    ).show();
  }

  Future passwordReset() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      if (mounted) {
        Navigator.pop(context);
        showAwesomeDialog(
          context,
          "Success",
          "Password reset link sent to your email.",
          DialogType.success,
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      String errorMessage = "An error occurred. Please try again.";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format (use @gmail.com)";
      }

      showAwesomeDialog(context, "Forgot Fail", errorMessage, DialogType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDCD7C9),
      appBar: AppBar(
        backgroundColor: Color(0xFFDCD7C9),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                'Forgot Password',
                style: GoogleFonts.oswald(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4B5945)),
              ),
              Text(
                'Enter your email to get a password reset link',
                style: GoogleFonts.oswald(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF66785F)),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  fillColor: Color(0xFF91AC8F),
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Your email',
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter your email';
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    passwordReset();
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9ABF80)),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                      color: Color(0xFF4B5945), fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
