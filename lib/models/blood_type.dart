enum BloodType {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative,
}

String bloodTypeToString(BloodType type) {
  switch (type) {
    case BloodType.aPositive: return "A+";
    case BloodType.aNegative: return "A-";
    case BloodType.bPositive: return "B+";
    case BloodType.bNegative: return "B-";
    case BloodType.abPositive: return "AB+";
    case BloodType.abNegative: return "AB-";
    case BloodType.oPositive: return "O+";
    case BloodType.oNegative: return "O-";
  }
}

BloodType bloodTypeFromString(String str) {
  switch (str) {
    case "A+": return BloodType.aPositive;
    case "A-": return BloodType.aNegative;
    case "B+": return BloodType.bPositive;
    case "B-": return BloodType.bNegative;
    case "AB+": return BloodType.abPositive;
    case "AB-": return BloodType.abNegative;
    case "O+": return BloodType.oPositive;
    case "O-": return BloodType.oNegative;
    default: return BloodType.oPositive;
  }
}
