import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/lot_rememberer/lotRemember.dart';
import 'package:flutter_application_2/services/auth.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Carpark Home Test'),
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        actions: <Widget>[
          ElevatedButton.icon(
            icon: Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
            },
            label: Text('Log Out'),
          )
        ],
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const lotRemember()));
        },
        child: null,
      )),
    ));
  }
}
