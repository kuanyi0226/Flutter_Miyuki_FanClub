import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project5_miyuki/services/auth_service.dart';

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
      if (_passwordController.text.trim() == '') {
        //pop the loading circle: failed to sign up
        Navigator.pop(context);
        _showErrorMessage('Please type your user name');
        return;
      }
      //check the number of password is longer than 6
      if (_passwordController.text.trim().length < 6) {
        //pop the loading circle: failed to sign up
        Navigator.pop(context);
        _showErrorMessage('Passwords has to be at least 6 letters');
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
            _userNameController.text.trim(), _emailController.text.trim());
      } else {
        //pop the loading circle: successfully sign up
        Navigator.pop(context);
        //confirm password doesn't match
        _showErrorMessage('Passwords don\'t match!');
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
            const SizedBox(height: 50),
            //logo
            Image.asset(
              'assets/images/login_icon.jpg',
              height: 150,
            ),
            const SizedBox(height: 15),
            //welcome text
            Text(
              '中島みゆきファンになりたい！',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 15),
            //user name textfield
            MyTextField(
              controller: _userNameController,
              hintText: 'User Name',
              obscureText: false,
            ),
            const SizedBox(height: 5),
            //email textfield
            MyTextField(
              controller: _emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 5),
            //password textfield
            MyTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 5),
            //confirm-password textfield
            MyTextField(
              controller: _confirmPasswordController,
              hintText: 'ConFirm Password',
              obscureText: true,
            ),
            const SizedBox(height: 5),
            //sign in button
            MyButton(onTap: signUp, text: 'Sign Up'),
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
                    child: Text('Or Continue With'),
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
            SizedBox(height: 20.0),
            //sign in with google
            SquareTile(
              imagePath: 'assets/images/google_icon.png',
              onTap: () async {
                AuthService().signInWithGoogle();
                try {
                  final user = await FirebaseAuth.instance.currentUser!;
                  final list = await FirebaseAuth.instance
                      .fetchSignInMethodsForEmail(user.email!);
                  if (list.isEmpty) {
                    MiyukiUser.createUser('No Name', user.email!);
                  }
                } catch (err) {
                  await Future.delayed(Duration(seconds: 3));
                  final user = await FirebaseAuth.instance.currentUser!;
                  final list = await FirebaseAuth.instance
                      .fetchSignInMethodsForEmail(user.email!);
                  if (list.isEmpty) {
                    MiyukiUser.createUser('No Name', user.email!);
                  }
                }
              },
            ),
            SizedBox(height: 20.0),
            //not a member register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                const SizedBox(width: 4),
                GestureDetector(
                  //stateful: must add widget.
                  onTap: widget.onTap,
                  child: Text(
                    'Login now',
                    style: TextStyle(
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
