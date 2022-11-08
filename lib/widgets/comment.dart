import 'package:flutter/material.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:intl/intl.dart';

class Comment extends StatelessWidget {
  final String commentBody;
  final double rating;
  final DateTime date;
  const Comment({
    Key? key,
    required this.commentBody,
    required this.date,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Container(
            padding: EdgeInsets.all(12),
            // color: kGreen,
            color: rating < 2.5 ? kColorRed : kColorGreen,
            child: Text(
              commentBody,
              style: tsReviewCategoryComment,
            ),
          ),
        ),
        Text(
          '${DateFormat('yyyy-MM-dd').format(date)}: $rating  stars',
          style: tsReviewCategoryCommentDate,
        ),
      ],
    );
  }
}
