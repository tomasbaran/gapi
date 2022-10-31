import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gapi/constants.dart';
import 'package:gapi/screens/add_worker_screen.dart';
import 'package:gapi/screens/model/worker.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:gapi/widgets/worker_container.dart';
import 'package:firebase_database/firebase_database.dart';

class WorkersListScreen extends StatefulWidget {
  WorkersListScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<WorkersListScreen> createState() => _WorkersListScreenState();
}

class _WorkersListScreenState extends State<WorkersListScreen> {
  int selectedCategoryIndex = 0;
  bool countedWorkers = false;
  int workersCounter = 0;

  Future<List<Widget>> readWorkersFromDatabase() async {
    List<WorkerContainer> output = [];

    FirebaseDatabase database = FirebaseDatabase.instance;

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('workers').get();
    if (snapshot.exists) {
      // List<Worker> workers = [];

      for (var worker in snapshot.children) {
        final workerName = worker.child('name').value;
        final workerPhoneNumber = worker.child('phone').value;
        final workerCategory = worker.child('category').value;

        if (workerCategory.toString() == categories[selectedCategoryIndex]) {
          output.add(WorkerContainer(
            phoneNumber: workerPhoneNumber.toString(),
            workerName: workerName.toString(),
            categoryName: workerCategory.toString(),
          ));
        }
      }
      print(snapshot.children.length);
      if (!countedWorkers) {
        setState(() {
          workersCounter = snapshot.children.length;
          countedWorkers = true;
        });
      }
    } else {
      print('No data available.');
    }

    return output;
  }

  List<Widget> defaultWidgetList = [];
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + ': $workersCounter proveederos'),
      ),
      body: Column(children: [
        SizedBox(
          height: 32,
        ),
        Container(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(
              categories.length,
              (index) => Row(
                children: [
                  const SizedBox(width: 24),
                  index == selectedCategoryIndex
                      ? Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text(
                            categories[index],
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => setState(() {
                            selectedCategoryIndex = index;
                          }),
                          child: Text(
                            categories[index],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FutureBuilder(
              future: readWorkersFromDatabase(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          selectedCategoryIndex = value;
                        });
                      },
                      controller: _pageController,
                      itemBuilder: (context, index) => ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: snapshot.data ?? [],
                      ),
                    ),
                  );
                } else
                  return const Text('...');
              },
            ),
          ),
        ),
        BottomBlackButton(
          title: '+ AÑADIR',
          onTap: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) => AddWorkerScreen(),
          ),
        ),
      ]),
    );
  }
}
