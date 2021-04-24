import 'package:apitest_app/constants/bottom_dark_gradient.dart';
import 'package:flutter/material.dart';

class BottomTitle extends StatelessWidget {
  final String title;

  const BottomTitle({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: bottomGradient),
          padding: EdgeInsets.all(8),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
