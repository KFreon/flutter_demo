import 'package:flutter/material.dart';

import 'appstate.dart';

class CoolDudeDisplay extends StatelessWidget {
  final CoolDude dude;

  const CoolDudeDisplay({super.key, required this.dude});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(dude.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(dude.areTheyACoolDude ? '😎' : '😭'),
        )
      ],
    );
  }
}
