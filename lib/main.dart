import 'package:flutter/material.dart';
import 'package:flutter_demo/appstate.dart';
import 'package:provider/provider.dart';

import 'coolDudeDisplay.dart';
import 'myModal.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => MyAppState(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flooter Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Flooter"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// This is state internal to the MyHomePage.
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var myState = context.watch<MyAppState>();
    var dudes = myState.coolDudes.map((e) => CoolDudeDisplay(dude: e));

    var firstColumn = Column(
      children: [
        const Text("Are you a cool dude?",
            style: TextStyle(fontSize: 50, fontStyle: FontStyle.italic)),
        ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => MyModal(context: context));
            },
            child: const Text("Add a cooldude"))
      ],
    );

    var secondColumn = Flexible(
      child: FractionallySizedBox(
          widthFactor: 0.75,
          heightFactor: 1,
          child: ListView(children: [...dudes])),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        firstColumn,
        secondColumn,
      ]),
    );
  }
}
