import 'package:flutter/foundation.dart';
// For listEquals in operator ==

@immutable
class Customer {
  final int id; // Changed from String to int
  final String? code; // New field
  final String name;
  final bool? gender; // New field (true: male, false: female)
  final DateTime? birthDate; // New field
  final String? contactNumber; // New field, assuming it's phone
  final String? address;
  final String? locationName; // New field
  final String? wardName; // New field
  final String? email; // New field
  final String? organization; // New field
  final String? comments; // New field
  final String? taxCode; // New field
  final int? retailerId; // New field
  final double? debt; // New field (decimal -> double)
  final double? totalInvoiced; // New field (decimal? -> double?)
  final double? totalPoint; // New field
  final double? totalRevenue; // New field (decimal? -> double?)
  final DateTime? modifiedDate; // New field
  final DateTime createdDate; // New field (required)
  final List<String>? groups; // New field (list of strings)
  final int? rewardPoint; // New field (long? -> int?)
  final String? psidFacebook; // New field (long? -> String? for large ID)

  const Customer({
    required this.id,
    this.code,
    required this.name,
    this.gender,
    this.birthDate,
    this.contactNumber,
    this.address,
    this.locationName,
    this.wardName,
    this.email,
    this.organization,
    this.comments,
    this.taxCode,
    this.retailerId,
    this.debt,
    this.totalInvoiced,
    this.totalPoint,
    this.totalRevenue,
    this.modifiedDate,
    required this.createdDate,
    this.groups,
    this.rewardPoint,
    this.psidFacebook,
  });

  // Factory constructor for deserialization from JSON
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as int,
      code: json['code'] as String?,
      name: json['name'] as String,
      gender: json['gender'] as bool?,
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'] as String)
          : null,
      contactNumber: json['contactNumber'] as String?,
      address: json['address'] as String?,
      locationName: json['locationName'] as String?,
      wardName: json['wardName'] as String?,
      email: json['email'] as String?,
      organization: json['organization'] as String?,
      comments: json['comments'] as String?,
      taxCode: json['taxCode'] as String?,
      retailerId: json['retailerId'] as int?,
      debt: (json['debt'] as num?)?.toDouble(), // num to double
      totalInvoiced: (json['totalInvoiced'] as num?)?.toDouble(),
      totalPoint: (json['totalPoint'] as num?)?.toDouble(),
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble(),
      modifiedDate: json['modifiedDate'] != null
          ? DateTime.parse(json['modifiedDate'] as String)
          : null,
      createdDate: DateTime.parse(json['createdDate'] as String),
      groups: (json['groups'] as List?)?.map((e) => e as String).toList(),
      rewardPoint: json['rewardPoint'] as int?,
      psidFacebook: json['psidFacebook']?.toString(), // Ensure it's string
    );
  }

  // Method for serialization to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
      'contactNumber': contactNumber,
      'address': address,
      'locationName': locationName,
      'wardName': wardName,
      'email': email,
      'organization': organization,
      'comments': comments,
      'taxCode': taxCode,
      'retailerId': retailerId,
      'debt': debt,
      'totalInvoiced': totalInvoiced,
      'totalPoint': totalPoint,
      'totalRevenue': totalRevenue,
      'modifiedDate': modifiedDate?.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'groups': groups,
      'rewardPoint': rewardPoint,
      'psidFacebook': psidFacebook,
    };
  }

  Customer copyWith({
    int? id,
    String? name,
    String? code,
    bool? gender,
    DateTime? birthDate,
    String? contactNumber,
    String? address,
    String? locationName,
    String? wardName,
    String? email,
    String? organization,
    String? comments,
    String? taxCode,
    int? retailerId,
    double? debt,
    double? totalInvoiced,
    double? totalPoint,
    double? totalRevenue,
    DateTime? modifiedDate,
    DateTime? createdDate,
    List<String>? groups,
    int? rewardPoint,
    String? psidFacebook,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      locationName: locationName ?? this.locationName,
      wardName: wardName ?? this.wardName,
      email: email ?? this.email,
      organization: organization ?? this.organization,
      comments: comments ?? this.comments,
      taxCode: taxCode ?? this.taxCode,
      retailerId: retailerId ?? this.retailerId,
      debt: debt ?? this.debt,
      totalInvoiced: totalInvoiced ?? this.totalInvoiced,
      totalPoint: totalPoint ?? this.totalPoint,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      createdDate: createdDate ?? this.createdDate,
      groups: groups ?? this.groups,
      rewardPoint: rewardPoint ?? this.rewardPoint,
      psidFacebook: psidFacebook ?? this.psidFacebook,
    );
  }

  @override
  String toString() {
    return 'Customer(id: $id, name: $name, contactNumber: $contactNumber, address: $address, code: $code, gender: $gender, birthDate: $birthDate, locationName: $locationName, wardName: $wardName, email: $email, organization: $organization, comments: $comments, taxCode: $taxCode, retailerId: $retailerId, debt: $debt, totalInvoiced: $totalInvoiced, totalPoint: $totalPoint, totalRevenue: $totalRevenue, modifiedDate: $modifiedDate, createdDate: $createdDate, groups: $groups, rewardPoint: $rewardPoint, psidFacebook: $psidFacebook)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Customer &&
        other.id == id && // Changed to int comparison
        other.code == code &&
        other.name == name &&
        other.gender == gender &&
        other.birthDate == birthDate &&
        other.contactNumber == contactNumber &&
        other.address == address &&
        other.locationName == locationName &&
        other.wardName == wardName &&
        other.email == email &&
        other.organization == organization &&
        other.comments == comments &&
        other.taxCode == taxCode &&
        other.retailerId == retailerId &&
        other.debt == debt &&
        other.totalInvoiced == totalInvoiced &&
        other.totalPoint == totalPoint &&
        other.totalRevenue == totalRevenue &&
        other.modifiedDate == modifiedDate &&
        other.createdDate == createdDate &&
        listEquals(other.groups, groups) && // Use listEquals for List comparison
        other.rewardPoint == rewardPoint &&
        other.psidFacebook == psidFacebook;
  }

  @override
  int get hashCode {
    // Combine hash codes of all fields
    return id.hashCode ^
        code.hashCode ^
        name.hashCode ^
        gender.hashCode ^
        birthDate.hashCode ^
        contactNumber.hashCode ^
        address.hashCode ^
        locationName.hashCode ^
        wardName.hashCode ^
        email.hashCode ^
        organization.hashCode ^
        comments.hashCode ^
        taxCode.hashCode ^
        retailerId.hashCode ^
        debt.hashCode ^
        totalInvoiced.hashCode ^
        totalPoint.hashCode ^
        totalRevenue.hashCode ^
        modifiedDate.hashCode ^
        createdDate.hashCode ^
        Object.hashAll(groups ?? []) ^ // Hash all elements in the list
        rewardPoint.hashCode ^
        psidFacebook.hashCode;
  }
}
