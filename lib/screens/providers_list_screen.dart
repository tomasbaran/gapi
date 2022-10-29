import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gapi/constants.dart';
import 'package:gapi/screens/add_provider_screen.dart';
import 'package:gapi/widgets/bottom_black_button.dart';

class ProvidersListScreen extends StatelessWidget {
  ProvidersListScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                  Text(categories[index]),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: [
                Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Luis Jimenez'),
                            Text('calificaciones: 6'),
                            Text('reseñas: 1'),
                          ],
                        ),
                        Container(
                          color: Colors.green,
                          child: Text('79%'),
                        ),
                      ],
                    ))
              ],
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
