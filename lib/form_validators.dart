String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  
  return null;
}
 String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password';
  }
  if (value != password) {
    return 'Passwords do not match';
  }
  return null;
}
String? validateFirstName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter the first name';
  }
  return null;
}

String? validateLastName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter the last name';
  }
  return null;
}

String? validateAge(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter the age';
  }
  int age = int.tryParse(value) ?? 0;
  if (age <= 0) {
    return 'Please enter a valid age';
  }
  return null;
}

String? validateGender(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select the gender';
  }
  return null;
}
