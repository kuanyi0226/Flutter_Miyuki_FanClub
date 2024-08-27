import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../services/firebase/auth_service.dart';

import '../../materials/colors.dart';
import '../../class/MiyukiUser.dart';

import '../../widgets/MyTextField.dart';
import '../../widgets/MyButton.dart';
import '../../widgets/SquareTile.dart';

class RegisterPage extends StatefulWidget {
  Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState(onTap: onTap);
}

class _RegisterPageState extends State<RegisterPage> {
  Function()? onTap;
  _RegisterPageState({required onTap});

  //controller for text
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //sign up method
  void signUp() async {
    //show loading circle(continuous)
    showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));
    //try to creating user
    try {
      //check whether the name is empty
      if (_userNameController.text.trim() == '') {
        //pop the loading circle: failed to sign up
        Navigator.pop(context);
        _showErrorMessage(AppLocalizations.of(context)!.type_username);
        return;
      }
      //check the number of password is longer than 6
      if (_passwordController.text.trim().length < 6) {
        //pop the loading circle: failed to sign up
        Navigator.pop(context);
        _showErrorMessage(AppLocalizations.of(context)!.password_length_error);
        return;
      }
      //check whether the confirm password is correct
      if (_passwordController.text.trim() ==
          _confirmPasswordController.text.trim()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        //pop the loading circle: failed to sign up
        Navigator.pop(context);
        //create miyuki user info
        MiyukiUser.createUser(
            name: _userNameController.text.trim(),
            email: _emailController.text.trim());
      } else {
        //pop the loading circle: successfully sign up
        Navigator.pop(context);
        //confirm password doesn't match
        _showErrorMessage(AppLocalizations.of(context)!.password_not_match);
      }
    } on FirebaseAuthException catch (err) {
      //pop the loading circle: failed to sign up
      Navigator.pop(context);
      //show error to user
      _showErrorMessage(err.code);
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
            //welcome text
            Text(
              AppLocalizations.of(context)!.sign_up_warning,
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            //user name textfield
            MyTextField(
              controller: _userNameController,
              hintText: AppLocalizations.of(context)!.user_name,
              obscureText: false,
            ),
            const SizedBox(height: 5),
            //email textfield
            MyTextField(
              controller: _emailController,
              hintText: AppLocalizations.of(context)!.email,
              obscureText: false,
            ),
            const SizedBox(height: 5),
            //password textfield
            MyTextField(
              controller: _passwordController,
              hintText: AppLocalizations.of(context)!.password,
              obscureText: true,
            ),
            const SizedBox(height: 5),
            //confirm-password textfield
            MyTextField(
              controller: _confirmPasswordController,
              hintText: AppLocalizations.of(context)!.password_type_again,
              obscureText: true,
            ),
            const SizedBox(height: 5),
            //sign in button
            MyButton(
                onTap: signUp, text: AppLocalizations.of(context)!.sign_up),
            const SizedBox(height: 15),
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
                Text(AppLocalizations.of(context)!.already_have_account),
                const SizedBox(width: 4),
                GestureDetector(
                  //stateful: must add widget.
                  onTap: widget.onTap,
                  child: Text(
                    AppLocalizations.of(context)!.login,
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
