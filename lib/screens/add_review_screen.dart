import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gapi/model/my_globals.dart';
import 'package:gapi/model/review.dart';
import 'package:gapi/screens/services/firebase_services.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:gapi/widgets/review_container.dart';
import 'package:provider/provider.dart';
import 'package:gapi/notifiers/review.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key, required this.workerName, required this.workerId});
  final String workerName;
  final String workerId;

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  TextEditingController myController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    myController.dispose();
  }

  String? comment;
  @override
  Widget build(BuildContext context) {
    // ReviewModel loadReviewModel = FirebaseServices().readReviewByUserOnFirebase(workerId: workerId);

    String? comment = myController.text;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Añade reseña: ${widget.workerName}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: kColorDarkGrey,
        // foregroundColor: kPrimaryColor2,
      ),
      body: FutureBuilder(
          future: FirebaseServices().readReviewByUserOnFirebase(workerId: widget.workerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.done) /* {
              return Text('loading');
            } else if (snapshot.hasData)  */

            {
              if (snapshot.data!.rating1 != null) {
                Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating1 =
                    double.parse(snapshot.data!.rating1.toString());
              }
              if (snapshot.data!.rating2 != null) {
                Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating2 =
                    double.parse(snapshot.data!.rating2.toString());
                // BUG: the next line causes error
                //   Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false)
                //       .changeReview2(double.parse(snapshot.data!.rating2.toString()));
              }

              print('tutu: ${snapshot.hasData}');
              print('commentText: ${snapshot.data!.commentText}');
              if (snapshot.data!.commentText != null) {
                myController.text = snapshot.data!.commentText!;
                comment = myController.text;
              }
              return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(height: 16),
                ReviewContainer(
                  isViewOnly: false,
                  rating1: snapshot.data!.rating1 == null ? '0' : snapshot.data!.rating1.toString(),
                  rating2: snapshot.data!.rating2 == null ? '0' : snapshot.data!.rating2.toString(),
                  // rating1: '0',
                  // rating2: '0',
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: myController,
                    onChanged: (value) {
                      comment = value;
                      print('onChanged: $value');
                    },
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Comentario',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                BottomButton(
                    title: 'Confirmar reseña',
                    onTap: () async {
                      print('workerId: ${widget.workerId}');
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
                          await FirebaseServices().writeReviewToWorkerOnFirebase(
                            workerId: widget.workerId,
                            rating1: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating1,
                            rating2: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating2,
                          );

                          FirebaseServices().writeReviewToReviewsOnFirebase(
                            workerId: widget.workerId,
                            rating1: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating1,
                            rating2: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating2,
                          );
                        } else {
                          print('commentarios: $comment');

                          await FirebaseServices().writeReviewToWorkerOnFirebase(
                            workerId: widget.workerId,
                            rating1: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating1,
                            rating2: Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).tmpRating2,
                            comment: comment,
                          );

                          FirebaseServices().writeReviewToReviewsOnFirebase(
                            workerId: widget.workerId,
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
                            duration: Duration(seconds: 5),
                            content: Text(
                              'Tu reseña ha sido añadida. Recárga la página para verla.',
                              style: tsSnackBarTitle,
                            ),
                            backgroundColor: kPrimaryColor2,
                          ),
                        );
                      }
                    }),
              ]);
            } else {
              return Text('?');
            }
          }),
    );
  }
}
