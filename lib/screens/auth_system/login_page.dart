import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../class/MiyukiUser.dart';
import '../../materials/colors.dart';
import '../../services/firebase/auth_service.dart';

import '../../widgets/MyTextField.dart';
import '../../widgets/MyButton.dart';
import '../../widgets/SquareTile.dart';

import './forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState(onTap: onTap);
}

class _LoginPageState extends State<LoginPage> {
  Function()? onTap;
  _LoginPageState({required onTap});

  //controller for text
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //sign in method
  void signIn() async {
    //show loading circle(continuous)
    showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));
    //try to sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      //pop the loading circle: successfully login
      Navigator.pop(context);
    } on FirebaseAuthException catch (err) {
      String errMessage = err.code;
      if (err.code.toString() == 'user-not-found')
        errMessage = AppLocalizations.of(context)!.user_not_found;
      else if (err.code.toString() == 'wrong-password')
        errMessage = AppLocalizations.of(context)!.wrong_password;
      else if (err.code.toString() == 'invalid-email')
        errMessage = AppLocalizations.of(context)!.invalid_email;
      else if (err.code.toString() == 'channel-error')
        errMessage = AppLocalizations.of(context)!.channel_error;
      else if (err.code.toString() == 'wrong_password')
        errMessage = AppLocalizations.of(context)!.wrong_password;
      //pop the loading circle: failed to login
      Navigator.pop(context);
      //show error to user
      _showErrorMessage(errMessage);
    }
  }

  //pop the wrong email message
  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme_dark_purple,
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme_purple,
      body: Center(
        child: SingleChildScrollView(
          child: Column(children: [
            //logo
            Image.asset(
              'assets/images/login_icon.jpg',
              height: 150,
            ),
            const SizedBox(height: 15),
            //welcome text
            Text(
              'みゆきさん、同じ時代に生まれてくれてありがとう！',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 15),
            //email textfield
            MyTextField(
              controller: _emailController,
              hintText: AppLocalizations.of(context)!.email,
            ),
            const SizedBox(height: 10),
            //password textfield
            MyTextField(
              controller: _passwordController,
              hintText: AppLocalizations.of(context)!.password,
              obscureText: true,
            ),
            const SizedBox(height: 10),
            //forgot password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForGotPasswordPage())),
                    child: Text(
                      AppLocalizations.of(context)!.forgot_password,
                      style: TextStyle(
                          fontSize: 17,
                          color: theme_dark_purple,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            //sign in button
            MyButton(onTap: signIn, text: AppLocalizations.of(context)!.login),
            const SizedBox(height: 20),
            //or continue with
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                      child: Divider(
                    thickness: 0.5,
                    color: Colors.white,
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(AppLocalizations.of(context)!.or),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            //sign in with google
            SquareTile(
              imagePath: 'assets/images/google_icon.png',
              onTap: () async {
                AuthService().signInWithGoogle();
                try {
                  await Future.delayed(Duration(seconds: 3));
                  final user = await FirebaseAuth.instance.currentUser!;
                  var userInfo = await FirebaseFirestore.instance
                      .collection('miyukiusers')
                      .doc(user.email)
                      .get();
                  if (userInfo.exists == false) {
                    InitData.miyukiUser.coin = 1023;
                    await MiyukiUser.createUser(
                        name: 'No Name', email: user.email!);
                    InitData.miyukiUser = await MiyukiUser.readUser(
                        FirebaseAuth.instance.currentUser!.email!);
                  }
                } catch (err) {
                  //do again
                  await Future.delayed(Duration(seconds: 3));
                  final user = await FirebaseAuth.instance.currentUser!;
                  var userInfo = await FirebaseFirestore.instance
                      .collection('miyukiusers')
                      .doc(user.email)
                      .get();
                  if (userInfo.exists == false) {
                    InitData.miyukiUser.coin = 1023;
                    await MiyukiUser.createUser(
                        name: 'No Name', email: user.email!);
                    InitData.miyukiUser = await MiyukiUser.readUser(
                        FirebaseAuth.instance.currentUser!.email!);
                  }
                }
              },
            ),
            SizedBox(height: 10.0),
            //not a member register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.not_a_member),
                const SizedBox(width: 4),
                GestureDetector(
                  //stateful: must add widget.
                  onTap: widget.onTap,
                  child: Text(
                    AppLocalizations.of(context)!.sign_up,
                    style: TextStyle(
                      fontSize: 17,
                      color: theme_dark_purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
