// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    check: () => id.equals(1),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _invoicePrefixMeta = const VerificationMeta(
    'invoicePrefix',
  );
  @override
  late final GeneratedColumn<String> invoicePrefix = GeneratedColumn<String>(
    'invoice_prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('OM'),
  );
  static const VerificationMeta _defaultDueDaysMeta = const VerificationMeta(
    'defaultDueDays',
  );
  @override
  late final GeneratedColumn<int> defaultDueDays = GeneratedColumn<int>(
    'default_due_days',
    aliasedName,
    false,
    check: () => ComparableExpr(defaultDueDays).isBetweenValues(0, 3650),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _instapayMeta = const VerificationMeta(
    'instapay',
  );
  @override
  late final GeneratedColumn<String> instapay = GeneratedColumn<String>(
    'instapay',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _walletMeta = const VerificationMeta('wallet');
  @override
  late final GeneratedColumn<String> wallet = GeneratedColumn<String>(
    'wallet',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bankIbanMeta = const VerificationMeta(
    'bankIban',
  );
  @override
  late final GeneratedColumn<String> bankIban = GeneratedColumn<String>(
    'bank_iban',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesEnMeta = const VerificationMeta(
    'notesEn',
  );
  @override
  late final GeneratedColumn<String> notesEn = GeneratedColumn<String>(
    'notes_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesArMeta = const VerificationMeta(
    'notesAr',
  );
  @override
  late final GeneratedColumn<String> notesAr = GeneratedColumn<String>(
    'notes_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _backupDirMeta = const VerificationMeta(
    'backupDir',
  );
  @override
  late final GeneratedColumn<String> backupDir = GeneratedColumn<String>(
    'backup_dir',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastBackupAtMeta = const VerificationMeta(
    'lastBackupAt',
  );
  @override
  late final GeneratedColumn<int> lastBackupAt = GeneratedColumn<int>(
    'last_backup_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    role,
    city,
    email,
    phone,
    website,
    invoicePrefix,
    defaultDueDays,
    instapay,
    wallet,
    bankIban,
    notesEn,
    notesAr,
    backupDir,
    lastBackupAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('invoice_prefix')) {
      context.handle(
        _invoicePrefixMeta,
        invoicePrefix.isAcceptableOrUnknown(
          data['invoice_prefix']!,
          _invoicePrefixMeta,
        ),
      );
    }
    if (data.containsKey('default_due_days')) {
      context.handle(
        _defaultDueDaysMeta,
        defaultDueDays.isAcceptableOrUnknown(
          data['default_due_days']!,
          _defaultDueDaysMeta,
        ),
      );
    }
    if (data.containsKey('instapay')) {
      context.handle(
        _instapayMeta,
        instapay.isAcceptableOrUnknown(data['instapay']!, _instapayMeta),
      );
    }
    if (data.containsKey('wallet')) {
      context.handle(
        _walletMeta,
        wallet.isAcceptableOrUnknown(data['wallet']!, _walletMeta),
      );
    }
    if (data.containsKey('bank_iban')) {
      context.handle(
        _bankIbanMeta,
        bankIban.isAcceptableOrUnknown(data['bank_iban']!, _bankIbanMeta),
      );
    }
    if (data.containsKey('notes_en')) {
      context.handle(
        _notesEnMeta,
        notesEn.isAcceptableOrUnknown(data['notes_en']!, _notesEnMeta),
      );
    }
    if (data.containsKey('notes_ar')) {
      context.handle(
        _notesArMeta,
        notesAr.isAcceptableOrUnknown(data['notes_ar']!, _notesArMeta),
      );
    }
    if (data.containsKey('backup_dir')) {
      context.handle(
        _backupDirMeta,
        backupDir.isAcceptableOrUnknown(data['backup_dir']!, _backupDirMeta),
      );
    }
    if (data.containsKey('last_backup_at')) {
      context.handle(
        _lastBackupAtMeta,
        lastBackupAt.isAcceptableOrUnknown(
          data['last_backup_at']!,
          _lastBackupAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      )!,
      invoicePrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_prefix'],
      )!,
      defaultDueDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_due_days'],
      )!,
      instapay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instapay'],
      )!,
      wallet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wallet'],
      )!,
      bankIban: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_iban'],
      )!,
      notesEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes_en'],
      )!,
      notesAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes_ar'],
      )!,
      backupDir: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backup_dir'],
      ),
      lastBackupAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_backup_at'],
      ),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final int id;
  final String name;
  final String role;
  final String city;
  final String email;
  final String phone;
  final String website;
  final String invoicePrefix;
  final int defaultDueDays;
  final String instapay;
  final String wallet;
  final String bankIban;
  final String notesEn;
  final String notesAr;
  final String? backupDir;
  final int? lastBackupAt;
  const SettingsRow({
    required this.id,
    required this.name,
    required this.role,
    required this.city,
    required this.email,
    required this.phone,
    required this.website,
    required this.invoicePrefix,
    required this.defaultDueDays,
    required this.instapay,
    required this.wallet,
    required this.bankIban,
    required this.notesEn,
    required this.notesAr,
    this.backupDir,
    this.lastBackupAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    map['city'] = Variable<String>(city);
    map['email'] = Variable<String>(email);
    map['phone'] = Variable<String>(phone);
    map['website'] = Variable<String>(website);
    map['invoice_prefix'] = Variable<String>(invoicePrefix);
    map['default_due_days'] = Variable<int>(defaultDueDays);
    map['instapay'] = Variable<String>(instapay);
    map['wallet'] = Variable<String>(wallet);
    map['bank_iban'] = Variable<String>(bankIban);
    map['notes_en'] = Variable<String>(notesEn);
    map['notes_ar'] = Variable<String>(notesAr);
    if (!nullToAbsent || backupDir != null) {
      map['backup_dir'] = Variable<String>(backupDir);
    }
    if (!nullToAbsent || lastBackupAt != null) {
      map['last_backup_at'] = Variable<int>(lastBackupAt);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      name: Value(name),
      role: Value(role),
      city: Value(city),
      email: Value(email),
      phone: Value(phone),
      website: Value(website),
      invoicePrefix: Value(invoicePrefix),
      defaultDueDays: Value(defaultDueDays),
      instapay: Value(instapay),
      wallet: Value(wallet),
      bankIban: Value(bankIban),
      notesEn: Value(notesEn),
      notesAr: Value(notesAr),
      backupDir: backupDir == null && nullToAbsent
          ? const Value.absent()
          : Value(backupDir),
      lastBackupAt: lastBackupAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBackupAt),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      city: serializer.fromJson<String>(json['city']),
      email: serializer.fromJson<String>(json['email']),
      phone: serializer.fromJson<String>(json['phone']),
      website: serializer.fromJson<String>(json['website']),
      invoicePrefix: serializer.fromJson<String>(json['invoicePrefix']),
      defaultDueDays: serializer.fromJson<int>(json['defaultDueDays']),
      instapay: serializer.fromJson<String>(json['instapay']),
      wallet: serializer.fromJson<String>(json['wallet']),
      bankIban: serializer.fromJson<String>(json['bankIban']),
      notesEn: serializer.fromJson<String>(json['notesEn']),
      notesAr: serializer.fromJson<String>(json['notesAr']),
      backupDir: serializer.fromJson<String?>(json['backupDir']),
      lastBackupAt: serializer.fromJson<int?>(json['lastBackupAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'city': serializer.toJson<String>(city),
      'email': serializer.toJson<String>(email),
      'phone': serializer.toJson<String>(phone),
      'website': serializer.toJson<String>(website),
      'invoicePrefix': serializer.toJson<String>(invoicePrefix),
      'defaultDueDays': serializer.toJson<int>(defaultDueDays),
      'instapay': serializer.toJson<String>(instapay),
      'wallet': serializer.toJson<String>(wallet),
      'bankIban': serializer.toJson<String>(bankIban),
      'notesEn': serializer.toJson<String>(notesEn),
      'notesAr': serializer.toJson<String>(notesAr),
      'backupDir': serializer.toJson<String?>(backupDir),
      'lastBackupAt': serializer.toJson<int?>(lastBackupAt),
    };
  }

  SettingsRow copyWith({
    int? id,
    String? name,
    String? role,
    String? city,
    String? email,
    String? phone,
    String? website,
    String? invoicePrefix,
    int? defaultDueDays,
    String? instapay,
    String? wallet,
    String? bankIban,
    String? notesEn,
    String? notesAr,
    Value<String?> backupDir = const Value.absent(),
    Value<int?> lastBackupAt = const Value.absent(),
  }) => SettingsRow(
    id: id ?? this.id,
    name: name ?? this.name,
    role: role ?? this.role,
    city: city ?? this.city,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    website: website ?? this.website,
    invoicePrefix: invoicePrefix ?? this.invoicePrefix,
    defaultDueDays: defaultDueDays ?? this.defaultDueDays,
    instapay: instapay ?? this.instapay,
    wallet: wallet ?? this.wallet,
    bankIban: bankIban ?? this.bankIban,
    notesEn: notesEn ?? this.notesEn,
    notesAr: notesAr ?? this.notesAr,
    backupDir: backupDir.present ? backupDir.value : this.backupDir,
    lastBackupAt: lastBackupAt.present ? lastBackupAt.value : this.lastBackupAt,
  );
  SettingsRow copyWithCompanion(AppSettingsCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      city: data.city.present ? data.city.value : this.city,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      website: data.website.present ? data.website.value : this.website,
      invoicePrefix: data.invoicePrefix.present
          ? data.invoicePrefix.value
          : this.invoicePrefix,
      defaultDueDays: data.defaultDueDays.present
          ? data.defaultDueDays.value
          : this.defaultDueDays,
      instapay: data.instapay.present ? data.instapay.value : this.instapay,
      wallet: data.wallet.present ? data.wallet.value : this.wallet,
      bankIban: data.bankIban.present ? data.bankIban.value : this.bankIban,
      notesEn: data.notesEn.present ? data.notesEn.value : this.notesEn,
      notesAr: data.notesAr.present ? data.notesAr.value : this.notesAr,
      backupDir: data.backupDir.present ? data.backupDir.value : this.backupDir,
      lastBackupAt: data.lastBackupAt.present
          ? data.lastBackupAt.value
          : this.lastBackupAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('city: $city, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('defaultDueDays: $defaultDueDays, ')
          ..write('instapay: $instapay, ')
          ..write('wallet: $wallet, ')
          ..write('bankIban: $bankIban, ')
          ..write('notesEn: $notesEn, ')
          ..write('notesAr: $notesAr, ')
          ..write('backupDir: $backupDir, ')
          ..write('lastBackupAt: $lastBackupAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    role,
    city,
    email,
    phone,
    website,
    invoicePrefix,
    defaultDueDays,
    instapay,
    wallet,
    bankIban,
    notesEn,
    notesAr,
    backupDir,
    lastBackupAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.role == this.role &&
          other.city == this.city &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.website == this.website &&
          other.invoicePrefix == this.invoicePrefix &&
          other.defaultDueDays == this.defaultDueDays &&
          other.instapay == this.instapay &&
          other.wallet == this.wallet &&
          other.bankIban == this.bankIban &&
          other.notesEn == this.notesEn &&
          other.notesAr == this.notesAr &&
          other.backupDir == this.backupDir &&
          other.lastBackupAt == this.lastBackupAt);
}

class AppSettingsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> role;
  final Value<String> city;
  final Value<String> email;
  final Value<String> phone;
  final Value<String> website;
  final Value<String> invoicePrefix;
  final Value<int> defaultDueDays;
  final Value<String> instapay;
  final Value<String> wallet;
  final Value<String> bankIban;
  final Value<String> notesEn;
  final Value<String> notesAr;
  final Value<String?> backupDir;
  final Value<int?> lastBackupAt;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.city = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.defaultDueDays = const Value.absent(),
    this.instapay = const Value.absent(),
    this.wallet = const Value.absent(),
    this.bankIban = const Value.absent(),
    this.notesEn = const Value.absent(),
    this.notesAr = const Value.absent(),
    this.backupDir = const Value.absent(),
    this.lastBackupAt = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.city = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.defaultDueDays = const Value.absent(),
    this.instapay = const Value.absent(),
    this.wallet = const Value.absent(),
    this.bankIban = const Value.absent(),
    this.notesEn = const Value.absent(),
    this.notesAr = const Value.absent(),
    this.backupDir = const Value.absent(),
    this.lastBackupAt = const Value.absent(),
  });
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? city,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? website,
    Expression<String>? invoicePrefix,
    Expression<int>? defaultDueDays,
    Expression<String>? instapay,
    Expression<String>? wallet,
    Expression<String>? bankIban,
    Expression<String>? notesEn,
    Expression<String>? notesAr,
    Expression<String>? backupDir,
    Expression<int>? lastBackupAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (city != null) 'city': city,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
      if (invoicePrefix != null) 'invoice_prefix': invoicePrefix,
      if (defaultDueDays != null) 'default_due_days': defaultDueDays,
      if (instapay != null) 'instapay': instapay,
      if (wallet != null) 'wallet': wallet,
      if (bankIban != null) 'bank_iban': bankIban,
      if (notesEn != null) 'notes_en': notesEn,
      if (notesAr != null) 'notes_ar': notesAr,
      if (backupDir != null) 'backup_dir': backupDir,
      if (lastBackupAt != null) 'last_backup_at': lastBackupAt,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? role,
    Value<String>? city,
    Value<String>? email,
    Value<String>? phone,
    Value<String>? website,
    Value<String>? invoicePrefix,
    Value<int>? defaultDueDays,
    Value<String>? instapay,
    Value<String>? wallet,
    Value<String>? bankIban,
    Value<String>? notesEn,
    Value<String>? notesAr,
    Value<String?>? backupDir,
    Value<int?>? lastBackupAt,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      city: city ?? this.city,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      defaultDueDays: defaultDueDays ?? this.defaultDueDays,
      instapay: instapay ?? this.instapay,
      wallet: wallet ?? this.wallet,
      bankIban: bankIban ?? this.bankIban,
      notesEn: notesEn ?? this.notesEn,
      notesAr: notesAr ?? this.notesAr,
      backupDir: backupDir ?? this.backupDir,
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (invoicePrefix.present) {
      map['invoice_prefix'] = Variable<String>(invoicePrefix.value);
    }
    if (defaultDueDays.present) {
      map['default_due_days'] = Variable<int>(defaultDueDays.value);
    }
    if (instapay.present) {
      map['instapay'] = Variable<String>(instapay.value);
    }
    if (wallet.present) {
      map['wallet'] = Variable<String>(wallet.value);
    }
    if (bankIban.present) {
      map['bank_iban'] = Variable<String>(bankIban.value);
    }
    if (notesEn.present) {
      map['notes_en'] = Variable<String>(notesEn.value);
    }
    if (notesAr.present) {
      map['notes_ar'] = Variable<String>(notesAr.value);
    }
    if (backupDir.present) {
      map['backup_dir'] = Variable<String>(backupDir.value);
    }
    if (lastBackupAt.present) {
      map['last_backup_at'] = Variable<int>(lastBackupAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('city: $city, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('defaultDueDays: $defaultDueDays, ')
          ..write('instapay: $instapay, ')
          ..write('wallet: $wallet, ')
          ..write('bankIban: $bankIban, ')
          ..write('notesEn: $notesEn, ')
          ..write('notesAr: $notesAr, ')
          ..write('backupDir: $backupDir, ')
          ..write('lastBackupAt: $lastBackupAt')
          ..write(')'))
        .toString();
  }
}

class $ClientsTable extends Clients with TableInfo<$ClientsTable, ClientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    check: () => ComparableExpr(
      StringExpressionOperators(name).trim().length,
    ).isBiggerThanValue(0),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactMeta = const VerificationMeta(
    'contact',
  );
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
    'contact',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    contact,
    city,
    phone,
    email,
    createdAt,
    updatedAt,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClientRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('contact')) {
      context.handle(
        _contactMeta,
        contact.isAcceptableOrUnknown(data['contact']!, _contactMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      contact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
}

class ClientRow extends DataClass implements Insertable<ClientRow> {
  final String id;
  final String name;
  final String contact;
  final String city;
  final String phone;
  final String email;
  final int createdAt;
  final int updatedAt;
  final bool archived;
  const ClientRow({
    required this.id,
    required this.name,
    required this.contact,
    required this.city,
    required this.phone,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['contact'] = Variable<String>(contact);
    map['city'] = Variable<String>(city);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      name: Value(name),
      contact: Value(contact),
      city: Value(city),
      phone: Value(phone),
      email: Value(email),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archived: Value(archived),
    );
  }

  factory ClientRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      contact: serializer.fromJson<String>(json['contact']),
      city: serializer.fromJson<String>(json['city']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'contact': serializer.toJson<String>(contact),
      'city': serializer.toJson<String>(city),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  ClientRow copyWith({
    String? id,
    String? name,
    String? contact,
    String? city,
    String? phone,
    String? email,
    int? createdAt,
    int? updatedAt,
    bool? archived,
  }) => ClientRow(
    id: id ?? this.id,
    name: name ?? this.name,
    contact: contact ?? this.contact,
    city: city ?? this.city,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archived: archived ?? this.archived,
  );
  ClientRow copyWithCompanion(ClientsCompanion data) {
    return ClientRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      contact: data.contact.present ? data.contact.value : this.contact,
      city: data.city.present ? data.city.value : this.city,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contact: $contact, ')
          ..write('city: $city, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    contact,
    city,
    phone,
    email,
    createdAt,
    updatedAt,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.contact == this.contact &&
          other.city == this.city &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archived == this.archived);
}

class ClientsCompanion extends UpdateCompanion<ClientRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> contact;
  final Value<String> city;
  final Value<String> phone;
  final Value<String> email;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> archived;
  final Value<int> rowid;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.contact = const Value.absent(),
    this.city = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientsCompanion.insert({
    required String id,
    required String name,
    this.contact = const Value.absent(),
    this.city = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ClientRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? contact,
    Expression<String>? city,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? archived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (contact != null) 'contact': contact,
      if (city != null) 'city': city,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archived != null) 'archived': archived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? contact,
    Value<String>? city,
    Value<String>? phone,
    Value<String>? email,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? archived,
    Value<int>? rowid,
  }) {
    return ClientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archived: archived ?? this.archived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contact: $contact, ')
          ..write('city: $city, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archived: $archived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices
    with TableInfo<$InvoicesTable, InvoiceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    check: () => ComparableExpr(seq).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _issueDateMeta = const VerificationMeta(
    'issueDate',
  );
  @override
  late final GeneratedColumn<String> issueDate = GeneratedColumn<String>(
    'issue_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidDateMeta = const VerificationMeta(
    'paidDate',
  );
  @override
  late final GeneratedColumn<String> paidDate = GeneratedColumn<String>(
    'paid_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    check: () => status.isIn(const ['draft', 'sent', 'paid', 'void']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contractRefMeta = const VerificationMeta(
    'contractRef',
  );
  @override
  late final GeneratedColumn<String> contractRef = GeneratedColumn<String>(
    'contract_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _vatOnMeta = const VerificationMeta('vatOn');
  @override
  late final GeneratedColumn<bool> vatOn = GeneratedColumn<bool>(
    'vat_on',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vat_on" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _vatRateBpMeta = const VerificationMeta(
    'vatRateBp',
  );
  @override
  late final GeneratedColumn<int> vatRateBp = GeneratedColumn<int>(
    'vat_rate_bp',
    aliasedName,
    false,
    check: () => ComparableExpr(vatRateBp).isBetweenValues(0, 10000),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1400),
  );
  static const VerificationMeta _notesEnMeta = const VerificationMeta(
    'notesEn',
  );
  @override
  late final GeneratedColumn<String> notesEn = GeneratedColumn<String>(
    'notes_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesArMeta = const VerificationMeta(
    'notesAr',
  );
  @override
  late final GeneratedColumn<String> notesAr = GeneratedColumn<String>(
    'notes_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _scopeOnMeta = const VerificationMeta(
    'scopeOn',
  );
  @override
  late final GeneratedColumn<bool> scopeOn = GeneratedColumn<bool>(
    'scope_on',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("scope_on" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _scopeTitleMeta = const VerificationMeta(
    'scopeTitle',
  );
  @override
  late final GeneratedColumn<String> scopeTitle = GeneratedColumn<String>(
    'scope_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _scopeOverviewMeta = const VerificationMeta(
    'scopeOverview',
  );
  @override
  late final GeneratedColumn<String> scopeOverview = GeneratedColumn<String>(
    'scope_overview',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _scopeDoneMeta = const VerificationMeta(
    'scopeDone',
  );
  @override
  late final GeneratedColumn<String> scopeDone = GeneratedColumn<String>(
    'scope_done',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _scopeDeliveredMeta = const VerificationMeta(
    'scopeDelivered',
  );
  @override
  late final GeneratedColumn<String> scopeDelivered = GeneratedColumn<String>(
    'scope_delivered',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _scopeWarrantyMeta = const VerificationMeta(
    'scopeWarranty',
  );
  @override
  late final GeneratedColumn<String> scopeWarranty = GeneratedColumn<String>(
    'scope_warranty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    number,
    year,
    seq,
    issueDate,
    dueDate,
    paidDate,
    status,
    contractRef,
    vatOn,
    vatRateBp,
    notesEn,
    notesAr,
    scopeOn,
    scopeTitle,
    scopeOverview,
    scopeDone,
    scopeDelivered,
    scopeWarranty,
    deletedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('issue_date')) {
      context.handle(
        _issueDateMeta,
        issueDate.isAcceptableOrUnknown(data['issue_date']!, _issueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_issueDateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('paid_date')) {
      context.handle(
        _paidDateMeta,
        paidDate.isAcceptableOrUnknown(data['paid_date']!, _paidDateMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('contract_ref')) {
      context.handle(
        _contractRefMeta,
        contractRef.isAcceptableOrUnknown(
          data['contract_ref']!,
          _contractRefMeta,
        ),
      );
    }
    if (data.containsKey('vat_on')) {
      context.handle(
        _vatOnMeta,
        vatOn.isAcceptableOrUnknown(data['vat_on']!, _vatOnMeta),
      );
    }
    if (data.containsKey('vat_rate_bp')) {
      context.handle(
        _vatRateBpMeta,
        vatRateBp.isAcceptableOrUnknown(data['vat_rate_bp']!, _vatRateBpMeta),
      );
    }
    if (data.containsKey('notes_en')) {
      context.handle(
        _notesEnMeta,
        notesEn.isAcceptableOrUnknown(data['notes_en']!, _notesEnMeta),
      );
    }
    if (data.containsKey('notes_ar')) {
      context.handle(
        _notesArMeta,
        notesAr.isAcceptableOrUnknown(data['notes_ar']!, _notesArMeta),
      );
    }
    if (data.containsKey('scope_on')) {
      context.handle(
        _scopeOnMeta,
        scopeOn.isAcceptableOrUnknown(data['scope_on']!, _scopeOnMeta),
      );
    }
    if (data.containsKey('scope_title')) {
      context.handle(
        _scopeTitleMeta,
        scopeTitle.isAcceptableOrUnknown(data['scope_title']!, _scopeTitleMeta),
      );
    }
    if (data.containsKey('scope_overview')) {
      context.handle(
        _scopeOverviewMeta,
        scopeOverview.isAcceptableOrUnknown(
          data['scope_overview']!,
          _scopeOverviewMeta,
        ),
      );
    }
    if (data.containsKey('scope_done')) {
      context.handle(
        _scopeDoneMeta,
        scopeDone.isAcceptableOrUnknown(data['scope_done']!, _scopeDoneMeta),
      );
    }
    if (data.containsKey('scope_delivered')) {
      context.handle(
        _scopeDeliveredMeta,
        scopeDelivered.isAcceptableOrUnknown(
          data['scope_delivered']!,
          _scopeDeliveredMeta,
        ),
      );
    }
    if (data.containsKey('scope_warranty')) {
      context.handle(
        _scopeWarrantyMeta,
        scopeWarranty.isAcceptableOrUnknown(
          data['scope_warranty']!,
          _scopeWarrantyMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {year, seq},
  ];
  @override
  InvoiceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      issueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}issue_date'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      )!,
      paidDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paid_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      contractRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contract_ref'],
      )!,
      vatOn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vat_on'],
      )!,
      vatRateBp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vat_rate_bp'],
      )!,
      notesEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes_en'],
      )!,
      notesAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes_ar'],
      )!,
      scopeOn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}scope_on'],
      )!,
      scopeTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_title'],
      )!,
      scopeOverview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_overview'],
      )!,
      scopeDone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_done'],
      )!,
      scopeDelivered: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_delivered'],
      )!,
      scopeWarranty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_warranty'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
}

class InvoiceRow extends DataClass implements Insertable<InvoiceRow> {
  final String id;
  final String clientId;
  final String number;
  final int year;
  final int seq;
  final String issueDate;
  final String dueDate;
  final String? paidDate;
  final String status;
  final String contractRef;
  final bool vatOn;
  final int vatRateBp;
  final String notesEn;
  final String notesAr;
  final bool scopeOn;
  final String scopeTitle;
  final String scopeOverview;
  final String scopeDone;
  final String scopeDelivered;
  final String scopeWarranty;
  final int? deletedAt;
  final int createdAt;
  final int updatedAt;
  const InvoiceRow({
    required this.id,
    required this.clientId,
    required this.number,
    required this.year,
    required this.seq,
    required this.issueDate,
    required this.dueDate,
    this.paidDate,
    required this.status,
    required this.contractRef,
    required this.vatOn,
    required this.vatRateBp,
    required this.notesEn,
    required this.notesAr,
    required this.scopeOn,
    required this.scopeTitle,
    required this.scopeOverview,
    required this.scopeDone,
    required this.scopeDelivered,
    required this.scopeWarranty,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['number'] = Variable<String>(number);
    map['year'] = Variable<int>(year);
    map['seq'] = Variable<int>(seq);
    map['issue_date'] = Variable<String>(issueDate);
    map['due_date'] = Variable<String>(dueDate);
    if (!nullToAbsent || paidDate != null) {
      map['paid_date'] = Variable<String>(paidDate);
    }
    map['status'] = Variable<String>(status);
    map['contract_ref'] = Variable<String>(contractRef);
    map['vat_on'] = Variable<bool>(vatOn);
    map['vat_rate_bp'] = Variable<int>(vatRateBp);
    map['notes_en'] = Variable<String>(notesEn);
    map['notes_ar'] = Variable<String>(notesAr);
    map['scope_on'] = Variable<bool>(scopeOn);
    map['scope_title'] = Variable<String>(scopeTitle);
    map['scope_overview'] = Variable<String>(scopeOverview);
    map['scope_done'] = Variable<String>(scopeDone);
    map['scope_delivered'] = Variable<String>(scopeDelivered);
    map['scope_warranty'] = Variable<String>(scopeWarranty);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      clientId: Value(clientId),
      number: Value(number),
      year: Value(year),
      seq: Value(seq),
      issueDate: Value(issueDate),
      dueDate: Value(dueDate),
      paidDate: paidDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paidDate),
      status: Value(status),
      contractRef: Value(contractRef),
      vatOn: Value(vatOn),
      vatRateBp: Value(vatRateBp),
      notesEn: Value(notesEn),
      notesAr: Value(notesAr),
      scopeOn: Value(scopeOn),
      scopeTitle: Value(scopeTitle),
      scopeOverview: Value(scopeOverview),
      scopeDone: Value(scopeDone),
      scopeDelivered: Value(scopeDelivered),
      scopeWarranty: Value(scopeWarranty),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory InvoiceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceRow(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      number: serializer.fromJson<String>(json['number']),
      year: serializer.fromJson<int>(json['year']),
      seq: serializer.fromJson<int>(json['seq']),
      issueDate: serializer.fromJson<String>(json['issueDate']),
      dueDate: serializer.fromJson<String>(json['dueDate']),
      paidDate: serializer.fromJson<String?>(json['paidDate']),
      status: serializer.fromJson<String>(json['status']),
      contractRef: serializer.fromJson<String>(json['contractRef']),
      vatOn: serializer.fromJson<bool>(json['vatOn']),
      vatRateBp: serializer.fromJson<int>(json['vatRateBp']),
      notesEn: serializer.fromJson<String>(json['notesEn']),
      notesAr: serializer.fromJson<String>(json['notesAr']),
      scopeOn: serializer.fromJson<bool>(json['scopeOn']),
      scopeTitle: serializer.fromJson<String>(json['scopeTitle']),
      scopeOverview: serializer.fromJson<String>(json['scopeOverview']),
      scopeDone: serializer.fromJson<String>(json['scopeDone']),
      scopeDelivered: serializer.fromJson<String>(json['scopeDelivered']),
      scopeWarranty: serializer.fromJson<String>(json['scopeWarranty']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'number': serializer.toJson<String>(number),
      'year': serializer.toJson<int>(year),
      'seq': serializer.toJson<int>(seq),
      'issueDate': serializer.toJson<String>(issueDate),
      'dueDate': serializer.toJson<String>(dueDate),
      'paidDate': serializer.toJson<String?>(paidDate),
      'status': serializer.toJson<String>(status),
      'contractRef': serializer.toJson<String>(contractRef),
      'vatOn': serializer.toJson<bool>(vatOn),
      'vatRateBp': serializer.toJson<int>(vatRateBp),
      'notesEn': serializer.toJson<String>(notesEn),
      'notesAr': serializer.toJson<String>(notesAr),
      'scopeOn': serializer.toJson<bool>(scopeOn),
      'scopeTitle': serializer.toJson<String>(scopeTitle),
      'scopeOverview': serializer.toJson<String>(scopeOverview),
      'scopeDone': serializer.toJson<String>(scopeDone),
      'scopeDelivered': serializer.toJson<String>(scopeDelivered),
      'scopeWarranty': serializer.toJson<String>(scopeWarranty),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  InvoiceRow copyWith({
    String? id,
    String? clientId,
    String? number,
    int? year,
    int? seq,
    String? issueDate,
    String? dueDate,
    Value<String?> paidDate = const Value.absent(),
    String? status,
    String? contractRef,
    bool? vatOn,
    int? vatRateBp,
    String? notesEn,
    String? notesAr,
    bool? scopeOn,
    String? scopeTitle,
    String? scopeOverview,
    String? scopeDone,
    String? scopeDelivered,
    String? scopeWarranty,
    Value<int?> deletedAt = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => InvoiceRow(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    number: number ?? this.number,
    year: year ?? this.year,
    seq: seq ?? this.seq,
    issueDate: issueDate ?? this.issueDate,
    dueDate: dueDate ?? this.dueDate,
    paidDate: paidDate.present ? paidDate.value : this.paidDate,
    status: status ?? this.status,
    contractRef: contractRef ?? this.contractRef,
    vatOn: vatOn ?? this.vatOn,
    vatRateBp: vatRateBp ?? this.vatRateBp,
    notesEn: notesEn ?? this.notesEn,
    notesAr: notesAr ?? this.notesAr,
    scopeOn: scopeOn ?? this.scopeOn,
    scopeTitle: scopeTitle ?? this.scopeTitle,
    scopeOverview: scopeOverview ?? this.scopeOverview,
    scopeDone: scopeDone ?? this.scopeDone,
    scopeDelivered: scopeDelivered ?? this.scopeDelivered,
    scopeWarranty: scopeWarranty ?? this.scopeWarranty,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InvoiceRow copyWithCompanion(InvoicesCompanion data) {
    return InvoiceRow(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      number: data.number.present ? data.number.value : this.number,
      year: data.year.present ? data.year.value : this.year,
      seq: data.seq.present ? data.seq.value : this.seq,
      issueDate: data.issueDate.present ? data.issueDate.value : this.issueDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      paidDate: data.paidDate.present ? data.paidDate.value : this.paidDate,
      status: data.status.present ? data.status.value : this.status,
      contractRef: data.contractRef.present
          ? data.contractRef.value
          : this.contractRef,
      vatOn: data.vatOn.present ? data.vatOn.value : this.vatOn,
      vatRateBp: data.vatRateBp.present ? data.vatRateBp.value : this.vatRateBp,
      notesEn: data.notesEn.present ? data.notesEn.value : this.notesEn,
      notesAr: data.notesAr.present ? data.notesAr.value : this.notesAr,
      scopeOn: data.scopeOn.present ? data.scopeOn.value : this.scopeOn,
      scopeTitle: data.scopeTitle.present
          ? data.scopeTitle.value
          : this.scopeTitle,
      scopeOverview: data.scopeOverview.present
          ? data.scopeOverview.value
          : this.scopeOverview,
      scopeDone: data.scopeDone.present ? data.scopeDone.value : this.scopeDone,
      scopeDelivered: data.scopeDelivered.present
          ? data.scopeDelivered.value
          : this.scopeDelivered,
      scopeWarranty: data.scopeWarranty.present
          ? data.scopeWarranty.value
          : this.scopeWarranty,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceRow(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('number: $number, ')
          ..write('year: $year, ')
          ..write('seq: $seq, ')
          ..write('issueDate: $issueDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('paidDate: $paidDate, ')
          ..write('status: $status, ')
          ..write('contractRef: $contractRef, ')
          ..write('vatOn: $vatOn, ')
          ..write('vatRateBp: $vatRateBp, ')
          ..write('notesEn: $notesEn, ')
          ..write('notesAr: $notesAr, ')
          ..write('scopeOn: $scopeOn, ')
          ..write('scopeTitle: $scopeTitle, ')
          ..write('scopeOverview: $scopeOverview, ')
          ..write('scopeDone: $scopeDone, ')
          ..write('scopeDelivered: $scopeDelivered, ')
          ..write('scopeWarranty: $scopeWarranty, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    clientId,
    number,
    year,
    seq,
    issueDate,
    dueDate,
    paidDate,
    status,
    contractRef,
    vatOn,
    vatRateBp,
    notesEn,
    notesAr,
    scopeOn,
    scopeTitle,
    scopeOverview,
    scopeDone,
    scopeDelivered,
    scopeWarranty,
    deletedAt,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceRow &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.number == this.number &&
          other.year == this.year &&
          other.seq == this.seq &&
          other.issueDate == this.issueDate &&
          other.dueDate == this.dueDate &&
          other.paidDate == this.paidDate &&
          other.status == this.status &&
          other.contractRef == this.contractRef &&
          other.vatOn == this.vatOn &&
          other.vatRateBp == this.vatRateBp &&
          other.notesEn == this.notesEn &&
          other.notesAr == this.notesAr &&
          other.scopeOn == this.scopeOn &&
          other.scopeTitle == this.scopeTitle &&
          other.scopeOverview == this.scopeOverview &&
          other.scopeDone == this.scopeDone &&
          other.scopeDelivered == this.scopeDelivered &&
          other.scopeWarranty == this.scopeWarranty &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InvoicesCompanion extends UpdateCompanion<InvoiceRow> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> number;
  final Value<int> year;
  final Value<int> seq;
  final Value<String> issueDate;
  final Value<String> dueDate;
  final Value<String?> paidDate;
  final Value<String> status;
  final Value<String> contractRef;
  final Value<bool> vatOn;
  final Value<int> vatRateBp;
  final Value<String> notesEn;
  final Value<String> notesAr;
  final Value<bool> scopeOn;
  final Value<String> scopeTitle;
  final Value<String> scopeOverview;
  final Value<String> scopeDone;
  final Value<String> scopeDelivered;
  final Value<String> scopeWarranty;
  final Value<int?> deletedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.number = const Value.absent(),
    this.year = const Value.absent(),
    this.seq = const Value.absent(),
    this.issueDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.status = const Value.absent(),
    this.contractRef = const Value.absent(),
    this.vatOn = const Value.absent(),
    this.vatRateBp = const Value.absent(),
    this.notesEn = const Value.absent(),
    this.notesAr = const Value.absent(),
    this.scopeOn = const Value.absent(),
    this.scopeTitle = const Value.absent(),
    this.scopeOverview = const Value.absent(),
    this.scopeDone = const Value.absent(),
    this.scopeDelivered = const Value.absent(),
    this.scopeWarranty = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoicesCompanion.insert({
    required String id,
    required String clientId,
    required String number,
    required int year,
    required int seq,
    required String issueDate,
    required String dueDate,
    this.paidDate = const Value.absent(),
    required String status,
    this.contractRef = const Value.absent(),
    this.vatOn = const Value.absent(),
    this.vatRateBp = const Value.absent(),
    this.notesEn = const Value.absent(),
    this.notesAr = const Value.absent(),
    this.scopeOn = const Value.absent(),
    this.scopeTitle = const Value.absent(),
    this.scopeOverview = const Value.absent(),
    this.scopeDone = const Value.absent(),
    this.scopeDelivered = const Value.absent(),
    this.scopeWarranty = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       number = Value(number),
       year = Value(year),
       seq = Value(seq),
       issueDate = Value(issueDate),
       dueDate = Value(dueDate),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<InvoiceRow> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? number,
    Expression<int>? year,
    Expression<int>? seq,
    Expression<String>? issueDate,
    Expression<String>? dueDate,
    Expression<String>? paidDate,
    Expression<String>? status,
    Expression<String>? contractRef,
    Expression<bool>? vatOn,
    Expression<int>? vatRateBp,
    Expression<String>? notesEn,
    Expression<String>? notesAr,
    Expression<bool>? scopeOn,
    Expression<String>? scopeTitle,
    Expression<String>? scopeOverview,
    Expression<String>? scopeDone,
    Expression<String>? scopeDelivered,
    Expression<String>? scopeWarranty,
    Expression<int>? deletedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (number != null) 'number': number,
      if (year != null) 'year': year,
      if (seq != null) 'seq': seq,
      if (issueDate != null) 'issue_date': issueDate,
      if (dueDate != null) 'due_date': dueDate,
      if (paidDate != null) 'paid_date': paidDate,
      if (status != null) 'status': status,
      if (contractRef != null) 'contract_ref': contractRef,
      if (vatOn != null) 'vat_on': vatOn,
      if (vatRateBp != null) 'vat_rate_bp': vatRateBp,
      if (notesEn != null) 'notes_en': notesEn,
      if (notesAr != null) 'notes_ar': notesAr,
      if (scopeOn != null) 'scope_on': scopeOn,
      if (scopeTitle != null) 'scope_title': scopeTitle,
      if (scopeOverview != null) 'scope_overview': scopeOverview,
      if (scopeDone != null) 'scope_done': scopeDone,
      if (scopeDelivered != null) 'scope_delivered': scopeDelivered,
      if (scopeWarranty != null) 'scope_warranty': scopeWarranty,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoicesCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? number,
    Value<int>? year,
    Value<int>? seq,
    Value<String>? issueDate,
    Value<String>? dueDate,
    Value<String?>? paidDate,
    Value<String>? status,
    Value<String>? contractRef,
    Value<bool>? vatOn,
    Value<int>? vatRateBp,
    Value<String>? notesEn,
    Value<String>? notesAr,
    Value<bool>? scopeOn,
    Value<String>? scopeTitle,
    Value<String>? scopeOverview,
    Value<String>? scopeDone,
    Value<String>? scopeDelivered,
    Value<String>? scopeWarranty,
    Value<int?>? deletedAt,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      number: number ?? this.number,
      year: year ?? this.year,
      seq: seq ?? this.seq,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      status: status ?? this.status,
      contractRef: contractRef ?? this.contractRef,
      vatOn: vatOn ?? this.vatOn,
      vatRateBp: vatRateBp ?? this.vatRateBp,
      notesEn: notesEn ?? this.notesEn,
      notesAr: notesAr ?? this.notesAr,
      scopeOn: scopeOn ?? this.scopeOn,
      scopeTitle: scopeTitle ?? this.scopeTitle,
      scopeOverview: scopeOverview ?? this.scopeOverview,
      scopeDone: scopeDone ?? this.scopeDone,
      scopeDelivered: scopeDelivered ?? this.scopeDelivered,
      scopeWarranty: scopeWarranty ?? this.scopeWarranty,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (issueDate.present) {
      map['issue_date'] = Variable<String>(issueDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (paidDate.present) {
      map['paid_date'] = Variable<String>(paidDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (contractRef.present) {
      map['contract_ref'] = Variable<String>(contractRef.value);
    }
    if (vatOn.present) {
      map['vat_on'] = Variable<bool>(vatOn.value);
    }
    if (vatRateBp.present) {
      map['vat_rate_bp'] = Variable<int>(vatRateBp.value);
    }
    if (notesEn.present) {
      map['notes_en'] = Variable<String>(notesEn.value);
    }
    if (notesAr.present) {
      map['notes_ar'] = Variable<String>(notesAr.value);
    }
    if (scopeOn.present) {
      map['scope_on'] = Variable<bool>(scopeOn.value);
    }
    if (scopeTitle.present) {
      map['scope_title'] = Variable<String>(scopeTitle.value);
    }
    if (scopeOverview.present) {
      map['scope_overview'] = Variable<String>(scopeOverview.value);
    }
    if (scopeDone.present) {
      map['scope_done'] = Variable<String>(scopeDone.value);
    }
    if (scopeDelivered.present) {
      map['scope_delivered'] = Variable<String>(scopeDelivered.value);
    }
    if (scopeWarranty.present) {
      map['scope_warranty'] = Variable<String>(scopeWarranty.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('number: $number, ')
          ..write('year: $year, ')
          ..write('seq: $seq, ')
          ..write('issueDate: $issueDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('paidDate: $paidDate, ')
          ..write('status: $status, ')
          ..write('contractRef: $contractRef, ')
          ..write('vatOn: $vatOn, ')
          ..write('vatRateBp: $vatRateBp, ')
          ..write('notesEn: $notesEn, ')
          ..write('notesAr: $notesAr, ')
          ..write('scopeOn: $scopeOn, ')
          ..write('scopeTitle: $scopeTitle, ')
          ..write('scopeOverview: $scopeOverview, ')
          ..write('scopeDone: $scopeDone, ')
          ..write('scopeDelivered: $scopeDelivered, ')
          ..write('scopeWarranty: $scopeWarranty, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SectionsTable extends Sections
    with TableInfo<$SectionsTable, SectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleEnMeta = const VerificationMeta(
    'titleEn',
  );
  @override
  late final GeneratedColumn<String> titleEn = GeneratedColumn<String>(
    'title_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _titleArMeta = const VerificationMeta(
    'titleAr',
  );
  @override
  late final GeneratedColumn<String> titleAr = GeneratedColumn<String>(
    'title_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    check: () => currency.isIn(const ['EGP', 'USD', 'SAR', 'AED', 'EUR']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceId,
    position,
    titleEn,
    titleAr,
    currency,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sections';
  @override
  VerificationContext validateIntegrity(
    Insertable<SectionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('title_en')) {
      context.handle(
        _titleEnMeta,
        titleEn.isAcceptableOrUnknown(data['title_en']!, _titleEnMeta),
      );
    }
    if (data.containsKey('title_ar')) {
      context.handle(
        _titleArMeta,
        titleAr.isAcceptableOrUnknown(data['title_ar']!, _titleArMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SectionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      titleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_en'],
      )!,
      titleAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ar'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
    );
  }

  @override
  $SectionsTable createAlias(String alias) {
    return $SectionsTable(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
}

class SectionRow extends DataClass implements Insertable<SectionRow> {
  final String id;
  final String invoiceId;
  final int position;
  final String titleEn;
  final String titleAr;
  final String currency;
  const SectionRow({
    required this.id,
    required this.invoiceId,
    required this.position,
    required this.titleEn,
    required this.titleAr,
    required this.currency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['invoice_id'] = Variable<String>(invoiceId);
    map['position'] = Variable<int>(position);
    map['title_en'] = Variable<String>(titleEn);
    map['title_ar'] = Variable<String>(titleAr);
    map['currency'] = Variable<String>(currency);
    return map;
  }

  SectionsCompanion toCompanion(bool nullToAbsent) {
    return SectionsCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      position: Value(position),
      titleEn: Value(titleEn),
      titleAr: Value(titleAr),
      currency: Value(currency),
    );
  }

  factory SectionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SectionRow(
      id: serializer.fromJson<String>(json['id']),
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      position: serializer.fromJson<int>(json['position']),
      titleEn: serializer.fromJson<String>(json['titleEn']),
      titleAr: serializer.fromJson<String>(json['titleAr']),
      currency: serializer.fromJson<String>(json['currency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'invoiceId': serializer.toJson<String>(invoiceId),
      'position': serializer.toJson<int>(position),
      'titleEn': serializer.toJson<String>(titleEn),
      'titleAr': serializer.toJson<String>(titleAr),
      'currency': serializer.toJson<String>(currency),
    };
  }

  SectionRow copyWith({
    String? id,
    String? invoiceId,
    int? position,
    String? titleEn,
    String? titleAr,
    String? currency,
  }) => SectionRow(
    id: id ?? this.id,
    invoiceId: invoiceId ?? this.invoiceId,
    position: position ?? this.position,
    titleEn: titleEn ?? this.titleEn,
    titleAr: titleAr ?? this.titleAr,
    currency: currency ?? this.currency,
  );
  SectionRow copyWithCompanion(SectionsCompanion data) {
    return SectionRow(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      position: data.position.present ? data.position.value : this.position,
      titleEn: data.titleEn.present ? data.titleEn.value : this.titleEn,
      titleAr: data.titleAr.present ? data.titleAr.value : this.titleAr,
      currency: data.currency.present ? data.currency.value : this.currency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SectionRow(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('position: $position, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleAr: $titleAr, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, invoiceId, position, titleEn, titleAr, currency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SectionRow &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.position == this.position &&
          other.titleEn == this.titleEn &&
          other.titleAr == this.titleAr &&
          other.currency == this.currency);
}

class SectionsCompanion extends UpdateCompanion<SectionRow> {
  final Value<String> id;
  final Value<String> invoiceId;
  final Value<int> position;
  final Value<String> titleEn;
  final Value<String> titleAr;
  final Value<String> currency;
  final Value<int> rowid;
  const SectionsCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.position = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.titleAr = const Value.absent(),
    this.currency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SectionsCompanion.insert({
    required String id,
    required String invoiceId,
    required int position,
    this.titleEn = const Value.absent(),
    this.titleAr = const Value.absent(),
    required String currency,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       invoiceId = Value(invoiceId),
       position = Value(position),
       currency = Value(currency);
  static Insertable<SectionRow> custom({
    Expression<String>? id,
    Expression<String>? invoiceId,
    Expression<int>? position,
    Expression<String>? titleEn,
    Expression<String>? titleAr,
    Expression<String>? currency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (position != null) 'position': position,
      if (titleEn != null) 'title_en': titleEn,
      if (titleAr != null) 'title_ar': titleAr,
      if (currency != null) 'currency': currency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? invoiceId,
    Value<int>? position,
    Value<String>? titleEn,
    Value<String>? titleAr,
    Value<String>? currency,
    Value<int>? rowid,
  }) {
    return SectionsCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      position: position ?? this.position,
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      currency: currency ?? this.currency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (titleEn.present) {
      map['title_en'] = Variable<String>(titleEn.value);
    }
    if (titleAr.present) {
      map['title_ar'] = Variable<String>(titleAr.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SectionsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('position: $position, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleAr: $titleAr, ')
          ..write('currency: $currency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, ItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sections (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceMeta = const VerificationMeta(
    'service',
  );
  @override
  late final GeneratedColumn<String> service = GeneratedColumn<String>(
    'service',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cycleMeta = const VerificationMeta('cycle');
  @override
  late final GeneratedColumn<String> cycle = GeneratedColumn<String>(
    'cycle',
    aliasedName,
    false,
    check: () => cycle.isIn(const ['one-time', 'monthly', 'annual']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    check: () => ComparableExpr(qty).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMinorMeta = const VerificationMeta(
    'unitPriceMinor',
  );
  @override
  late final GeneratedColumn<int> unitPriceMinor = GeneratedColumn<int>(
    'unit_price_minor',
    aliasedName,
    false,
    check: () => ComparableExpr(unitPriceMinor).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sectionId,
    position,
    service,
    description,
    cycle,
    qty,
    unitPriceMinor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('service')) {
      context.handle(
        _serviceMeta,
        service.isAcceptableOrUnknown(data['service']!, _serviceMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('cycle')) {
      context.handle(
        _cycleMeta,
        cycle.isAcceptableOrUnknown(data['cycle']!, _cycleMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('unit_price_minor')) {
      context.handle(
        _unitPriceMinorMeta,
        unitPriceMinor.isAcceptableOrUnknown(
          data['unit_price_minor']!,
          _unitPriceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMinorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      service: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      cycle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      unitPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_minor'],
      )!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
}

class ItemRow extends DataClass implements Insertable<ItemRow> {
  final String id;
  final String sectionId;
  final int position;
  final String service;
  final String description;
  final String cycle;
  final int qty;
  final int unitPriceMinor;
  const ItemRow({
    required this.id,
    required this.sectionId,
    required this.position,
    required this.service,
    required this.description,
    required this.cycle,
    required this.qty,
    required this.unitPriceMinor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['section_id'] = Variable<String>(sectionId);
    map['position'] = Variable<int>(position);
    map['service'] = Variable<String>(service);
    map['description'] = Variable<String>(description);
    map['cycle'] = Variable<String>(cycle);
    map['qty'] = Variable<int>(qty);
    map['unit_price_minor'] = Variable<int>(unitPriceMinor);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      sectionId: Value(sectionId),
      position: Value(position),
      service: Value(service),
      description: Value(description),
      cycle: Value(cycle),
      qty: Value(qty),
      unitPriceMinor: Value(unitPriceMinor),
    );
  }

  factory ItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemRow(
      id: serializer.fromJson<String>(json['id']),
      sectionId: serializer.fromJson<String>(json['sectionId']),
      position: serializer.fromJson<int>(json['position']),
      service: serializer.fromJson<String>(json['service']),
      description: serializer.fromJson<String>(json['description']),
      cycle: serializer.fromJson<String>(json['cycle']),
      qty: serializer.fromJson<int>(json['qty']),
      unitPriceMinor: serializer.fromJson<int>(json['unitPriceMinor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sectionId': serializer.toJson<String>(sectionId),
      'position': serializer.toJson<int>(position),
      'service': serializer.toJson<String>(service),
      'description': serializer.toJson<String>(description),
      'cycle': serializer.toJson<String>(cycle),
      'qty': serializer.toJson<int>(qty),
      'unitPriceMinor': serializer.toJson<int>(unitPriceMinor),
    };
  }

  ItemRow copyWith({
    String? id,
    String? sectionId,
    int? position,
    String? service,
    String? description,
    String? cycle,
    int? qty,
    int? unitPriceMinor,
  }) => ItemRow(
    id: id ?? this.id,
    sectionId: sectionId ?? this.sectionId,
    position: position ?? this.position,
    service: service ?? this.service,
    description: description ?? this.description,
    cycle: cycle ?? this.cycle,
    qty: qty ?? this.qty,
    unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
  );
  ItemRow copyWithCompanion(ItemsCompanion data) {
    return ItemRow(
      id: data.id.present ? data.id.value : this.id,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      position: data.position.present ? data.position.value : this.position,
      service: data.service.present ? data.service.value : this.service,
      description: data.description.present
          ? data.description.value
          : this.description,
      cycle: data.cycle.present ? data.cycle.value : this.cycle,
      qty: data.qty.present ? data.qty.value : this.qty,
      unitPriceMinor: data.unitPriceMinor.present
          ? data.unitPriceMinor.value
          : this.unitPriceMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemRow(')
          ..write('id: $id, ')
          ..write('sectionId: $sectionId, ')
          ..write('position: $position, ')
          ..write('service: $service, ')
          ..write('description: $description, ')
          ..write('cycle: $cycle, ')
          ..write('qty: $qty, ')
          ..write('unitPriceMinor: $unitPriceMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sectionId,
    position,
    service,
    description,
    cycle,
    qty,
    unitPriceMinor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemRow &&
          other.id == this.id &&
          other.sectionId == this.sectionId &&
          other.position == this.position &&
          other.service == this.service &&
          other.description == this.description &&
          other.cycle == this.cycle &&
          other.qty == this.qty &&
          other.unitPriceMinor == this.unitPriceMinor);
}

class ItemsCompanion extends UpdateCompanion<ItemRow> {
  final Value<String> id;
  final Value<String> sectionId;
  final Value<int> position;
  final Value<String> service;
  final Value<String> description;
  final Value<String> cycle;
  final Value<int> qty;
  final Value<int> unitPriceMinor;
  final Value<int> rowid;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.position = const Value.absent(),
    this.service = const Value.absent(),
    this.description = const Value.absent(),
    this.cycle = const Value.absent(),
    this.qty = const Value.absent(),
    this.unitPriceMinor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemsCompanion.insert({
    required String id,
    required String sectionId,
    required int position,
    this.service = const Value.absent(),
    this.description = const Value.absent(),
    required String cycle,
    required int qty,
    required int unitPriceMinor,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sectionId = Value(sectionId),
       position = Value(position),
       cycle = Value(cycle),
       qty = Value(qty),
       unitPriceMinor = Value(unitPriceMinor);
  static Insertable<ItemRow> custom({
    Expression<String>? id,
    Expression<String>? sectionId,
    Expression<int>? position,
    Expression<String>? service,
    Expression<String>? description,
    Expression<String>? cycle,
    Expression<int>? qty,
    Expression<int>? unitPriceMinor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sectionId != null) 'section_id': sectionId,
      if (position != null) 'position': position,
      if (service != null) 'service': service,
      if (description != null) 'description': description,
      if (cycle != null) 'cycle': cycle,
      if (qty != null) 'qty': qty,
      if (unitPriceMinor != null) 'unit_price_minor': unitPriceMinor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? sectionId,
    Value<int>? position,
    Value<String>? service,
    Value<String>? description,
    Value<String>? cycle,
    Value<int>? qty,
    Value<int>? unitPriceMinor,
    Value<int>? rowid,
  }) {
    return ItemsCompanion(
      id: id ?? this.id,
      sectionId: sectionId ?? this.sectionId,
      position: position ?? this.position,
      service: service ?? this.service,
      description: description ?? this.description,
      cycle: cycle ?? this.cycle,
      qty: qty ?? this.qty,
      unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (service.present) {
      map['service'] = Variable<String>(service.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (cycle.present) {
      map['cycle'] = Variable<String>(cycle.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (unitPriceMinor.present) {
      map['unit_price_minor'] = Variable<int>(unitPriceMinor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('sectionId: $sectionId, ')
          ..write('position: $position, ')
          ..write('service: $service, ')
          ..write('description: $description, ')
          ..write('cycle: $cycle, ')
          ..write('qty: $qty, ')
          ..write('unitPriceMinor: $unitPriceMinor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $SectionsTable sections = $SectionsTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final Index invoicesClient = Index(
    'invoices_client',
    'CREATE INDEX invoices_client ON invoices (client_id)',
  );
  late final Index sectionsInvoice = Index(
    'sections_invoice',
    'CREATE INDEX sections_invoice ON sections (invoice_id)',
  );
  late final Index itemsSection = Index(
    'items_section',
    'CREATE INDEX items_section ON items (section_id)',
  );
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final ClientsDao clientsDao = ClientsDao(this as AppDatabase);
  late final InvoicesDao invoicesDao = InvoicesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettings,
    clients,
    invoices,
    sections,
    items,
    invoicesClient,
    sectionsInvoice,
    itemsSection,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'invoices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sections', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> role,
      Value<String> city,
      Value<String> email,
      Value<String> phone,
      Value<String> website,
      Value<String> invoicePrefix,
      Value<int> defaultDueDays,
      Value<String> instapay,
      Value<String> wallet,
      Value<String> bankIban,
      Value<String> notesEn,
      Value<String> notesAr,
      Value<String?> backupDir,
      Value<int?> lastBackupAt,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> role,
      Value<String> city,
      Value<String> email,
      Value<String> phone,
      Value<String> website,
      Value<String> invoicePrefix,
      Value<int> defaultDueDays,
      Value<String> instapay,
      Value<String> wallet,
      Value<String> bankIban,
      Value<String> notesEn,
      Value<String> notesAr,
      Value<String?> backupDir,
      Value<int?> lastBackupAt,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultDueDays => $composableBuilder(
    column: $table.defaultDueDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instapay => $composableBuilder(
    column: $table.instapay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wallet => $composableBuilder(
    column: $table.wallet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankIban => $composableBuilder(
    column: $table.bankIban,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notesEn => $composableBuilder(
    column: $table.notesEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notesAr => $composableBuilder(
    column: $table.notesAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backupDir => $composableBuilder(
    column: $table.backupDir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastBackupAt => $composableBuilder(
    column: $table.lastBackupAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultDueDays => $composableBuilder(
    column: $table.defaultDueDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instapay => $composableBuilder(
    column: $table.instapay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wallet => $composableBuilder(
    column: $table.wallet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankIban => $composableBuilder(
    column: $table.bankIban,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notesEn => $composableBuilder(
    column: $table.notesEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notesAr => $composableBuilder(
    column: $table.notesAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backupDir => $composableBuilder(
    column: $table.backupDir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastBackupAt => $composableBuilder(
    column: $table.lastBackupAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultDueDays => $composableBuilder(
    column: $table.defaultDueDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instapay =>
      $composableBuilder(column: $table.instapay, builder: (column) => column);

  GeneratedColumn<String> get wallet =>
      $composableBuilder(column: $table.wallet, builder: (column) => column);

  GeneratedColumn<String> get bankIban =>
      $composableBuilder(column: $table.bankIban, builder: (column) => column);

  GeneratedColumn<String> get notesEn =>
      $composableBuilder(column: $table.notesEn, builder: (column) => column);

  GeneratedColumn<String> get notesAr =>
      $composableBuilder(column: $table.notesAr, builder: (column) => column);

  GeneratedColumn<String> get backupDir =>
      $composableBuilder(column: $table.backupDir, builder: (column) => column);

  GeneratedColumn<int> get lastBackupAt => $composableBuilder(
    column: $table.lastBackupAt,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          SettingsRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$AppDatabase, $AppSettingsTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> website = const Value.absent(),
                Value<String> invoicePrefix = const Value.absent(),
                Value<int> defaultDueDays = const Value.absent(),
                Value<String> instapay = const Value.absent(),
                Value<String> wallet = const Value.absent(),
                Value<String> bankIban = const Value.absent(),
                Value<String> notesEn = const Value.absent(),
                Value<String> notesAr = const Value.absent(),
                Value<String?> backupDir = const Value.absent(),
                Value<int?> lastBackupAt = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                name: name,
                role: role,
                city: city,
                email: email,
                phone: phone,
                website: website,
                invoicePrefix: invoicePrefix,
                defaultDueDays: defaultDueDays,
                instapay: instapay,
                wallet: wallet,
                bankIban: bankIban,
                notesEn: notesEn,
                notesAr: notesAr,
                backupDir: backupDir,
                lastBackupAt: lastBackupAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> website = const Value.absent(),
                Value<String> invoicePrefix = const Value.absent(),
                Value<int> defaultDueDays = const Value.absent(),
                Value<String> instapay = const Value.absent(),
                Value<String> wallet = const Value.absent(),
                Value<String> bankIban = const Value.absent(),
                Value<String> notesEn = const Value.absent(),
                Value<String> notesAr = const Value.absent(),
                Value<String?> backupDir = const Value.absent(),
                Value<int?> lastBackupAt = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                name: name,
                role: role,
                city: city,
                email: email,
                phone: phone,
                website: website,
                invoicePrefix: invoicePrefix,
                defaultDueDays: defaultDueDays,
                instapay: instapay,
                wallet: wallet,
                bankIban: bankIban,
                notesEn: notesEn,
                notesAr: notesAr,
                backupDir: backupDir,
                lastBackupAt: lastBackupAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, SettingsRow>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, SettingsRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      SettingsRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        SettingsRow,
        BaseReferences<_$AppDatabase, $AppSettingsTable, SettingsRow>,
      ),
      SettingsRow,
      PrefetchHooks Function()
    >;
typedef $$ClientsTableCreateCompanionBuilder =
    ClientsCompanion Function({
      required String id,
      required String name,
      Value<String> contact,
      Value<String> city,
      Value<String> phone,
      Value<String> email,
      required int createdAt,
      required int updatedAt,
      Value<bool> archived,
      Value<int> rowid,
    });
typedef $$ClientsTableUpdateCompanionBuilder =
    ClientsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> contact,
      Value<String> city,
      Value<String> phone,
      Value<String> email,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> archived,
      Value<int> rowid,
    });

final class $$ClientsTableReferences
    extends BaseReferences<_$AppDatabase, $ClientsTable, ClientRow> {
  $$ClientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InvoicesTable, List<InvoiceRow>>
  _invoicesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoices,
    aliasName: 'clients__id__invoices__client_id',
  );

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> invoicesRefs(
    Expression<bool> Function($$InvoicesTableFilterComposer f) f,
  ) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  Expression<T> invoicesRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTable,
          ClientRow,
          $$ClientsTableFilterComposer,
          $$ClientsTableOrderingComposer,
          $$ClientsTableAnnotationComposer,
          $$ClientsTableCreateCompanionBuilder,
          $$ClientsTableUpdateCompanionBuilder,
          (ClientRow, $$ClientsTableReferences),
          ClientRow,
          PrefetchHooks Function({bool invoicesRefs})
        > {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> contact = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientsCompanion(
                id: id,
                name: name,
                contact: contact,
                city: city,
                phone: phone,
                email: email,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archived: archived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> contact = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientsCompanion.insert(
                id: id,
                name: name,
                contact: contact,
                city: city,
                phone: phone,
                email: email,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archived: archived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ClientsTable, ClientRow>(table),
                  $$ClientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invoicesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (invoicesRefs) db.invoices],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (invoicesRefs)
                    await $_getPrefetchedDataByColumns<
                      ClientRow,
                      $ClientsTable,
                      InvoiceRow,
                      $InvoicesTable
                    >(
                      currentTable: table,
                      referencedTable: $$ClientsTableReferences
                          ._invoicesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ClientsTableReferences(db, table, p0).invoicesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'client_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTable,
      ClientRow,
      $$ClientsTableFilterComposer,
      $$ClientsTableOrderingComposer,
      $$ClientsTableAnnotationComposer,
      $$ClientsTableCreateCompanionBuilder,
      $$ClientsTableUpdateCompanionBuilder,
      (ClientRow, $$ClientsTableReferences),
      ClientRow,
      PrefetchHooks Function({bool invoicesRefs})
    >;
typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      required String id,
      required String clientId,
      required String number,
      required int year,
      required int seq,
      required String issueDate,
      required String dueDate,
      Value<String?> paidDate,
      required String status,
      Value<String> contractRef,
      Value<bool> vatOn,
      Value<int> vatRateBp,
      Value<String> notesEn,
      Value<String> notesAr,
      Value<bool> scopeOn,
      Value<String> scopeTitle,
      Value<String> scopeOverview,
      Value<String> scopeDone,
      Value<String> scopeDelivered,
      Value<String> scopeWarranty,
      Value<int?> deletedAt,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<String> id,
      Value<String> clientId,
      Value<String> number,
      Value<int> year,
      Value<int> seq,
      Value<String> issueDate,
      Value<String> dueDate,
      Value<String?> paidDate,
      Value<String> status,
      Value<String> contractRef,
      Value<bool> vatOn,
      Value<int> vatRateBp,
      Value<String> notesEn,
      Value<String> notesAr,
      Value<bool> scopeOn,
      Value<String> scopeTitle,
      Value<String> scopeOverview,
      Value<String> scopeDone,
      Value<String> scopeDelivered,
      Value<String> scopeWarranty,
      Value<int?> deletedAt,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$InvoicesTableReferences
    extends BaseReferences<_$AppDatabase, $InvoicesTable, InvoiceRow> {
  $$InvoicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) =>
      db.clients.createAlias('invoices__client_id__clients__id');

  $$ClientsTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<String>('client_id')!;

    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SectionsTable, List<SectionRow>>
  _sectionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sections,
    aliasName: 'invoices__id__sections__invoice_id',
  );

  $$SectionsTableProcessedTableManager get sectionsRefs {
    final manager = $$SectionsTableTableManager(
      $_db,
      $_db.sections,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sectionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get issueDate => $composableBuilder(
    column: $table.issueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contractRef => $composableBuilder(
    column: $table.contractRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vatOn => $composableBuilder(
    column: $table.vatOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vatRateBp => $composableBuilder(
    column: $table.vatRateBp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notesEn => $composableBuilder(
    column: $table.notesEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notesAr => $composableBuilder(
    column: $table.notesAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get scopeOn => $composableBuilder(
    column: $table.scopeOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scopeTitle => $composableBuilder(
    column: $table.scopeTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scopeOverview => $composableBuilder(
    column: $table.scopeOverview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scopeDone => $composableBuilder(
    column: $table.scopeDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scopeDelivered => $composableBuilder(
    column: $table.scopeDelivered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scopeWarranty => $composableBuilder(
    column: $table.scopeWarranty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sectionsRefs(
    Expression<bool> Function($$SectionsTableFilterComposer f) f,
  ) {
    final $$SectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sections,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionsTableFilterComposer(
            $db: $db,
            $table: $db.sections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get issueDate => $composableBuilder(
    column: $table.issueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contractRef => $composableBuilder(
    column: $table.contractRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get vatOn => $composableBuilder(
    column: $table.vatOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vatRateBp => $composableBuilder(
    column: $table.vatRateBp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notesEn => $composableBuilder(
    column: $table.notesEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notesAr => $composableBuilder(
    column: $table.notesAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get scopeOn => $composableBuilder(
    column: $table.scopeOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scopeTitle => $composableBuilder(
    column: $table.scopeTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scopeOverview => $composableBuilder(
    column: $table.scopeOverview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scopeDone => $composableBuilder(
    column: $table.scopeDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scopeDelivered => $composableBuilder(
    column: $table.scopeDelivered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scopeWarranty => $composableBuilder(
    column: $table.scopeWarranty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get issueDate =>
      $composableBuilder(column: $table.issueDate, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get paidDate =>
      $composableBuilder(column: $table.paidDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get contractRef => $composableBuilder(
    column: $table.contractRef,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get vatOn =>
      $composableBuilder(column: $table.vatOn, builder: (column) => column);

  GeneratedColumn<int> get vatRateBp =>
      $composableBuilder(column: $table.vatRateBp, builder: (column) => column);

  GeneratedColumn<String> get notesEn =>
      $composableBuilder(column: $table.notesEn, builder: (column) => column);

  GeneratedColumn<String> get notesAr =>
      $composableBuilder(column: $table.notesAr, builder: (column) => column);

  GeneratedColumn<bool> get scopeOn =>
      $composableBuilder(column: $table.scopeOn, builder: (column) => column);

  GeneratedColumn<String> get scopeTitle => $composableBuilder(
    column: $table.scopeTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scopeOverview => $composableBuilder(
    column: $table.scopeOverview,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scopeDone =>
      $composableBuilder(column: $table.scopeDone, builder: (column) => column);

  GeneratedColumn<String> get scopeDelivered => $composableBuilder(
    column: $table.scopeDelivered,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scopeWarranty => $composableBuilder(
    column: $table.scopeWarranty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sectionsRefs<T extends Object>(
    Expression<T> Function($$SectionsTableAnnotationComposer a) f,
  ) {
    final $$SectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sections,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          InvoiceRow,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (InvoiceRow, $$InvoicesTableReferences),
          InvoiceRow,
          PrefetchHooks Function({bool clientId, bool sectionsRefs})
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> number = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<String> issueDate = const Value.absent(),
                Value<String> dueDate = const Value.absent(),
                Value<String?> paidDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> contractRef = const Value.absent(),
                Value<bool> vatOn = const Value.absent(),
                Value<int> vatRateBp = const Value.absent(),
                Value<String> notesEn = const Value.absent(),
                Value<String> notesAr = const Value.absent(),
                Value<bool> scopeOn = const Value.absent(),
                Value<String> scopeTitle = const Value.absent(),
                Value<String> scopeOverview = const Value.absent(),
                Value<String> scopeDone = const Value.absent(),
                Value<String> scopeDelivered = const Value.absent(),
                Value<String> scopeWarranty = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                clientId: clientId,
                number: number,
                year: year,
                seq: seq,
                issueDate: issueDate,
                dueDate: dueDate,
                paidDate: paidDate,
                status: status,
                contractRef: contractRef,
                vatOn: vatOn,
                vatRateBp: vatRateBp,
                notesEn: notesEn,
                notesAr: notesAr,
                scopeOn: scopeOn,
                scopeTitle: scopeTitle,
                scopeOverview: scopeOverview,
                scopeDone: scopeDone,
                scopeDelivered: scopeDelivered,
                scopeWarranty: scopeWarranty,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String number,
                required int year,
                required int seq,
                required String issueDate,
                required String dueDate,
                Value<String?> paidDate = const Value.absent(),
                required String status,
                Value<String> contractRef = const Value.absent(),
                Value<bool> vatOn = const Value.absent(),
                Value<int> vatRateBp = const Value.absent(),
                Value<String> notesEn = const Value.absent(),
                Value<String> notesAr = const Value.absent(),
                Value<bool> scopeOn = const Value.absent(),
                Value<String> scopeTitle = const Value.absent(),
                Value<String> scopeOverview = const Value.absent(),
                Value<String> scopeDone = const Value.absent(),
                Value<String> scopeDelivered = const Value.absent(),
                Value<String> scopeWarranty = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                clientId: clientId,
                number: number,
                year: year,
                seq: seq,
                issueDate: issueDate,
                dueDate: dueDate,
                paidDate: paidDate,
                status: status,
                contractRef: contractRef,
                vatOn: vatOn,
                vatRateBp: vatRateBp,
                notesEn: notesEn,
                notesAr: notesAr,
                scopeOn: scopeOn,
                scopeTitle: scopeTitle,
                scopeOverview: scopeOverview,
                scopeDone: scopeDone,
                scopeDelivered: scopeDelivered,
                scopeWarranty: scopeWarranty,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InvoicesTable, InvoiceRow>(table),
                  $$InvoicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientId = false, sectionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sectionsRefs) db.sections],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.clientId,
                                referencedTable: $$InvoicesTableReferences
                                    ._clientIdTable(db),
                                referencedColumn: $$InvoicesTableReferences
                                    ._clientIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sectionsRefs)
                    await $_getPrefetchedDataByColumns<
                      InvoiceRow,
                      $InvoicesTable,
                      SectionRow,
                      $SectionsTable
                    >(
                      currentTable: table,
                      referencedTable: $$InvoicesTableReferences
                          ._sectionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$InvoicesTableReferences(db, table, p0).sectionsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'invoice_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      InvoiceRow,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (InvoiceRow, $$InvoicesTableReferences),
      InvoiceRow,
      PrefetchHooks Function({bool clientId, bool sectionsRefs})
    >;
typedef $$SectionsTableCreateCompanionBuilder =
    SectionsCompanion Function({
      required String id,
      required String invoiceId,
      required int position,
      Value<String> titleEn,
      Value<String> titleAr,
      required String currency,
      Value<int> rowid,
    });
typedef $$SectionsTableUpdateCompanionBuilder =
    SectionsCompanion Function({
      Value<String> id,
      Value<String> invoiceId,
      Value<int> position,
      Value<String> titleEn,
      Value<String> titleAr,
      Value<String> currency,
      Value<int> rowid,
    });

final class $$SectionsTableReferences
    extends BaseReferences<_$AppDatabase, $SectionsTable, SectionRow> {
  $$SectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias('sections__invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<String>('invoice_id')!;

    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ItemsTable, List<ItemRow>> _itemsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.items,
    aliasName: 'sections__id__items__section_id',
  );

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.sectionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SectionsTableFilterComposer
    extends Composer<_$AppDatabase, $SectionsTable> {
  $$SectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> itemsRefs(
    Expression<bool> Function($$ItemsTableFilterComposer f) f,
  ) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.sectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SectionsTable> {
  $$SectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SectionsTable> {
  $$SectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => column);

  GeneratedColumn<String> get titleAr =>
      $composableBuilder(column: $table.titleAr, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> itemsRefs<T extends Object>(
    Expression<T> Function($$ItemsTableAnnotationComposer a) f,
  ) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.sectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SectionsTable,
          SectionRow,
          $$SectionsTableFilterComposer,
          $$SectionsTableOrderingComposer,
          $$SectionsTableAnnotationComposer,
          $$SectionsTableCreateCompanionBuilder,
          $$SectionsTableUpdateCompanionBuilder,
          (SectionRow, $$SectionsTableReferences),
          SectionRow,
          PrefetchHooks Function({bool invoiceId, bool itemsRefs})
        > {
  $$SectionsTableTableManager(_$AppDatabase db, $SectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> invoiceId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> titleEn = const Value.absent(),
                Value<String> titleAr = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SectionsCompanion(
                id: id,
                invoiceId: invoiceId,
                position: position,
                titleEn: titleEn,
                titleAr: titleAr,
                currency: currency,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String invoiceId,
                required int position,
                Value<String> titleEn = const Value.absent(),
                Value<String> titleAr = const Value.absent(),
                required String currency,
                Value<int> rowid = const Value.absent(),
              }) => SectionsCompanion.insert(
                id: id,
                invoiceId: invoiceId,
                position: position,
                titleEn: titleEn,
                titleAr: titleAr,
                currency: currency,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SectionsTable, SectionRow>(table),
                  $$SectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invoiceId = false, itemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itemsRefs) db.items],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (invoiceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.invoiceId,
                                referencedTable: $$SectionsTableReferences
                                    ._invoiceIdTable(db),
                                referencedColumn: $$SectionsTableReferences
                                    ._invoiceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemsRefs)
                    await $_getPrefetchedDataByColumns<
                      SectionRow,
                      $SectionsTable,
                      ItemRow,
                      $ItemsTable
                    >(
                      currentTable: table,
                      referencedTable: $$SectionsTableReferences
                          ._itemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SectionsTableReferences(db, table, p0).itemsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'section_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SectionsTable,
      SectionRow,
      $$SectionsTableFilterComposer,
      $$SectionsTableOrderingComposer,
      $$SectionsTableAnnotationComposer,
      $$SectionsTableCreateCompanionBuilder,
      $$SectionsTableUpdateCompanionBuilder,
      (SectionRow, $$SectionsTableReferences),
      SectionRow,
      PrefetchHooks Function({bool invoiceId, bool itemsRefs})
    >;
typedef $$ItemsTableCreateCompanionBuilder =
    ItemsCompanion Function({
      required String id,
      required String sectionId,
      required int position,
      Value<String> service,
      Value<String> description,
      required String cycle,
      required int qty,
      required int unitPriceMinor,
      Value<int> rowid,
    });
typedef $$ItemsTableUpdateCompanionBuilder =
    ItemsCompanion Function({
      Value<String> id,
      Value<String> sectionId,
      Value<int> position,
      Value<String> service,
      Value<String> description,
      Value<String> cycle,
      Value<int> qty,
      Value<int> unitPriceMinor,
      Value<int> rowid,
    });

final class $$ItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsTable, ItemRow> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SectionsTable _sectionIdTable(_$AppDatabase db) =>
      db.sections.createAlias('items__section_id__sections__id');

  $$SectionsTableProcessedTableManager get sectionId {
    final $_column = $_itemColumn<String>('section_id')!;

    final manager = $$SectionsTableTableManager(
      $_db,
      $_db.sections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  $$SectionsTableFilterComposer get sectionId {
    final $$SectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionId,
      referencedTable: $db.sections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionsTableFilterComposer(
            $db: $db,
            $table: $db.sections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  $$SectionsTableOrderingComposer get sectionId {
    final $$SectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionId,
      referencedTable: $db.sections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionsTableOrderingComposer(
            $db: $db,
            $table: $db.sections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get service =>
      $composableBuilder(column: $table.service, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cycle =>
      $composableBuilder(column: $table.cycle, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => column,
  );

  $$SectionsTableAnnotationComposer get sectionId {
    final $$SectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionId,
      referencedTable: $db.sections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemsTable,
          ItemRow,
          $$ItemsTableFilterComposer,
          $$ItemsTableOrderingComposer,
          $$ItemsTableAnnotationComposer,
          $$ItemsTableCreateCompanionBuilder,
          $$ItemsTableUpdateCompanionBuilder,
          (ItemRow, $$ItemsTableReferences),
          ItemRow,
          PrefetchHooks Function({bool sectionId})
        > {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sectionId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> service = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> cycle = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<int> unitPriceMinor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemsCompanion(
                id: id,
                sectionId: sectionId,
                position: position,
                service: service,
                description: description,
                cycle: cycle,
                qty: qty,
                unitPriceMinor: unitPriceMinor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sectionId,
                required int position,
                Value<String> service = const Value.absent(),
                Value<String> description = const Value.absent(),
                required String cycle,
                required int qty,
                required int unitPriceMinor,
                Value<int> rowid = const Value.absent(),
              }) => ItemsCompanion.insert(
                id: id,
                sectionId: sectionId,
                position: position,
                service: service,
                description: description,
                cycle: cycle,
                qty: qty,
                unitPriceMinor: unitPriceMinor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemsTable, ItemRow>(table),
                  $$ItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sectionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sectionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sectionId,
                                referencedTable: $$ItemsTableReferences
                                    ._sectionIdTable(db),
                                referencedColumn: $$ItemsTableReferences
                                    ._sectionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemsTable,
      ItemRow,
      $$ItemsTableFilterComposer,
      $$ItemsTableOrderingComposer,
      $$ItemsTableAnnotationComposer,
      $$ItemsTableCreateCompanionBuilder,
      $$ItemsTableUpdateCompanionBuilder,
      (ItemRow, $$ItemsTableReferences),
      ItemRow,
      PrefetchHooks Function({bool sectionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$SectionsTableTableManager get sections =>
      $$SectionsTableTableManager(_db, _db.sections);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
}
