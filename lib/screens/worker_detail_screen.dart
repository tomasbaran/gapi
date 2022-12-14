import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gapi/model/review.dart';
import 'package:gapi/model/my_globals.dart';
import 'package:gapi/notifiers/review.dart';
import 'package:gapi/screens/add_review_screen.dart';
import 'package:gapi/screens/login_screen.dart';
import 'package:gapi/screens/services/firebase_services.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:gapi/widgets/comment.dart';
import 'package:gapi/widgets/review_container.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'dart:async';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkersDetailScreen extends StatefulWidget {
  final String categoryName;
  final String phoneNumber;
  final String workerName;
  final String workerId;
  final String workerRanking;
  final String? workerRatingsCount;
  final String? workerCommentsCount;
  final String? rating1;
  final String? rating2;
  final List<ReviewModel> comments;
  const WorkersDetailScreen({
    Key? key,
    required this.workerName,
    required this.workerId,
    required this.categoryName,
    required this.phoneNumber,
    required this.workerRanking,
    this.rating1,
    this.rating2,
    this.workerCommentsCount,
    this.workerRatingsCount,
    this.comments = const [],
  }) : super(key: key);

  @override
  State<WorkersDetailScreen> createState() => _WorkersDetailScreenState();
}

class _WorkersDetailScreenState extends State<WorkersDetailScreen> {
  bool _hasCallSupport = false;
  String parsedPhoneNumber = '...';

  // Future<void>? _launched;

  Future formatPhoneNumber() async {
    parsedPhoneNumber = "(" +
        widget.phoneNumber.substring(0, 3) +
        ") " +
        widget.phoneNumber.substring(3, 6) +
        " " +
        widget.phoneNumber.substring(6, 8) +
        " " +
        widget.phoneNumber.substring(8, widget.phoneNumber.length);
  }

  @override
  void initState() {
    super.initState();

    formatPhoneNumber();
    // Check for phone call support.
    UrlLauncher.canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
        print('_hasCallSupport: $_hasCallSupport');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _makePhoneCall(String phoneNumber) async {
      String int_number_string = '+52' + phoneNumber;
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: '9991234567',
      );
      print('calling...');
      await UrlLauncher.launchUrl(launchUri);
    }

    return Scaffold(
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          backgroundColor: kColorAlmostBlack,
          child: Icon(
            Icons.star_border,
            size: 40,
            color: kPrimaryColor2,
          ),
          onPressed: () async {
            if (FirebaseAuth.instance.currentUser == null) {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) => LoginScreen(),
              );
            } else {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) => AddReviewScreen(
                  workerId: widget.workerId,
                  workerName: widget.workerName,
                ),
              ).whenComplete(() {
                Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).changeReview1(0);
                Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).changeReview2(0);
              });
            }
          },
        ),
      ),
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(children: [
                const SizedBox(height: 12),
                UnconstrainedBox(
                  child: LimitedBox(
                    maxHeight: 140,
                    maxWidth: 140,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.workerRanking == '0'
                            ? Colors.white70
                            : widget.workerRanking.characters.first == '-'
                                ? kColorRed
                                : kColorGreen,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'Tedi ranking:',
                            style: tsRankingInfo,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Center(
                                child: Text(
                                  widget.workerRanking == '0' ? '?' : widget.workerRanking + ' %',
                                  style: TextStyle(
                                    color: widget.workerRanking == '0'
                                        ? Colors.black38
                                        : widget.workerRanking.characters.first == '-'
                                            ? Colors.white
                                            : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: tsRankingInfo,
                                  children: [
                                    TextSpan(text: 'rese??as: ', style: tsRankingInfo.copyWith(fontWeight: FontWeight.normal)),
                                    TextSpan(text: widget.workerRatingsCount ?? '0'),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: tsRankingInfo,
                                  children: [
                                    TextSpan(text: 'comentarios: ', style: tsRankingInfo.copyWith(fontWeight: FontWeight.normal)),
                                    TextSpan(text: widget.workerCommentsCount ?? '0'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.workerName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kColorAlmostBlack),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                    ),
                    Text(
                      'M??rida y sus alrededores',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                ReviewContainer(
                  rating1: widget.rating1,
                  rating2: widget.rating2,
                ),
                SizedBox(height: 16),
                for (var comment in widget.comments)
                  Comment(
                    commentText: comment.commentText,
                    date: comment.date!,
                    rating: comment.avgRating!,
                  ),
              ]),
            ),
            const SizedBox(height: 8),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  final link = WhatsAppUnilink(
                    phoneNumber: '+52' + widget.phoneNumber,
                    text: "??Hola! Encontr?? referencias de su trabajo en www.tedi.app. ??Cu??ndo est?? disponible, por favor?",
                  );
                  // Convert the WhatsAppUnilink instance to a string.
                  // Use either Dart's string interpolation or the toString() method.
                  // The "launch" method is part of "url_launcher".
                  // await launchUrl(Uri.parse(link.toString()));

                  if (!await launchUrl(Uri.parse(link.toString()))) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text('Whatsapp no disponible. Prueba llamarle copiando el n??mero.'),
                        backgroundColor: kColorRed,
                      ),
                    );
                  }

                  // print(launchUrl(Uri.parse(link.toString())).ca);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: 240,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.5, color: kPrimaryColor2),
                    // color: Colors.grey.shade300,
                    // color: kColorAlmostBlack,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.whatsapp,
                        size: 30,
                        color: kPrimaryColor2,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Env??a un whatsapp',
                        style: tsCtaWhatsapp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    // ElevatedButton(
                    //   style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
                    //   onPressed: () {
                    //     _hasCallSupport
                    //         ? () => setState(() {
                    //               _launched = _makePhoneCall(widget.phoneNumber.toString());
                    //             })
                    //         : null;
                    //   },
                    //   child: _hasCallSupport ? const Text('Make phone call') : const Text('Calling not supported'),
                    //   // child:
                    //   // Padding(
                    //   //   padding: const EdgeInsets.all(16.0),
                    //   //   child: Row(
                    //   //     mainAxisSize: MainAxisSize.min,
                    //   //     children: [
                    //   //       Icon(Icons.phone),
                    //   //       const SizedBox(
                    //   //         width: 12,
                    //   //       ),
                    //   //       Text(
                    //   //         widget.phoneNumber,
                    //   //         style: TextStyle(fontSize: 20),
                    //   //       ),
                    //   //     ],
                    //   //   ),
                    //   // ),
                    // ),

                    MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.phoneNumber)).then((value) {
                        //only if ->
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text('Copiado.'),
                          ),
                        ); // -> show a notification
                      });
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(
                        Icons.phone,
                        color: kColorAlmostBlack,
                      ),
                      SizedBox(width: 12),
                      Text(
                        parsedPhoneNumber,
                        // widget.phoneNumber,
                        style: TextStyle(fontSize: 20, color: kColorAlmostBlack),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.copy, color: kColorAlmostBlack),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
