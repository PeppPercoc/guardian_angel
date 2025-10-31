import 'dart:convert';
import 'blood_type.dart';

class User {
  String name;
  String surname;
  DateTime dob;
  BloodType bloodType;
  String allergies;
  String conditions;
  String contactName;
  String contactPhone;
  String notes;

  User({
    required this.name,
    required this.surname,
    required this.dob,
    required this.bloodType,
    required this.allergies,
    required this.conditions,
    required this.contactName,
    required this.contactPhone,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'surname': surname,
    'dob': dob.toIso8601String(),
    'bloodType': bloodTypeToString(bloodType),
    'allergies': allergies,
    'conditions': conditions,
    'contactName': contactName,
    'contactPhone': contactPhone,
    'notes': notes,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'] ?? '',
    surname: json['surname'] ?? '',
    dob: DateTime.parse(json['dob']),
    bloodType: bloodTypeFromString(json['bloodType'] ?? 'O+'),
    allergies: json['allergies'] ?? '',
    conditions: json['conditions'] ?? '',
    contactName: json['contactName'] ?? '',
    contactPhone: json['contactPhone'] ?? '',
    notes: json['notes'] ?? '',
  );

  // Utility: da codificare/decodificare a stringa univoca JSON
  String encode() => jsonEncode(toJson());

  static User decode(String userJson) => User.fromJson(jsonDecode(userJson));
}
