// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241213100313_up = [
  InsertTable('Note'),
  InsertColumn('content', Column.varchar, onTable: 'Note'),
  InsertColumn('created_at', Column.varchar, onTable: 'Note'),
  InsertColumn('id', Column.varchar, onTable: 'Note', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Note', unique: true)
];

const List<MigrationCommand> _migration_20241213100313_down = [
  DropTable('Note'),
  DropColumn('content', onTable: 'Note'),
  DropColumn('created_at', onTable: 'Note'),
  DropColumn('id', onTable: 'Note'),
  DropIndex('index_Note_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241213100313',
  up: _migration_20241213100313_up,
  down: _migration_20241213100313_down,
)
class Migration20241213100313 extends Migration {
  const Migration20241213100313()
    : super(
        version: 20241213100313,
        up: _migration_20241213100313_up,
        down: _migration_20241213100313_down,
      );
}
