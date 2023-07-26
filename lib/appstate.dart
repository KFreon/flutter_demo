import 'dart:collection';

import 'package:flutter/material.dart';

class CoolDude {
  String name;
  bool areTheyACoolDude;

  CoolDude({required this.name, required this.areTheyACoolDude});
}

// This is shared state
class MyAppState extends ChangeNotifier {
  final List<CoolDude> _coolDudes = []; // _ means private to this class
  UnmodifiableListView<CoolDude> coolDudes; // public immutable view

  // Weird, surely this isn't how it's done?
  MyAppState() : coolDudes = UnmodifiableListView<CoolDude>([]) {
    coolDudes = UnmodifiableListView(_coolDudes);
  }

  void addACoolDude(CoolDude dude) {
    _coolDudes.add(dude);

    // Notifies the providers (only one in this case)
    notifyListeners();
  }
}
