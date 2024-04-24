import 'form_validators.dart';
import 'package:flutter/material.dart';
import 'selected_package_provider.dart';
import 'package:provider/provider.dart';
class FamilyMemberForm extends StatefulWidget {
  final int familySize;
  final Function()? onFamilyMemberAdded;

  FamilyMemberForm({required this.familySize, this.onFamilyMemberAdded});

  @override
  _FamilyMemberFormState createState() => _FamilyMemberFormState();
}

class _FamilyMemberFormState extends State<FamilyMemberForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  String? _selectedGender;

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final newMember = FamilyMember(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        age: int.parse(_ageController.text),
        gender: _selectedGender!,
      );

      Provider.of<SelectedPackageProvider>(context, listen: false).addFamilyMember(newMember);

      _firstNameController.clear();
      _lastNameController.clear();
      _ageController.clear();
      setState(() {
        _selectedGender = null;
      });

      // Notify parent widget that a family member has been added
      widget.onFamilyMemberAdded?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(labelText: 'First Name'),
            validator:validateFirstName
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(labelText: 'Last Name'),
            validator: validateLastName
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Age'),
            validator: validateAge
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            onChanged: (String? value) {
              setState(() {
                _selectedGender = value;
              });
            },
            items: ['Male', 'Female', 'Other'].map((String gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(),
            ),
            validator: validateGender
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _submitForm(context),
            child: Text('Add '),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}