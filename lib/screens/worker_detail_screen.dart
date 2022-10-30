import 'package:flutter/material.dart';
import 'package:gapi/widgets/bottom_black_button.dart';

class WorkersDetailScreen extends StatelessWidget {
  final String categoryName;
  final String phoneNumber;
  final String workerName;
  const WorkersDetailScreen({Key? key, required this.workerName, required this.categoryName, required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          margin: EdgeInsets.all(32),
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(32),
            ),
          ),
          child: Center(
            child: Text(
              '? %',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
            ),
          ),
        ),
        Text(workerName),
        Text(phoneNumber),
        BottomBlackButton(title: '+ AÑADIR EVALUACIÓN', onTap: () => null),
      ]),
    );
  }
}
