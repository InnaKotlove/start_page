import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: FilledButton(child: Text('Logout'), onPressed: () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(keyToken);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => MyHomePage(title: 'Main', token: null)), (Route<dynamic> route) => false);
    },)),);
  }

}