part of '../models.dart';

@immutable
/// Someone invoices and contracts are for.
class Client {
  /// A client; ids are UUIDs, [name] is required.
  const Client({
    required this.id,
    required this.name,
    this.contact = '',
    this.city = '',
    this.phone = '',
    this.email = '',
    this.archived = false,
    this.legalName = '',
    this.registryNo = '',
    this.address = '',
    this.representative = '',
    this.representativeTitle = '',
    this.isDemo = false,
  });

  /// Stable UUID.
  final String id;

  /// Display name; never empty (CHECK constraint).
  final String name;

  /// Contact person, printed as "Attn:".
  final String contact;

  /// Printed under the name.
  final String city;

  /// Phone; searchable with any digits.
  final String phone;

  /// `{{client.email}}`.
  final String email;

  /// Hidden with its documents from the list, search and summary.
  final bool archived;

  /// Legal details used in contracts.
  final String legalName;

  /// سجل تجاري / رقم قومي.
  final String registryNo;

  /// `{{client.address}}`.
  final String address;

  /// Who signs for the client; `{{client.representative}}`.
  final String representative;

  /// Their title; `{{client.representativeTitle}}`.
  final String representativeTitle;

  /// Part of the demo set (cleared when the user saves the client).
  final bool isDemo;

  /// A copy with the given fields replaced (the id never changes).
  Client copyWith({
    String? name,
    String? contact,
    String? city,
    String? phone,
    String? email,
    bool? archived,
    String? legalName,
    String? registryNo,
    String? address,
    String? representative,
    String? representativeTitle,
    bool? isDemo,
  }) => Client(
    id: id,
    name: name ?? this.name,
    contact: contact ?? this.contact,
    city: city ?? this.city,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    archived: archived ?? this.archived,
    legalName: legalName ?? this.legalName,
    registryNo: registryNo ?? this.registryNo,
    address: address ?? this.address,
    representative: representative ?? this.representative,
    representativeTitle: representativeTitle ?? this.representativeTitle,
    isDemo: isDemo ?? this.isDemo,
  );

  @override
  bool operator ==(Object other) =>
      other is Client &&
      other.id == id &&
      other.name == name &&
      other.contact == contact &&
      other.city == city &&
      other.phone == phone &&
      other.email == email &&
      other.archived == archived &&
      other.legalName == legalName &&
      other.registryNo == registryNo &&
      other.address == address &&
      other.representative == representative &&
      other.representativeTitle == representativeTitle &&
      other.isDemo == isDemo;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    contact,
    city,
    phone,
    email,
    archived,
    legalName,
    registryNo,
    address,
    representative,
    representativeTitle,
    isDemo,
  );
}
