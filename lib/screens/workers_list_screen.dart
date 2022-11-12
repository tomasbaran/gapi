import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gapi/model/review.dart';
import 'package:gapi/model/my_globals.dart';
import 'package:gapi/screens/services/firebase_services.dart';
import 'package:gapi/theme/constants.dart';
import 'package:gapi/screens/add_worker_screen.dart';
import 'package:gapi/model/worker.dart';
import 'package:gapi/theme/style_constants.dart';
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
  int reviewsCounter = 0;

  Future<List<Widget>> readWorkersFromDatabase() async {
    List<WorkerContainer> output = [];

    FirebaseDatabase database = FirebaseDatabase.instance;

    final workersRef = database.ref().child('workers');
    final workersSnapshot = await workersRef.get();

    final reviewsRef = database.ref().child('reviews');
    final reviewsSnapshot = await reviewsRef.get();

    if (workersSnapshot.exists) {
      List<Worker> orderedWorkers = FirebaseServices().sortByRanking(workersSnapshot);

      for (var worker in orderedWorkers) {
        final workerName = worker.name;
        final workerPhoneNumber = worker.phoneNumber;
        final workerCategory = worker.category;
        final workerRanking = worker.ranking;
        final workerAllRatingsCount = worker.ratingsCount;
        final workerAllCommentsCount = worker.commentsCount;
        final rating1 = worker.avg_rating1;
        final rating2 = worker.avg_rating2;
        final comments = worker.comments;
        print('worker: ${worker.name} ${worker.comments}');

        if (workerCategory.toString() == categories[selectedCategoryIndex]) {
          output.add(WorkerContainer(
            phoneNumber: workerPhoneNumber.toString(),
            workerName: workerName.toString(),
            categoryName: workerCategory.toString(),
            workerId: worker.key,
            workerRanking: workerRanking.toString(),
            workerAllRatingsCount: workerAllRatingsCount == null ? null : workerAllRatingsCount.toString(),
            workerAllCommentsCount: workerAllCommentsCount == null ? null : workerAllCommentsCount.toString(),
            rating1: rating1 == null ? null : worker.avg_rating1.toStringAsFixed(1),
            rating2: rating2 == null ? null : worker.avg_rating2!.toStringAsFixed(1),
            comments: comments,
          ));
          print('rating2: ${rating2}');
          print('rating2: ${output.last.rating2}');
        }
      }

      if (!countedWorkers) {
        setState(() {
          workersCounter = workersSnapshot.children.length;
          reviewsCounter = reviewsSnapshot.children.length;
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
      key: myGlobals.scaffoldKey,
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          backgroundColor: kColorAlmostBlack,
          child: Icon(
            Icons.add,
            size: 40,
            color: kPrimaryColor2,
          ),
          onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) => AddWorkerScreen(categoryIndex: selectedCategoryIndex),
          ),
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        title: Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(widget.title, style: tsMainAppBarTitle),
                  const Expanded(child: Text(': servicios del hogar', style: tsMainAppBarSubtitle)),
                  (FirebaseAuth.instance.currentUser == null)
                      ? Container()
                      // RELEASE-MODE:
                      : const Icon(Icons.verified)
                  // DEV-MODE:
                  // : MouseRegion(
                  //     cursor: SystemMouseCursors.click,
                  //     child: GestureDetector(
                  //       child:
                  //           // Icon(Icons.account_circle_sharp),
                  //           Icon(Icons.verified),
                  //       onTap: (() => FirebaseServices().logout()),
                  //     ),
                  //   ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: kColorGrey,
                    size: 14,
                  ),
                  Text(
                    'Mérida: $workersCounter proveedores, $reviewsCounter reseñas',
                    style: TextStyle(
                      color: kColorGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      body: Column(children: [
        Container(
          color: Theme.of(context).primaryColor,
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
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: const Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            categories[index],
                            style: TextStyle(color: kColorAlmostBlack, fontWeight: FontWeight.bold),
                          ),
                        )
                      : MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => setState(() {
                              selectedCategoryIndex = index;
                              _pageController.jumpToPage(selectedCategoryIndex);
                            }),
                            child: Text(
                              categories[index],
                              style: TextStyle(color: Colors.white),
                            ),
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
                return const Text('cargando proveedores...');
            },
          ),
        ),
        // BottomButton(
        //   title: '+ AÑADIR',
        //   onTap: () => showModalBottomSheet(
        //     isScrollControlled: true,
        //     context: context,
        //     builder: (BuildContext context) => AddWorkerScreen(),
        //   ),
        // ),
      ]),
    );
  }
}
