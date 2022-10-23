import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start_page/second_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString(keyToken)));
}

class MyApp extends StatelessWidget {
  String? token;

  MyApp({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'test app', token: token),
    );
  }
}

const keyToken = 'keyToken';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.token})
      : super(key: key);

  final String title;
  final String? token;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailController =
  TextEditingController(text: 'Developer5@gmail.com');
  TextEditingController passController = TextEditingController(text: '123456');

  @override
  Widget build(BuildContext context) {
    if (widget.token != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SecondPage()));
      });
    }
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            const Text(
              'Увійдіть\nщоб продовжити',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    width: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.blue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.facebook),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Facebook',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    width: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/images/google.png')),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Google',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text(
                '---------- або--------',
                style: TextStyle(fontSize: 25),
              )
            ]),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Поштова скринька',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: passController,
                decoration: InputDecoration(
                  hintText: 'Пароль',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  'Забули пароль?',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                )),
            SizedBox(
              height: 20,
            ),
            FilledButton(
              onPressed: () async {
                var url = Uri.parse(
                    'http://restapi.adequateshop.com/api/authaccount/login');
                Map<String, String> body = {
                  'email': emailController.text,
                  'password': passController.text
                };
                Map<String, String> headers = {
                  'Content-Type': 'application/json'
                };

                var response = await http.post(url,
                    body: jsonEncode(body), headers: headers);

                if (response.statusCode == 200) {
                  print('Success');
                  Map<String, dynamic> body = jsonDecode(response.body);
                  Map<String, dynamic> data = body['data'];
                  String token = data['Token'];

                  final SharedPreferences prefs = await SharedPreferences
                      .getInstance();
                  await prefs.setString(keyToken, token);

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SecondPage()));
                } else {
                  print('Failure');
                }
              },
              child: Text('Увійти'),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(360, 40))),
            ),
          ],
        ),
      ),
    );
  }
}
