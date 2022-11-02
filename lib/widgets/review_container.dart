import 'package:flutter/material.dart';
import 'package:gapi/theme/style_constants.dart';

class ReviewContainer extends StatelessWidget {
  const ReviewContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsabilidad',
              style: tsReviewCategory,
            ),
            SizedBox(height: kSizeBtwRankings),
            Text(
              'Calidad',
              style: tsReviewCategory,
            ),
          ],
        ),
        Column(
          children: [
            FiveStarRow(),
            SizedBox(height: kSizeBtwRankings),
            FiveStarRow(),
          ],
        ),
        Column(
          children: [
            Text(
              '?',
              style: tsReviewCategoryResult,
            ),
            SizedBox(height: kSizeBtwRankings),
            Text(
              '?',
              style: tsReviewCategoryResult,
            ),
          ],
        ),
      ],
    );
  }
}

class FiveStarRow extends StatelessWidget {
  const FiveStarRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star_border_outlined),
        Icon(Icons.star_border_outlined),
        Icon(Icons.star_border_outlined),
        Icon(Icons.star_border_outlined),
        Icon(Icons.star_border_outlined),
      ],
    );
  }
}
