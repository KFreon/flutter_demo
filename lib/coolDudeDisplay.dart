import 'package:flutter/material.dart';
import 'package:flutter_demo/appstate.dart';
import 'package:flutter_demo/deleteModal.dart';
import 'package:provider/provider.dart';

import 'data.service.dart';

class CoolDudeDisplay extends StatelessWidget {
  final CoolDude dude;

  const CoolDudeDisplay({super.key, required this.dude});

  @override
  Widget build(BuildContext context) {
    final myState = context.watch<MyAppState>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(dude.areTheyACoolDude ? '😎' : '😭'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(dude.name,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => DeleteModal(
                      dude: dude,
                      deleteTheDude: myState.deleteADude,
                      outsideBuildContext: context));
            },
            child: const Text("X"))
      ],
    );
  }
}
