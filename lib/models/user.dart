import 'dart:convert';
import 'blood_type.dart';

class User {
  String name;
  String lastName;
  DateTime dateOfBirth;
  BloodType bloodType;
  String allergens;
  String medicalConditions;
  String emergencyContactName;
  String emergencyContactPhone;
  String additionalNotes;

  User({
    required this.name,
    required this.lastName,
    required this.dateOfBirth,
    required this.bloodType,
    required this.allergens,
    required this.medicalConditions,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.additionalNotes,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'lastName': lastName,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'bloodType': bloodTypeToString(bloodType),
    'allergens': allergens,
    'medicalConditions': medicalConditions,
    'emergencyContactName': emergencyContactName,
    'emergencyContactPhone': emergencyContactPhone,
    'additionalNotes': additionalNotes,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'] ?? json['name'] ?? '',
    lastName: json['lastName'] ?? json['surname'] ?? '',
    dateOfBirth: DateTime.parse(json['dateOfBirth'] ?? json['dob'] ?? DateTime.now().toIso8601String()),
    bloodType: bloodTypeFromString(json['bloodType'] ?? 'O+'),
    allergens: json['allergens'] ?? json['allergies'] ?? '',
    medicalConditions: json['medicalConditions'] ?? json['conditions'] ?? '',
    emergencyContactName: json['emergencyContactName'] ?? json['contactName'] ?? '',
    emergencyContactPhone: json['emergencyContactPhone'] ?? json['contactPhone'] ?? '',
    additionalNotes: json['additionalNotes'] ?? json['notes'] ?? '',
  );

  // Utility: da codificare/decodificare a stringa univoca JSON
  String encode() => jsonEncode(toJson());

  static User decode(String userJson) => User.fromJson(jsonDecode(userJson));
}
