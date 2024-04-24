import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Model class for family member data
class FamilyMember {
  String firstName;
  String lastName;
  int age;
  String gender;

  FamilyMember({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
  });
}

class SelectedPackageProvider extends ChangeNotifier {
  Set<dynamic> _selectedPackages = {};
  Map<dynamic, double> _premiums = {};
  Map<dynamic, double> _benefits = {}; 

 
  Set<dynamic> get selectedPackages => _selectedPackages;
  Map<dynamic, double> get premiums => _premiums;
  Map<dynamic, double> get benefits => _benefits; 

 
  void addSelectedPackage(dynamic package) {
    _selectedPackages.add(package);
    _calculateTotalPremium();
    notifyListeners();
  }

 
  void removeSelectedPackage(dynamic package) {
    _selectedPackages.remove(package);
    _premiums.remove(package);
    _benefits.remove(package); 
    _calculateTotalPremium();
    notifyListeners(); 
  }

  
  void updateSelectedPackage(dynamic package, double newValue) {
    List<dynamic> benefitRanges = package['benefitRanges'];
    double premium = _calculatePremium(benefitRanges, newValue);
    _premiums[package] = premium;
    _benefits[package] = newValue; 
    _calculateTotalPremium();
    notifyListeners();
  }

  bool isSelected(dynamic package) {
    return _selectedPackages.contains(package);
  }

  
  double _calculatePremium(List<dynamic> ranges, double benefit) {
    if (ranges == null) {
      return 0.0; 
    }
    for (var range in ranges) {
      double minLimit = range['minLimit']?.toDouble() ?? 0.0;
      double maxLimit = range['maxLimit']?.toDouble() ?? 0.0;
      double rate = range['rate']?.toDouble() ?? null;
      if (minLimit != null && maxLimit != null && rate != null) {
        if (benefit >= minLimit && benefit <= maxLimit) {
          return benefit * rate / 100;
        }
      }
    }
    return 0.0; 
  }


  double _totalPremium = 0.0;
  double get totalPremium => _totalPremium;

  void _calculateTotalPremium() {
    _totalPremium = 0.0;
    _selectedPackages.forEach((package) {
      _totalPremium += _premiums[package] ?? 0.0;
    });
  }






  int _selectedFamilySize = 1;
  List<FamilyMember> _familyMembers = [];

  int get selectedFamilySize => _selectedFamilySize;

  set selectedFamilySize(int value) {
    _selectedFamilySize = value;
    notifyListeners();
  }

  List<FamilyMember> get familyMembers => _familyMembers;

  void addFamilyMember(FamilyMember member) {
    _familyMembers.add(member);
    notifyListeners();
  }
}



