import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'dart:async';

class WorkersDetailScreen extends StatefulWidget {
  final String categoryName;
  final String phoneNumber;
  final String workerName;
  const WorkersDetailScreen({Key? key, required this.workerName, required this.categoryName, required this.phoneNumber}) : super(key: key);

  @override
  State<WorkersDetailScreen> createState() => _WorkersDetailScreenState();
}

class _WorkersDetailScreenState extends State<WorkersDetailScreen> {
  bool _hasCallSupport = false;
  Future<void>? _launched;
  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: ListView(children: [
            UnconstrainedBox(
              child: LimitedBox(
                maxHeight: 200,
                maxWidth: 200,
                child: Container(
                  margin: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.grey,
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
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
        Center(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:

                  //  ElevatedButton(
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
                      const SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text('Copiado.'),
                        backgroundColor: Colors.green,
                      ),
                    ); // -> show a notification
                  });
                },
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.phone),
                  SizedBox(width: 12),
                  Text(
                    widget.phoneNumber,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.copy),
                ]),
              )),
        ),
        const SizedBox(height: 12),
        BottomBlackButton(title: '+ AÑADIR EVALUACIÓN', onTap: () => null),
      ]),
    );
  }
}
