import 'package:flutter/material.dart';
import 'package:gapi/model/comment.dart';
import 'package:gapi/screens/worker_detail_screen.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:gapi/widgets/comment.dart';

class WorkerContainer extends StatelessWidget {
  const WorkerContainer({
    Key? key,
    required this.workerName,
    required this.categoryName,
    required this.phoneNumber,
    required this.workerId,
    required this.workerRanking,
    this.workerAllRatingsCount,
    this.workerAllCommentsCount,
    this.rating1,
    this.rating2,
    this.comments = const [],
  }) : super(key: key);
  final String workerName;
  final String categoryName;
  final String phoneNumber;
  final String workerId;
  final String workerRanking;
  final String? workerAllRatingsCount;
  final String? workerAllCommentsCount;
  final String? rating1;
  final String? rating2;
  final List<CommentModel> comments;

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
                    rating1: rating1,
                    rating2: rating2,
                    comments: comments,
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
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: tsWorkerContainerTitle,
                      ),
                      Text('reseñas: ' + (workerAllRatingsCount == null ? '0' : workerAllRatingsCount.toString())),
                      Text('comentarios: ' + (workerAllCommentsCount == null ? '0' : workerAllCommentsCount.toString())),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: workerAllRatingsCount == '0'
                        ? Colors.white70
                        : workerRanking.characters.first == '-'
                            ? kColorRed
                            : kPrimaryColor2,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    workerAllRatingsCount == '0' ? '?' : workerRanking + ' %',
                    style: TextStyle(
                      color: workerAllRatingsCount == '0'
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
