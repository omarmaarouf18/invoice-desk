// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
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
  static const VerificationMeta _legalNameMeta = const VerificationMeta(
    'legalName',
  );
  @override
  late final GeneratedColumn<String> legalName = GeneratedColumn<String>(
    'legal_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nationalIdOrRegistryMeta =
      const VerificationMeta('nationalIdOrRegistry');
  @override
  late final GeneratedColumn<String> nationalIdOrRegistry =
      GeneratedColumn<String>(
        'national_id_or_registry',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _contractPrefixMeta = const VerificationMeta(
    'contractPrefix',
  );
  @override
  late final GeneratedColumn<String> contractPrefix = GeneratedColumn<String>(
    'contract_prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('CT'),
  );
  static const VerificationMeta _quotePrefixMeta = const VerificationMeta(
    'quotePrefix',
  );
  @override
  late final GeneratedColumn<String> quotePrefix = GeneratedColumn<String>(
    'quote_prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('QT'),
  );
  static const VerificationMeta _defaultJurisdictionMeta =
      const VerificationMeta('defaultJurisdiction');
  @override
  late final GeneratedColumn<String> defaultJurisdiction =
      GeneratedColumn<String>(
        'default_jurisdiction',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('المحكمة الاقتصادية المختصة'),
      );
  static const VerificationMeta _contractWesternDigitsMeta =
      const VerificationMeta('contractWesternDigits');
  @override
  late final GeneratedColumn<bool> contractWesternDigits =
      GeneratedColumn<bool>(
        'contract_western_digits',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("contract_western_digits" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rev,
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
    legalName,
    nationalIdOrRegistry,
    address,
    contractPrefix,
    quotePrefix,
    defaultJurisdiction,
    contractWesternDigits,
    deviceId,
    updatedAt,
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
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
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
    if (data.containsKey('legal_name')) {
      context.handle(
        _legalNameMeta,
        legalName.isAcceptableOrUnknown(data['legal_name']!, _legalNameMeta),
      );
    }
    if (data.containsKey('national_id_or_registry')) {
      context.handle(
        _nationalIdOrRegistryMeta,
        nationalIdOrRegistry.isAcceptableOrUnknown(
          data['national_id_or_registry']!,
          _nationalIdOrRegistryMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('contract_prefix')) {
      context.handle(
        _contractPrefixMeta,
        contractPrefix.isAcceptableOrUnknown(
          data['contract_prefix']!,
          _contractPrefixMeta,
        ),
      );
    }
    if (data.containsKey('quote_prefix')) {
      context.handle(
        _quotePrefixMeta,
        quotePrefix.isAcceptableOrUnknown(
          data['quote_prefix']!,
          _quotePrefixMeta,
        ),
      );
    }
    if (data.containsKey('default_jurisdiction')) {
      context.handle(
        _defaultJurisdictionMeta,
        defaultJurisdiction.isAcceptableOrUnknown(
          data['default_jurisdiction']!,
          _defaultJurisdictionMeta,
        ),
      );
    }
    if (data.containsKey('contract_western_digits')) {
      context.handle(
        _contractWesternDigitsMeta,
        contractWesternDigits.isAcceptableOrUnknown(
          data['contract_western_digits']!,
          _contractWesternDigitsMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
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
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
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
      legalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legal_name'],
      )!,
      nationalIdOrRegistry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}national_id_or_registry'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      contractPrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contract_prefix'],
      )!,
      quotePrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_prefix'],
      )!,
      defaultJurisdiction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_jurisdiction'],
      )!,
      contractWesternDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}contract_western_digits'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
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
  final int rev;
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
  final String legalName;
  final String nationalIdOrRegistry;
  final String address;
  final String contractPrefix;
  final String quotePrefix;
  final String defaultJurisdiction;

  /// Sub-item numbers in contracts: Western (1.) instead of Arabic (١.).
  final bool contractWesternDigits;

  /// Random UUID of this installation, generated once.
  final String deviceId;
  final int updatedAt;
  const SettingsRow({
    required this.rev,
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
    required this.legalName,
    required this.nationalIdOrRegistry,
    required this.address,
    required this.contractPrefix,
    required this.quotePrefix,
    required this.defaultJurisdiction,
    required this.contractWesternDigits,
    required this.deviceId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rev'] = Variable<int>(rev);
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
    map['legal_name'] = Variable<String>(legalName);
    map['national_id_or_registry'] = Variable<String>(nationalIdOrRegistry);
    map['address'] = Variable<String>(address);
    map['contract_prefix'] = Variable<String>(contractPrefix);
    map['quote_prefix'] = Variable<String>(quotePrefix);
    map['default_jurisdiction'] = Variable<String>(defaultJurisdiction);
    map['contract_western_digits'] = Variable<bool>(contractWesternDigits);
    map['device_id'] = Variable<String>(deviceId);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      rev: Value(rev),
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
      legalName: Value(legalName),
      nationalIdOrRegistry: Value(nationalIdOrRegistry),
      address: Value(address),
      contractPrefix: Value(contractPrefix),
      quotePrefix: Value(quotePrefix),
      defaultJurisdiction: Value(defaultJurisdiction),
      contractWesternDigits: Value(contractWesternDigits),
      deviceId: Value(deviceId),
      updatedAt: Value(updatedAt),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      rev: serializer.fromJson<int>(json['rev']),
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
      legalName: serializer.fromJson<String>(json['legalName']),
      nationalIdOrRegistry: serializer.fromJson<String>(
        json['nationalIdOrRegistry'],
      ),
      address: serializer.fromJson<String>(json['address']),
      contractPrefix: serializer.fromJson<String>(json['contractPrefix']),
      quotePrefix: serializer.fromJson<String>(json['quotePrefix']),
      defaultJurisdiction: serializer.fromJson<String>(
        json['defaultJurisdiction'],
      ),
      contractWesternDigits: serializer.fromJson<bool>(
        json['contractWesternDigits'],
      ),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rev': serializer.toJson<int>(rev),
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
      'legalName': serializer.toJson<String>(legalName),
      'nationalIdOrRegistry': serializer.toJson<String>(nationalIdOrRegistry),
      'address': serializer.toJson<String>(address),
      'contractPrefix': serializer.toJson<String>(contractPrefix),
      'quotePrefix': serializer.toJson<String>(quotePrefix),
      'defaultJurisdiction': serializer.toJson<String>(defaultJurisdiction),
      'contractWesternDigits': serializer.toJson<bool>(contractWesternDigits),
      'deviceId': serializer.toJson<String>(deviceId),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  SettingsRow copyWith({
    int? rev,
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
    String? legalName,
    String? nationalIdOrRegistry,
    String? address,
    String? contractPrefix,
    String? quotePrefix,
    String? defaultJurisdiction,
    bool? contractWesternDigits,
    String? deviceId,
    int? updatedAt,
  }) => SettingsRow(
    rev: rev ?? this.rev,
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
    legalName: legalName ?? this.legalName,
    nationalIdOrRegistry: nationalIdOrRegistry ?? this.nationalIdOrRegistry,
    address: address ?? this.address,
    contractPrefix: contractPrefix ?? this.contractPrefix,
    quotePrefix: quotePrefix ?? this.quotePrefix,
    defaultJurisdiction: defaultJurisdiction ?? this.defaultJurisdiction,
    contractWesternDigits: contractWesternDigits ?? this.contractWesternDigits,
    deviceId: deviceId ?? this.deviceId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SettingsRow copyWithCompanion(AppSettingsCompanion data) {
    return SettingsRow(
      rev: data.rev.present ? data.rev.value : this.rev,
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
      legalName: data.legalName.present ? data.legalName.value : this.legalName,
      nationalIdOrRegistry: data.nationalIdOrRegistry.present
          ? data.nationalIdOrRegistry.value
          : this.nationalIdOrRegistry,
      address: data.address.present ? data.address.value : this.address,
      contractPrefix: data.contractPrefix.present
          ? data.contractPrefix.value
          : this.contractPrefix,
      quotePrefix: data.quotePrefix.present
          ? data.quotePrefix.value
          : this.quotePrefix,
      defaultJurisdiction: data.defaultJurisdiction.present
          ? data.defaultJurisdiction.value
          : this.defaultJurisdiction,
      contractWesternDigits: data.contractWesternDigits.present
          ? data.contractWesternDigits.value
          : this.contractWesternDigits,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('rev: $rev, ')
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
          ..write('lastBackupAt: $lastBackupAt, ')
          ..write('legalName: $legalName, ')
          ..write('nationalIdOrRegistry: $nationalIdOrRegistry, ')
          ..write('address: $address, ')
          ..write('contractPrefix: $contractPrefix, ')
          ..write('quotePrefix: $quotePrefix, ')
          ..write('defaultJurisdiction: $defaultJurisdiction, ')
          ..write('contractWesternDigits: $contractWesternDigits, ')
          ..write('deviceId: $deviceId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    rev,
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
    legalName,
    nationalIdOrRegistry,
    address,
    contractPrefix,
    quotePrefix,
    defaultJurisdiction,
    contractWesternDigits,
    deviceId,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.rev == this.rev &&
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
          other.lastBackupAt == this.lastBackupAt &&
          other.legalName == this.legalName &&
          other.nationalIdOrRegistry == this.nationalIdOrRegistry &&
          other.address == this.address &&
          other.contractPrefix == this.contractPrefix &&
          other.quotePrefix == this.quotePrefix &&
          other.defaultJurisdiction == this.defaultJurisdiction &&
          other.contractWesternDigits == this.contractWesternDigits &&
          other.deviceId == this.deviceId &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> rev;
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
  final Value<String> legalName;
  final Value<String> nationalIdOrRegistry;
  final Value<String> address;
  final Value<String> contractPrefix;
  final Value<String> quotePrefix;
  final Value<String> defaultJurisdiction;
  final Value<bool> contractWesternDigits;
  final Value<String> deviceId;
  final Value<int> updatedAt;
  const AppSettingsCompanion({
    this.rev = const Value.absent(),
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
    this.legalName = const Value.absent(),
    this.nationalIdOrRegistry = const Value.absent(),
    this.address = const Value.absent(),
    this.contractPrefix = const Value.absent(),
    this.quotePrefix = const Value.absent(),
    this.defaultJurisdiction = const Value.absent(),
    this.contractWesternDigits = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.rev = const Value.absent(),
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
    this.legalName = const Value.absent(),
    this.nationalIdOrRegistry = const Value.absent(),
    this.address = const Value.absent(),
    this.contractPrefix = const Value.absent(),
    this.quotePrefix = const Value.absent(),
    this.defaultJurisdiction = const Value.absent(),
    this.contractWesternDigits = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<SettingsRow> custom({
    Expression<int>? rev,
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
    Expression<String>? legalName,
    Expression<String>? nationalIdOrRegistry,
    Expression<String>? address,
    Expression<String>? contractPrefix,
    Expression<String>? quotePrefix,
    Expression<String>? defaultJurisdiction,
    Expression<bool>? contractWesternDigits,
    Expression<String>? deviceId,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (rev != null) 'rev': rev,
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
      if (legalName != null) 'legal_name': legalName,
      if (nationalIdOrRegistry != null)
        'national_id_or_registry': nationalIdOrRegistry,
      if (address != null) 'address': address,
      if (contractPrefix != null) 'contract_prefix': contractPrefix,
      if (quotePrefix != null) 'quote_prefix': quotePrefix,
      if (defaultJurisdiction != null)
        'default_jurisdiction': defaultJurisdiction,
      if (contractWesternDigits != null)
        'contract_western_digits': contractWesternDigits,
      if (deviceId != null) 'device_id': deviceId,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? rev,
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
    Value<String>? legalName,
    Value<String>? nationalIdOrRegistry,
    Value<String>? address,
    Value<String>? contractPrefix,
    Value<String>? quotePrefix,
    Value<String>? defaultJurisdiction,
    Value<bool>? contractWesternDigits,
    Value<String>? deviceId,
    Value<int>? updatedAt,
  }) {
    return AppSettingsCompanion(
      rev: rev ?? this.rev,
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
      legalName: legalName ?? this.legalName,
      nationalIdOrRegistry: nationalIdOrRegistry ?? this.nationalIdOrRegistry,
      address: address ?? this.address,
      contractPrefix: contractPrefix ?? this.contractPrefix,
      quotePrefix: quotePrefix ?? this.quotePrefix,
      defaultJurisdiction: defaultJurisdiction ?? this.defaultJurisdiction,
      contractWesternDigits:
          contractWesternDigits ?? this.contractWesternDigits,
      deviceId: deviceId ?? this.deviceId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
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
    if (legalName.present) {
      map['legal_name'] = Variable<String>(legalName.value);
    }
    if (nationalIdOrRegistry.present) {
      map['national_id_or_registry'] = Variable<String>(
        nationalIdOrRegistry.value,
      );
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (contractPrefix.present) {
      map['contract_prefix'] = Variable<String>(contractPrefix.value);
    }
    if (quotePrefix.present) {
      map['quote_prefix'] = Variable<String>(quotePrefix.value);
    }
    if (defaultJurisdiction.present) {
      map['default_jurisdiction'] = Variable<String>(defaultJurisdiction.value);
    }
    if (contractWesternDigits.present) {
      map['contract_western_digits'] = Variable<bool>(
        contractWesternDigits.value,
      );
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('rev: $rev, ')
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
          ..write('lastBackupAt: $lastBackupAt, ')
          ..write('legalName: $legalName, ')
          ..write('nationalIdOrRegistry: $nationalIdOrRegistry, ')
          ..write('address: $address, ')
          ..write('contractPrefix: $contractPrefix, ')
          ..write('quotePrefix: $quotePrefix, ')
          ..write('defaultJurisdiction: $defaultJurisdiction, ')
          ..write('contractWesternDigits: $contractWesternDigits, ')
          ..write('deviceId: $deviceId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<String> rowId = GeneratedColumn<String>(
    'row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<int> changedAt = GeneratedColumn<int>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, entity, rowId, rev, changedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIdMeta);
    }
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    } else if (isInserting) {
      context.missing(_revMeta);
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {entity, rowId},
  ];
  @override
  OutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_id'],
      )!,
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}changed_at'],
      )!,
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
}

class OutboxRow extends DataClass implements Insertable<OutboxRow> {
  final int id;

  /// Table name of the changed row.
  final String entity;

  /// The changed row's id (settings: `1`).
  final String rowId;

  /// The row's revision after the change.
  final int rev;

  /// The row's `updated_at` (UTC epoch ms) at the change.
  final int changedAt;
  const OutboxRow({
    required this.id,
    required this.entity,
    required this.rowId,
    required this.rev,
    required this.changedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity'] = Variable<String>(entity);
    map['row_id'] = Variable<String>(rowId);
    map['rev'] = Variable<int>(rev);
    map['changed_at'] = Variable<int>(changedAt);
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      id: Value(id),
      entity: Value(entity),
      rowId: Value(rowId),
      rev: Value(rev),
      changedAt: Value(changedAt),
    );
  }

  factory OutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxRow(
      id: serializer.fromJson<int>(json['id']),
      entity: serializer.fromJson<String>(json['entity']),
      rowId: serializer.fromJson<String>(json['rowId']),
      rev: serializer.fromJson<int>(json['rev']),
      changedAt: serializer.fromJson<int>(json['changedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entity': serializer.toJson<String>(entity),
      'rowId': serializer.toJson<String>(rowId),
      'rev': serializer.toJson<int>(rev),
      'changedAt': serializer.toJson<int>(changedAt),
    };
  }

  OutboxRow copyWith({
    int? id,
    String? entity,
    String? rowId,
    int? rev,
    int? changedAt,
  }) => OutboxRow(
    id: id ?? this.id,
    entity: entity ?? this.entity,
    rowId: rowId ?? this.rowId,
    rev: rev ?? this.rev,
    changedAt: changedAt ?? this.changedAt,
  );
  OutboxRow copyWithCompanion(OutboxCompanion data) {
    return OutboxRow(
      id: data.id.present ? data.id.value : this.id,
      entity: data.entity.present ? data.entity.value : this.entity,
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      rev: data.rev.present ? data.rev.value : this.rev,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxRow(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('rowId: $rowId, ')
          ..write('rev: $rev, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entity, rowId, rev, changedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxRow &&
          other.id == this.id &&
          other.entity == this.entity &&
          other.rowId == this.rowId &&
          other.rev == this.rev &&
          other.changedAt == this.changedAt);
}

class OutboxCompanion extends UpdateCompanion<OutboxRow> {
  final Value<int> id;
  final Value<String> entity;
  final Value<String> rowId;
  final Value<int> rev;
  final Value<int> changedAt;
  const OutboxCompanion({
    this.id = const Value.absent(),
    this.entity = const Value.absent(),
    this.rowId = const Value.absent(),
    this.rev = const Value.absent(),
    this.changedAt = const Value.absent(),
  });
  OutboxCompanion.insert({
    this.id = const Value.absent(),
    required String entity,
    required String rowId,
    required int rev,
    required int changedAt,
  }) : entity = Value(entity),
       rowId = Value(rowId),
       rev = Value(rev),
       changedAt = Value(changedAt);
  static Insertable<OutboxRow> custom({
    Expression<int>? id,
    Expression<String>? entity,
    Expression<String>? rowId,
    Expression<int>? rev,
    Expression<int>? changedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entity != null) 'entity': entity,
      if (rowId != null) 'row_id': rowId,
      if (rev != null) 'rev': rev,
      if (changedAt != null) 'changed_at': changedAt,
    });
  }

  OutboxCompanion copyWith({
    Value<int>? id,
    Value<String>? entity,
    Value<String>? rowId,
    Value<int>? rev,
    Value<int>? changedAt,
  }) {
    return OutboxCompanion(
      id: id ?? this.id,
      entity: entity ?? this.entity,
      rowId: rowId ?? this.rowId,
      rev: rev ?? this.rev,
      changedAt: changedAt ?? this.changedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (rowId.present) {
      map['row_id'] = Variable<String>(rowId.value);
    }
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<int>(changedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('rowId: $rowId, ')
          ..write('rev: $rev, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }
}

class $ClientsTable extends Clients with TableInfo<$ClientsTable, ClientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
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
  static const VerificationMeta _legalNameMeta = const VerificationMeta(
    'legalName',
  );
  @override
  late final GeneratedColumn<String> legalName = GeneratedColumn<String>(
    'legal_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _registryNoMeta = const VerificationMeta(
    'registryNo',
  );
  @override
  late final GeneratedColumn<String> registryNo = GeneratedColumn<String>(
    'registry_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _representativeMeta = const VerificationMeta(
    'representative',
  );
  @override
  late final GeneratedColumn<String> representative = GeneratedColumn<String>(
    'representative',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _representativeTitleMeta =
      const VerificationMeta('representativeTitle');
  @override
  late final GeneratedColumn<String> representativeTitle =
      GeneratedColumn<String>(
        'representative_title',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
    'is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rev,
    id,
    name,
    contact,
    city,
    phone,
    email,
    createdAt,
    updatedAt,
    archived,
    deletedAt,
    legalName,
    registryNo,
    address,
    representative,
    representativeTitle,
    isDemo,
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
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('legal_name')) {
      context.handle(
        _legalNameMeta,
        legalName.isAcceptableOrUnknown(data['legal_name']!, _legalNameMeta),
      );
    }
    if (data.containsKey('registry_no')) {
      context.handle(
        _registryNoMeta,
        registryNo.isAcceptableOrUnknown(data['registry_no']!, _registryNoMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('representative')) {
      context.handle(
        _representativeMeta,
        representative.isAcceptableOrUnknown(
          data['representative']!,
          _representativeMeta,
        ),
      );
    }
    if (data.containsKey('representative_title')) {
      context.handle(
        _representativeTitleMeta,
        representativeTitle.isAcceptableOrUnknown(
          data['representative_title']!,
          _representativeTitleMeta,
        ),
      );
    }
    if (data.containsKey('is_demo')) {
      context.handle(
        _isDemoMeta,
        isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta),
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
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
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
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      legalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legal_name'],
      )!,
      registryNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registry_no'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      representative: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}representative'],
      )!,
      representativeTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}representative_title'],
      )!,
      isDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo'],
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
  final int rev;
  final String id;
  final String name;
  final String contact;
  final String city;
  final String phone;
  final String email;
  final int createdAt;
  final int updatedAt;
  final bool archived;

  /// Soft delete (schema v2). Purged after 30 days once no invoice rows
  /// reference the client. See `triggers.drift` for the guards.
  final int? deletedAt;
  final String legalName;
  final String registryNo;
  final String address;
  final String representative;
  final String representativeTitle;

  /// v5: demo row (removed with the demo set; cleared on user edits).
  final bool isDemo;
  const ClientRow({
    required this.rev,
    required this.id,
    required this.name,
    required this.contact,
    required this.city,
    required this.phone,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.archived,
    this.deletedAt,
    required this.legalName,
    required this.registryNo,
    required this.address,
    required this.representative,
    required this.representativeTitle,
    required this.isDemo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rev'] = Variable<int>(rev);
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['contact'] = Variable<String>(contact);
    map['city'] = Variable<String>(city);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['archived'] = Variable<bool>(archived);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['legal_name'] = Variable<String>(legalName);
    map['registry_no'] = Variable<String>(registryNo);
    map['address'] = Variable<String>(address);
    map['representative'] = Variable<String>(representative);
    map['representative_title'] = Variable<String>(representativeTitle);
    map['is_demo'] = Variable<bool>(isDemo);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      rev: Value(rev),
      id: Value(id),
      name: Value(name),
      contact: Value(contact),
      city: Value(city),
      phone: Value(phone),
      email: Value(email),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archived: Value(archived),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      legalName: Value(legalName),
      registryNo: Value(registryNo),
      address: Value(address),
      representative: Value(representative),
      representativeTitle: Value(representativeTitle),
      isDemo: Value(isDemo),
    );
  }

  factory ClientRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientRow(
      rev: serializer.fromJson<int>(json['rev']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      contact: serializer.fromJson<String>(json['contact']),
      city: serializer.fromJson<String>(json['city']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      archived: serializer.fromJson<bool>(json['archived']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      legalName: serializer.fromJson<String>(json['legalName']),
      registryNo: serializer.fromJson<String>(json['registryNo']),
      address: serializer.fromJson<String>(json['address']),
      representative: serializer.fromJson<String>(json['representative']),
      representativeTitle: serializer.fromJson<String>(
        json['representativeTitle'],
      ),
      isDemo: serializer.fromJson<bool>(json['isDemo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rev': serializer.toJson<int>(rev),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'contact': serializer.toJson<String>(contact),
      'city': serializer.toJson<String>(city),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'archived': serializer.toJson<bool>(archived),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'legalName': serializer.toJson<String>(legalName),
      'registryNo': serializer.toJson<String>(registryNo),
      'address': serializer.toJson<String>(address),
      'representative': serializer.toJson<String>(representative),
      'representativeTitle': serializer.toJson<String>(representativeTitle),
      'isDemo': serializer.toJson<bool>(isDemo),
    };
  }

  ClientRow copyWith({
    int? rev,
    String? id,
    String? name,
    String? contact,
    String? city,
    String? phone,
    String? email,
    int? createdAt,
    int? updatedAt,
    bool? archived,
    Value<int?> deletedAt = const Value.absent(),
    String? legalName,
    String? registryNo,
    String? address,
    String? representative,
    String? representativeTitle,
    bool? isDemo,
  }) => ClientRow(
    rev: rev ?? this.rev,
    id: id ?? this.id,
    name: name ?? this.name,
    contact: contact ?? this.contact,
    city: city ?? this.city,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archived: archived ?? this.archived,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    legalName: legalName ?? this.legalName,
    registryNo: registryNo ?? this.registryNo,
    address: address ?? this.address,
    representative: representative ?? this.representative,
    representativeTitle: representativeTitle ?? this.representativeTitle,
    isDemo: isDemo ?? this.isDemo,
  );
  ClientRow copyWithCompanion(ClientsCompanion data) {
    return ClientRow(
      rev: data.rev.present ? data.rev.value : this.rev,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      contact: data.contact.present ? data.contact.value : this.contact,
      city: data.city.present ? data.city.value : this.city,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archived: data.archived.present ? data.archived.value : this.archived,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      legalName: data.legalName.present ? data.legalName.value : this.legalName,
      registryNo: data.registryNo.present
          ? data.registryNo.value
          : this.registryNo,
      address: data.address.present ? data.address.value : this.address,
      representative: data.representative.present
          ? data.representative.value
          : this.representative,
      representativeTitle: data.representativeTitle.present
          ? data.representativeTitle.value
          : this.representativeTitle,
      isDemo: data.isDemo.present ? data.isDemo.value : this.isDemo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientRow(')
          ..write('rev: $rev, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contact: $contact, ')
          ..write('city: $city, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archived: $archived, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('legalName: $legalName, ')
          ..write('registryNo: $registryNo, ')
          ..write('address: $address, ')
          ..write('representative: $representative, ')
          ..write('representativeTitle: $representativeTitle, ')
          ..write('isDemo: $isDemo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rev,
    id,
    name,
    contact,
    city,
    phone,
    email,
    createdAt,
    updatedAt,
    archived,
    deletedAt,
    legalName,
    registryNo,
    address,
    representative,
    representativeTitle,
    isDemo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientRow &&
          other.rev == this.rev &&
          other.id == this.id &&
          other.name == this.name &&
          other.contact == this.contact &&
          other.city == this.city &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archived == this.archived &&
          other.deletedAt == this.deletedAt &&
          other.legalName == this.legalName &&
          other.registryNo == this.registryNo &&
          other.address == this.address &&
          other.representative == this.representative &&
          other.representativeTitle == this.representativeTitle &&
          other.isDemo == this.isDemo);
}

class ClientsCompanion extends UpdateCompanion<ClientRow> {
  final Value<int> rev;
  final Value<String> id;
  final Value<String> name;
  final Value<String> contact;
  final Value<String> city;
  final Value<String> phone;
  final Value<String> email;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> archived;
  final Value<int?> deletedAt;
  final Value<String> legalName;
  final Value<String> registryNo;
  final Value<String> address;
  final Value<String> representative;
  final Value<String> representativeTitle;
  final Value<bool> isDemo;
  final Value<int> rowid;
  const ClientsCompanion({
    this.rev = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.contact = const Value.absent(),
    this.city = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archived = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.legalName = const Value.absent(),
    this.registryNo = const Value.absent(),
    this.address = const Value.absent(),
    this.representative = const Value.absent(),
    this.representativeTitle = const Value.absent(),
    this.isDemo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientsCompanion.insert({
    this.rev = const Value.absent(),
    required String id,
    required String name,
    this.contact = const Value.absent(),
    this.city = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.archived = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.legalName = const Value.absent(),
    this.registryNo = const Value.absent(),
    this.address = const Value.absent(),
    this.representative = const Value.absent(),
    this.representativeTitle = const Value.absent(),
    this.isDemo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ClientRow> custom({
    Expression<int>? rev,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? contact,
    Expression<String>? city,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? archived,
    Expression<int>? deletedAt,
    Expression<String>? legalName,
    Expression<String>? registryNo,
    Expression<String>? address,
    Expression<String>? representative,
    Expression<String>? representativeTitle,
    Expression<bool>? isDemo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rev != null) 'rev': rev,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (contact != null) 'contact': contact,
      if (city != null) 'city': city,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archived != null) 'archived': archived,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (legalName != null) 'legal_name': legalName,
      if (registryNo != null) 'registry_no': registryNo,
      if (address != null) 'address': address,
      if (representative != null) 'representative': representative,
      if (representativeTitle != null)
        'representative_title': representativeTitle,
      if (isDemo != null) 'is_demo': isDemo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientsCompanion copyWith({
    Value<int>? rev,
    Value<String>? id,
    Value<String>? name,
    Value<String>? contact,
    Value<String>? city,
    Value<String>? phone,
    Value<String>? email,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? archived,
    Value<int?>? deletedAt,
    Value<String>? legalName,
    Value<String>? registryNo,
    Value<String>? address,
    Value<String>? representative,
    Value<String>? representativeTitle,
    Value<bool>? isDemo,
    Value<int>? rowid,
  }) {
    return ClientsCompanion(
      rev: rev ?? this.rev,
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archived: archived ?? this.archived,
      deletedAt: deletedAt ?? this.deletedAt,
      legalName: legalName ?? this.legalName,
      registryNo: registryNo ?? this.registryNo,
      address: address ?? this.address,
      representative: representative ?? this.representative,
      representativeTitle: representativeTitle ?? this.representativeTitle,
      isDemo: isDemo ?? this.isDemo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
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
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (legalName.present) {
      map['legal_name'] = Variable<String>(legalName.value);
    }
    if (registryNo.present) {
      map['registry_no'] = Variable<String>(registryNo.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (representative.present) {
      map['representative'] = Variable<String>(representative.value);
    }
    if (representativeTitle.present) {
      map['representative_title'] = Variable<String>(representativeTitle.value);
    }
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('rev: $rev, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contact: $contact, ')
          ..write('city: $city, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archived: $archived, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('legalName: $legalName, ')
          ..write('registryNo: $registryNo, ')
          ..write('address: $address, ')
          ..write('representative: $representative, ')
          ..write('representativeTitle: $representativeTitle, ')
          ..write('isDemo: $isDemo, ')
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
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
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
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
    'is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    rev,
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
    isDemo,
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
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
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
    if (data.containsKey('is_demo')) {
      context.handle(
        _isDemoMeta,
        isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta),
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
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
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
      isDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo'],
      )!,
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
  final int rev;
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

  /// v5: demo row (removed with the demo set; cleared on user edits).
  final bool isDemo;
  final int createdAt;
  final int updatedAt;
  const InvoiceRow({
    required this.rev,
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
    required this.isDemo,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rev'] = Variable<int>(rev);
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
    map['is_demo'] = Variable<bool>(isDemo);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      rev: Value(rev),
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
      isDemo: Value(isDemo),
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
      rev: serializer.fromJson<int>(json['rev']),
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
      isDemo: serializer.fromJson<bool>(json['isDemo']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rev': serializer.toJson<int>(rev),
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
      'isDemo': serializer.toJson<bool>(isDemo),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  InvoiceRow copyWith({
    int? rev,
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
    bool? isDemo,
    int? createdAt,
    int? updatedAt,
  }) => InvoiceRow(
    rev: rev ?? this.rev,
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
    isDemo: isDemo ?? this.isDemo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InvoiceRow copyWithCompanion(InvoicesCompanion data) {
    return InvoiceRow(
      rev: data.rev.present ? data.rev.value : this.rev,
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
      isDemo: data.isDemo.present ? data.isDemo.value : this.isDemo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceRow(')
          ..write('rev: $rev, ')
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
          ..write('isDemo: $isDemo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    rev,
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
    isDemo,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceRow &&
          other.rev == this.rev &&
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
          other.isDemo == this.isDemo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InvoicesCompanion extends UpdateCompanion<InvoiceRow> {
  final Value<int> rev;
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
  final Value<bool> isDemo;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const InvoicesCompanion({
    this.rev = const Value.absent(),
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
    this.isDemo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoicesCompanion.insert({
    this.rev = const Value.absent(),
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
    this.isDemo = const Value.absent(),
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
    Expression<int>? rev,
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
    Expression<bool>? isDemo,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rev != null) 'rev': rev,
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
      if (isDemo != null) 'is_demo': isDemo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoicesCompanion copyWith({
    Value<int>? rev,
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
    Value<bool>? isDemo,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return InvoicesCompanion(
      rev: rev ?? this.rev,
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
      isDemo: isDemo ?? this.isDemo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
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
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
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
          ..write('rev: $rev, ')
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
          ..write('isDemo: $isDemo, ')
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
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    rev,
    updatedAt,
    deletedAt,
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
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
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
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
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
  final int rev;

  /// UTC epoch ms of the last write; 0 for rows from before v4 until the
  /// migration backfills it.
  final int updatedAt;

  /// Tombstone: hidden everywhere, purged after 30 days.
  final int? deletedAt;
  final String id;
  final String invoiceId;
  final int position;
  final String titleEn;
  final String titleAr;
  final String currency;
  const SectionRow({
    required this.rev,
    required this.updatedAt,
    this.deletedAt,
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
    map['rev'] = Variable<int>(rev);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
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
      rev: Value(rev),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
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
      rev: serializer.fromJson<int>(json['rev']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
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
      'rev': serializer.toJson<int>(rev),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'id': serializer.toJson<String>(id),
      'invoiceId': serializer.toJson<String>(invoiceId),
      'position': serializer.toJson<int>(position),
      'titleEn': serializer.toJson<String>(titleEn),
      'titleAr': serializer.toJson<String>(titleAr),
      'currency': serializer.toJson<String>(currency),
    };
  }

  SectionRow copyWith({
    int? rev,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? id,
    String? invoiceId,
    int? position,
    String? titleEn,
    String? titleAr,
    String? currency,
  }) => SectionRow(
    rev: rev ?? this.rev,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    id: id ?? this.id,
    invoiceId: invoiceId ?? this.invoiceId,
    position: position ?? this.position,
    titleEn: titleEn ?? this.titleEn,
    titleAr: titleAr ?? this.titleAr,
    currency: currency ?? this.currency,
  );
  SectionRow copyWithCompanion(SectionsCompanion data) {
    return SectionRow(
      rev: data.rev.present ? data.rev.value : this.rev,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
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
          ..write('rev: $rev, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
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
  int get hashCode => Object.hash(
    rev,
    updatedAt,
    deletedAt,
    id,
    invoiceId,
    position,
    titleEn,
    titleAr,
    currency,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SectionRow &&
          other.rev == this.rev &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.position == this.position &&
          other.titleEn == this.titleEn &&
          other.titleAr == this.titleAr &&
          other.currency == this.currency);
}

class SectionsCompanion extends UpdateCompanion<SectionRow> {
  final Value<int> rev;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> id;
  final Value<String> invoiceId;
  final Value<int> position;
  final Value<String> titleEn;
  final Value<String> titleAr;
  final Value<String> currency;
  final Value<int> rowid;
  const SectionsCompanion({
    this.rev = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.position = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.titleAr = const Value.absent(),
    this.currency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SectionsCompanion.insert({
    this.rev = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
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
    Expression<int>? rev,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? id,
    Expression<String>? invoiceId,
    Expression<int>? position,
    Expression<String>? titleEn,
    Expression<String>? titleAr,
    Expression<String>? currency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rev != null) 'rev': rev,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
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
    Value<int>? rev,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? id,
    Value<String>? invoiceId,
    Value<int>? position,
    Value<String>? titleEn,
    Value<String>? titleAr,
    Value<String>? currency,
    Value<int>? rowid,
  }) {
    return SectionsCompanion(
      rev: rev ?? this.rev,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
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
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
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
          ..write('rev: $rev, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
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
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    rev,
    updatedAt,
    deletedAt,
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
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
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
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
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
  final int rev;

  /// UTC epoch ms of the last write; 0 for rows from before v4 until the
  /// migration backfills it.
  final int updatedAt;

  /// Tombstone: hidden everywhere, purged after 30 days.
  final int? deletedAt;
  final String id;
  final String sectionId;
  final int position;
  final String service;
  final String description;
  final String cycle;
  final int qty;
  final int unitPriceMinor;
  const ItemRow({
    required this.rev,
    required this.updatedAt,
    this.deletedAt,
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
    map['rev'] = Variable<int>(rev);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
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
      rev: Value(rev),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
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
      rev: serializer.fromJson<int>(json['rev']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
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
      'rev': serializer.toJson<int>(rev),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
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
    int? rev,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? id,
    String? sectionId,
    int? position,
    String? service,
    String? description,
    String? cycle,
    int? qty,
    int? unitPriceMinor,
  }) => ItemRow(
    rev: rev ?? this.rev,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
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
      rev: data.rev.present ? data.rev.value : this.rev,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
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
          ..write('rev: $rev, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
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
    rev,
    updatedAt,
    deletedAt,
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
          other.rev == this.rev &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
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
  final Value<int> rev;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
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
    this.rev = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
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
    this.rev = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
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
    Expression<int>? rev,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
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
      if (rev != null) 'rev': rev,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
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
    Value<int>? rev,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
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
      rev: rev ?? this.rev,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
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
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
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
          ..write('rev: $rev, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
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

class $ClauseTemplatesTable extends ClauseTemplates
    with TableInfo<$ClauseTemplatesTable, TemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClauseTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
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
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    check: () => kind.isIn(const ['contract', 'quote']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _preambleMeta = const VerificationMeta(
    'preamble',
  );
  @override
  late final GeneratedColumn<String> preamble = GeneratedColumn<String>(
    'preamble',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _closingMeta = const VerificationMeta(
    'closing',
  );
  @override
  late final GeneratedColumn<String> closing = GeneratedColumn<String>(
    'closing',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _varDefaultsMeta = const VerificationMeta(
    'varDefaults',
  );
  @override
  late final GeneratedColumn<String> varDefaults = GeneratedColumn<String>(
    'var_defaults',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
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
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
    'is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    rev,
    id,
    name,
    kind,
    position,
    archived,
    preamble,
    closing,
    varDefaults,
    deletedAt,
    isDemo,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clause_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<TemplateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
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
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('preamble')) {
      context.handle(
        _preambleMeta,
        preamble.isAcceptableOrUnknown(data['preamble']!, _preambleMeta),
      );
    }
    if (data.containsKey('closing')) {
      context.handle(
        _closingMeta,
        closing.isAcceptableOrUnknown(data['closing']!, _closingMeta),
      );
    }
    if (data.containsKey('var_defaults')) {
      context.handle(
        _varDefaultsMeta,
        varDefaults.isAcceptableOrUnknown(
          data['var_defaults']!,
          _varDefaultsMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_demo')) {
      context.handle(
        _isDemoMeta,
        isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta),
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
  TemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateRow(
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      preamble: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preamble'],
      )!,
      closing: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}closing'],
      )!,
      varDefaults: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}var_defaults'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      isDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo'],
      )!,
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
  $ClauseTemplatesTable createAlias(String alias) {
    return $ClauseTemplatesTable(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
}

class TemplateRow extends DataClass implements Insertable<TemplateRow> {
  final int rev;
  final String id;
  final String name;
  final String kind;
  final int position;
  final bool archived;
  final String preamble;
  final String closing;

  /// JSON object of variable name → default value.
  final String varDefaults;

  /// v4: tombstone instead of a hard delete.
  final int? deletedAt;

  /// v5: demo row (removed with the demo set; cleared on user edits).
  final bool isDemo;
  final int createdAt;
  final int updatedAt;
  const TemplateRow({
    required this.rev,
    required this.id,
    required this.name,
    required this.kind,
    required this.position,
    required this.archived,
    required this.preamble,
    required this.closing,
    required this.varDefaults,
    this.deletedAt,
    required this.isDemo,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rev'] = Variable<int>(rev);
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['kind'] = Variable<String>(kind);
    map['position'] = Variable<int>(position);
    map['archived'] = Variable<bool>(archived);
    map['preamble'] = Variable<String>(preamble);
    map['closing'] = Variable<String>(closing);
    map['var_defaults'] = Variable<String>(varDefaults);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['is_demo'] = Variable<bool>(isDemo);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ClauseTemplatesCompanion toCompanion(bool nullToAbsent) {
    return ClauseTemplatesCompanion(
      rev: Value(rev),
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      position: Value(position),
      archived: Value(archived),
      preamble: Value(preamble),
      closing: Value(closing),
      varDefaults: Value(varDefaults),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDemo: Value(isDemo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TemplateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateRow(
      rev: serializer.fromJson<int>(json['rev']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      position: serializer.fromJson<int>(json['position']),
      archived: serializer.fromJson<bool>(json['archived']),
      preamble: serializer.fromJson<String>(json['preamble']),
      closing: serializer.fromJson<String>(json['closing']),
      varDefaults: serializer.fromJson<String>(json['varDefaults']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      isDemo: serializer.fromJson<bool>(json['isDemo']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rev': serializer.toJson<int>(rev),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(kind),
      'position': serializer.toJson<int>(position),
      'archived': serializer.toJson<bool>(archived),
      'preamble': serializer.toJson<String>(preamble),
      'closing': serializer.toJson<String>(closing),
      'varDefaults': serializer.toJson<String>(varDefaults),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'isDemo': serializer.toJson<bool>(isDemo),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  TemplateRow copyWith({
    int? rev,
    String? id,
    String? name,
    String? kind,
    int? position,
    bool? archived,
    String? preamble,
    String? closing,
    String? varDefaults,
    Value<int?> deletedAt = const Value.absent(),
    bool? isDemo,
    int? createdAt,
    int? updatedAt,
  }) => TemplateRow(
    rev: rev ?? this.rev,
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    position: position ?? this.position,
    archived: archived ?? this.archived,
    preamble: preamble ?? this.preamble,
    closing: closing ?? this.closing,
    varDefaults: varDefaults ?? this.varDefaults,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDemo: isDemo ?? this.isDemo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TemplateRow copyWithCompanion(ClauseTemplatesCompanion data) {
    return TemplateRow(
      rev: data.rev.present ? data.rev.value : this.rev,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      position: data.position.present ? data.position.value : this.position,
      archived: data.archived.present ? data.archived.value : this.archived,
      preamble: data.preamble.present ? data.preamble.value : this.preamble,
      closing: data.closing.present ? data.closing.value : this.closing,
      varDefaults: data.varDefaults.present
          ? data.varDefaults.value
          : this.varDefaults,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDemo: data.isDemo.present ? data.isDemo.value : this.isDemo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplateRow(')
          ..write('rev: $rev, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('position: $position, ')
          ..write('archived: $archived, ')
          ..write('preamble: $preamble, ')
          ..write('closing: $closing, ')
          ..write('varDefaults: $varDefaults, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDemo: $isDemo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rev,
    id,
    name,
    kind,
    position,
    archived,
    preamble,
    closing,
    varDefaults,
    deletedAt,
    isDemo,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateRow &&
          other.rev == this.rev &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.position == this.position &&
          other.archived == this.archived &&
          other.preamble == this.preamble &&
          other.closing == this.closing &&
          other.varDefaults == this.varDefaults &&
          other.deletedAt == this.deletedAt &&
          other.isDemo == this.isDemo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ClauseTemplatesCompanion extends UpdateCompanion<TemplateRow> {
  final Value<int> rev;
  final Value<String> id;
  final Value<String> name;
  final Value<String> kind;
  final Value<int> position;
  final Value<bool> archived;
  final Value<String> preamble;
  final Value<String> closing;
  final Value<String> varDefaults;
  final Value<int?> deletedAt;
  final Value<bool> isDemo;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ClauseTemplatesCompanion({
    this.rev = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.position = const Value.absent(),
    this.archived = const Value.absent(),
    this.preamble = const Value.absent(),
    this.closing = const Value.absent(),
    this.varDefaults = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDemo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClauseTemplatesCompanion.insert({
    this.rev = const Value.absent(),
    required String id,
    required String name,
    required String kind,
    required int position,
    this.archived = const Value.absent(),
    this.preamble = const Value.absent(),
    this.closing = const Value.absent(),
    this.varDefaults = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDemo = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       kind = Value(kind),
       position = Value(position),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TemplateRow> custom({
    Expression<int>? rev,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<int>? position,
    Expression<bool>? archived,
    Expression<String>? preamble,
    Expression<String>? closing,
    Expression<String>? varDefaults,
    Expression<int>? deletedAt,
    Expression<bool>? isDemo,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rev != null) 'rev': rev,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (position != null) 'position': position,
      if (archived != null) 'archived': archived,
      if (preamble != null) 'preamble': preamble,
      if (closing != null) 'closing': closing,
      if (varDefaults != null) 'var_defaults': varDefaults,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDemo != null) 'is_demo': isDemo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClauseTemplatesCompanion copyWith({
    Value<int>? rev,
    Value<String>? id,
    Value<String>? name,
    Value<String>? kind,
    Value<int>? position,
    Value<bool>? archived,
    Value<String>? preamble,
    Value<String>? closing,
    Value<String>? varDefaults,
    Value<int?>? deletedAt,
    Value<bool>? isDemo,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ClauseTemplatesCompanion(
      rev: rev ?? this.rev,
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      position: position ?? this.position,
      archived: archived ?? this.archived,
      preamble: preamble ?? this.preamble,
      closing: closing ?? this.closing,
      varDefaults: varDefaults ?? this.varDefaults,
      deletedAt: deletedAt ?? this.deletedAt,
      isDemo: isDemo ?? this.isDemo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (preamble.present) {
      map['preamble'] = Variable<String>(preamble.value);
    }
    if (closing.present) {
      map['closing'] = Variable<String>(closing.value);
    }
    if (varDefaults.present) {
      map['var_defaults'] = Variable<String>(varDefaults.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
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
    return (StringBuffer('ClauseTemplatesCompanion(')
          ..write('rev: $rev, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('position: $position, ')
          ..write('archived: $archived, ')
          ..write('preamble: $preamble, ')
          ..write('closing: $closing, ')
          ..write('varDefaults: $varDefaults, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDemo: $isDemo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LibraryClausesTable extends LibraryClauses
    with TableInfo<$LibraryClausesTable, LibraryClauseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryClausesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clause_templates (id) ON DELETE CASCADE',
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _optionalMeta = const VerificationMeta(
    'optional',
  );
  @override
  late final GeneratedColumn<bool> optional = GeneratedColumn<bool>(
    'optional',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("optional" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _enabledByDefaultMeta = const VerificationMeta(
    'enabledByDefault',
  );
  @override
  late final GeneratedColumn<bool> enabledByDefault = GeneratedColumn<bool>(
    'enabled_by_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled_by_default" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rev,
    updatedAt,
    deletedAt,
    id,
    templateId,
    position,
    title,
    body,
    optional,
    enabledByDefault,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_clauses';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryClauseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('optional')) {
      context.handle(
        _optionalMeta,
        optional.isAcceptableOrUnknown(data['optional']!, _optionalMeta),
      );
    }
    if (data.containsKey('enabled_by_default')) {
      context.handle(
        _enabledByDefaultMeta,
        enabledByDefault.isAcceptableOrUnknown(
          data['enabled_by_default']!,
          _enabledByDefaultMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibraryClauseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryClauseRow(
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      optional: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}optional'],
      )!,
      enabledByDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled_by_default'],
      )!,
    );
  }

  @override
  $LibraryClausesTable createAlias(String alias) {
    return $LibraryClausesTable(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
}

class LibraryClauseRow extends DataClass
    implements Insertable<LibraryClauseRow> {
  final int rev;

  /// UTC epoch ms of the last write; 0 for rows from before v4 until the
  /// migration backfills it.
  final int updatedAt;

  /// Tombstone: hidden everywhere, purged after 30 days.
  final int? deletedAt;
  final String id;
  final String templateId;
  final int position;
  final String title;
  final String body;
  final bool optional;
  final bool enabledByDefault;
  const LibraryClauseRow({
    required this.rev,
    required this.updatedAt,
    this.deletedAt,
    required this.id,
    required this.templateId,
    required this.position,
    required this.title,
    required this.body,
    required this.optional,
    required this.enabledByDefault,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rev'] = Variable<int>(rev);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['id'] = Variable<String>(id);
    map['template_id'] = Variable<String>(templateId);
    map['position'] = Variable<int>(position);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['optional'] = Variable<bool>(optional);
    map['enabled_by_default'] = Variable<bool>(enabledByDefault);
    return map;
  }

  LibraryClausesCompanion toCompanion(bool nullToAbsent) {
    return LibraryClausesCompanion(
      rev: Value(rev),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      id: Value(id),
      templateId: Value(templateId),
      position: Value(position),
      title: Value(title),
      body: Value(body),
      optional: Value(optional),
      enabledByDefault: Value(enabledByDefault),
    );
  }

  factory LibraryClauseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryClauseRow(
      rev: serializer.fromJson<int>(json['rev']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      id: serializer.fromJson<String>(json['id']),
      templateId: serializer.fromJson<String>(json['templateId']),
      position: serializer.fromJson<int>(json['position']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      optional: serializer.fromJson<bool>(json['optional']),
      enabledByDefault: serializer.fromJson<bool>(json['enabledByDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rev': serializer.toJson<int>(rev),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'id': serializer.toJson<String>(id),
      'templateId': serializer.toJson<String>(templateId),
      'position': serializer.toJson<int>(position),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'optional': serializer.toJson<bool>(optional),
      'enabledByDefault': serializer.toJson<bool>(enabledByDefault),
    };
  }

  LibraryClauseRow copyWith({
    int? rev,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? id,
    String? templateId,
    int? position,
    String? title,
    String? body,
    bool? optional,
    bool? enabledByDefault,
  }) => LibraryClauseRow(
    rev: rev ?? this.rev,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    position: position ?? this.position,
    title: title ?? this.title,
    body: body ?? this.body,
    optional: optional ?? this.optional,
    enabledByDefault: enabledByDefault ?? this.enabledByDefault,
  );
  LibraryClauseRow copyWithCompanion(LibraryClausesCompanion data) {
    return LibraryClauseRow(
      rev: data.rev.present ? data.rev.value : this.rev,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      position: data.position.present ? data.position.value : this.position,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      optional: data.optional.present ? data.optional.value : this.optional,
      enabledByDefault: data.enabledByDefault.present
          ? data.enabledByDefault.value
          : this.enabledByDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryClauseRow(')
          ..write('rev: $rev, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('optional: $optional, ')
          ..write('enabledByDefault: $enabledByDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rev,
    updatedAt,
    deletedAt,
    id,
    templateId,
    position,
    title,
    body,
    optional,
    enabledByDefault,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryClauseRow &&
          other.rev == this.rev &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.position == this.position &&
          other.title == this.title &&
          other.body == this.body &&
          other.optional == this.optional &&
          other.enabledByDefault == this.enabledByDefault);
}

class LibraryClausesCompanion extends UpdateCompanion<LibraryClauseRow> {
  final Value<int> rev;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> id;
  final Value<String> templateId;
  final Value<int> position;
  final Value<String> title;
  final Value<String> body;
  final Value<bool> optional;
  final Value<bool> enabledByDefault;
  final Value<int> rowid;
  const LibraryClausesCompanion({
    this.rev = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.position = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.optional = const Value.absent(),
    this.enabledByDefault = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibraryClausesCompanion.insert({
    this.rev = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String id,
    required String templateId,
    required int position,
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.optional = const Value.absent(),
    this.enabledByDefault = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       templateId = Value(templateId),
       position = Value(position);
  static Insertable<LibraryClauseRow> custom({
    Expression<int>? rev,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? id,
    Expression<String>? templateId,
    Expression<int>? position,
    Expression<String>? title,
    Expression<String>? body,
    Expression<bool>? optional,
    Expression<bool>? enabledByDefault,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rev != null) 'rev': rev,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (position != null) 'position': position,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (optional != null) 'optional': optional,
      if (enabledByDefault != null) 'enabled_by_default': enabledByDefault,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibraryClausesCompanion copyWith({
    Value<int>? rev,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? id,
    Value<String>? templateId,
    Value<int>? position,
    Value<String>? title,
    Value<String>? body,
    Value<bool>? optional,
    Value<bool>? enabledByDefault,
    Value<int>? rowid,
  }) {
    return LibraryClausesCompanion(
      rev: rev ?? this.rev,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      position: position ?? this.position,
      title: title ?? this.title,
      body: body ?? this.body,
      optional: optional ?? this.optional,
      enabledByDefault: enabledByDefault ?? this.enabledByDefault,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (optional.present) {
      map['optional'] = Variable<bool>(optional.value);
    }
    if (enabledByDefault.present) {
      map['enabled_by_default'] = Variable<bool>(enabledByDefault.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryClausesCompanion(')
          ..write('rev: $rev, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('optional: $optional, ')
          ..write('enabledByDefault: $enabledByDefault, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContractsTable extends Contracts
    with TableInfo<$ContractsTable, ContractRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContractsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
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
  static const VerificationMeta _seriesMeta = const VerificationMeta('series');
  @override
  late final GeneratedColumn<String> series = GeneratedColumn<String>(
    'series',
    aliasedName,
    false,
    check: () => series.isIn(const ['contract', 'quote']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _amendmentNoMeta = const VerificationMeta(
    'amendmentNo',
  );
  @override
  late final GeneratedColumn<int> amendmentNo = GeneratedColumn<int>(
    'amendment_no',
    aliasedName,
    false,
    check: () => ComparableExpr(amendmentNo).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contracts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    check: () => kind.isIn(const ['contract', 'quote', 'amendment']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateNameMeta = const VerificationMeta(
    'templateName',
  );
  @override
  late final GeneratedColumn<String> templateName = GeneratedColumn<String>(
    'template_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _projectNameMeta = const VerificationMeta(
    'projectName',
  );
  @override
  late final GeneratedColumn<String> projectName = GeneratedColumn<String>(
    'project_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _projectSummaryMeta = const VerificationMeta(
    'projectSummary',
  );
  @override
  late final GeneratedColumn<String> projectSummary = GeneratedColumn<String>(
    'project_summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _preambleMeta = const VerificationMeta(
    'preamble',
  );
  @override
  late final GeneratedColumn<String> preamble = GeneratedColumn<String>(
    'preamble',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _closingMeta = const VerificationMeta(
    'closing',
  );
  @override
  late final GeneratedColumn<String> closing = GeneratedColumn<String>(
    'closing',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signedDateMeta = const VerificationMeta(
    'signedDate',
  );
  @override
  late final GeneratedColumn<String> signedDate = GeneratedColumn<String>(
    'signed_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
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
    check: () => status.isIn(const [
      'draft',
      'sent',
      'signed',
      'active',
      'completed',
      'cancelled',
    ]),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jurisdictionMeta = const VerificationMeta(
    'jurisdiction',
  );
  @override
  late final GeneratedColumn<String> jurisdiction = GeneratedColumn<String>(
    'jurisdiction',
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
  static const VerificationMeta _totalMinorMeta = const VerificationMeta(
    'totalMinor',
  );
  @override
  late final GeneratedColumn<int> totalMinor = GeneratedColumn<int>(
    'total_minor',
    aliasedName,
    false,
    check: () => ComparableExpr(totalMinor).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _varsMeta = const VerificationMeta('vars');
  @override
  late final GeneratedColumn<String> vars = GeneratedColumn<String>(
    'vars',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _outOfScopeMeta = const VerificationMeta(
    'outOfScope',
  );
  @override
  late final GeneratedColumn<String> outOfScope = GeneratedColumn<String>(
    'out_of_scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _unlockedMeta = const VerificationMeta(
    'unlocked',
  );
  @override
  late final GeneratedColumn<bool> unlocked = GeneratedColumn<bool>(
    'unlocked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("unlocked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _historyMeta = const VerificationMeta(
    'history',
  );
  @override
  late final GeneratedColumn<String> history = GeneratedColumn<String>(
    'history',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
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
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
    'is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    rev,
    id,
    clientId,
    number,
    series,
    year,
    seq,
    amendmentNo,
    parentId,
    kind,
    templateName,
    title,
    projectName,
    projectSummary,
    preamble,
    closing,
    issueDate,
    startDate,
    signedDate,
    endDate,
    status,
    jurisdiction,
    currency,
    totalMinor,
    vars,
    outOfScope,
    unlocked,
    history,
    deletedAt,
    isDemo,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contracts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContractRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
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
    if (data.containsKey('series')) {
      context.handle(
        _seriesMeta,
        series.isAcceptableOrUnknown(data['series']!, _seriesMeta),
      );
    } else if (isInserting) {
      context.missing(_seriesMeta);
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
    if (data.containsKey('amendment_no')) {
      context.handle(
        _amendmentNoMeta,
        amendmentNo.isAcceptableOrUnknown(
          data['amendment_no']!,
          _amendmentNoMeta,
        ),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('template_name')) {
      context.handle(
        _templateNameMeta,
        templateName.isAcceptableOrUnknown(
          data['template_name']!,
          _templateNameMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('project_name')) {
      context.handle(
        _projectNameMeta,
        projectName.isAcceptableOrUnknown(
          data['project_name']!,
          _projectNameMeta,
        ),
      );
    }
    if (data.containsKey('project_summary')) {
      context.handle(
        _projectSummaryMeta,
        projectSummary.isAcceptableOrUnknown(
          data['project_summary']!,
          _projectSummaryMeta,
        ),
      );
    }
    if (data.containsKey('preamble')) {
      context.handle(
        _preambleMeta,
        preamble.isAcceptableOrUnknown(data['preamble']!, _preambleMeta),
      );
    }
    if (data.containsKey('closing')) {
      context.handle(
        _closingMeta,
        closing.isAcceptableOrUnknown(data['closing']!, _closingMeta),
      );
    }
    if (data.containsKey('issue_date')) {
      context.handle(
        _issueDateMeta,
        issueDate.isAcceptableOrUnknown(data['issue_date']!, _issueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_issueDateMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('signed_date')) {
      context.handle(
        _signedDateMeta,
        signedDate.isAcceptableOrUnknown(data['signed_date']!, _signedDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
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
    if (data.containsKey('jurisdiction')) {
      context.handle(
        _jurisdictionMeta,
        jurisdiction.isAcceptableOrUnknown(
          data['jurisdiction']!,
          _jurisdictionMeta,
        ),
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
    if (data.containsKey('total_minor')) {
      context.handle(
        _totalMinorMeta,
        totalMinor.isAcceptableOrUnknown(data['total_minor']!, _totalMinorMeta),
      );
    }
    if (data.containsKey('vars')) {
      context.handle(
        _varsMeta,
        vars.isAcceptableOrUnknown(data['vars']!, _varsMeta),
      );
    }
    if (data.containsKey('out_of_scope')) {
      context.handle(
        _outOfScopeMeta,
        outOfScope.isAcceptableOrUnknown(
          data['out_of_scope']!,
          _outOfScopeMeta,
        ),
      );
    }
    if (data.containsKey('unlocked')) {
      context.handle(
        _unlockedMeta,
        unlocked.isAcceptableOrUnknown(data['unlocked']!, _unlockedMeta),
      );
    }
    if (data.containsKey('history')) {
      context.handle(
        _historyMeta,
        history.isAcceptableOrUnknown(data['history']!, _historyMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_demo')) {
      context.handle(
        _isDemoMeta,
        isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta),
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
    {series, year, seq, amendmentNo},
  ];
  @override
  ContractRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContractRow(
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
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
      series: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      amendmentNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amendment_no'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      templateName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_name'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      projectName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_name'],
      )!,
      projectSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_summary'],
      )!,
      preamble: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preamble'],
      )!,
      closing: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}closing'],
      )!,
      issueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}issue_date'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      ),
      signedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signed_date'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      jurisdiction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jurisdiction'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      totalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minor'],
      )!,
      vars: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vars'],
      )!,
      outOfScope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}out_of_scope'],
      )!,
      unlocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}unlocked'],
      )!,
      history: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}history'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      isDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo'],
      )!,
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
  $ContractsTable createAlias(String alias) {
    return $ContractsTable(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
}

class ContractRow extends DataClass implements Insertable<ContractRow> {
  final int rev;
  final String id;
  final String clientId;
  final String number;

  /// Numbering series: `contract` (CT-…) or `quote` (QT-…). Amendments use
  /// their original's series, year and seq plus [amendmentNo].
  final String series;
  final int year;
  final int seq;
  final int amendmentNo;

  /// The original contract of an amendment.
  final String? parentId;
  final String kind;
  final String templateName;
  final String title;
  final String projectName;
  final String projectSummary;
  final String preamble;
  final String closing;
  final String issueDate;
  final String? startDate;
  final String? signedDate;
  final String? endDate;
  final String status;
  final String jurisdiction;
  final String currency;
  final int totalMinor;

  /// JSON object of custom variable name → value.
  final String vars;

  /// One out-of-scope entry per line.
  final String outOfScope;

  /// Signed contracts are read-only unless explicitly unlocked.
  final bool unlocked;

  /// JSON list of `{at, event}` entries (unlocks, status changes).
  final String history;
  final int? deletedAt;

  /// v5: demo row (removed with the demo set; cleared on user edits).
  final bool isDemo;
  final int createdAt;
  final int updatedAt;
  const ContractRow({
    required this.rev,
    required this.id,
    required this.clientId,
    required this.number,
    required this.series,
    required this.year,
    required this.seq,
    required this.amendmentNo,
    this.parentId,
    required this.kind,
    required this.templateName,
    required this.title,
    required this.projectName,
    required this.projectSummary,
    required this.preamble,
    required this.closing,
    required this.issueDate,
    this.startDate,
    this.signedDate,
    this.endDate,
    required this.status,
    required this.jurisdiction,
    required this.currency,
    required this.totalMinor,
    required this.vars,
    required this.outOfScope,
    required this.unlocked,
    required this.history,
    this.deletedAt,
    required this.isDemo,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rev'] = Variable<int>(rev);
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['number'] = Variable<String>(number);
    map['series'] = Variable<String>(series);
    map['year'] = Variable<int>(year);
    map['seq'] = Variable<int>(seq);
    map['amendment_no'] = Variable<int>(amendmentNo);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['kind'] = Variable<String>(kind);
    map['template_name'] = Variable<String>(templateName);
    map['title'] = Variable<String>(title);
    map['project_name'] = Variable<String>(projectName);
    map['project_summary'] = Variable<String>(projectSummary);
    map['preamble'] = Variable<String>(preamble);
    map['closing'] = Variable<String>(closing);
    map['issue_date'] = Variable<String>(issueDate);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<String>(startDate);
    }
    if (!nullToAbsent || signedDate != null) {
      map['signed_date'] = Variable<String>(signedDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    map['status'] = Variable<String>(status);
    map['jurisdiction'] = Variable<String>(jurisdiction);
    map['currency'] = Variable<String>(currency);
    map['total_minor'] = Variable<int>(totalMinor);
    map['vars'] = Variable<String>(vars);
    map['out_of_scope'] = Variable<String>(outOfScope);
    map['unlocked'] = Variable<bool>(unlocked);
    map['history'] = Variable<String>(history);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['is_demo'] = Variable<bool>(isDemo);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ContractsCompanion toCompanion(bool nullToAbsent) {
    return ContractsCompanion(
      rev: Value(rev),
      id: Value(id),
      clientId: Value(clientId),
      number: Value(number),
      series: Value(series),
      year: Value(year),
      seq: Value(seq),
      amendmentNo: Value(amendmentNo),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      kind: Value(kind),
      templateName: Value(templateName),
      title: Value(title),
      projectName: Value(projectName),
      projectSummary: Value(projectSummary),
      preamble: Value(preamble),
      closing: Value(closing),
      issueDate: Value(issueDate),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      signedDate: signedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(signedDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      status: Value(status),
      jurisdiction: Value(jurisdiction),
      currency: Value(currency),
      totalMinor: Value(totalMinor),
      vars: Value(vars),
      outOfScope: Value(outOfScope),
      unlocked: Value(unlocked),
      history: Value(history),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDemo: Value(isDemo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ContractRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContractRow(
      rev: serializer.fromJson<int>(json['rev']),
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      number: serializer.fromJson<String>(json['number']),
      series: serializer.fromJson<String>(json['series']),
      year: serializer.fromJson<int>(json['year']),
      seq: serializer.fromJson<int>(json['seq']),
      amendmentNo: serializer.fromJson<int>(json['amendmentNo']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      kind: serializer.fromJson<String>(json['kind']),
      templateName: serializer.fromJson<String>(json['templateName']),
      title: serializer.fromJson<String>(json['title']),
      projectName: serializer.fromJson<String>(json['projectName']),
      projectSummary: serializer.fromJson<String>(json['projectSummary']),
      preamble: serializer.fromJson<String>(json['preamble']),
      closing: serializer.fromJson<String>(json['closing']),
      issueDate: serializer.fromJson<String>(json['issueDate']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      signedDate: serializer.fromJson<String?>(json['signedDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      status: serializer.fromJson<String>(json['status']),
      jurisdiction: serializer.fromJson<String>(json['jurisdiction']),
      currency: serializer.fromJson<String>(json['currency']),
      totalMinor: serializer.fromJson<int>(json['totalMinor']),
      vars: serializer.fromJson<String>(json['vars']),
      outOfScope: serializer.fromJson<String>(json['outOfScope']),
      unlocked: serializer.fromJson<bool>(json['unlocked']),
      history: serializer.fromJson<String>(json['history']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      isDemo: serializer.fromJson<bool>(json['isDemo']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rev': serializer.toJson<int>(rev),
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'number': serializer.toJson<String>(number),
      'series': serializer.toJson<String>(series),
      'year': serializer.toJson<int>(year),
      'seq': serializer.toJson<int>(seq),
      'amendmentNo': serializer.toJson<int>(amendmentNo),
      'parentId': serializer.toJson<String?>(parentId),
      'kind': serializer.toJson<String>(kind),
      'templateName': serializer.toJson<String>(templateName),
      'title': serializer.toJson<String>(title),
      'projectName': serializer.toJson<String>(projectName),
      'projectSummary': serializer.toJson<String>(projectSummary),
      'preamble': serializer.toJson<String>(preamble),
      'closing': serializer.toJson<String>(closing),
      'issueDate': serializer.toJson<String>(issueDate),
      'startDate': serializer.toJson<String?>(startDate),
      'signedDate': serializer.toJson<String?>(signedDate),
      'endDate': serializer.toJson<String?>(endDate),
      'status': serializer.toJson<String>(status),
      'jurisdiction': serializer.toJson<String>(jurisdiction),
      'currency': serializer.toJson<String>(currency),
      'totalMinor': serializer.toJson<int>(totalMinor),
      'vars': serializer.toJson<String>(vars),
      'outOfScope': serializer.toJson<String>(outOfScope),
      'unlocked': serializer.toJson<bool>(unlocked),
      'history': serializer.toJson<String>(history),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'isDemo': serializer.toJson<bool>(isDemo),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ContractRow copyWith({
    int? rev,
    String? id,
    String? clientId,
    String? number,
    String? series,
    int? year,
    int? seq,
    int? amendmentNo,
    Value<String?> parentId = const Value.absent(),
    String? kind,
    String? templateName,
    String? title,
    String? projectName,
    String? projectSummary,
    String? preamble,
    String? closing,
    String? issueDate,
    Value<String?> startDate = const Value.absent(),
    Value<String?> signedDate = const Value.absent(),
    Value<String?> endDate = const Value.absent(),
    String? status,
    String? jurisdiction,
    String? currency,
    int? totalMinor,
    String? vars,
    String? outOfScope,
    bool? unlocked,
    String? history,
    Value<int?> deletedAt = const Value.absent(),
    bool? isDemo,
    int? createdAt,
    int? updatedAt,
  }) => ContractRow(
    rev: rev ?? this.rev,
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    number: number ?? this.number,
    series: series ?? this.series,
    year: year ?? this.year,
    seq: seq ?? this.seq,
    amendmentNo: amendmentNo ?? this.amendmentNo,
    parentId: parentId.present ? parentId.value : this.parentId,
    kind: kind ?? this.kind,
    templateName: templateName ?? this.templateName,
    title: title ?? this.title,
    projectName: projectName ?? this.projectName,
    projectSummary: projectSummary ?? this.projectSummary,
    preamble: preamble ?? this.preamble,
    closing: closing ?? this.closing,
    issueDate: issueDate ?? this.issueDate,
    startDate: startDate.present ? startDate.value : this.startDate,
    signedDate: signedDate.present ? signedDate.value : this.signedDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    status: status ?? this.status,
    jurisdiction: jurisdiction ?? this.jurisdiction,
    currency: currency ?? this.currency,
    totalMinor: totalMinor ?? this.totalMinor,
    vars: vars ?? this.vars,
    outOfScope: outOfScope ?? this.outOfScope,
    unlocked: unlocked ?? this.unlocked,
    history: history ?? this.history,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDemo: isDemo ?? this.isDemo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ContractRow copyWithCompanion(ContractsCompanion data) {
    return ContractRow(
      rev: data.rev.present ? data.rev.value : this.rev,
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      number: data.number.present ? data.number.value : this.number,
      series: data.series.present ? data.series.value : this.series,
      year: data.year.present ? data.year.value : this.year,
      seq: data.seq.present ? data.seq.value : this.seq,
      amendmentNo: data.amendmentNo.present
          ? data.amendmentNo.value
          : this.amendmentNo,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      kind: data.kind.present ? data.kind.value : this.kind,
      templateName: data.templateName.present
          ? data.templateName.value
          : this.templateName,
      title: data.title.present ? data.title.value : this.title,
      projectName: data.projectName.present
          ? data.projectName.value
          : this.projectName,
      projectSummary: data.projectSummary.present
          ? data.projectSummary.value
          : this.projectSummary,
      preamble: data.preamble.present ? data.preamble.value : this.preamble,
      closing: data.closing.present ? data.closing.value : this.closing,
      issueDate: data.issueDate.present ? data.issueDate.value : this.issueDate,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      signedDate: data.signedDate.present
          ? data.signedDate.value
          : this.signedDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      status: data.status.present ? data.status.value : this.status,
      jurisdiction: data.jurisdiction.present
          ? data.jurisdiction.value
          : this.jurisdiction,
      currency: data.currency.present ? data.currency.value : this.currency,
      totalMinor: data.totalMinor.present
          ? data.totalMinor.value
          : this.totalMinor,
      vars: data.vars.present ? data.vars.value : this.vars,
      outOfScope: data.outOfScope.present
          ? data.outOfScope.value
          : this.outOfScope,
      unlocked: data.unlocked.present ? data.unlocked.value : this.unlocked,
      history: data.history.present ? data.history.value : this.history,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDemo: data.isDemo.present ? data.isDemo.value : this.isDemo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContractRow(')
          ..write('rev: $rev, ')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('number: $number, ')
          ..write('series: $series, ')
          ..write('year: $year, ')
          ..write('seq: $seq, ')
          ..write('amendmentNo: $amendmentNo, ')
          ..write('parentId: $parentId, ')
          ..write('kind: $kind, ')
          ..write('templateName: $templateName, ')
          ..write('title: $title, ')
          ..write('projectName: $projectName, ')
          ..write('projectSummary: $projectSummary, ')
          ..write('preamble: $preamble, ')
          ..write('closing: $closing, ')
          ..write('issueDate: $issueDate, ')
          ..write('startDate: $startDate, ')
          ..write('signedDate: $signedDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('jurisdiction: $jurisdiction, ')
          ..write('currency: $currency, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('vars: $vars, ')
          ..write('outOfScope: $outOfScope, ')
          ..write('unlocked: $unlocked, ')
          ..write('history: $history, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDemo: $isDemo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    rev,
    id,
    clientId,
    number,
    series,
    year,
    seq,
    amendmentNo,
    parentId,
    kind,
    templateName,
    title,
    projectName,
    projectSummary,
    preamble,
    closing,
    issueDate,
    startDate,
    signedDate,
    endDate,
    status,
    jurisdiction,
    currency,
    totalMinor,
    vars,
    outOfScope,
    unlocked,
    history,
    deletedAt,
    isDemo,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContractRow &&
          other.rev == this.rev &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.number == this.number &&
          other.series == this.series &&
          other.year == this.year &&
          other.seq == this.seq &&
          other.amendmentNo == this.amendmentNo &&
          other.parentId == this.parentId &&
          other.kind == this.kind &&
          other.templateName == this.templateName &&
          other.title == this.title &&
          other.projectName == this.projectName &&
          other.projectSummary == this.projectSummary &&
          other.preamble == this.preamble &&
          other.closing == this.closing &&
          other.issueDate == this.issueDate &&
          other.startDate == this.startDate &&
          other.signedDate == this.signedDate &&
          other.endDate == this.endDate &&
          other.status == this.status &&
          other.jurisdiction == this.jurisdiction &&
          other.currency == this.currency &&
          other.totalMinor == this.totalMinor &&
          other.vars == this.vars &&
          other.outOfScope == this.outOfScope &&
          other.unlocked == this.unlocked &&
          other.history == this.history &&
          other.deletedAt == this.deletedAt &&
          other.isDemo == this.isDemo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ContractsCompanion extends UpdateCompanion<ContractRow> {
  final Value<int> rev;
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> number;
  final Value<String> series;
  final Value<int> year;
  final Value<int> seq;
  final Value<int> amendmentNo;
  final Value<String?> parentId;
  final Value<String> kind;
  final Value<String> templateName;
  final Value<String> title;
  final Value<String> projectName;
  final Value<String> projectSummary;
  final Value<String> preamble;
  final Value<String> closing;
  final Value<String> issueDate;
  final Value<String?> startDate;
  final Value<String?> signedDate;
  final Value<String?> endDate;
  final Value<String> status;
  final Value<String> jurisdiction;
  final Value<String> currency;
  final Value<int> totalMinor;
  final Value<String> vars;
  final Value<String> outOfScope;
  final Value<bool> unlocked;
  final Value<String> history;
  final Value<int?> deletedAt;
  final Value<bool> isDemo;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ContractsCompanion({
    this.rev = const Value.absent(),
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.number = const Value.absent(),
    this.series = const Value.absent(),
    this.year = const Value.absent(),
    this.seq = const Value.absent(),
    this.amendmentNo = const Value.absent(),
    this.parentId = const Value.absent(),
    this.kind = const Value.absent(),
    this.templateName = const Value.absent(),
    this.title = const Value.absent(),
    this.projectName = const Value.absent(),
    this.projectSummary = const Value.absent(),
    this.preamble = const Value.absent(),
    this.closing = const Value.absent(),
    this.issueDate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.signedDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.jurisdiction = const Value.absent(),
    this.currency = const Value.absent(),
    this.totalMinor = const Value.absent(),
    this.vars = const Value.absent(),
    this.outOfScope = const Value.absent(),
    this.unlocked = const Value.absent(),
    this.history = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDemo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContractsCompanion.insert({
    this.rev = const Value.absent(),
    required String id,
    required String clientId,
    required String number,
    required String series,
    required int year,
    required int seq,
    this.amendmentNo = const Value.absent(),
    this.parentId = const Value.absent(),
    required String kind,
    this.templateName = const Value.absent(),
    this.title = const Value.absent(),
    this.projectName = const Value.absent(),
    this.projectSummary = const Value.absent(),
    this.preamble = const Value.absent(),
    this.closing = const Value.absent(),
    required String issueDate,
    this.startDate = const Value.absent(),
    this.signedDate = const Value.absent(),
    this.endDate = const Value.absent(),
    required String status,
    this.jurisdiction = const Value.absent(),
    required String currency,
    this.totalMinor = const Value.absent(),
    this.vars = const Value.absent(),
    this.outOfScope = const Value.absent(),
    this.unlocked = const Value.absent(),
    this.history = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDemo = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       number = Value(number),
       series = Value(series),
       year = Value(year),
       seq = Value(seq),
       kind = Value(kind),
       issueDate = Value(issueDate),
       status = Value(status),
       currency = Value(currency),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ContractRow> custom({
    Expression<int>? rev,
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? number,
    Expression<String>? series,
    Expression<int>? year,
    Expression<int>? seq,
    Expression<int>? amendmentNo,
    Expression<String>? parentId,
    Expression<String>? kind,
    Expression<String>? templateName,
    Expression<String>? title,
    Expression<String>? projectName,
    Expression<String>? projectSummary,
    Expression<String>? preamble,
    Expression<String>? closing,
    Expression<String>? issueDate,
    Expression<String>? startDate,
    Expression<String>? signedDate,
    Expression<String>? endDate,
    Expression<String>? status,
    Expression<String>? jurisdiction,
    Expression<String>? currency,
    Expression<int>? totalMinor,
    Expression<String>? vars,
    Expression<String>? outOfScope,
    Expression<bool>? unlocked,
    Expression<String>? history,
    Expression<int>? deletedAt,
    Expression<bool>? isDemo,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rev != null) 'rev': rev,
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (number != null) 'number': number,
      if (series != null) 'series': series,
      if (year != null) 'year': year,
      if (seq != null) 'seq': seq,
      if (amendmentNo != null) 'amendment_no': amendmentNo,
      if (parentId != null) 'parent_id': parentId,
      if (kind != null) 'kind': kind,
      if (templateName != null) 'template_name': templateName,
      if (title != null) 'title': title,
      if (projectName != null) 'project_name': projectName,
      if (projectSummary != null) 'project_summary': projectSummary,
      if (preamble != null) 'preamble': preamble,
      if (closing != null) 'closing': closing,
      if (issueDate != null) 'issue_date': issueDate,
      if (startDate != null) 'start_date': startDate,
      if (signedDate != null) 'signed_date': signedDate,
      if (endDate != null) 'end_date': endDate,
      if (status != null) 'status': status,
      if (jurisdiction != null) 'jurisdiction': jurisdiction,
      if (currency != null) 'currency': currency,
      if (totalMinor != null) 'total_minor': totalMinor,
      if (vars != null) 'vars': vars,
      if (outOfScope != null) 'out_of_scope': outOfScope,
      if (unlocked != null) 'unlocked': unlocked,
      if (history != null) 'history': history,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDemo != null) 'is_demo': isDemo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContractsCompanion copyWith({
    Value<int>? rev,
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? number,
    Value<String>? series,
    Value<int>? year,
    Value<int>? seq,
    Value<int>? amendmentNo,
    Value<String?>? parentId,
    Value<String>? kind,
    Value<String>? templateName,
    Value<String>? title,
    Value<String>? projectName,
    Value<String>? projectSummary,
    Value<String>? preamble,
    Value<String>? closing,
    Value<String>? issueDate,
    Value<String?>? startDate,
    Value<String?>? signedDate,
    Value<String?>? endDate,
    Value<String>? status,
    Value<String>? jurisdiction,
    Value<String>? currency,
    Value<int>? totalMinor,
    Value<String>? vars,
    Value<String>? outOfScope,
    Value<bool>? unlocked,
    Value<String>? history,
    Value<int?>? deletedAt,
    Value<bool>? isDemo,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ContractsCompanion(
      rev: rev ?? this.rev,
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      number: number ?? this.number,
      series: series ?? this.series,
      year: year ?? this.year,
      seq: seq ?? this.seq,
      amendmentNo: amendmentNo ?? this.amendmentNo,
      parentId: parentId ?? this.parentId,
      kind: kind ?? this.kind,
      templateName: templateName ?? this.templateName,
      title: title ?? this.title,
      projectName: projectName ?? this.projectName,
      projectSummary: projectSummary ?? this.projectSummary,
      preamble: preamble ?? this.preamble,
      closing: closing ?? this.closing,
      issueDate: issueDate ?? this.issueDate,
      startDate: startDate ?? this.startDate,
      signedDate: signedDate ?? this.signedDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      jurisdiction: jurisdiction ?? this.jurisdiction,
      currency: currency ?? this.currency,
      totalMinor: totalMinor ?? this.totalMinor,
      vars: vars ?? this.vars,
      outOfScope: outOfScope ?? this.outOfScope,
      unlocked: unlocked ?? this.unlocked,
      history: history ?? this.history,
      deletedAt: deletedAt ?? this.deletedAt,
      isDemo: isDemo ?? this.isDemo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (series.present) {
      map['series'] = Variable<String>(series.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (amendmentNo.present) {
      map['amendment_no'] = Variable<int>(amendmentNo.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (templateName.present) {
      map['template_name'] = Variable<String>(templateName.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (projectName.present) {
      map['project_name'] = Variable<String>(projectName.value);
    }
    if (projectSummary.present) {
      map['project_summary'] = Variable<String>(projectSummary.value);
    }
    if (preamble.present) {
      map['preamble'] = Variable<String>(preamble.value);
    }
    if (closing.present) {
      map['closing'] = Variable<String>(closing.value);
    }
    if (issueDate.present) {
      map['issue_date'] = Variable<String>(issueDate.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (signedDate.present) {
      map['signed_date'] = Variable<String>(signedDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (jurisdiction.present) {
      map['jurisdiction'] = Variable<String>(jurisdiction.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (totalMinor.present) {
      map['total_minor'] = Variable<int>(totalMinor.value);
    }
    if (vars.present) {
      map['vars'] = Variable<String>(vars.value);
    }
    if (outOfScope.present) {
      map['out_of_scope'] = Variable<String>(outOfScope.value);
    }
    if (unlocked.present) {
      map['unlocked'] = Variable<bool>(unlocked.value);
    }
    if (history.present) {
      map['history'] = Variable<String>(history.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
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
    return (StringBuffer('ContractsCompanion(')
          ..write('rev: $rev, ')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('number: $number, ')
          ..write('series: $series, ')
          ..write('year: $year, ')
          ..write('seq: $seq, ')
          ..write('amendmentNo: $amendmentNo, ')
          ..write('parentId: $parentId, ')
          ..write('kind: $kind, ')
          ..write('templateName: $templateName, ')
          ..write('title: $title, ')
          ..write('projectName: $projectName, ')
          ..write('projectSummary: $projectSummary, ')
          ..write('preamble: $preamble, ')
          ..write('closing: $closing, ')
          ..write('issueDate: $issueDate, ')
          ..write('startDate: $startDate, ')
          ..write('signedDate: $signedDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('jurisdiction: $jurisdiction, ')
          ..write('currency: $currency, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('vars: $vars, ')
          ..write('outOfScope: $outOfScope, ')
          ..write('unlocked: $unlocked, ')
          ..write('history: $history, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDemo: $isDemo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContractClausesTable extends ContractClauses
    with TableInfo<$ContractClausesTable, ContractClauseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContractClausesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contractIdMeta = const VerificationMeta(
    'contractId',
  );
  @override
  late final GeneratedColumn<String> contractId = GeneratedColumn<String>(
    'contract_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contracts (id) ON DELETE CASCADE',
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _optionalMeta = const VerificationMeta(
    'optional',
  );
  @override
  late final GeneratedColumn<bool> optional = GeneratedColumn<bool>(
    'optional',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("optional" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fromLibraryClauseIdMeta =
      const VerificationMeta('fromLibraryClauseId');
  @override
  late final GeneratedColumn<String> fromLibraryClauseId =
      GeneratedColumn<String>(
        'from_library_clause_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    rev,
    updatedAt,
    deletedAt,
    id,
    contractId,
    position,
    title,
    body,
    enabled,
    optional,
    fromLibraryClauseId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contract_clauses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContractClauseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('contract_id')) {
      context.handle(
        _contractIdMeta,
        contractId.isAcceptableOrUnknown(data['contract_id']!, _contractIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contractIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('optional')) {
      context.handle(
        _optionalMeta,
        optional.isAcceptableOrUnknown(data['optional']!, _optionalMeta),
      );
    }
    if (data.containsKey('from_library_clause_id')) {
      context.handle(
        _fromLibraryClauseIdMeta,
        fromLibraryClauseId.isAcceptableOrUnknown(
          data['from_library_clause_id']!,
          _fromLibraryClauseIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContractClauseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContractClauseRow(
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      contractId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contract_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      optional: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}optional'],
      )!,
      fromLibraryClauseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_library_clause_id'],
      ),
    );
  }

  @override
  $ContractClausesTable createAlias(String alias) {
    return $ContractClausesTable(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
}

class ContractClauseRow extends DataClass
    implements Insertable<ContractClauseRow> {
  final int rev;

  /// UTC epoch ms of the last write; 0 for rows from before v4 until the
  /// migration backfills it.
  final int updatedAt;

  /// Tombstone: hidden everywhere, purged after 30 days.
  final int? deletedAt;
  final String id;
  final String contractId;
  final int position;
  final String title;
  final String body;
  final bool enabled;
  final bool optional;

  /// Not a foreign key: the library may change or lose the clause, the
  /// contract keeps its snapshot.
  final String? fromLibraryClauseId;
  const ContractClauseRow({
    required this.rev,
    required this.updatedAt,
    this.deletedAt,
    required this.id,
    required this.contractId,
    required this.position,
    required this.title,
    required this.body,
    required this.enabled,
    required this.optional,
    this.fromLibraryClauseId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rev'] = Variable<int>(rev);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['id'] = Variable<String>(id);
    map['contract_id'] = Variable<String>(contractId);
    map['position'] = Variable<int>(position);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['enabled'] = Variable<bool>(enabled);
    map['optional'] = Variable<bool>(optional);
    if (!nullToAbsent || fromLibraryClauseId != null) {
      map['from_library_clause_id'] = Variable<String>(fromLibraryClauseId);
    }
    return map;
  }

  ContractClausesCompanion toCompanion(bool nullToAbsent) {
    return ContractClausesCompanion(
      rev: Value(rev),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      id: Value(id),
      contractId: Value(contractId),
      position: Value(position),
      title: Value(title),
      body: Value(body),
      enabled: Value(enabled),
      optional: Value(optional),
      fromLibraryClauseId: fromLibraryClauseId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromLibraryClauseId),
    );
  }

  factory ContractClauseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContractClauseRow(
      rev: serializer.fromJson<int>(json['rev']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      id: serializer.fromJson<String>(json['id']),
      contractId: serializer.fromJson<String>(json['contractId']),
      position: serializer.fromJson<int>(json['position']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      optional: serializer.fromJson<bool>(json['optional']),
      fromLibraryClauseId: serializer.fromJson<String?>(
        json['fromLibraryClauseId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rev': serializer.toJson<int>(rev),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'id': serializer.toJson<String>(id),
      'contractId': serializer.toJson<String>(contractId),
      'position': serializer.toJson<int>(position),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'enabled': serializer.toJson<bool>(enabled),
      'optional': serializer.toJson<bool>(optional),
      'fromLibraryClauseId': serializer.toJson<String?>(fromLibraryClauseId),
    };
  }

  ContractClauseRow copyWith({
    int? rev,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? id,
    String? contractId,
    int? position,
    String? title,
    String? body,
    bool? enabled,
    bool? optional,
    Value<String?> fromLibraryClauseId = const Value.absent(),
  }) => ContractClauseRow(
    rev: rev ?? this.rev,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    id: id ?? this.id,
    contractId: contractId ?? this.contractId,
    position: position ?? this.position,
    title: title ?? this.title,
    body: body ?? this.body,
    enabled: enabled ?? this.enabled,
    optional: optional ?? this.optional,
    fromLibraryClauseId: fromLibraryClauseId.present
        ? fromLibraryClauseId.value
        : this.fromLibraryClauseId,
  );
  ContractClauseRow copyWithCompanion(ContractClausesCompanion data) {
    return ContractClauseRow(
      rev: data.rev.present ? data.rev.value : this.rev,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      id: data.id.present ? data.id.value : this.id,
      contractId: data.contractId.present
          ? data.contractId.value
          : this.contractId,
      position: data.position.present ? data.position.value : this.position,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      optional: data.optional.present ? data.optional.value : this.optional,
      fromLibraryClauseId: data.fromLibraryClauseId.present
          ? data.fromLibraryClauseId.value
          : this.fromLibraryClauseId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContractClauseRow(')
          ..write('rev: $rev, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('id: $id, ')
          ..write('contractId: $contractId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('enabled: $enabled, ')
          ..write('optional: $optional, ')
          ..write('fromLibraryClauseId: $fromLibraryClauseId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rev,
    updatedAt,
    deletedAt,
    id,
    contractId,
    position,
    title,
    body,
    enabled,
    optional,
    fromLibraryClauseId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContractClauseRow &&
          other.rev == this.rev &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.id == this.id &&
          other.contractId == this.contractId &&
          other.position == this.position &&
          other.title == this.title &&
          other.body == this.body &&
          other.enabled == this.enabled &&
          other.optional == this.optional &&
          other.fromLibraryClauseId == this.fromLibraryClauseId);
}

class ContractClausesCompanion extends UpdateCompanion<ContractClauseRow> {
  final Value<int> rev;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> id;
  final Value<String> contractId;
  final Value<int> position;
  final Value<String> title;
  final Value<String> body;
  final Value<bool> enabled;
  final Value<bool> optional;
  final Value<String?> fromLibraryClauseId;
  final Value<int> rowid;
  const ContractClausesCompanion({
    this.rev = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.contractId = const Value.absent(),
    this.position = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.enabled = const Value.absent(),
    this.optional = const Value.absent(),
    this.fromLibraryClauseId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContractClausesCompanion.insert({
    this.rev = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String id,
    required String contractId,
    required int position,
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.enabled = const Value.absent(),
    this.optional = const Value.absent(),
    this.fromLibraryClauseId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       contractId = Value(contractId),
       position = Value(position);
  static Insertable<ContractClauseRow> custom({
    Expression<int>? rev,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? id,
    Expression<String>? contractId,
    Expression<int>? position,
    Expression<String>? title,
    Expression<String>? body,
    Expression<bool>? enabled,
    Expression<bool>? optional,
    Expression<String>? fromLibraryClauseId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rev != null) 'rev': rev,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (id != null) 'id': id,
      if (contractId != null) 'contract_id': contractId,
      if (position != null) 'position': position,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (enabled != null) 'enabled': enabled,
      if (optional != null) 'optional': optional,
      if (fromLibraryClauseId != null)
        'from_library_clause_id': fromLibraryClauseId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContractClausesCompanion copyWith({
    Value<int>? rev,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? id,
    Value<String>? contractId,
    Value<int>? position,
    Value<String>? title,
    Value<String>? body,
    Value<bool>? enabled,
    Value<bool>? optional,
    Value<String?>? fromLibraryClauseId,
    Value<int>? rowid,
  }) {
    return ContractClausesCompanion(
      rev: rev ?? this.rev,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      id: id ?? this.id,
      contractId: contractId ?? this.contractId,
      position: position ?? this.position,
      title: title ?? this.title,
      body: body ?? this.body,
      enabled: enabled ?? this.enabled,
      optional: optional ?? this.optional,
      fromLibraryClauseId: fromLibraryClauseId ?? this.fromLibraryClauseId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (contractId.present) {
      map['contract_id'] = Variable<String>(contractId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (optional.present) {
      map['optional'] = Variable<bool>(optional.value);
    }
    if (fromLibraryClauseId.present) {
      map['from_library_clause_id'] = Variable<String>(
        fromLibraryClauseId.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContractClausesCompanion(')
          ..write('rev: $rev, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('id: $id, ')
          ..write('contractId: $contractId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('enabled: $enabled, ')
          ..write('optional: $optional, ')
          ..write('fromLibraryClauseId: $fromLibraryClauseId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScopeItemsTable extends ScopeItems
    with TableInfo<$ScopeItemsTable, ScopeItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScopeItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contractIdMeta = const VerificationMeta(
    'contractId',
  );
  @override
  late final GeneratedColumn<String> contractId = GeneratedColumn<String>(
    'contract_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contracts (id) ON DELETE CASCADE',
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
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _itemMeta = const VerificationMeta('item');
  @override
  late final GeneratedColumn<String> item = GeneratedColumn<String>(
    'item',
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
  static const VerificationMeta _acceptanceMeta = const VerificationMeta(
    'acceptance',
  );
  @override
  late final GeneratedColumn<String> acceptance = GeneratedColumn<String>(
    'acceptance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rev,
    updatedAt,
    deletedAt,
    id,
    contractId,
    position,
    phase,
    item,
    description,
    acceptance,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scope_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScopeItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('contract_id')) {
      context.handle(
        _contractIdMeta,
        contractId.isAcceptableOrUnknown(data['contract_id']!, _contractIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contractIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    }
    if (data.containsKey('item')) {
      context.handle(
        _itemMeta,
        item.isAcceptableOrUnknown(data['item']!, _itemMeta),
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
    if (data.containsKey('acceptance')) {
      context.handle(
        _acceptanceMeta,
        acceptance.isAcceptableOrUnknown(data['acceptance']!, _acceptanceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScopeItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScopeItemRow(
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      contractId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contract_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase'],
      )!,
      item: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      acceptance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}acceptance'],
      )!,
    );
  }

  @override
  $ScopeItemsTable createAlias(String alias) {
    return $ScopeItemsTable(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
}

class ScopeItemRow extends DataClass implements Insertable<ScopeItemRow> {
  final int rev;

  /// UTC epoch ms of the last write; 0 for rows from before v4 until the
  /// migration backfills it.
  final int updatedAt;

  /// Tombstone: hidden everywhere, purged after 30 days.
  final int? deletedAt;
  final String id;
  final String contractId;
  final int position;
  final String phase;
  final String item;
  final String description;
  final String acceptance;
  const ScopeItemRow({
    required this.rev,
    required this.updatedAt,
    this.deletedAt,
    required this.id,
    required this.contractId,
    required this.position,
    required this.phase,
    required this.item,
    required this.description,
    required this.acceptance,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rev'] = Variable<int>(rev);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['id'] = Variable<String>(id);
    map['contract_id'] = Variable<String>(contractId);
    map['position'] = Variable<int>(position);
    map['phase'] = Variable<String>(phase);
    map['item'] = Variable<String>(item);
    map['description'] = Variable<String>(description);
    map['acceptance'] = Variable<String>(acceptance);
    return map;
  }

  ScopeItemsCompanion toCompanion(bool nullToAbsent) {
    return ScopeItemsCompanion(
      rev: Value(rev),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      id: Value(id),
      contractId: Value(contractId),
      position: Value(position),
      phase: Value(phase),
      item: Value(item),
      description: Value(description),
      acceptance: Value(acceptance),
    );
  }

  factory ScopeItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScopeItemRow(
      rev: serializer.fromJson<int>(json['rev']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      id: serializer.fromJson<String>(json['id']),
      contractId: serializer.fromJson<String>(json['contractId']),
      position: serializer.fromJson<int>(json['position']),
      phase: serializer.fromJson<String>(json['phase']),
      item: serializer.fromJson<String>(json['item']),
      description: serializer.fromJson<String>(json['description']),
      acceptance: serializer.fromJson<String>(json['acceptance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rev': serializer.toJson<int>(rev),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'id': serializer.toJson<String>(id),
      'contractId': serializer.toJson<String>(contractId),
      'position': serializer.toJson<int>(position),
      'phase': serializer.toJson<String>(phase),
      'item': serializer.toJson<String>(item),
      'description': serializer.toJson<String>(description),
      'acceptance': serializer.toJson<String>(acceptance),
    };
  }

  ScopeItemRow copyWith({
    int? rev,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? id,
    String? contractId,
    int? position,
    String? phase,
    String? item,
    String? description,
    String? acceptance,
  }) => ScopeItemRow(
    rev: rev ?? this.rev,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    id: id ?? this.id,
    contractId: contractId ?? this.contractId,
    position: position ?? this.position,
    phase: phase ?? this.phase,
    item: item ?? this.item,
    description: description ?? this.description,
    acceptance: acceptance ?? this.acceptance,
  );
  ScopeItemRow copyWithCompanion(ScopeItemsCompanion data) {
    return ScopeItemRow(
      rev: data.rev.present ? data.rev.value : this.rev,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      id: data.id.present ? data.id.value : this.id,
      contractId: data.contractId.present
          ? data.contractId.value
          : this.contractId,
      position: data.position.present ? data.position.value : this.position,
      phase: data.phase.present ? data.phase.value : this.phase,
      item: data.item.present ? data.item.value : this.item,
      description: data.description.present
          ? data.description.value
          : this.description,
      acceptance: data.acceptance.present
          ? data.acceptance.value
          : this.acceptance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScopeItemRow(')
          ..write('rev: $rev, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('id: $id, ')
          ..write('contractId: $contractId, ')
          ..write('position: $position, ')
          ..write('phase: $phase, ')
          ..write('item: $item, ')
          ..write('description: $description, ')
          ..write('acceptance: $acceptance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rev,
    updatedAt,
    deletedAt,
    id,
    contractId,
    position,
    phase,
    item,
    description,
    acceptance,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScopeItemRow &&
          other.rev == this.rev &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.id == this.id &&
          other.contractId == this.contractId &&
          other.position == this.position &&
          other.phase == this.phase &&
          other.item == this.item &&
          other.description == this.description &&
          other.acceptance == this.acceptance);
}

class ScopeItemsCompanion extends UpdateCompanion<ScopeItemRow> {
  final Value<int> rev;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> id;
  final Value<String> contractId;
  final Value<int> position;
  final Value<String> phase;
  final Value<String> item;
  final Value<String> description;
  final Value<String> acceptance;
  final Value<int> rowid;
  const ScopeItemsCompanion({
    this.rev = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.contractId = const Value.absent(),
    this.position = const Value.absent(),
    this.phase = const Value.absent(),
    this.item = const Value.absent(),
    this.description = const Value.absent(),
    this.acceptance = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScopeItemsCompanion.insert({
    this.rev = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String id,
    required String contractId,
    required int position,
    this.phase = const Value.absent(),
    this.item = const Value.absent(),
    this.description = const Value.absent(),
    this.acceptance = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       contractId = Value(contractId),
       position = Value(position);
  static Insertable<ScopeItemRow> custom({
    Expression<int>? rev,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? id,
    Expression<String>? contractId,
    Expression<int>? position,
    Expression<String>? phase,
    Expression<String>? item,
    Expression<String>? description,
    Expression<String>? acceptance,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rev != null) 'rev': rev,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (id != null) 'id': id,
      if (contractId != null) 'contract_id': contractId,
      if (position != null) 'position': position,
      if (phase != null) 'phase': phase,
      if (item != null) 'item': item,
      if (description != null) 'description': description,
      if (acceptance != null) 'acceptance': acceptance,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScopeItemsCompanion copyWith({
    Value<int>? rev,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? id,
    Value<String>? contractId,
    Value<int>? position,
    Value<String>? phase,
    Value<String>? item,
    Value<String>? description,
    Value<String>? acceptance,
    Value<int>? rowid,
  }) {
    return ScopeItemsCompanion(
      rev: rev ?? this.rev,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      id: id ?? this.id,
      contractId: contractId ?? this.contractId,
      position: position ?? this.position,
      phase: phase ?? this.phase,
      item: item ?? this.item,
      description: description ?? this.description,
      acceptance: acceptance ?? this.acceptance,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (contractId.present) {
      map['contract_id'] = Variable<String>(contractId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (item.present) {
      map['item'] = Variable<String>(item.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (acceptance.present) {
      map['acceptance'] = Variable<String>(acceptance.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScopeItemsCompanion(')
          ..write('rev: $rev, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('id: $id, ')
          ..write('contractId: $contractId, ')
          ..write('position: $position, ')
          ..write('phase: $phase, ')
          ..write('item: $item, ')
          ..write('description: $description, ')
          ..write('acceptance: $acceptance, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentMilestonesTable extends PaymentMilestones
    with TableInfo<$PaymentMilestonesTable, MilestoneRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentMilestonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contractIdMeta = const VerificationMeta(
    'contractId',
  );
  @override
  late final GeneratedColumn<String> contractId = GeneratedColumn<String>(
    'contract_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contracts (id) ON DELETE CASCADE',
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _percentBpMeta = const VerificationMeta(
    'percentBp',
  );
  @override
  late final GeneratedColumn<int> percentBp = GeneratedColumn<int>(
    'percent_bp',
    aliasedName,
    true,
    check: () => ComparableExpr(percentBp).isBetweenValues(0, 10000),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    true,
    check: () => ComparableExpr(amountMinor).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _triggerMeta = const VerificationMeta(
    'trigger',
  );
  @override
  late final GeneratedColumn<String> trigger = GeneratedColumn<String>(
    'trigger',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
    'invoice_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rev,
    updatedAt,
    deletedAt,
    id,
    contractId,
    position,
    label,
    percentBp,
    amountMinor,
    trigger,
    dueDate,
    invoiceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_milestones';
  @override
  VerificationContext validateIntegrity(
    Insertable<MilestoneRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('contract_id')) {
      context.handle(
        _contractIdMeta,
        contractId.isAcceptableOrUnknown(data['contract_id']!, _contractIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contractIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('percent_bp')) {
      context.handle(
        _percentBpMeta,
        percentBp.isAcceptableOrUnknown(data['percent_bp']!, _percentBpMeta),
      );
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    }
    if (data.containsKey('trigger')) {
      context.handle(
        _triggerMeta,
        trigger.isAcceptableOrUnknown(data['trigger']!, _triggerMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MilestoneRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MilestoneRow(
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      contractId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contract_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      percentBp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}percent_bp'],
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      ),
      trigger: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      ),
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_id'],
      ),
    );
  }

  @override
  $PaymentMilestonesTable createAlias(String alias) {
    return $PaymentMilestonesTable(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
}

class MilestoneRow extends DataClass implements Insertable<MilestoneRow> {
  final int rev;

  /// UTC epoch ms of the last write; 0 for rows from before v4 until the
  /// migration backfills it.
  final int updatedAt;

  /// Tombstone: hidden everywhere, purged after 30 days.
  final int? deletedAt;
  final String id;
  final String contractId;
  final int position;
  final String label;
  final int? percentBp;
  final int? amountMinor;
  final String trigger;
  final String? dueDate;
  final String? invoiceId;
  const MilestoneRow({
    required this.rev,
    required this.updatedAt,
    this.deletedAt,
    required this.id,
    required this.contractId,
    required this.position,
    required this.label,
    this.percentBp,
    this.amountMinor,
    required this.trigger,
    this.dueDate,
    this.invoiceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rev'] = Variable<int>(rev);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['id'] = Variable<String>(id);
    map['contract_id'] = Variable<String>(contractId);
    map['position'] = Variable<int>(position);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || percentBp != null) {
      map['percent_bp'] = Variable<int>(percentBp);
    }
    if (!nullToAbsent || amountMinor != null) {
      map['amount_minor'] = Variable<int>(amountMinor);
    }
    map['trigger'] = Variable<String>(trigger);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    if (!nullToAbsent || invoiceId != null) {
      map['invoice_id'] = Variable<String>(invoiceId);
    }
    return map;
  }

  PaymentMilestonesCompanion toCompanion(bool nullToAbsent) {
    return PaymentMilestonesCompanion(
      rev: Value(rev),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      id: Value(id),
      contractId: Value(contractId),
      position: Value(position),
      label: Value(label),
      percentBp: percentBp == null && nullToAbsent
          ? const Value.absent()
          : Value(percentBp),
      amountMinor: amountMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(amountMinor),
      trigger: Value(trigger),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      invoiceId: invoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceId),
    );
  }

  factory MilestoneRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MilestoneRow(
      rev: serializer.fromJson<int>(json['rev']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      id: serializer.fromJson<String>(json['id']),
      contractId: serializer.fromJson<String>(json['contractId']),
      position: serializer.fromJson<int>(json['position']),
      label: serializer.fromJson<String>(json['label']),
      percentBp: serializer.fromJson<int?>(json['percentBp']),
      amountMinor: serializer.fromJson<int?>(json['amountMinor']),
      trigger: serializer.fromJson<String>(json['trigger']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      invoiceId: serializer.fromJson<String?>(json['invoiceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rev': serializer.toJson<int>(rev),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'id': serializer.toJson<String>(id),
      'contractId': serializer.toJson<String>(contractId),
      'position': serializer.toJson<int>(position),
      'label': serializer.toJson<String>(label),
      'percentBp': serializer.toJson<int?>(percentBp),
      'amountMinor': serializer.toJson<int?>(amountMinor),
      'trigger': serializer.toJson<String>(trigger),
      'dueDate': serializer.toJson<String?>(dueDate),
      'invoiceId': serializer.toJson<String?>(invoiceId),
    };
  }

  MilestoneRow copyWith({
    int? rev,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? id,
    String? contractId,
    int? position,
    String? label,
    Value<int?> percentBp = const Value.absent(),
    Value<int?> amountMinor = const Value.absent(),
    String? trigger,
    Value<String?> dueDate = const Value.absent(),
    Value<String?> invoiceId = const Value.absent(),
  }) => MilestoneRow(
    rev: rev ?? this.rev,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    id: id ?? this.id,
    contractId: contractId ?? this.contractId,
    position: position ?? this.position,
    label: label ?? this.label,
    percentBp: percentBp.present ? percentBp.value : this.percentBp,
    amountMinor: amountMinor.present ? amountMinor.value : this.amountMinor,
    trigger: trigger ?? this.trigger,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    invoiceId: invoiceId.present ? invoiceId.value : this.invoiceId,
  );
  MilestoneRow copyWithCompanion(PaymentMilestonesCompanion data) {
    return MilestoneRow(
      rev: data.rev.present ? data.rev.value : this.rev,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      id: data.id.present ? data.id.value : this.id,
      contractId: data.contractId.present
          ? data.contractId.value
          : this.contractId,
      position: data.position.present ? data.position.value : this.position,
      label: data.label.present ? data.label.value : this.label,
      percentBp: data.percentBp.present ? data.percentBp.value : this.percentBp,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      trigger: data.trigger.present ? data.trigger.value : this.trigger,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MilestoneRow(')
          ..write('rev: $rev, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('id: $id, ')
          ..write('contractId: $contractId, ')
          ..write('position: $position, ')
          ..write('label: $label, ')
          ..write('percentBp: $percentBp, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('trigger: $trigger, ')
          ..write('dueDate: $dueDate, ')
          ..write('invoiceId: $invoiceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rev,
    updatedAt,
    deletedAt,
    id,
    contractId,
    position,
    label,
    percentBp,
    amountMinor,
    trigger,
    dueDate,
    invoiceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MilestoneRow &&
          other.rev == this.rev &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.id == this.id &&
          other.contractId == this.contractId &&
          other.position == this.position &&
          other.label == this.label &&
          other.percentBp == this.percentBp &&
          other.amountMinor == this.amountMinor &&
          other.trigger == this.trigger &&
          other.dueDate == this.dueDate &&
          other.invoiceId == this.invoiceId);
}

class PaymentMilestonesCompanion extends UpdateCompanion<MilestoneRow> {
  final Value<int> rev;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> id;
  final Value<String> contractId;
  final Value<int> position;
  final Value<String> label;
  final Value<int?> percentBp;
  final Value<int?> amountMinor;
  final Value<String> trigger;
  final Value<String?> dueDate;
  final Value<String?> invoiceId;
  final Value<int> rowid;
  const PaymentMilestonesCompanion({
    this.rev = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.contractId = const Value.absent(),
    this.position = const Value.absent(),
    this.label = const Value.absent(),
    this.percentBp = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.trigger = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentMilestonesCompanion.insert({
    this.rev = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String id,
    required String contractId,
    required int position,
    this.label = const Value.absent(),
    this.percentBp = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.trigger = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       contractId = Value(contractId),
       position = Value(position);
  static Insertable<MilestoneRow> custom({
    Expression<int>? rev,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? id,
    Expression<String>? contractId,
    Expression<int>? position,
    Expression<String>? label,
    Expression<int>? percentBp,
    Expression<int>? amountMinor,
    Expression<String>? trigger,
    Expression<String>? dueDate,
    Expression<String>? invoiceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rev != null) 'rev': rev,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (id != null) 'id': id,
      if (contractId != null) 'contract_id': contractId,
      if (position != null) 'position': position,
      if (label != null) 'label': label,
      if (percentBp != null) 'percent_bp': percentBp,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (trigger != null) 'trigger': trigger,
      if (dueDate != null) 'due_date': dueDate,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentMilestonesCompanion copyWith({
    Value<int>? rev,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? id,
    Value<String>? contractId,
    Value<int>? position,
    Value<String>? label,
    Value<int?>? percentBp,
    Value<int?>? amountMinor,
    Value<String>? trigger,
    Value<String?>? dueDate,
    Value<String?>? invoiceId,
    Value<int>? rowid,
  }) {
    return PaymentMilestonesCompanion(
      rev: rev ?? this.rev,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      id: id ?? this.id,
      contractId: contractId ?? this.contractId,
      position: position ?? this.position,
      label: label ?? this.label,
      percentBp: percentBp ?? this.percentBp,
      amountMinor: amountMinor ?? this.amountMinor,
      trigger: trigger ?? this.trigger,
      dueDate: dueDate ?? this.dueDate,
      invoiceId: invoiceId ?? this.invoiceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (contractId.present) {
      map['contract_id'] = Variable<String>(contractId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (percentBp.present) {
      map['percent_bp'] = Variable<int>(percentBp.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (trigger.present) {
      map['trigger'] = Variable<String>(trigger.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMilestonesCompanion(')
          ..write('rev: $rev, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('id: $id, ')
          ..write('contractId: $contractId, ')
          ..write('position: $position, ')
          ..write('label: $label, ')
          ..write('percentBp: $percentBp, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('trigger: $trigger, ')
          ..write('dueDate: $dueDate, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostponementsTable extends Postponements
    with TableInfo<$PostponementsTable, PostponementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostponementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    check: () => entityType.isIn(const ['invoice', 'milestone']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromDateMeta = const VerificationMeta(
    'fromDate',
  );
  @override
  late final GeneratedColumn<String> fromDate = GeneratedColumn<String>(
    'from_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toDateMeta = const VerificationMeta('toDate');
  @override
  late final GeneratedColumn<String> toDate = GeneratedColumn<String>(
    'to_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
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
  @override
  List<GeneratedColumn> get $columns => [
    rev,
    id,
    entityType,
    entityId,
    fromDate,
    toDate,
    reason,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'postponements';
  @override
  VerificationContext validateIntegrity(
    Insertable<PostponementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('from_date')) {
      context.handle(
        _fromDateMeta,
        fromDate.isAcceptableOrUnknown(data['from_date']!, _fromDateMeta),
      );
    } else if (isInserting) {
      context.missing(_fromDateMeta);
    }
    if (data.containsKey('to_date')) {
      context.handle(
        _toDateMeta,
        toDate.isAcceptableOrUnknown(data['to_date']!, _toDateMeta),
      );
    } else if (isInserting) {
      context.missing(_toDateMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PostponementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostponementRow(
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      fromDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_date'],
      )!,
      toDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_date'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $PostponementsTable createAlias(String alias) {
    return $PostponementsTable(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
}

class PostponementRow extends DataClass implements Insertable<PostponementRow> {
  final int rev;
  final String id;
  final String entityType;

  /// Not a foreign key: one column, two tables.
  final String entityId;
  final String fromDate;
  final String toDate;
  final String reason;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const PostponementRow({
    required this.rev,
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rev'] = Variable<int>(rev);
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['from_date'] = Variable<String>(fromDate);
    map['to_date'] = Variable<String>(toDate);
    map['reason'] = Variable<String>(reason);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  PostponementsCompanion toCompanion(bool nullToAbsent) {
    return PostponementsCompanion(
      rev: Value(rev),
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      fromDate: Value(fromDate),
      toDate: Value(toDate),
      reason: Value(reason),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory PostponementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostponementRow(
      rev: serializer.fromJson<int>(json['rev']),
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      fromDate: serializer.fromJson<String>(json['fromDate']),
      toDate: serializer.fromJson<String>(json['toDate']),
      reason: serializer.fromJson<String>(json['reason']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rev': serializer.toJson<int>(rev),
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'fromDate': serializer.toJson<String>(fromDate),
      'toDate': serializer.toJson<String>(toDate),
      'reason': serializer.toJson<String>(reason),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  PostponementRow copyWith({
    int? rev,
    String? id,
    String? entityType,
    String? entityId,
    String? fromDate,
    String? toDate,
    String? reason,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
  }) => PostponementRow(
    rev: rev ?? this.rev,
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    fromDate: fromDate ?? this.fromDate,
    toDate: toDate ?? this.toDate,
    reason: reason ?? this.reason,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  PostponementRow copyWithCompanion(PostponementsCompanion data) {
    return PostponementRow(
      rev: data.rev.present ? data.rev.value : this.rev,
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      fromDate: data.fromDate.present ? data.fromDate.value : this.fromDate,
      toDate: data.toDate.present ? data.toDate.value : this.toDate,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostponementRow(')
          ..write('rev: $rev, ')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('fromDate: $fromDate, ')
          ..write('toDate: $toDate, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rev,
    id,
    entityType,
    entityId,
    fromDate,
    toDate,
    reason,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostponementRow &&
          other.rev == this.rev &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.fromDate == this.fromDate &&
          other.toDate == this.toDate &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class PostponementsCompanion extends UpdateCompanion<PostponementRow> {
  final Value<int> rev;
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> fromDate;
  final Value<String> toDate;
  final Value<String> reason;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const PostponementsCompanion({
    this.rev = const Value.absent(),
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.fromDate = const Value.absent(),
    this.toDate = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostponementsCompanion.insert({
    this.rev = const Value.absent(),
    required String id,
    required String entityType,
    required String entityId,
    required String fromDate,
    required String toDate,
    this.reason = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       fromDate = Value(fromDate),
       toDate = Value(toDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PostponementRow> custom({
    Expression<int>? rev,
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? fromDate,
    Expression<String>? toDate,
    Expression<String>? reason,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rev != null) 'rev': rev,
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (fromDate != null) 'from_date': fromDate,
      if (toDate != null) 'to_date': toDate,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostponementsCompanion copyWith({
    Value<int>? rev,
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? fromDate,
    Value<String>? toDate,
    Value<String>? reason,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return PostponementsCompanion(
      rev: rev ?? this.rev,
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (fromDate.present) {
      map['from_date'] = Variable<String>(fromDate.value);
    }
    if (toDate.present) {
      map['to_date'] = Variable<String>(toDate.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostponementsCompanion(')
          ..write('rev: $rev, ')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('fromDate: $fromDate, ')
          ..write('toDate: $toDate, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, ReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    check: () => ComparableExpr(
      StringExpressionOperators(body).trim().length,
    ).isBiggerThanValue(0),
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    true,
    check: () => entityType.isIn(const ['invoice', 'contract']),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<int> doneAt = GeneratedColumn<int>(
    'done_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
    'is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    rev,
    id,
    date,
    time,
    body,
    clientId,
    entityType,
    entityId,
    doneAt,
    deletedAt,
    isDemo,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    }
    if (data.containsKey('text')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['text']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_demo')) {
      context.handle(
        _isDemoMeta,
        isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta),
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
  ReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderRow(
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      ),
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      ),
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      ),
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}done_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      isDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo'],
      )!,
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
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
}

class ReminderRow extends DataClass implements Insertable<ReminderRow> {
  final int rev;
  final String id;
  final String date;

  /// `HH:MM`, 24-hour; null for an all-day reminder.
  final String? time;
  final String body;
  final String? clientId;

  /// `invoice` or `contract`, with [entityId]; both null when unlinked.
  final String? entityType;
  final String? entityId;
  final int? doneAt;
  final int? deletedAt;
  final bool isDemo;
  final int createdAt;
  final int updatedAt;
  const ReminderRow({
    required this.rev,
    required this.id,
    required this.date,
    this.time,
    required this.body,
    this.clientId,
    this.entityType,
    this.entityId,
    this.doneAt,
    this.deletedAt,
    required this.isDemo,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rev'] = Variable<int>(rev);
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<String>(time);
    }
    map['text'] = Variable<String>(body);
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<String>(clientId);
    }
    if (!nullToAbsent || entityType != null) {
      map['entity_type'] = Variable<String>(entityType);
    }
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    if (!nullToAbsent || doneAt != null) {
      map['done_at'] = Variable<int>(doneAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['is_demo'] = Variable<bool>(isDemo);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      rev: Value(rev),
      id: Value(id),
      date: Value(date),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      body: Value(body),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
      entityType: entityType == null && nullToAbsent
          ? const Value.absent()
          : Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      doneAt: doneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(doneAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDemo: Value(isDemo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderRow(
      rev: serializer.fromJson<int>(json['rev']),
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      time: serializer.fromJson<String?>(json['time']),
      body: serializer.fromJson<String>(json['body']),
      clientId: serializer.fromJson<String?>(json['clientId']),
      entityType: serializer.fromJson<String?>(json['entityType']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      doneAt: serializer.fromJson<int?>(json['doneAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      isDemo: serializer.fromJson<bool>(json['isDemo']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rev': serializer.toJson<int>(rev),
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'time': serializer.toJson<String?>(time),
      'body': serializer.toJson<String>(body),
      'clientId': serializer.toJson<String?>(clientId),
      'entityType': serializer.toJson<String?>(entityType),
      'entityId': serializer.toJson<String?>(entityId),
      'doneAt': serializer.toJson<int?>(doneAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'isDemo': serializer.toJson<bool>(isDemo),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ReminderRow copyWith({
    int? rev,
    String? id,
    String? date,
    Value<String?> time = const Value.absent(),
    String? body,
    Value<String?> clientId = const Value.absent(),
    Value<String?> entityType = const Value.absent(),
    Value<String?> entityId = const Value.absent(),
    Value<int?> doneAt = const Value.absent(),
    Value<int?> deletedAt = const Value.absent(),
    bool? isDemo,
    int? createdAt,
    int? updatedAt,
  }) => ReminderRow(
    rev: rev ?? this.rev,
    id: id ?? this.id,
    date: date ?? this.date,
    time: time.present ? time.value : this.time,
    body: body ?? this.body,
    clientId: clientId.present ? clientId.value : this.clientId,
    entityType: entityType.present ? entityType.value : this.entityType,
    entityId: entityId.present ? entityId.value : this.entityId,
    doneAt: doneAt.present ? doneAt.value : this.doneAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDemo: isDemo ?? this.isDemo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReminderRow copyWithCompanion(RemindersCompanion data) {
    return ReminderRow(
      rev: data.rev.present ? data.rev.value : this.rev,
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      time: data.time.present ? data.time.value : this.time,
      body: data.body.present ? data.body.value : this.body,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDemo: data.isDemo.present ? data.isDemo.value : this.isDemo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRow(')
          ..write('rev: $rev, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('body: $body, ')
          ..write('clientId: $clientId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('doneAt: $doneAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDemo: $isDemo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rev,
    id,
    date,
    time,
    body,
    clientId,
    entityType,
    entityId,
    doneAt,
    deletedAt,
    isDemo,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderRow &&
          other.rev == this.rev &&
          other.id == this.id &&
          other.date == this.date &&
          other.time == this.time &&
          other.body == this.body &&
          other.clientId == this.clientId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.doneAt == this.doneAt &&
          other.deletedAt == this.deletedAt &&
          other.isDemo == this.isDemo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RemindersCompanion extends UpdateCompanion<ReminderRow> {
  final Value<int> rev;
  final Value<String> id;
  final Value<String> date;
  final Value<String?> time;
  final Value<String> body;
  final Value<String?> clientId;
  final Value<String?> entityType;
  final Value<String?> entityId;
  final Value<int?> doneAt;
  final Value<int?> deletedAt;
  final Value<bool> isDemo;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const RemindersCompanion({
    this.rev = const Value.absent(),
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.body = const Value.absent(),
    this.clientId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDemo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.rev = const Value.absent(),
    required String id,
    required String date,
    this.time = const Value.absent(),
    required String body,
    this.clientId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDemo = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       body = Value(body),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ReminderRow> custom({
    Expression<int>? rev,
    Expression<String>? id,
    Expression<String>? date,
    Expression<String>? time,
    Expression<String>? body,
    Expression<String>? clientId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<int>? doneAt,
    Expression<int>? deletedAt,
    Expression<bool>? isDemo,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rev != null) 'rev': rev,
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (body != null) 'text': body,
      if (clientId != null) 'client_id': clientId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (doneAt != null) 'done_at': doneAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDemo != null) 'is_demo': isDemo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? rev,
    Value<String>? id,
    Value<String>? date,
    Value<String?>? time,
    Value<String>? body,
    Value<String?>? clientId,
    Value<String?>? entityType,
    Value<String?>? entityId,
    Value<int?>? doneAt,
    Value<int?>? deletedAt,
    Value<bool>? isDemo,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      rev: rev ?? this.rev,
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      body: body ?? this.body,
      clientId: clientId ?? this.clientId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      doneAt: doneAt ?? this.doneAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDemo: isDemo ?? this.isDemo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (body.present) {
      map['text'] = Variable<String>(body.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<int>(doneAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
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
    return (StringBuffer('RemindersCompanion(')
          ..write('rev: $rev, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('body: $body, ')
          ..write('clientId: $clientId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('doneAt: $doneAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDemo: $isDemo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  late final Trigger settingsSyncInsert = Trigger(
    'CREATE TRIGGER settings_sync_insert AFTER INSERT ON settings BEGIN UPDATE settings SET rev = NEW.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'settings\' AND row_id = CAST(NEW.id AS TEXT);INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'settings\', CAST(NEW.id AS TEXT), NEW.rev + 1, NEW.updated_at);END',
    'settings_sync_insert',
  );
  late final Trigger settingsSyncUpdate = Trigger(
    'CREATE TRIGGER settings_sync_update AFTER UPDATE ON settings WHEN NEW.rev = OLD.rev BEGIN UPDATE settings SET rev = OLD.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'settings\' AND row_id = CAST(NEW.id AS TEXT);INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'settings\', CAST(NEW.id AS TEXT), OLD.rev + 1, NEW.updated_at);END',
    'settings_sync_update',
  );
  late final $ClientsTable clients = $ClientsTable(this);
  late final Trigger clientsSyncInsert = Trigger(
    'CREATE TRIGGER clients_sync_insert AFTER INSERT ON clients BEGIN UPDATE clients SET rev = NEW.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'clients\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'clients\', NEW.id, NEW.rev + 1, NEW.updated_at);END',
    'clients_sync_insert',
  );
  late final Trigger clientsSyncUpdate = Trigger(
    'CREATE TRIGGER clients_sync_update AFTER UPDATE ON clients WHEN NEW.rev = OLD.rev BEGIN UPDATE clients SET rev = OLD.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'clients\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'clients\', NEW.id, OLD.rev + 1, NEW.updated_at);END',
    'clients_sync_update',
  );
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final Trigger invoicesSyncInsert = Trigger(
    'CREATE TRIGGER invoices_sync_insert AFTER INSERT ON invoices BEGIN UPDATE invoices SET rev = NEW.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'invoices\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'invoices\', NEW.id, NEW.rev + 1, NEW.updated_at);END',
    'invoices_sync_insert',
  );
  late final Trigger invoicesSyncUpdate = Trigger(
    'CREATE TRIGGER invoices_sync_update AFTER UPDATE ON invoices WHEN NEW.rev = OLD.rev BEGIN UPDATE invoices SET rev = OLD.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'invoices\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'invoices\', NEW.id, OLD.rev + 1, NEW.updated_at);END',
    'invoices_sync_update',
  );
  late final $SectionsTable sections = $SectionsTable(this);
  late final Trigger sectionsSyncInsert = Trigger(
    'CREATE TRIGGER sections_sync_insert AFTER INSERT ON sections BEGIN UPDATE sections SET rev = NEW.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'sections\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'sections\', NEW.id, NEW.rev + 1, NEW.updated_at);END',
    'sections_sync_insert',
  );
  late final Trigger sectionsSyncUpdate = Trigger(
    'CREATE TRIGGER sections_sync_update AFTER UPDATE ON sections WHEN NEW.rev = OLD.rev BEGIN UPDATE sections SET rev = OLD.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'sections\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'sections\', NEW.id, OLD.rev + 1, NEW.updated_at);END',
    'sections_sync_update',
  );
  late final $ItemsTable items = $ItemsTable(this);
  late final Trigger itemsSyncInsert = Trigger(
    'CREATE TRIGGER items_sync_insert AFTER INSERT ON items BEGIN UPDATE items SET rev = NEW.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'items\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'items\', NEW.id, NEW.rev + 1, NEW.updated_at);END',
    'items_sync_insert',
  );
  late final Trigger itemsSyncUpdate = Trigger(
    'CREATE TRIGGER items_sync_update AFTER UPDATE ON items WHEN NEW.rev = OLD.rev BEGIN UPDATE items SET rev = OLD.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'items\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'items\', NEW.id, OLD.rev + 1, NEW.updated_at);END',
    'items_sync_update',
  );
  late final $ClauseTemplatesTable clauseTemplates = $ClauseTemplatesTable(
    this,
  );
  late final Trigger clauseTemplatesSyncInsert = Trigger(
    'CREATE TRIGGER clause_templates_sync_insert AFTER INSERT ON clause_templates BEGIN UPDATE clause_templates SET rev = NEW.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'clause_templates\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'clause_templates\', NEW.id, NEW.rev + 1, NEW.updated_at);END',
    'clause_templates_sync_insert',
  );
  late final Trigger clauseTemplatesSyncUpdate = Trigger(
    'CREATE TRIGGER clause_templates_sync_update AFTER UPDATE ON clause_templates WHEN NEW.rev = OLD.rev BEGIN UPDATE clause_templates SET rev = OLD.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'clause_templates\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'clause_templates\', NEW.id, OLD.rev + 1, NEW.updated_at);END',
    'clause_templates_sync_update',
  );
  late final $LibraryClausesTable libraryClauses = $LibraryClausesTable(this);
  late final Trigger libraryClausesSyncInsert = Trigger(
    'CREATE TRIGGER library_clauses_sync_insert AFTER INSERT ON library_clauses BEGIN UPDATE library_clauses SET rev = NEW.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'library_clauses\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'library_clauses\', NEW.id, NEW.rev + 1, NEW.updated_at);END',
    'library_clauses_sync_insert',
  );
  late final Trigger libraryClausesSyncUpdate = Trigger(
    'CREATE TRIGGER library_clauses_sync_update AFTER UPDATE ON library_clauses WHEN NEW.rev = OLD.rev BEGIN UPDATE library_clauses SET rev = OLD.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'library_clauses\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'library_clauses\', NEW.id, OLD.rev + 1, NEW.updated_at);END',
    'library_clauses_sync_update',
  );
  late final $ContractsTable contracts = $ContractsTable(this);
  late final Trigger contractsSyncInsert = Trigger(
    'CREATE TRIGGER contracts_sync_insert AFTER INSERT ON contracts BEGIN UPDATE contracts SET rev = NEW.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'contracts\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'contracts\', NEW.id, NEW.rev + 1, NEW.updated_at);END',
    'contracts_sync_insert',
  );
  late final Trigger contractsSyncUpdate = Trigger(
    'CREATE TRIGGER contracts_sync_update AFTER UPDATE ON contracts WHEN NEW.rev = OLD.rev BEGIN UPDATE contracts SET rev = OLD.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'contracts\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'contracts\', NEW.id, OLD.rev + 1, NEW.updated_at);END',
    'contracts_sync_update',
  );
  late final $ContractClausesTable contractClauses = $ContractClausesTable(
    this,
  );
  late final Trigger contractClausesSyncInsert = Trigger(
    'CREATE TRIGGER contract_clauses_sync_insert AFTER INSERT ON contract_clauses BEGIN UPDATE contract_clauses SET rev = NEW.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'contract_clauses\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'contract_clauses\', NEW.id, NEW.rev + 1, NEW.updated_at);END',
    'contract_clauses_sync_insert',
  );
  late final Trigger contractClausesSyncUpdate = Trigger(
    'CREATE TRIGGER contract_clauses_sync_update AFTER UPDATE ON contract_clauses WHEN NEW.rev = OLD.rev BEGIN UPDATE contract_clauses SET rev = OLD.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'contract_clauses\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'contract_clauses\', NEW.id, OLD.rev + 1, NEW.updated_at);END',
    'contract_clauses_sync_update',
  );
  late final $ScopeItemsTable scopeItems = $ScopeItemsTable(this);
  late final Trigger scopeItemsSyncInsert = Trigger(
    'CREATE TRIGGER scope_items_sync_insert AFTER INSERT ON scope_items BEGIN UPDATE scope_items SET rev = NEW.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'scope_items\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'scope_items\', NEW.id, NEW.rev + 1, NEW.updated_at);END',
    'scope_items_sync_insert',
  );
  late final Trigger scopeItemsSyncUpdate = Trigger(
    'CREATE TRIGGER scope_items_sync_update AFTER UPDATE ON scope_items WHEN NEW.rev = OLD.rev BEGIN UPDATE scope_items SET rev = OLD.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'scope_items\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'scope_items\', NEW.id, OLD.rev + 1, NEW.updated_at);END',
    'scope_items_sync_update',
  );
  late final $PaymentMilestonesTable paymentMilestones =
      $PaymentMilestonesTable(this);
  late final Trigger paymentMilestonesSyncInsert = Trigger(
    'CREATE TRIGGER payment_milestones_sync_insert AFTER INSERT ON payment_milestones BEGIN UPDATE payment_milestones SET rev = NEW.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'payment_milestones\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'payment_milestones\', NEW.id, NEW.rev + 1, NEW.updated_at);END',
    'payment_milestones_sync_insert',
  );
  late final Trigger paymentMilestonesSyncUpdate = Trigger(
    'CREATE TRIGGER payment_milestones_sync_update AFTER UPDATE ON payment_milestones WHEN NEW.rev = OLD.rev BEGIN UPDATE payment_milestones SET rev = OLD.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'payment_milestones\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'payment_milestones\', NEW.id, OLD.rev + 1, NEW.updated_at);END',
    'payment_milestones_sync_update',
  );
  late final $PostponementsTable postponements = $PostponementsTable(this);
  late final Trigger postponementsSyncInsert = Trigger(
    'CREATE TRIGGER postponements_sync_insert AFTER INSERT ON postponements BEGIN UPDATE postponements SET rev = NEW.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'postponements\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'postponements\', NEW.id, NEW.rev + 1, NEW.updated_at);END',
    'postponements_sync_insert',
  );
  late final Trigger postponementsSyncUpdate = Trigger(
    'CREATE TRIGGER postponements_sync_update AFTER UPDATE ON postponements WHEN NEW.rev = OLD.rev BEGIN UPDATE postponements SET rev = OLD.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'postponements\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'postponements\', NEW.id, OLD.rev + 1, NEW.updated_at);END',
    'postponements_sync_update',
  );
  late final $RemindersTable reminders = $RemindersTable(this);
  late final Trigger remindersSyncInsert = Trigger(
    'CREATE TRIGGER reminders_sync_insert AFTER INSERT ON reminders BEGIN UPDATE reminders SET rev = NEW.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'reminders\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'reminders\', NEW.id, NEW.rev + 1, NEW.updated_at);END',
    'reminders_sync_insert',
  );
  late final Trigger remindersSyncUpdate = Trigger(
    'CREATE TRIGGER reminders_sync_update AFTER UPDATE ON reminders WHEN NEW.rev = OLD.rev BEGIN UPDATE reminders SET rev = OLD.rev + 1 WHERE id = NEW.id;DELETE FROM outbox WHERE entity = \'reminders\' AND row_id = NEW.id;INSERT INTO outbox (entity, row_id, rev, changed_at) VALUES (\'reminders\', NEW.id, OLD.rev + 1, NEW.updated_at);END',
    'reminders_sync_update',
  );
  late final Index invoicesClient = Index(
    'invoices_client',
    'CREATE INDEX invoices_client ON invoices (client_id)',
  );
  late final Index invoicesDue = Index(
    'invoices_due',
    'CREATE INDEX invoices_due ON invoices (due_date)',
  );
  late final Index invoicesPaid = Index(
    'invoices_paid',
    'CREATE INDEX invoices_paid ON invoices (paid_date)',
  );
  late final Index sectionsInvoice = Index(
    'sections_invoice',
    'CREATE INDEX sections_invoice ON sections (invoice_id)',
  );
  late final Index itemsSection = Index(
    'items_section',
    'CREATE INDEX items_section ON items (section_id)',
  );
  late final Index libraryClausesTemplate = Index(
    'library_clauses_template',
    'CREATE INDEX library_clauses_template ON library_clauses (template_id)',
  );
  late final Index contractsClient = Index(
    'contracts_client',
    'CREATE INDEX contracts_client ON contracts (client_id)',
  );
  late final Index contractsParent = Index(
    'contracts_parent',
    'CREATE INDEX contracts_parent ON contracts (parent_id)',
  );
  late final Index contractClausesContract = Index(
    'contract_clauses_contract',
    'CREATE INDEX contract_clauses_contract ON contract_clauses (contract_id)',
  );
  late final Index scopeItemsContract = Index(
    'scope_items_contract',
    'CREATE INDEX scope_items_contract ON scope_items (contract_id)',
  );
  late final Index milestonesContract = Index(
    'milestones_contract',
    'CREATE INDEX milestones_contract ON payment_milestones (contract_id)',
  );
  late final Index milestonesInvoice = Index(
    'milestones_invoice',
    'CREATE INDEX milestones_invoice ON payment_milestones (invoice_id)',
  );
  late final Index milestonesDue = Index(
    'milestones_due',
    'CREATE INDEX milestones_due ON payment_milestones (due_date)',
  );
  late final Index postponementsEntity = Index(
    'postponements_entity',
    'CREATE INDEX postponements_entity ON postponements (entity_id)',
  );
  late final Index remindersDate = Index(
    'reminders_date',
    'CREATE INDEX reminders_date ON reminders (date)',
  );
  late final Trigger clientsSoftDeleteGuard = Trigger(
    'CREATE TRIGGER clients_soft_delete_guard BEFORE UPDATE OF deleted_at ON clients WHEN NEW.deleted_at IS NOT NULL AND(EXISTS (SELECT 1 FROM invoices WHERE client_id = NEW.id AND deleted_at IS NULL) OR EXISTS (SELECT 1 FROM contracts WHERE client_id = NEW.id AND deleted_at IS NULL))BEGIN SELECT RAISE (ABORT, \'client has live documents\');END',
    'clients_soft_delete_guard',
  );
  late final Trigger invoicesReviveGuard = Trigger(
    'CREATE TRIGGER invoices_revive_guard BEFORE UPDATE OF deleted_at ON invoices WHEN NEW.deleted_at IS NULL AND EXISTS (SELECT 1 FROM clients WHERE id = NEW.client_id AND deleted_at IS NOT NULL) BEGIN SELECT RAISE (ABORT, \'client is deleted\');END',
    'invoices_revive_guard',
  );
  late final Trigger invoicesInsertGuard = Trigger(
    'CREATE TRIGGER invoices_insert_guard BEFORE INSERT ON invoices WHEN NEW.deleted_at IS NULL AND EXISTS (SELECT 1 FROM clients WHERE id = NEW.client_id AND deleted_at IS NOT NULL) BEGIN SELECT RAISE (ABORT, \'client is deleted\');END',
    'invoices_insert_guard',
  );
  late final Trigger contractsReviveGuard = Trigger(
    'CREATE TRIGGER contracts_revive_guard BEFORE UPDATE OF deleted_at ON contracts WHEN NEW.deleted_at IS NULL AND EXISTS (SELECT 1 FROM clients WHERE id = NEW.client_id AND deleted_at IS NOT NULL) BEGIN SELECT RAISE (ABORT, \'client is deleted\');END',
    'contracts_revive_guard',
  );
  late final Trigger contractsInsertGuard = Trigger(
    'CREATE TRIGGER contracts_insert_guard BEFORE INSERT ON contracts WHEN NEW.deleted_at IS NULL AND EXISTS (SELECT 1 FROM clients WHERE id = NEW.client_id AND deleted_at IS NOT NULL) BEGIN SELECT RAISE (ABORT, \'client is deleted\');END',
    'contracts_insert_guard',
  );
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final ClientsDao clientsDao = ClientsDao(this as AppDatabase);
  late final InvoicesDao invoicesDao = InvoicesDao(this as AppDatabase);
  late final LibraryDao libraryDao = LibraryDao(this as AppDatabase);
  late final ContractsDao contractsDao = ContractsDao(this as AppDatabase);
  late final CalendarDao calendarDao = CalendarDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettings,
    outbox,
    settingsSyncInsert,
    settingsSyncUpdate,
    clients,
    clientsSyncInsert,
    clientsSyncUpdate,
    invoices,
    invoicesSyncInsert,
    invoicesSyncUpdate,
    sections,
    sectionsSyncInsert,
    sectionsSyncUpdate,
    items,
    itemsSyncInsert,
    itemsSyncUpdate,
    clauseTemplates,
    clauseTemplatesSyncInsert,
    clauseTemplatesSyncUpdate,
    libraryClauses,
    libraryClausesSyncInsert,
    libraryClausesSyncUpdate,
    contracts,
    contractsSyncInsert,
    contractsSyncUpdate,
    contractClauses,
    contractClausesSyncInsert,
    contractClausesSyncUpdate,
    scopeItems,
    scopeItemsSyncInsert,
    scopeItemsSyncUpdate,
    paymentMilestones,
    paymentMilestonesSyncInsert,
    paymentMilestonesSyncUpdate,
    postponements,
    postponementsSyncInsert,
    postponementsSyncUpdate,
    reminders,
    remindersSyncInsert,
    remindersSyncUpdate,
    invoicesClient,
    invoicesDue,
    invoicesPaid,
    sectionsInvoice,
    itemsSection,
    libraryClausesTemplate,
    contractsClient,
    contractsParent,
    contractClausesContract,
    scopeItemsContract,
    milestonesContract,
    milestonesInvoice,
    milestonesDue,
    postponementsEntity,
    remindersDate,
    clientsSoftDeleteGuard,
    invoicesReviveGuard,
    invoicesInsertGuard,
    contractsReviveGuard,
    contractsInsertGuard,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'settings',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('settings', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'settings',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('settings', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clients',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('clients', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clients',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('clients', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'invoices',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('invoices', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'invoices',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('invoices', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
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
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('sections', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sections',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('sections', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('items', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('items', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clause_templates',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('clause_templates', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clause_templates',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('clause_templates', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clause_templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('library_clauses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'library_clauses',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('library_clauses', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'library_clauses',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('library_clauses', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contracts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('contracts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contracts',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('contracts', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contracts',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('contracts', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contracts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('contract_clauses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contract_clauses',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('contract_clauses', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contract_clauses',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('contract_clauses', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contracts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('scope_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'scope_items',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('scope_items', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'scope_items',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('scope_items', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contracts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('payment_milestones', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'invoices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('payment_milestones', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'payment_milestones',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('payment_milestones', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'payment_milestones',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('payment_milestones', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'postponements',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('postponements', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'postponements',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('postponements', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clients',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminders', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'reminders',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('reminders', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'reminders',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('reminders', kind: UpdateKind.update),
        TableUpdate('outbox', kind: UpdateKind.delete),
        TableUpdate('outbox', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clients',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'invoices',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'invoices',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contracts',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contracts',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
  ]);
}

typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> rev,
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
      Value<String> legalName,
      Value<String> nationalIdOrRegistry,
      Value<String> address,
      Value<String> contractPrefix,
      Value<String> quotePrefix,
      Value<String> defaultJurisdiction,
      Value<bool> contractWesternDigits,
      Value<String> deviceId,
      Value<int> updatedAt,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> rev,
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
      Value<String> legalName,
      Value<String> nationalIdOrRegistry,
      Value<String> address,
      Value<String> contractPrefix,
      Value<String> quotePrefix,
      Value<String> defaultJurisdiction,
      Value<bool> contractWesternDigits,
      Value<String> deviceId,
      Value<int> updatedAt,
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
  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

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

  ColumnFilters<String> get legalName => $composableBuilder(
    column: $table.legalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nationalIdOrRegistry => $composableBuilder(
    column: $table.nationalIdOrRegistry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contractPrefix => $composableBuilder(
    column: $table.contractPrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quotePrefix => $composableBuilder(
    column: $table.quotePrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultJurisdiction => $composableBuilder(
    column: $table.defaultJurisdiction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get contractWesternDigits => $composableBuilder(
    column: $table.contractWesternDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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
  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

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

  ColumnOrderings<String> get legalName => $composableBuilder(
    column: $table.legalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nationalIdOrRegistry => $composableBuilder(
    column: $table.nationalIdOrRegistry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contractPrefix => $composableBuilder(
    column: $table.contractPrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quotePrefix => $composableBuilder(
    column: $table.quotePrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultJurisdiction => $composableBuilder(
    column: $table.defaultJurisdiction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get contractWesternDigits => $composableBuilder(
    column: $table.contractWesternDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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
  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

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

  GeneratedColumn<String> get legalName =>
      $composableBuilder(column: $table.legalName, builder: (column) => column);

  GeneratedColumn<String> get nationalIdOrRegistry => $composableBuilder(
    column: $table.nationalIdOrRegistry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get contractPrefix => $composableBuilder(
    column: $table.contractPrefix,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quotePrefix => $composableBuilder(
    column: $table.quotePrefix,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultJurisdiction => $composableBuilder(
    column: $table.defaultJurisdiction,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get contractWesternDigits => $composableBuilder(
    column: $table.contractWesternDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
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
                Value<int> rev = const Value.absent(),
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
                Value<String> legalName = const Value.absent(),
                Value<String> nationalIdOrRegistry = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> contractPrefix = const Value.absent(),
                Value<String> quotePrefix = const Value.absent(),
                Value<String> defaultJurisdiction = const Value.absent(),
                Value<bool> contractWesternDigits = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => AppSettingsCompanion(
                rev: rev,
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
                legalName: legalName,
                nationalIdOrRegistry: nationalIdOrRegistry,
                address: address,
                contractPrefix: contractPrefix,
                quotePrefix: quotePrefix,
                defaultJurisdiction: defaultJurisdiction,
                contractWesternDigits: contractWesternDigits,
                deviceId: deviceId,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
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
                Value<String> legalName = const Value.absent(),
                Value<String> nationalIdOrRegistry = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> contractPrefix = const Value.absent(),
                Value<String> quotePrefix = const Value.absent(),
                Value<String> defaultJurisdiction = const Value.absent(),
                Value<bool> contractWesternDigits = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                rev: rev,
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
                legalName: legalName,
                nationalIdOrRegistry: nationalIdOrRegistry,
                address: address,
                contractPrefix: contractPrefix,
                quotePrefix: quotePrefix,
                defaultJurisdiction: defaultJurisdiction,
                contractWesternDigits: contractWesternDigits,
                deviceId: deviceId,
                updatedAt: updatedAt,
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
typedef $$OutboxTableCreateCompanionBuilder =
    OutboxCompanion Function({
      Value<int> id,
      required String entity,
      required String rowId,
      required int rev,
      required int changedAt,
    });
typedef $$OutboxTableUpdateCompanionBuilder =
    OutboxCompanion Function({
      Value<int> id,
      Value<String> entity,
      Value<String> rowId,
      Value<int> rev,
      Value<int> changedAt,
    });

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
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

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
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

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<int> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxRow,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (OutboxRow, BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>),
          OutboxRow,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> rowId = const Value.absent(),
                Value<int> rev = const Value.absent(),
                Value<int> changedAt = const Value.absent(),
              }) => OutboxCompanion(
                id: id,
                entity: entity,
                rowId: rowId,
                rev: rev,
                changedAt: changedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entity,
                required String rowId,
                required int rev,
                required int changedAt,
              }) => OutboxCompanion.insert(
                id: id,
                entity: entity,
                rowId: rowId,
                rev: rev,
                changedAt: changedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxTable, OutboxRow>(table),
                  BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>(
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

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxRow,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxRow, BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>),
      OutboxRow,
      PrefetchHooks Function()
    >;
typedef $$ClientsTableCreateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> rev,
      required String id,
      required String name,
      Value<String> contact,
      Value<String> city,
      Value<String> phone,
      Value<String> email,
      required int createdAt,
      required int updatedAt,
      Value<bool> archived,
      Value<int?> deletedAt,
      Value<String> legalName,
      Value<String> registryNo,
      Value<String> address,
      Value<String> representative,
      Value<String> representativeTitle,
      Value<bool> isDemo,
      Value<int> rowid,
    });
typedef $$ClientsTableUpdateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> rev,
      Value<String> id,
      Value<String> name,
      Value<String> contact,
      Value<String> city,
      Value<String> phone,
      Value<String> email,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> archived,
      Value<int?> deletedAt,
      Value<String> legalName,
      Value<String> registryNo,
      Value<String> address,
      Value<String> representative,
      Value<String> representativeTitle,
      Value<bool> isDemo,
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

  static MultiTypedResultKey<$ContractsTable, List<ContractRow>>
  _contractsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contracts,
    aliasName: 'clients__id__contracts__client_id',
  );

  $$ContractsTableProcessedTableManager get contractsRefs {
    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_contractsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<ReminderRow>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: 'clients__id__reminders__client_id',
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
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
  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

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

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get legalName => $composableBuilder(
    column: $table.legalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registryNo => $composableBuilder(
    column: $table.registryNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get representative => $composableBuilder(
    column: $table.representative,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get representativeTitle => $composableBuilder(
    column: $table.representativeTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
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

  Expression<bool> contractsRefs(
    Expression<bool> Function($$ContractsTableFilterComposer f) f,
  ) {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
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
  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

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

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get legalName => $composableBuilder(
    column: $table.legalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registryNo => $composableBuilder(
    column: $table.registryNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get representative => $composableBuilder(
    column: $table.representative,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get representativeTitle => $composableBuilder(
    column: $table.representativeTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
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
  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

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

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get legalName =>
      $composableBuilder(column: $table.legalName, builder: (column) => column);

  GeneratedColumn<String> get registryNo => $composableBuilder(
    column: $table.registryNo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get representative => $composableBuilder(
    column: $table.representative,
    builder: (column) => column,
  );

  GeneratedColumn<String> get representativeTitle => $composableBuilder(
    column: $table.representativeTitle,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDemo =>
      $composableBuilder(column: $table.isDemo, builder: (column) => column);

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

  Expression<T> contractsRefs<T extends Object>(
    Expression<T> Function($$ContractsTableAnnotationComposer a) f,
  ) {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
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
          PrefetchHooks Function({
            bool invoicesRefs,
            bool contractsRefs,
            bool remindersRefs,
          })
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
                Value<int> rev = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> contact = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> legalName = const Value.absent(),
                Value<String> registryNo = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> representative = const Value.absent(),
                Value<String> representativeTitle = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientsCompanion(
                rev: rev,
                id: id,
                name: name,
                contact: contact,
                city: city,
                phone: phone,
                email: email,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archived: archived,
                deletedAt: deletedAt,
                legalName: legalName,
                registryNo: registryNo,
                address: address,
                representative: representative,
                representativeTitle: representativeTitle,
                isDemo: isDemo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                required String id,
                required String name,
                Value<String> contact = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<bool> archived = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> legalName = const Value.absent(),
                Value<String> registryNo = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> representative = const Value.absent(),
                Value<String> representativeTitle = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientsCompanion.insert(
                rev: rev,
                id: id,
                name: name,
                contact: contact,
                city: city,
                phone: phone,
                email: email,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archived: archived,
                deletedAt: deletedAt,
                legalName: legalName,
                registryNo: registryNo,
                address: address,
                representative: representative,
                representativeTitle: representativeTitle,
                isDemo: isDemo,
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
          prefetchHooksCallback:
              ({
                invoicesRefs = false,
                contractsRefs = false,
                remindersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoicesRefs) db.invoices,
                    if (contractsRefs) db.contracts,
                    if (remindersRefs) db.reminders,
                  ],
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
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'client_id',
                          typedResults: items,
                        ),
                      if (contractsRefs)
                        await $_getPrefetchedDataByColumns<
                          ClientRow,
                          $ClientsTable,
                          ContractRow,
                          $ContractsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._contractsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).contractsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'client_id',
                          typedResults: items,
                        ),
                      if (remindersRefs)
                        await $_getPrefetchedDataByColumns<
                          ClientRow,
                          $ClientsTable,
                          ReminderRow,
                          $RemindersTable
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
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
      PrefetchHooks Function({
        bool invoicesRefs,
        bool contractsRefs,
        bool remindersRefs,
      })
    >;
typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> rev,
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
      Value<bool> isDemo,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> rev,
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
      Value<bool> isDemo,
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

  static MultiTypedResultKey<$PaymentMilestonesTable, List<MilestoneRow>>
  _paymentMilestonesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paymentMilestones,
        aliasName: 'invoices__id__payment_milestones__invoice_id',
      );

  $$PaymentMilestonesTableProcessedTableManager get paymentMilestonesRefs {
    final manager = $$PaymentMilestonesTableTableManager(
      $_db,
      $_db.paymentMilestones,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _paymentMilestonesRefsTable($_db),
    );
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
  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

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

  ColumnFilters<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
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

  Expression<bool> paymentMilestonesRefs(
    Expression<bool> Function($$PaymentMilestonesTableFilterComposer f) f,
  ) {
    final $$PaymentMilestonesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentMilestones,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMilestonesTableFilterComposer(
            $db: $db,
            $table: $db.paymentMilestones,
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
  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

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

  ColumnOrderings<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
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
  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

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

  GeneratedColumn<bool> get isDemo =>
      $composableBuilder(column: $table.isDemo, builder: (column) => column);

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

  Expression<T> paymentMilestonesRefs<T extends Object>(
    Expression<T> Function($$PaymentMilestonesTableAnnotationComposer a) f,
  ) {
    final $$PaymentMilestonesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.paymentMilestones,
          getReferencedColumn: (t) => t.invoiceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaymentMilestonesTableAnnotationComposer(
                $db: $db,
                $table: $db.paymentMilestones,
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
          PrefetchHooks Function({
            bool clientId,
            bool sectionsRefs,
            bool paymentMilestonesRefs,
          })
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
                Value<int> rev = const Value.absent(),
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
                Value<bool> isDemo = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion(
                rev: rev,
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
                isDemo: isDemo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
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
                Value<bool> isDemo = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion.insert(
                rev: rev,
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
                isDemo: isDemo,
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
          prefetchHooksCallback:
              ({
                clientId = false,
                sectionsRefs = false,
                paymentMilestonesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sectionsRefs) db.sections,
                    if (paymentMilestonesRefs) db.paymentMilestones,
                  ],
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
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).sectionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'invoice_id',
                          typedResults: items,
                        ),
                      if (paymentMilestonesRefs)
                        await $_getPrefetchedDataByColumns<
                          InvoiceRow,
                          $InvoicesTable,
                          MilestoneRow,
                          $PaymentMilestonesTable
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._paymentMilestonesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentMilestonesRefs,
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
      PrefetchHooks Function({
        bool clientId,
        bool sectionsRefs,
        bool paymentMilestonesRefs,
      })
    >;
typedef $$SectionsTableCreateCompanionBuilder =
    SectionsCompanion Function({
      Value<int> rev,
      Value<int> updatedAt,
      Value<int?> deletedAt,
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
      Value<int> rev,
      Value<int> updatedAt,
      Value<int?> deletedAt,
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
  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

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
  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

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
  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

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
                Value<int> rev = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> invoiceId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> titleEn = const Value.absent(),
                Value<String> titleAr = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SectionsCompanion(
                rev: rev,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
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
                Value<int> rev = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                required String id,
                required String invoiceId,
                required int position,
                Value<String> titleEn = const Value.absent(),
                Value<String> titleAr = const Value.absent(),
                required String currency,
                Value<int> rowid = const Value.absent(),
              }) => SectionsCompanion.insert(
                rev: rev,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
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
      Value<int> rev,
      Value<int> updatedAt,
      Value<int?> deletedAt,
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
      Value<int> rev,
      Value<int> updatedAt,
      Value<int?> deletedAt,
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
  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

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
  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

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
  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

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
                Value<int> rev = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
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
                rev: rev,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
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
                Value<int> rev = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
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
                rev: rev,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
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
typedef $$ClauseTemplatesTableCreateCompanionBuilder =
    ClauseTemplatesCompanion Function({
      Value<int> rev,
      required String id,
      required String name,
      required String kind,
      required int position,
      Value<bool> archived,
      Value<String> preamble,
      Value<String> closing,
      Value<String> varDefaults,
      Value<int?> deletedAt,
      Value<bool> isDemo,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ClauseTemplatesTableUpdateCompanionBuilder =
    ClauseTemplatesCompanion Function({
      Value<int> rev,
      Value<String> id,
      Value<String> name,
      Value<String> kind,
      Value<int> position,
      Value<bool> archived,
      Value<String> preamble,
      Value<String> closing,
      Value<String> varDefaults,
      Value<int?> deletedAt,
      Value<bool> isDemo,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$ClauseTemplatesTableReferences
    extends BaseReferences<_$AppDatabase, $ClauseTemplatesTable, TemplateRow> {
  $$ClauseTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$LibraryClausesTable, List<LibraryClauseRow>>
  _libraryClausesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.libraryClauses,
    aliasName: 'clause_templates__id__library_clauses__template_id',
  );

  $$LibraryClausesTableProcessedTableManager get libraryClausesRefs {
    final manager = $$LibraryClausesTableTableManager(
      $_db,
      $_db.libraryClauses,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_libraryClausesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClauseTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $ClauseTemplatesTable> {
  $$ClauseTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preamble => $composableBuilder(
    column: $table.preamble,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get closing => $composableBuilder(
    column: $table.closing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get varDefaults => $composableBuilder(
    column: $table.varDefaults,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
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

  Expression<bool> libraryClausesRefs(
    Expression<bool> Function($$LibraryClausesTableFilterComposer f) f,
  ) {
    final $$LibraryClausesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.libraryClauses,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryClausesTableFilterComposer(
            $db: $db,
            $table: $db.libraryClauses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClauseTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClauseTemplatesTable> {
  $$ClauseTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preamble => $composableBuilder(
    column: $table.preamble,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get closing => $composableBuilder(
    column: $table.closing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get varDefaults => $composableBuilder(
    column: $table.varDefaults,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
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
}

class $$ClauseTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClauseTemplatesTable> {
  $$ClauseTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<String> get preamble =>
      $composableBuilder(column: $table.preamble, builder: (column) => column);

  GeneratedColumn<String> get closing =>
      $composableBuilder(column: $table.closing, builder: (column) => column);

  GeneratedColumn<String> get varDefaults => $composableBuilder(
    column: $table.varDefaults,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDemo =>
      $composableBuilder(column: $table.isDemo, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> libraryClausesRefs<T extends Object>(
    Expression<T> Function($$LibraryClausesTableAnnotationComposer a) f,
  ) {
    final $$LibraryClausesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.libraryClauses,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryClausesTableAnnotationComposer(
            $db: $db,
            $table: $db.libraryClauses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClauseTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClauseTemplatesTable,
          TemplateRow,
          $$ClauseTemplatesTableFilterComposer,
          $$ClauseTemplatesTableOrderingComposer,
          $$ClauseTemplatesTableAnnotationComposer,
          $$ClauseTemplatesTableCreateCompanionBuilder,
          $$ClauseTemplatesTableUpdateCompanionBuilder,
          (TemplateRow, $$ClauseTemplatesTableReferences),
          TemplateRow,
          PrefetchHooks Function({bool libraryClausesRefs})
        > {
  $$ClauseTemplatesTableTableManager(
    _$AppDatabase db,
    $ClauseTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClauseTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClauseTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClauseTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<String> preamble = const Value.absent(),
                Value<String> closing = const Value.absent(),
                Value<String> varDefaults = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClauseTemplatesCompanion(
                rev: rev,
                id: id,
                name: name,
                kind: kind,
                position: position,
                archived: archived,
                preamble: preamble,
                closing: closing,
                varDefaults: varDefaults,
                deletedAt: deletedAt,
                isDemo: isDemo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                required String id,
                required String name,
                required String kind,
                required int position,
                Value<bool> archived = const Value.absent(),
                Value<String> preamble = const Value.absent(),
                Value<String> closing = const Value.absent(),
                Value<String> varDefaults = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ClauseTemplatesCompanion.insert(
                rev: rev,
                id: id,
                name: name,
                kind: kind,
                position: position,
                archived: archived,
                preamble: preamble,
                closing: closing,
                varDefaults: varDefaults,
                deletedAt: deletedAt,
                isDemo: isDemo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ClauseTemplatesTable, TemplateRow>(table),
                  $$ClauseTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({libraryClausesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (libraryClausesRefs) db.libraryClauses,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (libraryClausesRefs)
                    await $_getPrefetchedDataByColumns<
                      TemplateRow,
                      $ClauseTemplatesTable,
                      LibraryClauseRow,
                      $LibraryClausesTable
                    >(
                      currentTable: table,
                      referencedTable: $$ClauseTemplatesTableReferences
                          ._libraryClausesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ClauseTemplatesTableReferences(
                            db,
                            table,
                            p0,
                          ).libraryClausesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'template_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ClauseTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClauseTemplatesTable,
      TemplateRow,
      $$ClauseTemplatesTableFilterComposer,
      $$ClauseTemplatesTableOrderingComposer,
      $$ClauseTemplatesTableAnnotationComposer,
      $$ClauseTemplatesTableCreateCompanionBuilder,
      $$ClauseTemplatesTableUpdateCompanionBuilder,
      (TemplateRow, $$ClauseTemplatesTableReferences),
      TemplateRow,
      PrefetchHooks Function({bool libraryClausesRefs})
    >;
typedef $$LibraryClausesTableCreateCompanionBuilder =
    LibraryClausesCompanion Function({
      Value<int> rev,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      required String id,
      required String templateId,
      required int position,
      Value<String> title,
      Value<String> body,
      Value<bool> optional,
      Value<bool> enabledByDefault,
      Value<int> rowid,
    });
typedef $$LibraryClausesTableUpdateCompanionBuilder =
    LibraryClausesCompanion Function({
      Value<int> rev,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> id,
      Value<String> templateId,
      Value<int> position,
      Value<String> title,
      Value<String> body,
      Value<bool> optional,
      Value<bool> enabledByDefault,
      Value<int> rowid,
    });

final class $$LibraryClausesTableReferences
    extends
        BaseReferences<_$AppDatabase, $LibraryClausesTable, LibraryClauseRow> {
  $$LibraryClausesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ClauseTemplatesTable _templateIdTable(_$AppDatabase db) => db
      .clauseTemplates
      .createAlias('library_clauses__template_id__clause_templates__id');

  $$ClauseTemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<String>('template_id')!;

    final manager = $$ClauseTemplatesTableTableManager(
      $_db,
      $_db.clauseTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LibraryClausesTableFilterComposer
    extends Composer<_$AppDatabase, $LibraryClausesTable> {
  $$LibraryClausesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get optional => $composableBuilder(
    column: $table.optional,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabledByDefault => $composableBuilder(
    column: $table.enabledByDefault,
    builder: (column) => ColumnFilters(column),
  );

  $$ClauseTemplatesTableFilterComposer get templateId {
    final $$ClauseTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.clauseTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClauseTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.clauseTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LibraryClausesTableOrderingComposer
    extends Composer<_$AppDatabase, $LibraryClausesTable> {
  $$LibraryClausesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get optional => $composableBuilder(
    column: $table.optional,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabledByDefault => $composableBuilder(
    column: $table.enabledByDefault,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClauseTemplatesTableOrderingComposer get templateId {
    final $$ClauseTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.clauseTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClauseTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.clauseTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LibraryClausesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibraryClausesTable> {
  $$LibraryClausesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<bool> get optional =>
      $composableBuilder(column: $table.optional, builder: (column) => column);

  GeneratedColumn<bool> get enabledByDefault => $composableBuilder(
    column: $table.enabledByDefault,
    builder: (column) => column,
  );

  $$ClauseTemplatesTableAnnotationComposer get templateId {
    final $$ClauseTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.clauseTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClauseTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.clauseTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LibraryClausesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LibraryClausesTable,
          LibraryClauseRow,
          $$LibraryClausesTableFilterComposer,
          $$LibraryClausesTableOrderingComposer,
          $$LibraryClausesTableAnnotationComposer,
          $$LibraryClausesTableCreateCompanionBuilder,
          $$LibraryClausesTableUpdateCompanionBuilder,
          (LibraryClauseRow, $$LibraryClausesTableReferences),
          LibraryClauseRow,
          PrefetchHooks Function({bool templateId})
        > {
  $$LibraryClausesTableTableManager(
    _$AppDatabase db,
    $LibraryClausesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryClausesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryClausesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryClausesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> optional = const Value.absent(),
                Value<bool> enabledByDefault = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LibraryClausesCompanion(
                rev: rev,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                id: id,
                templateId: templateId,
                position: position,
                title: title,
                body: body,
                optional: optional,
                enabledByDefault: enabledByDefault,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                required String id,
                required String templateId,
                required int position,
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> optional = const Value.absent(),
                Value<bool> enabledByDefault = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LibraryClausesCompanion.insert(
                rev: rev,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                id: id,
                templateId: templateId,
                position: position,
                title: title,
                body: body,
                optional: optional,
                enabledByDefault: enabledByDefault,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LibraryClausesTable, LibraryClauseRow>(table),
                  $$LibraryClausesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateId = false}) {
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
                    if (templateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.templateId,
                                referencedTable: $$LibraryClausesTableReferences
                                    ._templateIdTable(db),
                                referencedColumn:
                                    $$LibraryClausesTableReferences
                                        ._templateIdTable(db)
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

typedef $$LibraryClausesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LibraryClausesTable,
      LibraryClauseRow,
      $$LibraryClausesTableFilterComposer,
      $$LibraryClausesTableOrderingComposer,
      $$LibraryClausesTableAnnotationComposer,
      $$LibraryClausesTableCreateCompanionBuilder,
      $$LibraryClausesTableUpdateCompanionBuilder,
      (LibraryClauseRow, $$LibraryClausesTableReferences),
      LibraryClauseRow,
      PrefetchHooks Function({bool templateId})
    >;
typedef $$ContractsTableCreateCompanionBuilder =
    ContractsCompanion Function({
      Value<int> rev,
      required String id,
      required String clientId,
      required String number,
      required String series,
      required int year,
      required int seq,
      Value<int> amendmentNo,
      Value<String?> parentId,
      required String kind,
      Value<String> templateName,
      Value<String> title,
      Value<String> projectName,
      Value<String> projectSummary,
      Value<String> preamble,
      Value<String> closing,
      required String issueDate,
      Value<String?> startDate,
      Value<String?> signedDate,
      Value<String?> endDate,
      required String status,
      Value<String> jurisdiction,
      required String currency,
      Value<int> totalMinor,
      Value<String> vars,
      Value<String> outOfScope,
      Value<bool> unlocked,
      Value<String> history,
      Value<int?> deletedAt,
      Value<bool> isDemo,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ContractsTableUpdateCompanionBuilder =
    ContractsCompanion Function({
      Value<int> rev,
      Value<String> id,
      Value<String> clientId,
      Value<String> number,
      Value<String> series,
      Value<int> year,
      Value<int> seq,
      Value<int> amendmentNo,
      Value<String?> parentId,
      Value<String> kind,
      Value<String> templateName,
      Value<String> title,
      Value<String> projectName,
      Value<String> projectSummary,
      Value<String> preamble,
      Value<String> closing,
      Value<String> issueDate,
      Value<String?> startDate,
      Value<String?> signedDate,
      Value<String?> endDate,
      Value<String> status,
      Value<String> jurisdiction,
      Value<String> currency,
      Value<int> totalMinor,
      Value<String> vars,
      Value<String> outOfScope,
      Value<bool> unlocked,
      Value<String> history,
      Value<int?> deletedAt,
      Value<bool> isDemo,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$ContractsTableReferences
    extends BaseReferences<_$AppDatabase, $ContractsTable, ContractRow> {
  $$ContractsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) =>
      db.clients.createAlias('contracts__client_id__clients__id');

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

  static $ContractsTable _parentIdTable(_$AppDatabase db) =>
      db.contracts.createAlias('contracts__parent_id__contracts__id');

  $$ContractsTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ContractClausesTable, List<ContractClauseRow>>
  _contractClausesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contractClauses,
    aliasName: 'contracts__id__contract_clauses__contract_id',
  );

  $$ContractClausesTableProcessedTableManager get contractClausesRefs {
    final manager = $$ContractClausesTableTableManager(
      $_db,
      $_db.contractClauses,
    ).filter((f) => f.contractId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _contractClausesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScopeItemsTable, List<ScopeItemRow>>
  _scopeItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.scopeItems,
    aliasName: 'contracts__id__scope_items__contract_id',
  );

  $$ScopeItemsTableProcessedTableManager get scopeItemsRefs {
    final manager = $$ScopeItemsTableTableManager(
      $_db,
      $_db.scopeItems,
    ).filter((f) => f.contractId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_scopeItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentMilestonesTable, List<MilestoneRow>>
  _paymentMilestonesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paymentMilestones,
        aliasName: 'contracts__id__payment_milestones__contract_id',
      );

  $$PaymentMilestonesTableProcessedTableManager get paymentMilestonesRefs {
    final manager = $$PaymentMilestonesTableTableManager(
      $_db,
      $_db.paymentMilestones,
    ).filter((f) => f.contractId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _paymentMilestonesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ContractsTableFilterComposer
    extends Composer<_$AppDatabase, $ContractsTable> {
  $$ContractsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get series => $composableBuilder(
    column: $table.series,
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

  ColumnFilters<int> get amendmentNo => $composableBuilder(
    column: $table.amendmentNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateName => $composableBuilder(
    column: $table.templateName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectSummary => $composableBuilder(
    column: $table.projectSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preamble => $composableBuilder(
    column: $table.preamble,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get closing => $composableBuilder(
    column: $table.closing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get issueDate => $composableBuilder(
    column: $table.issueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signedDate => $composableBuilder(
    column: $table.signedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jurisdiction => $composableBuilder(
    column: $table.jurisdiction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vars => $composableBuilder(
    column: $table.vars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outOfScope => $composableBuilder(
    column: $table.outOfScope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get unlocked => $composableBuilder(
    column: $table.unlocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get history => $composableBuilder(
    column: $table.history,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
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

  $$ContractsTableFilterComposer get parentId {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> contractClausesRefs(
    Expression<bool> Function($$ContractClausesTableFilterComposer f) f,
  ) {
    final $$ContractClausesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contractClauses,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractClausesTableFilterComposer(
            $db: $db,
            $table: $db.contractClauses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scopeItemsRefs(
    Expression<bool> Function($$ScopeItemsTableFilterComposer f) f,
  ) {
    final $$ScopeItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scopeItems,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScopeItemsTableFilterComposer(
            $db: $db,
            $table: $db.scopeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentMilestonesRefs(
    Expression<bool> Function($$PaymentMilestonesTableFilterComposer f) f,
  ) {
    final $$PaymentMilestonesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentMilestones,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMilestonesTableFilterComposer(
            $db: $db,
            $table: $db.paymentMilestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContractsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContractsTable> {
  $$ContractsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get series => $composableBuilder(
    column: $table.series,
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

  ColumnOrderings<int> get amendmentNo => $composableBuilder(
    column: $table.amendmentNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateName => $composableBuilder(
    column: $table.templateName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectSummary => $composableBuilder(
    column: $table.projectSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preamble => $composableBuilder(
    column: $table.preamble,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get closing => $composableBuilder(
    column: $table.closing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get issueDate => $composableBuilder(
    column: $table.issueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signedDate => $composableBuilder(
    column: $table.signedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jurisdiction => $composableBuilder(
    column: $table.jurisdiction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vars => $composableBuilder(
    column: $table.vars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outOfScope => $composableBuilder(
    column: $table.outOfScope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get unlocked => $composableBuilder(
    column: $table.unlocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get history => $composableBuilder(
    column: $table.history,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
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

  $$ContractsTableOrderingComposer get parentId {
    final $$ContractsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableOrderingComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContractsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContractsTable> {
  $$ContractsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get series =>
      $composableBuilder(column: $table.series, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<int> get amendmentNo => $composableBuilder(
    column: $table.amendmentNo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get templateName => $composableBuilder(
    column: $table.templateName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get projectSummary => $composableBuilder(
    column: $table.projectSummary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preamble =>
      $composableBuilder(column: $table.preamble, builder: (column) => column);

  GeneratedColumn<String> get closing =>
      $composableBuilder(column: $table.closing, builder: (column) => column);

  GeneratedColumn<String> get issueDate =>
      $composableBuilder(column: $table.issueDate, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get signedDate => $composableBuilder(
    column: $table.signedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get jurisdiction => $composableBuilder(
    column: $table.jurisdiction,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vars =>
      $composableBuilder(column: $table.vars, builder: (column) => column);

  GeneratedColumn<String> get outOfScope => $composableBuilder(
    column: $table.outOfScope,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get unlocked =>
      $composableBuilder(column: $table.unlocked, builder: (column) => column);

  GeneratedColumn<String> get history =>
      $composableBuilder(column: $table.history, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDemo =>
      $composableBuilder(column: $table.isDemo, builder: (column) => column);

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

  $$ContractsTableAnnotationComposer get parentId {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> contractClausesRefs<T extends Object>(
    Expression<T> Function($$ContractClausesTableAnnotationComposer a) f,
  ) {
    final $$ContractClausesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contractClauses,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractClausesTableAnnotationComposer(
            $db: $db,
            $table: $db.contractClauses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scopeItemsRefs<T extends Object>(
    Expression<T> Function($$ScopeItemsTableAnnotationComposer a) f,
  ) {
    final $$ScopeItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scopeItems,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScopeItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.scopeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentMilestonesRefs<T extends Object>(
    Expression<T> Function($$PaymentMilestonesTableAnnotationComposer a) f,
  ) {
    final $$PaymentMilestonesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.paymentMilestones,
          getReferencedColumn: (t) => t.contractId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaymentMilestonesTableAnnotationComposer(
                $db: $db,
                $table: $db.paymentMilestones,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ContractsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContractsTable,
          ContractRow,
          $$ContractsTableFilterComposer,
          $$ContractsTableOrderingComposer,
          $$ContractsTableAnnotationComposer,
          $$ContractsTableCreateCompanionBuilder,
          $$ContractsTableUpdateCompanionBuilder,
          (ContractRow, $$ContractsTableReferences),
          ContractRow,
          PrefetchHooks Function({
            bool clientId,
            bool parentId,
            bool contractClausesRefs,
            bool scopeItemsRefs,
            bool paymentMilestonesRefs,
          })
        > {
  $$ContractsTableTableManager(_$AppDatabase db, $ContractsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContractsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContractsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContractsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> number = const Value.absent(),
                Value<String> series = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<int> amendmentNo = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> templateName = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> projectName = const Value.absent(),
                Value<String> projectSummary = const Value.absent(),
                Value<String> preamble = const Value.absent(),
                Value<String> closing = const Value.absent(),
                Value<String> issueDate = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> signedDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> jurisdiction = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> totalMinor = const Value.absent(),
                Value<String> vars = const Value.absent(),
                Value<String> outOfScope = const Value.absent(),
                Value<bool> unlocked = const Value.absent(),
                Value<String> history = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContractsCompanion(
                rev: rev,
                id: id,
                clientId: clientId,
                number: number,
                series: series,
                year: year,
                seq: seq,
                amendmentNo: amendmentNo,
                parentId: parentId,
                kind: kind,
                templateName: templateName,
                title: title,
                projectName: projectName,
                projectSummary: projectSummary,
                preamble: preamble,
                closing: closing,
                issueDate: issueDate,
                startDate: startDate,
                signedDate: signedDate,
                endDate: endDate,
                status: status,
                jurisdiction: jurisdiction,
                currency: currency,
                totalMinor: totalMinor,
                vars: vars,
                outOfScope: outOfScope,
                unlocked: unlocked,
                history: history,
                deletedAt: deletedAt,
                isDemo: isDemo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                required String id,
                required String clientId,
                required String number,
                required String series,
                required int year,
                required int seq,
                Value<int> amendmentNo = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                required String kind,
                Value<String> templateName = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> projectName = const Value.absent(),
                Value<String> projectSummary = const Value.absent(),
                Value<String> preamble = const Value.absent(),
                Value<String> closing = const Value.absent(),
                required String issueDate,
                Value<String?> startDate = const Value.absent(),
                Value<String?> signedDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                required String status,
                Value<String> jurisdiction = const Value.absent(),
                required String currency,
                Value<int> totalMinor = const Value.absent(),
                Value<String> vars = const Value.absent(),
                Value<String> outOfScope = const Value.absent(),
                Value<bool> unlocked = const Value.absent(),
                Value<String> history = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ContractsCompanion.insert(
                rev: rev,
                id: id,
                clientId: clientId,
                number: number,
                series: series,
                year: year,
                seq: seq,
                amendmentNo: amendmentNo,
                parentId: parentId,
                kind: kind,
                templateName: templateName,
                title: title,
                projectName: projectName,
                projectSummary: projectSummary,
                preamble: preamble,
                closing: closing,
                issueDate: issueDate,
                startDate: startDate,
                signedDate: signedDate,
                endDate: endDate,
                status: status,
                jurisdiction: jurisdiction,
                currency: currency,
                totalMinor: totalMinor,
                vars: vars,
                outOfScope: outOfScope,
                unlocked: unlocked,
                history: history,
                deletedAt: deletedAt,
                isDemo: isDemo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContractsTable, ContractRow>(table),
                  $$ContractsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clientId = false,
                parentId = false,
                contractClausesRefs = false,
                scopeItemsRefs = false,
                paymentMilestonesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (contractClausesRefs) db.contractClauses,
                    if (scopeItemsRefs) db.scopeItems,
                    if (paymentMilestonesRefs) db.paymentMilestones,
                  ],
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
                                    referencedTable: $$ContractsTableReferences
                                        ._clientIdTable(db),
                                    referencedColumn: $$ContractsTableReferences
                                        ._clientIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (parentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentId,
                                    referencedTable: $$ContractsTableReferences
                                        ._parentIdTable(db),
                                    referencedColumn: $$ContractsTableReferences
                                        ._parentIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (contractClausesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContractRow,
                          $ContractsTable,
                          ContractClauseRow,
                          $ContractClausesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContractsTableReferences
                              ._contractClausesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContractsTableReferences(
                                db,
                                table,
                                p0,
                              ).contractClausesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'contract_id',
                          typedResults: items,
                        ),
                      if (scopeItemsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContractRow,
                          $ContractsTable,
                          ScopeItemRow,
                          $ScopeItemsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContractsTableReferences
                              ._scopeItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContractsTableReferences(
                                db,
                                table,
                                p0,
                              ).scopeItemsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'contract_id',
                          typedResults: items,
                        ),
                      if (paymentMilestonesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContractRow,
                          $ContractsTable,
                          MilestoneRow,
                          $PaymentMilestonesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContractsTableReferences
                              ._paymentMilestonesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContractsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentMilestonesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'contract_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ContractsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContractsTable,
      ContractRow,
      $$ContractsTableFilterComposer,
      $$ContractsTableOrderingComposer,
      $$ContractsTableAnnotationComposer,
      $$ContractsTableCreateCompanionBuilder,
      $$ContractsTableUpdateCompanionBuilder,
      (ContractRow, $$ContractsTableReferences),
      ContractRow,
      PrefetchHooks Function({
        bool clientId,
        bool parentId,
        bool contractClausesRefs,
        bool scopeItemsRefs,
        bool paymentMilestonesRefs,
      })
    >;
typedef $$ContractClausesTableCreateCompanionBuilder =
    ContractClausesCompanion Function({
      Value<int> rev,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      required String id,
      required String contractId,
      required int position,
      Value<String> title,
      Value<String> body,
      Value<bool> enabled,
      Value<bool> optional,
      Value<String?> fromLibraryClauseId,
      Value<int> rowid,
    });
typedef $$ContractClausesTableUpdateCompanionBuilder =
    ContractClausesCompanion Function({
      Value<int> rev,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> id,
      Value<String> contractId,
      Value<int> position,
      Value<String> title,
      Value<String> body,
      Value<bool> enabled,
      Value<bool> optional,
      Value<String?> fromLibraryClauseId,
      Value<int> rowid,
    });

final class $$ContractClausesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ContractClausesTable,
          ContractClauseRow
        > {
  $$ContractClausesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContractsTable _contractIdTable(_$AppDatabase db) =>
      db.contracts.createAlias('contract_clauses__contract_id__contracts__id');

  $$ContractsTableProcessedTableManager get contractId {
    final $_column = $_itemColumn<String>('contract_id')!;

    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contractIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContractClausesTableFilterComposer
    extends Composer<_$AppDatabase, $ContractClausesTable> {
  $$ContractClausesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get optional => $composableBuilder(
    column: $table.optional,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromLibraryClauseId => $composableBuilder(
    column: $table.fromLibraryClauseId,
    builder: (column) => ColumnFilters(column),
  );

  $$ContractsTableFilterComposer get contractId {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContractClausesTableOrderingComposer
    extends Composer<_$AppDatabase, $ContractClausesTable> {
  $$ContractClausesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get optional => $composableBuilder(
    column: $table.optional,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromLibraryClauseId => $composableBuilder(
    column: $table.fromLibraryClauseId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContractsTableOrderingComposer get contractId {
    final $$ContractsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableOrderingComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContractClausesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContractClausesTable> {
  $$ContractClausesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get optional =>
      $composableBuilder(column: $table.optional, builder: (column) => column);

  GeneratedColumn<String> get fromLibraryClauseId => $composableBuilder(
    column: $table.fromLibraryClauseId,
    builder: (column) => column,
  );

  $$ContractsTableAnnotationComposer get contractId {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContractClausesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContractClausesTable,
          ContractClauseRow,
          $$ContractClausesTableFilterComposer,
          $$ContractClausesTableOrderingComposer,
          $$ContractClausesTableAnnotationComposer,
          $$ContractClausesTableCreateCompanionBuilder,
          $$ContractClausesTableUpdateCompanionBuilder,
          (ContractClauseRow, $$ContractClausesTableReferences),
          ContractClauseRow,
          PrefetchHooks Function({bool contractId})
        > {
  $$ContractClausesTableTableManager(
    _$AppDatabase db,
    $ContractClausesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContractClausesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContractClausesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContractClausesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> contractId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> optional = const Value.absent(),
                Value<String?> fromLibraryClauseId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContractClausesCompanion(
                rev: rev,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                id: id,
                contractId: contractId,
                position: position,
                title: title,
                body: body,
                enabled: enabled,
                optional: optional,
                fromLibraryClauseId: fromLibraryClauseId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                required String id,
                required String contractId,
                required int position,
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> optional = const Value.absent(),
                Value<String?> fromLibraryClauseId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContractClausesCompanion.insert(
                rev: rev,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                id: id,
                contractId: contractId,
                position: position,
                title: title,
                body: body,
                enabled: enabled,
                optional: optional,
                fromLibraryClauseId: fromLibraryClauseId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContractClausesTable, ContractClauseRow>(table),
                  $$ContractClausesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contractId = false}) {
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
                    if (contractId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.contractId,
                                referencedTable:
                                    $$ContractClausesTableReferences
                                        ._contractIdTable(db),
                                referencedColumn:
                                    $$ContractClausesTableReferences
                                        ._contractIdTable(db)
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

typedef $$ContractClausesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContractClausesTable,
      ContractClauseRow,
      $$ContractClausesTableFilterComposer,
      $$ContractClausesTableOrderingComposer,
      $$ContractClausesTableAnnotationComposer,
      $$ContractClausesTableCreateCompanionBuilder,
      $$ContractClausesTableUpdateCompanionBuilder,
      (ContractClauseRow, $$ContractClausesTableReferences),
      ContractClauseRow,
      PrefetchHooks Function({bool contractId})
    >;
typedef $$ScopeItemsTableCreateCompanionBuilder =
    ScopeItemsCompanion Function({
      Value<int> rev,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      required String id,
      required String contractId,
      required int position,
      Value<String> phase,
      Value<String> item,
      Value<String> description,
      Value<String> acceptance,
      Value<int> rowid,
    });
typedef $$ScopeItemsTableUpdateCompanionBuilder =
    ScopeItemsCompanion Function({
      Value<int> rev,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> id,
      Value<String> contractId,
      Value<int> position,
      Value<String> phase,
      Value<String> item,
      Value<String> description,
      Value<String> acceptance,
      Value<int> rowid,
    });

final class $$ScopeItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ScopeItemsTable, ScopeItemRow> {
  $$ScopeItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContractsTable _contractIdTable(_$AppDatabase db) =>
      db.contracts.createAlias('scope_items__contract_id__contracts__id');

  $$ContractsTableProcessedTableManager get contractId {
    final $_column = $_itemColumn<String>('contract_id')!;

    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contractIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScopeItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ScopeItemsTable> {
  $$ScopeItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get item => $composableBuilder(
    column: $table.item,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get acceptance => $composableBuilder(
    column: $table.acceptance,
    builder: (column) => ColumnFilters(column),
  );

  $$ContractsTableFilterComposer get contractId {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScopeItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScopeItemsTable> {
  $$ScopeItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get item => $composableBuilder(
    column: $table.item,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get acceptance => $composableBuilder(
    column: $table.acceptance,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContractsTableOrderingComposer get contractId {
    final $$ContractsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableOrderingComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScopeItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScopeItemsTable> {
  $$ScopeItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<String> get item =>
      $composableBuilder(column: $table.item, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get acceptance => $composableBuilder(
    column: $table.acceptance,
    builder: (column) => column,
  );

  $$ContractsTableAnnotationComposer get contractId {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScopeItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScopeItemsTable,
          ScopeItemRow,
          $$ScopeItemsTableFilterComposer,
          $$ScopeItemsTableOrderingComposer,
          $$ScopeItemsTableAnnotationComposer,
          $$ScopeItemsTableCreateCompanionBuilder,
          $$ScopeItemsTableUpdateCompanionBuilder,
          (ScopeItemRow, $$ScopeItemsTableReferences),
          ScopeItemRow,
          PrefetchHooks Function({bool contractId})
        > {
  $$ScopeItemsTableTableManager(_$AppDatabase db, $ScopeItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScopeItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScopeItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScopeItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> contractId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> phase = const Value.absent(),
                Value<String> item = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> acceptance = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScopeItemsCompanion(
                rev: rev,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                id: id,
                contractId: contractId,
                position: position,
                phase: phase,
                item: item,
                description: description,
                acceptance: acceptance,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                required String id,
                required String contractId,
                required int position,
                Value<String> phase = const Value.absent(),
                Value<String> item = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> acceptance = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScopeItemsCompanion.insert(
                rev: rev,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                id: id,
                contractId: contractId,
                position: position,
                phase: phase,
                item: item,
                description: description,
                acceptance: acceptance,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScopeItemsTable, ScopeItemRow>(table),
                  $$ScopeItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contractId = false}) {
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
                    if (contractId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.contractId,
                                referencedTable: $$ScopeItemsTableReferences
                                    ._contractIdTable(db),
                                referencedColumn: $$ScopeItemsTableReferences
                                    ._contractIdTable(db)
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

typedef $$ScopeItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScopeItemsTable,
      ScopeItemRow,
      $$ScopeItemsTableFilterComposer,
      $$ScopeItemsTableOrderingComposer,
      $$ScopeItemsTableAnnotationComposer,
      $$ScopeItemsTableCreateCompanionBuilder,
      $$ScopeItemsTableUpdateCompanionBuilder,
      (ScopeItemRow, $$ScopeItemsTableReferences),
      ScopeItemRow,
      PrefetchHooks Function({bool contractId})
    >;
typedef $$PaymentMilestonesTableCreateCompanionBuilder =
    PaymentMilestonesCompanion Function({
      Value<int> rev,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      required String id,
      required String contractId,
      required int position,
      Value<String> label,
      Value<int?> percentBp,
      Value<int?> amountMinor,
      Value<String> trigger,
      Value<String?> dueDate,
      Value<String?> invoiceId,
      Value<int> rowid,
    });
typedef $$PaymentMilestonesTableUpdateCompanionBuilder =
    PaymentMilestonesCompanion Function({
      Value<int> rev,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> id,
      Value<String> contractId,
      Value<int> position,
      Value<String> label,
      Value<int?> percentBp,
      Value<int?> amountMinor,
      Value<String> trigger,
      Value<String?> dueDate,
      Value<String?> invoiceId,
      Value<int> rowid,
    });

final class $$PaymentMilestonesTableReferences
    extends
        BaseReferences<_$AppDatabase, $PaymentMilestonesTable, MilestoneRow> {
  $$PaymentMilestonesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContractsTable _contractIdTable(_$AppDatabase db) => db.contracts
      .createAlias('payment_milestones__contract_id__contracts__id');

  $$ContractsTableProcessedTableManager get contractId {
    final $_column = $_itemColumn<String>('contract_id')!;

    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contractIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias('payment_milestones__invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager? get invoiceId {
    final $_column = $_itemColumn<String>('invoice_id');
    if ($_column == null) return null;
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
}

class $$PaymentMilestonesTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentMilestonesTable> {
  $$PaymentMilestonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get percentBp => $composableBuilder(
    column: $table.percentBp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  $$ContractsTableFilterComposer get contractId {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$PaymentMilestonesTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentMilestonesTable> {
  $$PaymentMilestonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get percentBp => $composableBuilder(
    column: $table.percentBp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContractsTableOrderingComposer get contractId {
    final $$ContractsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableOrderingComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

class $$PaymentMilestonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentMilestonesTable> {
  $$PaymentMilestonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get percentBp =>
      $composableBuilder(column: $table.percentBp, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trigger =>
      $composableBuilder(column: $table.trigger, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  $$ContractsTableAnnotationComposer get contractId {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$PaymentMilestonesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentMilestonesTable,
          MilestoneRow,
          $$PaymentMilestonesTableFilterComposer,
          $$PaymentMilestonesTableOrderingComposer,
          $$PaymentMilestonesTableAnnotationComposer,
          $$PaymentMilestonesTableCreateCompanionBuilder,
          $$PaymentMilestonesTableUpdateCompanionBuilder,
          (MilestoneRow, $$PaymentMilestonesTableReferences),
          MilestoneRow,
          PrefetchHooks Function({bool contractId, bool invoiceId})
        > {
  $$PaymentMilestonesTableTableManager(
    _$AppDatabase db,
    $PaymentMilestonesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentMilestonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentMilestonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentMilestonesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> contractId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int?> percentBp = const Value.absent(),
                Value<int?> amountMinor = const Value.absent(),
                Value<String> trigger = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String?> invoiceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentMilestonesCompanion(
                rev: rev,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                id: id,
                contractId: contractId,
                position: position,
                label: label,
                percentBp: percentBp,
                amountMinor: amountMinor,
                trigger: trigger,
                dueDate: dueDate,
                invoiceId: invoiceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                required String id,
                required String contractId,
                required int position,
                Value<String> label = const Value.absent(),
                Value<int?> percentBp = const Value.absent(),
                Value<int?> amountMinor = const Value.absent(),
                Value<String> trigger = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String?> invoiceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentMilestonesCompanion.insert(
                rev: rev,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                id: id,
                contractId: contractId,
                position: position,
                label: label,
                percentBp: percentBp,
                amountMinor: amountMinor,
                trigger: trigger,
                dueDate: dueDate,
                invoiceId: invoiceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentMilestonesTable, MilestoneRow>(table),
                  $$PaymentMilestonesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contractId = false, invoiceId = false}) {
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
                    if (contractId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.contractId,
                                referencedTable:
                                    $$PaymentMilestonesTableReferences
                                        ._contractIdTable(db),
                                referencedColumn:
                                    $$PaymentMilestonesTableReferences
                                        ._contractIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (invoiceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.invoiceId,
                                referencedTable:
                                    $$PaymentMilestonesTableReferences
                                        ._invoiceIdTable(db),
                                referencedColumn:
                                    $$PaymentMilestonesTableReferences
                                        ._invoiceIdTable(db)
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

typedef $$PaymentMilestonesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentMilestonesTable,
      MilestoneRow,
      $$PaymentMilestonesTableFilterComposer,
      $$PaymentMilestonesTableOrderingComposer,
      $$PaymentMilestonesTableAnnotationComposer,
      $$PaymentMilestonesTableCreateCompanionBuilder,
      $$PaymentMilestonesTableUpdateCompanionBuilder,
      (MilestoneRow, $$PaymentMilestonesTableReferences),
      MilestoneRow,
      PrefetchHooks Function({bool contractId, bool invoiceId})
    >;
typedef $$PostponementsTableCreateCompanionBuilder =
    PostponementsCompanion Function({
      Value<int> rev,
      required String id,
      required String entityType,
      required String entityId,
      required String fromDate,
      required String toDate,
      Value<String> reason,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });
typedef $$PostponementsTableUpdateCompanionBuilder =
    PostponementsCompanion Function({
      Value<int> rev,
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> fromDate,
      Value<String> toDate,
      Value<String> reason,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });

class $$PostponementsTableFilterComposer
    extends Composer<_$AppDatabase, $PostponementsTable> {
  $$PostponementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromDate => $composableBuilder(
    column: $table.fromDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toDate => $composableBuilder(
    column: $table.toDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
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

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PostponementsTableOrderingComposer
    extends Composer<_$AppDatabase, $PostponementsTable> {
  $$PostponementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromDate => $composableBuilder(
    column: $table.fromDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toDate => $composableBuilder(
    column: $table.toDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
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

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PostponementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PostponementsTable> {
  $$PostponementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get fromDate =>
      $composableBuilder(column: $table.fromDate, builder: (column) => column);

  GeneratedColumn<String> get toDate =>
      $composableBuilder(column: $table.toDate, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$PostponementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PostponementsTable,
          PostponementRow,
          $$PostponementsTableFilterComposer,
          $$PostponementsTableOrderingComposer,
          $$PostponementsTableAnnotationComposer,
          $$PostponementsTableCreateCompanionBuilder,
          $$PostponementsTableUpdateCompanionBuilder,
          (
            PostponementRow,
            BaseReferences<_$AppDatabase, $PostponementsTable, PostponementRow>,
          ),
          PostponementRow,
          PrefetchHooks Function()
        > {
  $$PostponementsTableTableManager(_$AppDatabase db, $PostponementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostponementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostponementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostponementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> fromDate = const Value.absent(),
                Value<String> toDate = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostponementsCompanion(
                rev: rev,
                id: id,
                entityType: entityType,
                entityId: entityId,
                fromDate: fromDate,
                toDate: toDate,
                reason: reason,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                required String id,
                required String entityType,
                required String entityId,
                required String fromDate,
                required String toDate,
                Value<String> reason = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostponementsCompanion.insert(
                rev: rev,
                id: id,
                entityType: entityType,
                entityId: entityId,
                fromDate: fromDate,
                toDate: toDate,
                reason: reason,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PostponementsTable, PostponementRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PostponementsTable,
                    PostponementRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PostponementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PostponementsTable,
      PostponementRow,
      $$PostponementsTableFilterComposer,
      $$PostponementsTableOrderingComposer,
      $$PostponementsTableAnnotationComposer,
      $$PostponementsTableCreateCompanionBuilder,
      $$PostponementsTableUpdateCompanionBuilder,
      (
        PostponementRow,
        BaseReferences<_$AppDatabase, $PostponementsTable, PostponementRow>,
      ),
      PostponementRow,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> rev,
      required String id,
      required String date,
      Value<String?> time,
      required String body,
      Value<String?> clientId,
      Value<String?> entityType,
      Value<String?> entityId,
      Value<int?> doneAt,
      Value<int?> deletedAt,
      Value<bool> isDemo,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> rev,
      Value<String> id,
      Value<String> date,
      Value<String?> time,
      Value<String> body,
      Value<String?> clientId,
      Value<String?> entityType,
      Value<String?> entityId,
      Value<int?> doneAt,
      Value<int?> deletedAt,
      Value<bool> isDemo,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, ReminderRow> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) =>
      db.clients.createAlias('reminders__client_id__clients__id');

  $$ClientsTableProcessedTableManager? get clientId {
    final $_column = $_itemColumn<String>('client_id');
    if ($_column == null) return null;
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
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
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
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
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

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<int> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDemo =>
      $composableBuilder(column: $table.isDemo, builder: (column) => column);

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
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          ReminderRow,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (ReminderRow, $$RemindersTableReferences),
          ReminderRow,
          PrefetchHooks Function({bool clientId})
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String?> time = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
                Value<String?> entityType = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                Value<int?> doneAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                rev: rev,
                id: id,
                date: date,
                time: time,
                body: body,
                clientId: clientId,
                entityType: entityType,
                entityId: entityId,
                doneAt: doneAt,
                deletedAt: deletedAt,
                isDemo: isDemo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> rev = const Value.absent(),
                required String id,
                required String date,
                Value<String?> time = const Value.absent(),
                required String body,
                Value<String?> clientId = const Value.absent(),
                Value<String?> entityType = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                Value<int?> doneAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                rev: rev,
                id: id,
                date: date,
                time: time,
                body: body,
                clientId: clientId,
                entityType: entityType,
                entityId: entityId,
                doneAt: doneAt,
                deletedAt: deletedAt,
                isDemo: isDemo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTable, ReminderRow>(table),
                  $$RemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientId = false}) {
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
                    if (clientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.clientId,
                                referencedTable: $$RemindersTableReferences
                                    ._clientIdTable(db),
                                referencedColumn: $$RemindersTableReferences
                                    ._clientIdTable(db)
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

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      ReminderRow,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (ReminderRow, $$RemindersTableReferences),
      ReminderRow,
      PrefetchHooks Function({bool clientId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$SectionsTableTableManager get sections =>
      $$SectionsTableTableManager(_db, _db.sections);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$ClauseTemplatesTableTableManager get clauseTemplates =>
      $$ClauseTemplatesTableTableManager(_db, _db.clauseTemplates);
  $$LibraryClausesTableTableManager get libraryClauses =>
      $$LibraryClausesTableTableManager(_db, _db.libraryClauses);
  $$ContractsTableTableManager get contracts =>
      $$ContractsTableTableManager(_db, _db.contracts);
  $$ContractClausesTableTableManager get contractClauses =>
      $$ContractClausesTableTableManager(_db, _db.contractClauses);
  $$ScopeItemsTableTableManager get scopeItems =>
      $$ScopeItemsTableTableManager(_db, _db.scopeItems);
  $$PaymentMilestonesTableTableManager get paymentMilestones =>
      $$PaymentMilestonesTableTableManager(_db, _db.paymentMilestones);
  $$PostponementsTableTableManager get postponements =>
      $$PostponementsTableTableManager(_db, _db.postponements);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
}
