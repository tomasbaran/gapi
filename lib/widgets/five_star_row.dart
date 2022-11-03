import 'package:flutter/material.dart';

class FiveStarRow extends StatefulWidget {
  const FiveStarRow({
    Key? key,
  }) : super(key: key);

  @override
  State<FiveStarRow> createState() => _FiveStarRowState();
}

class _FiveStarRowState extends State<FiveStarRow> {
  bool showFullstar = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          5,
          (index) => GestureDetector(
                onTap: () => setState(() {
                  showFullstar = !showFullstar;
                  print(showFullstar);
                }),
                child: Icon(
                  showFullstar ? Icons.star : Icons.star_border_outlined,
                  size: 28,
                ),
              )),
    );
  }
}
