// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_dao.dart';

// ignore_for_file: type=lint
mixin _$LibraryDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClauseTemplatesTable get clauseTemplates => attachedDatabase.clauseTemplates;
  $LibraryClausesTable get libraryClauses => attachedDatabase.libraryClauses;
  LibraryDaoManager get managers => LibraryDaoManager(this);
}

class LibraryDaoManager {
  final _$LibraryDaoMixin _db;
  LibraryDaoManager(this._db);
  $$ClauseTemplatesTableTableManager get clauseTemplates =>
      $$ClauseTemplatesTableTableManager(
        _db.attachedDatabase,
        _db.clauseTemplates,
      );
  $$LibraryClausesTableTableManager get libraryClauses =>
      $$LibraryClausesTableTableManager(
        _db.attachedDatabase,
        _db.libraryClauses,
      );
}
