import 'package:flutter/material.dart';
import 'package:gapi/theme/style_constants.dart';

class BottomButton extends StatelessWidget {
  BottomButton({
    required this.title,
    required this.onTap,
  });
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: Container(
          padding: const EdgeInsets.only(top: 15),
          height: 50,
          width: double.infinity,
          color: kColorAlmostBlack,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                color: kPrimaryColor2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
