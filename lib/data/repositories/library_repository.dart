import 'package:clock/clock.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/repository.dart';
import 'package:invoice_desk/domain/contract_models.dart';

/// The clause library (templates and their clauses). Contracts copy what
/// they need, so nothing here ever changes an existing contract.
class LibraryRepository with ClockedRepository {
  /// Wraps [_db]; writes are stamped with [clock].
  LibraryRepository(this._db, {this.clock = const Clock()});
  final AppDatabase _db;
  @override
  final Clock clock;

  /// Templates with clauses, by position, re-emitting on change.
  Stream<List<ClauseTemplate>> watchAll() => _db.libraryDao.watchAll();

  /// Templates with clauses, by position.
  Future<List<ClauseTemplate>> getAll() => _db.libraryDao.getAll();

  /// The library's current wording of one clause, for "استرجاع النص".
  Future<LibraryClause?> clauseById(String id) => _db.libraryDao.clauseById(id);

  /// Saves the template and replaces its clauses, atomically.
  Future<void> saveTemplate(ClauseTemplate t) =>
      at(() => _db.libraryDao.saveTemplate(t));

  /// "حفظ في المكتبة": new wording for one library clause.
  Future<void> updateClauseText(
    String id, {
    required String title,
    required String body,
  }) => at(() => _db.libraryDao.updateClauseText(id, title: title, body: body));

  /// Deletes the template and its clauses; contracts made from it keep
  /// their copies.
  Future<void> deleteTemplate(String id) =>
      at(() => _db.libraryDao.deleteTemplate(id));
}
