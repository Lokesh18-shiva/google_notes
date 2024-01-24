// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_notes/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyWidget extends StatefulWidget {
  Notes notes;
  List<Notes> notess;
  MyWidget({Key? key, required this.notes,required this.notess}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {  TextEditingController titleController = TextEditingController(text: widget.notes.title);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.abc),
          onPressed: () async {
            String newTitle = titleController.text;
            if (newTitle.isEmpty) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              List<String> notesJson =
                  widget.notess.map((n) => jsonEncode(n)).toList();
              await prefs.setStringList('notes', notesJson);
            } else {
              setState(() {
                widget.notes.title = newTitle;
              });
            }
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: titleController,
          )
        ],
      ),
    );
  }
}
