import 'package:flutter/material.dart';

import '../materials/colors.dart';

import '../widgets/MyTextField.dart';
import '../widgets/MyButton.dart';
import '../widgets/SquareTile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controller for text
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  //sign in method
  void signIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme_purple,
      body: Center(
        child: Column(children: [
          const SizedBox(height: 50),
          //logo
          Image.asset(
            'assets/images/login_icon.jpg',
            height: 150,
          ),
          const SizedBox(height: 30),
          //welcome text
          Text(
            'みゆきさん、同じ時代に生まれてくれてありがとう！',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 30),
          //username textfield
          MyTextField(
            controller: _userNameController,
            hintText: 'Username',
            obscureText: false,
          ),
          const SizedBox(height: 10),
          //password textfield
          MyTextField(
            controller: _passwordController,
            hintText: 'Password',
            obscureText: true,
          ),
          const SizedBox(height: 10),
          //forgot password
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Forgot password?',
                  style: TextStyle(color: theme_dark_purple),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          //sign in button
          MyButton(onTap: signIn),
          const SizedBox(height: 30),
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
          SizedBox(height: 50.0),
          //sign in with google
          SquareTile(imagePath: 'assets/images/google_icon.png'),
          SizedBox(height: 30.0),
          //not a member register now
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Not a member?'),
              const SizedBox(width: 4),
              Text(
                'Register now',
                style: TextStyle(
                  color: theme_dark_purple,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
