import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:gapi/widgets/review_container.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Container(
            padding: EdgeInsets.all(12),
            // color: kGreen,
            color: rating < 2.5 ? kColorRed : kColorGreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commentBody,
                  style: tsReviewCategoryComment,
                ),
                const SizedBox(
                  height: 8,
                ),
                RatingBarIndicator(
                  unratedColor: Colors.transparent,
                  rating: rating,
                  itemSize: 8,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          '${DateFormat('yyyy-MM-dd').format(date)}',
          style: tsReviewCategoryCommentDate,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
