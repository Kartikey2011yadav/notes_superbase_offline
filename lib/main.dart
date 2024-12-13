import 'package:brick_core/core.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'brick/repository.dart';
import 'models/note.model.dart';

Future<void> main() async {
  await Repository.configure(databaseFactory);
  // .initialize() does not need to be invoked within main()
  // It can be invoked from within a state manager or within
  // an initState()
  await Repository().initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Stream<List<Note>> notesStream = Repository().subscribe<Note>();

  @override
  void initState() {
    super.initState();
    final session = Supabase.instance.client.auth.currentSession;
    if(session == null) {
      Supabase.instance.client.auth.signInAnonymously();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 12.0, color: Colors.black54),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Notes'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: StreamBuilder<List<Note>>(
            stream: notesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final note = snapshot.data![index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(note.content, style: Theme.of(context).textTheme.headlineMedium),
                        subtitle: Text(note.createdAt, style: Theme.of(context).textTheme.bodyMedium),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () async {
                            await Repository().delete<Note>(note);
                          },
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No notes found', style: TextStyle(color: Colors.white, fontSize: 20)));
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Repository().upsert<Note>(Note(
              content: 'Hello, world!',
              createdAt: DateTime.now().toIso8601String(),
            ));
          },
          tooltip: 'Add Note',
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
