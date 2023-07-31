import 'package:flutter/material.dart';
import 'package:flutter_demo/data.service.dart';

class DeleteModal extends SimpleDialog {
  final CoolDude dude;
  final Function(CoolDude dude) deleteTheDude;
  final BuildContext outsideBuildContext;
  const DeleteModal(
      {super.key,
      super.title,
      required this.dude,
      required this.deleteTheDude,
      required this.outsideBuildContext});

  @override
  Widget? get title =>
      Text("Are you sure you want to delete the dude: ${dude.name}");

  @override
  List<Widget>? get children => [
        SimpleDialogOption(
            onPressed: () {
              deleteTheDude(dude);
              Navigator.pop(outsideBuildContext);
            },
            child: const Text("They are not worthy!")),
        SimpleDialogOption(
            onPressed: () => Navigator.pop(outsideBuildContext),
            child: const Text("I have reconsidered"))
      ];
}
