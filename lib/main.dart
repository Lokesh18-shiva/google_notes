import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_notes/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NoteListScreen(),
    );
  }
}

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({Key? key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Notes> notes = [];

  @override
  void initState() {
    _getSavedNotes();
    super.initState();
  }

  Future<void> _getSavedNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? notesJson = prefs.getStringList('notes');
    if (notesJson != null) {
      setState(() {
        notes = notesJson.map((e) => Notes.fromJson(json.decode(e))).toList();
      });
    }
  }

  Future<void> _addNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Notes newNote = Notes(title: '', content: '');

    setState(() {
      notes.add(newNote);
    });

    List<String> notesJson = notes.map((note) => jsonEncode(note)).toList();
    await prefs.setStringList('notes', notesJson);
  }

  Future<void> _editNoteTitle(Notes note) async {
    
    // String? newTitle = await showDialog<String>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     final TextEditingController titleController =
    //         TextEditingController(text: note.title);

    //     return AlertDialog(
    //       title: const Text('Edit Note Title'),
    //       content: TextField(
    //         controller: titleController,
    //         decoration: const InputDecoration(labelText: 'Title'),
    //       ),
    //       actions: <Widget>[
    //         TextButton(
    //           child: const Text('Save'),
    //           onPressed: () {
    //             Navigator.of(context).pop(titleController.text);
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );

    // if (newTitle != null) {
    //   setState(() {
    //     note.title = newTitle;
    //   });

    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   List<String> notesJson = notes.map((n) => jsonEncode(n)).toList();
    //   await prefs.setStringList('notes', notesJson);
    // }
  }

  Future<void> _deleteNote(Notes note) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      notes.remove(note);
    });

    List<String> notesJson = notes.map((n) => jsonEncode(n)).toList();
    await prefs.setStringList('notes', notesJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(notes[index].title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
      return MyWidget(notes: notes[index], notess: notes);
    })));},
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteNote(notes[index]),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Notes {
  String title;
  String content;

  Notes({required this.title, required this.content});

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}
