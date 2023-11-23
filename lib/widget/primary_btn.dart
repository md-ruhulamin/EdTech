// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final Color? titlecolor;

  const RoundButton({required this.title, this.titlecolor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Color.fromARGB(255, 90, 236, 114),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: titlecolor, fontSize: 18),
        ),
      ),
    );
  }
}
