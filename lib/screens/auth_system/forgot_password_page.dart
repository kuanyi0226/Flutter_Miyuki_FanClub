import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../materials/colors.dart';
import '../../widgets/MyTextField.dart';

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
          title: Text(AppLocalizations.of(context)!.password_reset_sent),
        ),
      );
    } on FirebaseAuthException catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: theme_dark_purple,
          title: Text('${err.message.toString()}\n\n' +
              AppLocalizations.of(context)!.password_reset_fail),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.password_reset),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.password_reset_info,
            style: TextStyle(
                fontSize: 20, color: theme_purple, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          //email textfield
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyTextField(
              controller: _emailController,
              hintText: AppLocalizations.of(context)!.email,
              obscureText: false,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _resetPassword,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                color: theme_purple,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.password_reset,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
