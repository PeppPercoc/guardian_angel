import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_angel/models/user.dart';
import 'package:guardian_angel/models/blood_type.dart';

void main() {
  group('User Model Tests', () {
    test('User.encode() serializza correttamente i dati', () {
      // Arrange
      final user = User(
        name: 'Paolo',
        lastName: 'Rossi',
        dateOfBirth: DateTime(1990, 5, 15),
        bloodType: BloodType.oPositive,
        allergens: 'Nessuno',
        medicalConditions: 'Nessuno',
        emergencyContactName: 'Maria Rossi',
        emergencyContactPhone: '+39 3401234567',
        additionalNotes: 'Note di prova',
      );

      // Act
      final encoded = user.encode();

      // Assert
      expect(encoded, isNotEmpty);
      expect(encoded, contains('Paolo'));
      expect(encoded, contains('Rossi'));
      expect(encoded, contains('Maria Rossi'));
    });

    test('User.decode() deserializza correttamente i dati', () {
      // Arrange
      final user = User(
        name: 'Giovanni',
        lastName: 'Bianchi',
        dateOfBirth: DateTime(1985, 3, 20),
        bloodType: BloodType.aPositive,
        allergens: 'Penicillina',
        medicalConditions: 'Asma',
        emergencyContactName: 'Lucia Bianchi',
        emergencyContactPhone: '+39 3409876543',
        additionalNotes: 'Paziente critico',
      );
      final encoded = user.encode();

      // Act
      final decoded = User.decode(encoded);

      // Assert
      expect(decoded.name, equals('Giovanni'));
      expect(decoded.lastName, equals('Bianchi'));
      expect(decoded.allergens, equals('Penicillina'));
      expect(decoded.medicalConditions, equals('Asma'));
      expect(decoded.emergencyContactName, equals('Lucia Bianchi'));
      expect(decoded.emergencyContactPhone, equals('+39 3409876543'));
    });

    test('User encode-decode roundtrip mantiene i dati', () {
      // Arrange
      final originalUser = User(
        name: 'Alice',
        lastName: 'Verde',
        dateOfBirth: DateTime(2000, 12, 1),
        bloodType: BloodType.bPositive,
        allergens: 'Lattosio',
        medicalConditions: 'Allergia al nichel',
        emergencyContactName: 'Bob Verde',
        emergencyContactPhone: '+39 3201234567',
        additionalNotes: 'VIP - Attenzione speciale',
      );

      // Act
      final encoded = originalUser.encode();
      final decodedUser = User.decode(encoded);

      // Assert
      expect(decodedUser.name, equals(originalUser.name));
      expect(decodedUser.lastName, equals(originalUser.lastName));
      expect(decodedUser.bloodType, equals(originalUser.bloodType));
      expect(decodedUser.allergens, equals(originalUser.allergens));
      expect(decodedUser.emergencyContactPhone, 
          equals(originalUser.emergencyContactPhone));
    });

    test('bloodTypeToString converte correttamente', () {
      // Arrange & Act & Assert
      expect(bloodTypeToString(BloodType.oPositive), equals('O+'));
      expect(bloodTypeToString(BloodType.aPositive), equals('A+'));
      expect(bloodTypeToString(BloodType.bPositive), equals('B+'));
      expect(bloodTypeToString(BloodType.abPositive), equals('AB+'));
      expect(bloodTypeToString(BloodType.oNegative), equals('O-'));
    });

    test('bloodTypeFromString converte correttamente', () {
      // Arrange & Act & Assert
      expect(bloodTypeFromString('O+'), equals(BloodType.oPositive));
      expect(bloodTypeFromString('A+'), equals(BloodType.aPositive));
      expect(bloodTypeFromString('B-'), equals(BloodType.bNegative));
      expect(bloodTypeFromString('AB+'), equals(BloodType.abPositive));
    });
  });
}
