import 'package:flutter/material.dart';
import 'package:gapi/screens/worker_detail_screen.dart';
import 'package:gapi/theme/style_constants.dart';

class WorkerContainer extends StatelessWidget {
  const WorkerContainer({
    Key? key,
    required this.workerName,
    required this.categoryName,
    required this.phoneNumber,
  }) : super(key: key);
  final String workerName;
  final String categoryName;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WorkersDetailScreen(
                    workerName: workerName,
                    categoryName: categoryName,
                    phoneNumber: phoneNumber,
                  ))),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kPrimaryColorLight,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workerName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text('calificaciones: 0'),
                  Text('reseñas: 0'),
                ],
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.all(Radius.circular(8))),
                child: const Text(
                  '? %',
                  style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
