import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../materials/colors.dart';

import '../../widgets/MyTextField.dart';
import '../../widgets/MyButton.dart';

class ForGotPasswordPage extends StatefulWidget {
  ForGotPasswordPage({super.key});

  @override
  State<ForGotPasswordPage> createState() => _ForGotPasswordPageState();
}

class _ForGotPasswordPageState extends State<ForGotPasswordPage> {
  final _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future _resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: theme_dark_purple,
          title: Text('Password Reset Link Sent!\nPlease Check Your Email'),
        ),
      );
    } on FirebaseAuthException catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: theme_dark_purple,
          title: Text(
              '${err.message.toString()}\n\nPlease type the correct Email'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme_light_gray,
      appBar: AppBar(
        backgroundColor: theme_dark_purple,
        title: Text('Reset Password'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter Your Email\nwe will sent you a password reset link',
            style: TextStyle(
                fontSize: 20,
                color: theme_dark_purple,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          //email textfield
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyTextField(
              controller: _emailController,
              hintText: 'Email',
              obscureText: false,
            ),
          ),
          const SizedBox(height: 10),
          MyButton(onTap: _resetPassword, text: 'Reset Password'),
        ],
      ),
    );
  }
}
