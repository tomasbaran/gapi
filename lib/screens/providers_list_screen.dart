import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gapi/constants.dart';
import 'package:gapi/screens/add_provider_screen.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:gapi/widgets/provider_container.dart';
import 'package:firebase_database/firebase_database.dart';

class ProvidersListScreen extends StatefulWidget {
  ProvidersListScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ProvidersListScreen> createState() => _ProvidersListScreenState();
}

class _ProvidersListScreenState extends State<ProvidersListScreen> {
  int selectedCategoryIndex = 0;

  Future<List<Widget>> readProvidersFromDatabase() async {
    List<ProviderContainer> output = [];
    output.add(ProviderContainer(providerName: 'providerName'));

    FirebaseDatabase database = FirebaseDatabase.instance;

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('providers').get();
    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('No data available.');
    }

    return output;
  }

  List<Widget> defaultWidgetList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
              future: readProvidersFromDatabase(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(children: snapshot.data ?? []);
                } else
                  return const SizedBox();
              },
            ),
          ),
        ),
        BottomBlackButton(
          title: 'Añadir',
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => AddProviderScreen(),
          ),
        ),
      ]),
    );
  }
}
