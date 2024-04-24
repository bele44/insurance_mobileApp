import 'package:flutter/material.dart';
import 'benefit.dart';
import 'familymemberform.dart';

class FamilyRegistrationPage extends StatefulWidget {
  @override
  _FamilyRegistrationPageState createState() => _FamilyRegistrationPageState();
}

class _FamilyRegistrationPageState extends State<FamilyRegistrationPage> {
  int _selectedFamilySize = 1;
  int _familyMembersAdded = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Family Members'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      backgroundColor: Colors.lightBlue.shade400,
      body: Container( // Wrap the Stack with a Container
        color: Colors.lightBlue.shade200,
          child:Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.lightBlue.shade200,
                        Colors.lightBlue.shade400,
                      ],
                    ),
                  ),
                  child: CustomPaint(
                    size: Size(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height /
                            2),
                    painter: CurvePainter(),
                  ),
                ),
              ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Select Size of Family:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<int>(
                    value: _selectedFamilySize,
                    onChanged: (int? value) {
                      setState(() {
                        if (value != _selectedFamilySize) {
                          _selectedFamilySize = value!;
                          // Reset family members added count if the selected family size changes
                          _familyMembersAdded = 0;
                        }
                      });
                    },
                    items: <int>[1, 2, 3, 4, 5]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value'),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Register Family Members:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              FamilyMemberForm(
                familySize: _selectedFamilySize,
                onFamilyMemberAdded: () {
                  setState(() {
                    _familyMembersAdded++;
                    if (_familyMembersAdded == _selectedFamilySize) {
                      // If all family members added, navigate to new page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BenefitPage()),
                      );
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
            ],
          )
    ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.3,
        size.width * 0.4, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.6, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;
}
