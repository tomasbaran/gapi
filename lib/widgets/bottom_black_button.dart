import 'package:flutter/material.dart';

class BottomBlackButton extends StatelessWidget {
  BottomBlackButton({
    required this.title,
    required this.onTap,
  });
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.only(top: 15),
        height: 50,
        width: double.infinity,
        color: Colors.black87,
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      onTap: () => onTap(),
    );
  }
}
