import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appstate.dart';

class MyModal extends StatefulWidget {
  final BuildContext context;

  const MyModal({super.key, required this.context});

  @override
  State<StatefulWidget> createState() =>
      _MyModalState(outsideBuildContext: this.context);
}

class _MyModalState extends State<MyModal> {
  String newCoolDude = "";
  bool isCoolDude = false;

  BuildContext outsideBuildContext;

  _MyModalState({required this.outsideBuildContext});

  @override
  Widget build(BuildContext context) {
    var myState = context.watch<MyAppState>();

    return Center(
        child: Column(children: [
      const Icon(Icons.airplane_ticket, color: Colors.purple, size: 50),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: 100,
            child: TextField(
                onChanged: (value) => setState(() {
                      newCoolDude = value;
                    }),
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: "Your name")),
          ),
          Column(children: [
            const Text("Cool?"),
            Checkbox(
                value: isCoolDude,
                onChanged: (value) => setState(() {
                      isCoolDude = value ?? false;
                    }))
          ])
        ]),
      ),
      ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
          ),
          onPressed: newCoolDude.isNotEmpty
              ? () {
                  myState.addACoolDude(CoolDude(
                      name: newCoolDude, areTheyACoolDude: isCoolDude));
                  setState(() {
                    newCoolDude = "";
                  });
                  Navigator.pop(outsideBuildContext);
                }
              : null,
          child: const Text("Add", style: TextStyle(color: Colors.white)))
    ]));
  }
}
