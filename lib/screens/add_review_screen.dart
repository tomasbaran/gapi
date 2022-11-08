import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gapi/model/my_globals.dart';
import 'package:gapi/screens/services/firebase_services.dart';
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
                'Comentario',
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
              print('review1: ${Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating1}');
              print('review2: ${Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating2}');

              if (Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating1 == 0 ||
                  Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating2 == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Hay que calificar todas cualidades.'),
                    backgroundColor: kColorRed,
                  ),
                );
              } else {
                if (comment == null) {
                  FirebaseServices().writeReviewToReviewOnFirebase(
                    workerId: workerId,
                    rating1: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating1,
                    rating2: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating2,
                  );
                  FirebaseServices().writeReviewToWorkerOnFirebase(
                    workerId: workerId,
                    rating1: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating1,
                    rating2: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating2,
                  );
                } else {
                  print('commentarios: $comment');
                  FirebaseServices().writeReviewToReviewOnFirebase(
                    workerId: workerId,
                    rating1: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating1,
                    rating2: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating2,
                    comment: comment,
                  );
                  FirebaseServices().writeReviewToWorkerOnFirebase(
                    workerId: workerId,
                    rating1: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating1,
                    rating2: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating2,
                    comment: comment,
                  );
                }
                Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).changeReview1(0);
                Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).changeReview2(0);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text(
                      'Tu reseña ha sido añadida.',
                      style: tsSnackBarTitle,
                    ),
                    backgroundColor: kPrimaryColor2,
                  ),
                );
              }
            }),
      ]),
    );
  }
}
