import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:gapi/widgets/review_container.dart';

class AddReviewScreen extends StatelessWidget {
  const AddReviewScreen({super.key, required this.workerName});
  final String workerName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Añade reseña: $workerName')),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SizedBox(height: 16),
        ReviewContainer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comment',
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        BottomButton(title: 'Confirmar reseña', onTap: () => null),
      ]),
    );
  }
}