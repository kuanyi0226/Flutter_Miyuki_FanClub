import 'package:flutter/material.dart';
import 'package:project5_miyuki/materials/MyText.dart';
import 'package:project5_miyuki/materials/colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('プライバシーポリシー\nPrivacy Policy')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              //What is the Privacy Policy
              Text(
                '1. What is the Privacy Policy?',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Effective June 27, 2023\n\n' +
                    'In the privacy policy, we will tell you what kinds of data ${APPNAME_EN} collect. Also, you will know how we use it.\n' +
                    'Here we promise you, any of your data will only be use in this APP: ${APPNAME_EN}.\n',
                style: TextStyle(fontSize: 15),
              ),
              //What information do we collect?
              Text(
                '2. What information do we collect?',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                color: theme_dark_grey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '(1) Your Email\n' +
                        '(2) Your UserName(You can change it whenever you want)\n' +
                        '(3) The amount of YUKI Coin you have in this app\n' +
                        '(4) Whether you are vip\n' +
                        '(5) The Comments you commented in the public homepage or a song page\n' +
                        '(6) The Resources you want to share via Google Survey Sheet\n' +
                        '(7) The Images or Video you uploaded\n\n' +
                        '※Vip means the friends of developer, you can not get Vip by cash(we will not sell the vip!)\n\n'
                            '※(Important!!!) We can not see your password in backend, so only you can see or modify it through "Forgot Password"',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              //How will we use your data
              Text(
                '3. How will we use your data?',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'We will use your data only in this app. Your email will not be seen by other users, but any of your comments will be along with your "User Name", so please politely and carefully make a comment.\n\n' +
                    'The developer has the ultimate right to modify your Yuki Coin, users can not have oppositions',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ));
  }
}
