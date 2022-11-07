import 'package:flutter/material.dart';
import 'package:gapi/model/my_globals.dart';
import 'package:gapi/notifiers/review.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:gapi/widgets/five_star_row.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ReviewContainer extends StatelessWidget {
  final bool isViewOnly;
  final String? rating1;
  final String? rating2;

  const ReviewContainer({
    Key? key,
    this.rating1,
    this.rating2,
    this.isViewOnly = true,
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
        isViewOnly
            ? Column(
                children: [
                  RatingBarIndicator(
                    rating: double.parse(rating1 ?? '0'),
                    itemSize: 28,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: kSizeBtwRankings),
                  RatingBarIndicator(
                    rating: double.parse(rating2 ?? '0'),
                    itemSize: 28,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.black87,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  RatingBar.builder(
                    itemSize: 28,
                    itemBuilder: (context, _) => MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: const Icon(
                        Icons.star,
                        color: kPrimaryColor2,
                      ),
                    ),
                    onRatingUpdate: (rating) {
                      Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).changeReview1(rating);
                      print(rating);
                    },
                  ),
                  SizedBox(height: kSizeBtwRankings),
                  RatingBar.builder(
                    itemSize: 28,
                    itemBuilder: (context, _) => MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: const Icon(
                        Icons.star,
                        color: kPrimaryColor2,
                      ),
                    ),
                    onRatingUpdate: (rating) {
                      Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).changeReview2(rating);
                      print(rating);
                    },
                  ),
                ],
              ),
        !isViewOnly
            ? Container()
            : Column(
                children: [
                  Text(
                    Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).review1 == 0
                        ? rating1.toString()
                        : Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).review1.toString(),
                    style: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).review1 == 0
                        ? tsReviewValue.copyWith(color: kColorAlmostBlack)
                        : tsReviewValue,
                  ),
                  SizedBox(height: kSizeBtwRankings),
                  Text(
                    Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).review2 == 0
                        ? rating2.toString()
                        : Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).review2.toString(),
                    style: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).review2 == 0
                        ? tsReviewValue.copyWith(color: kColorAlmostBlack)
                        : tsReviewValue,
                  ),
                ],
              )
      ],
    );
  }
}
