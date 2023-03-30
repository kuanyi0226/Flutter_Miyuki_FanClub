import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import './class/User.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(controller: controller),
        actions: [
          IconButton(
            onPressed: () {
              final name = controller.text;
              createUser(name: name);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<User>>(
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong!');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;

            return ListView(
              children: users.map(buildUser).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        stream: readUsers(),
      ),
    );
  }
}

Widget buildUser(User user) => ListTile(
      leading: CircleAvatar(child: Text('${user.age}')),
      title: Text(user.name),
      subtitle: Text(user.birthday.toIso8601String()),
    );

//create data
Future createUser({required String name}) async {
  //Reference t document
  final docUser = FirebaseFirestore.instance.collection('users').doc('my-id');
  final now = DateTime.now();

  final user = User(
    id: docUser.id,
    name: name,
    age: 21,
    birthday: DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    ),
  );
  final json = user.toJson();

  //create document and write data to Firebase
  await docUser.set(json);
}

//read data
Stream<List<User>> readUsers() =>
    FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
