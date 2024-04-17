import 'package:flutter/material.dart';
import 'selected_package_provider.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Consumer<SelectedPackageProvider>(
      builder: (context, provider, _) {
        print("Consuming SelectedPackageProvider...");
        
        double totalPremium = provider.totalPremium;

        List<dynamic> selectedPackages = provider.selectedPackages.toList();

        
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Summary Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            backgroundColor: Colors.blue, 
            elevation: 0, 
          ),
          backgroundColor: Colors
              .transparent, 
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Total Premium:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ' ${totalPremium.toStringAsFixed(2)} Birr',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Selected Packages:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedPackages.length,
                        itemBuilder: (context, index) {
                          final package = selectedPackages[index];
                          final premium = provider.premiums[package];
                          final benefit = provider.benefits[package];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                package['packageName'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    'Benefit:  ${benefit?.toStringAsFixed(2)} Birr',
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Premium:  ${premium?.toStringAsFixed(2)} Birr',
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
