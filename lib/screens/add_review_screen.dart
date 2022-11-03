import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gapi/model/my_globals.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:gapi/widgets/review_container.dart';
import 'package:provider/provider.dart';
import 'package:gapi/notifiers/review.dart';

class AddReviewScreen extends StatelessWidget {
  const AddReviewScreen({super.key, required this.workerName, required this.workerId});
  final String workerName;
  final String workerId;
  @override
  Widget build(BuildContext context) {
    String? comment;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Añade reseña: $workerName',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: kColorDarkGrey,
        // foregroundColor: kPrimaryColor2,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SizedBox(height: 16),
        ReviewContainer(isViewOnly: false),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comment',
              ),
              TextField(
                onChanged: (value) => comment = value,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(),
        ),
        BottomButton(
            title: 'Confirmar reseña',
            onTap: () {
              print('workerId: $workerId');
              print('date: ${DateTime.now()}');
              print('review1: ${Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).review1}');
              print('review2: ${Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).review2}');
              if (comment != null) {
                print('comment: $comment');
              }
            }),
      ]),
    );
  }
}
