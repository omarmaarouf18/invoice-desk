// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contracts_dao.dart';

// ignore_for_file: type=lint
mixin _$ContractsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientsTable get clients => attachedDatabase.clients;
  $ContractsTable get contracts => attachedDatabase.contracts;
  $ContractClausesTable get contractClauses => attachedDatabase.contractClauses;
  $ScopeItemsTable get scopeItems => attachedDatabase.scopeItems;
  $InvoicesTable get invoices => attachedDatabase.invoices;
  $PaymentMilestonesTable get paymentMilestones =>
      attachedDatabase.paymentMilestones;
  ContractsDaoManager get managers => ContractsDaoManager(this);
}

class ContractsDaoManager {
  final _$ContractsDaoMixin _db;
  ContractsDaoManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db.attachedDatabase, _db.clients);
  $$ContractsTableTableManager get contracts =>
      $$ContractsTableTableManager(_db.attachedDatabase, _db.contracts);
  $$ContractClausesTableTableManager get contractClauses =>
      $$ContractClausesTableTableManager(
        _db.attachedDatabase,
        _db.contractClauses,
      );
  $$ScopeItemsTableTableManager get scopeItems =>
      $$ScopeItemsTableTableManager(_db.attachedDatabase, _db.scopeItems);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db.attachedDatabase, _db.invoices);
  $$PaymentMilestonesTableTableManager get paymentMilestones =>
      $$PaymentMilestonesTableTableManager(
        _db.attachedDatabase,
        _db.paymentMilestones,
      );
}
