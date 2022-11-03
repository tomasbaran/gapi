import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gapi/model/my_globals.dart';
import 'package:gapi/notifiers/review.dart';
import 'package:gapi/screens/add_review_screen.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:gapi/widgets/comment.dart';
import 'package:gapi/widgets/review_container.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'dart:async';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class WorkersDetailScreen extends StatefulWidget {
  final String categoryName;
  final String phoneNumber;
  final String workerName;
  final String workerId;
  const WorkersDetailScreen({Key? key, required this.workerName, required this.workerId, required this.categoryName, required this.phoneNumber})
      : super(key: key);

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
        path: '9991759427',
      );
      print('calling...');
      await UrlLauncher.launchUrl(launchUri);
    }

    return Scaffold(
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          backgroundColor: kPrimaryColor2,
          child: Icon(
            Icons.star_border,
            size: 40,
            color: kColorAlmostBlack,
          ),
          onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) => AddReviewScreen(
              workerId: widget.workerId,
              workerName: widget.workerName,
            ),
          ).whenComplete(() {
            Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).changeReview1(0);
            Provider.of<Review>(myGlobals.scaffoldKey.currentContext!, listen: false).changeReview2(0);
          }),
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
                UnconstrainedBox(
                  child: LimitedBox(
                    maxHeight: 200,
                    maxWidth: 200,
                    child: Container(
                      margin: EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '? %',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
                        ),
                      ),
                    ),
                  ),
                ),
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
                      'Mérida y sus alrededores',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                ReviewContainer(),
                SizedBox(height: 24),

                // comment
                // Comment(),
              ]),
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

                    GestureDetector(
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
          ],
        ),
      ),
    );
  }
}
