import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/appstate.dart';
import 'package:flutter_demo/data.service.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'coolDudeDisplay.dart';
import 'myModal.dart';

final DataService _dataService = DataService();

Future<void> main() async {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();

    // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
    // this step, it will use the sqlite version available on the system.
    databaseFactory = databaseFactoryFfi;
  }
  await WidgetsFlutterBinding.ensureInitialized();
  await _dataService.initialiseDatabase();

  runApp(ChangeNotifierProvider(
      create: (context) => MyAppState(_dataService), child: const MyApp()));
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

    // Get an error that we haven't finished initState yet, and that updates should happen here...
    myState.initialiseState();
    var coolDudes = myState.coolDudes.map((e) => CoolDudeDisplay(dude: e));
    var uncoolDudes = myState.uncoolDudes.map((e) => CoolDudeDisplay(dude: e));

    var firstRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Are you a cool dude?",
              style: TextStyle(fontSize: 50, fontStyle: FontStyle.italic)),
        ),
        ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => MyModal(context: context));
            },
            child: const Text("Add a cooldude"))
      ],
    );

    const borderStyle = BorderSide(color: Colors.grey, width: 1);
    const columnDecoration =
        BoxDecoration(border: Border(left: borderStyle, right: borderStyle));

    const columnTitleStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        decoration: TextDecoration.underline,
        decorationThickness: 2);

    var secondColumn = Flexible(
      child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
              decoration: columnDecoration,
              child: Column(
                children: [
                  const Text("Cool Dudes 😎", style: columnTitleStyle),
                  Expanded(child: ListView(children: [...coolDudes]))
                ],
              ))),
    );

    var thirdColumn = Flexible(
      child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
              decoration: columnDecoration,
              child: Column(
                children: [
                  const Text("Uncool Dudes 😭", style: columnTitleStyle),
                  Expanded(child: ListView(children: [...uncoolDudes]))
                ],
              ))),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            firstRow,
            Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [secondColumn, thirdColumn])),
          ],
        ));
  }
}
