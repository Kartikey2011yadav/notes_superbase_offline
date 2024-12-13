// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite/db.dart';
part '20241213100313.migration.dart';

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final migrations = <Migration>{
  const Migration20241213100313(),};

/// A consumable database structure including the latest generated migration.
final schema = Schema(20241213100313, generatorVersion: 1, tables: <SchemaTable>{
  SchemaTable('Note', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('content', Column.varchar),
    SchemaColumn('created_at', Column.varchar),
    SchemaColumn('id', Column.varchar, unique: true)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  })
});
