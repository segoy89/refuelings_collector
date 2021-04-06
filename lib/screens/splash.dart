import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Refuelings Collector',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
