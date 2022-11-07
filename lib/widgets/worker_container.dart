import 'package:flutter/material.dart';
import 'package:gapi/screens/worker_detail_screen.dart';
import 'package:gapi/theme/style_constants.dart';

class WorkerContainer extends StatelessWidget {
  const WorkerContainer({
    Key? key,
    required this.workerName,
    required this.categoryName,
    required this.phoneNumber,
    required this.workerId,
    required this.workerRanking,
  }) : super(key: key);
  final String workerName;
  final String categoryName;
  final String phoneNumber;
  final String workerId;
  final String workerRanking;

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
                    workerId: workerId,
                    workerRanking: workerRanking,
                  ))),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kColorLightGrey,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workerName,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: tsWorkerContainerTitle,
                      ),
                      Text('calificaciones: 0'),
                      Text('reseñas: 0'),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: workerRanking == 'null'
                        ? Colors.white70
                        : workerRanking.characters.first == '-'
                            ? kColorRed
                            : kPrimaryColor2,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    workerRanking == 'null' ? '?' : workerRanking + ' %',
                    style: TextStyle(
                      color: workerRanking == 'null'
                          ? Colors.black38
                          : workerRanking.characters.first == '-'
                              ? Colors.white
                              : kColorAlmostBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
