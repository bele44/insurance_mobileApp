import 'package:flutter/material.dart';
import 'benefit.dart';
import 'signup.dart'; // Import the signup page file
import 'form_validators.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isHovered = false;
   bool _showPassword = false;

 

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Perform login/authentication
      String email = _emailController.text;
      String password = _passwordController.text;

      // For demonstration, let's print the email and password
      print('Email: $email');
      print('Password: $password');

      // Navigate to the benefit page after successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BenefitPage()),
      );
    }
  }

  void _goToSignUp() {
    // Navigate to the signup page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.transparent, 
      body: Stack(
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
                    size: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height / 2),
                    painter: CurvePainter(),
                  ),
                ),
              ),
       Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Please Log in To Get Medical Covers',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
             TextFormField(
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
    labelText: 'Email',
    prefixIcon: Icon(Icons.email),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2.0,
      ),
    ),
  ),
  validator: validateEmail,
),

              SizedBox(height: 20),
             TextFormField(
  controller: _passwordController,
  obscureText: !_showPassword,
  decoration: InputDecoration(
    labelText: 'Password',
    prefixIcon: Icon(Icons.lock),
    suffixIcon: IconButton(
      icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
      onPressed: () {
        setState(() {
          _showPassword = !_showPassword;
        });
      },
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2.0,
      ),
    ),
  ),
  validator: validatePassword,
),

              SizedBox(height: 20),
              MouseRegion(
                onEnter: (_) {
                  // Called when the mouse pointer enters the button area
                  setState(() {
                    isHovered = true;
                  });
                },
                onExit: (_) {
                  // Called when the mouse pointer exits the button area
                  setState(() {
                    isHovered = false;
                  });
                },
                child: SizedBox(
                  width: double.infinity, // Set the width to match the parent width
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      primary: isHovered ? Colors.blue.withOpacity(0.8) : Colors.blue, // Background color
                      onPrimary: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Button border radius
                      ),
                      elevation: 5, // Button shadow
                      shadowColor: Colors.black, // Shadow color
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _goToSignUp,
                child: Text(
                  'Don\'t have an account? Sign up here',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
            ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
  

  // Custom painter for drawing curves
class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.4,
        size.width * 0.4, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.7, size.width, size.height * 0.6);
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