// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_dao.dart';

// ignore_for_file: type=lint
mixin _$CalendarDaoMixin on DatabaseAccessor<AppDatabase> {
  $PostponementsTable get postponements => attachedDatabase.postponements;
  $ClientsTable get clients => attachedDatabase.clients;
  $RemindersTable get reminders => attachedDatabase.reminders;
  CalendarDaoManager get managers => CalendarDaoManager(this);
}

class CalendarDaoManager {
  final _$CalendarDaoMixin _db;
  CalendarDaoManager(this._db);
  $$PostponementsTableTableManager get postponements =>
      $$PostponementsTableTableManager(_db.attachedDatabase, _db.postponements);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db.attachedDatabase, _db.clients);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db.attachedDatabase, _db.reminders);
}
