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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo Home Page'),
        ),
        body: StreamBuilder(
          stream: notesStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final note = snapshot.data![index];
                    return ListTile(
                      title: Text(note.content),
                      subtitle: Text(note.createdAt),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await Repository().delete<Note>(note);
                        },
                      ),
                    );
                  });
              // return Text('${snapshot.data?.length} notes found');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Repository().upsert<Note>(Note(
              content: 'Hello, world!',
              createdAt: DateTime.now().toIso8601String(),
            ));
          },
          tooltip: 'Add Notes',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
