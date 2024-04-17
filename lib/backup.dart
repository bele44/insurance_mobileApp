// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'summary_page.dart';
// //import 'package:provider/provider.dart';
// import 'selected_package_model.dart';
// class SelectedPackageModel {
//   final String packageName;
//   final double benefit;
//   final double premium;

//   SelectedPackageModel(this.packageName, this.benefit, this.premium);

//   SelectedPackageModel updateValues({double? newBenefit, double? newPremium}) {
//     return SelectedPackageModel(
//       packageName,
//       newBenefit ?? benefit,
//       newPremium ?? premium,
//     );
//   }

//   @override
//   String toString() {
//     return 'SelectedPackageModel(packageName: $packageName, benefit: $benefit, premium: $premium)';
//   }
// }

// class BenefitPage extends StatefulWidget {
//   const BenefitPage({Key? key}) : super(key: key);

//   @override
//   _BenefitPageState createState() => _BenefitPageState();
// }

// class _BenefitPageState extends State<BenefitPage> {
//   double totalPremium = 0.0;
//   Map<String, List<dynamic>> categorizedPackages = {};
//   Map<dynamic, double> sliderValues = {};
//   Set<dynamic> selectedPackages = {};
//   List<SelectedPackageModel> selectedPackageList = [];
//   bool isLoading = true;

//   void initializeSliderValues(List<dynamic> packages) {
//     for (var package in packages) {
//       sliderValues[package] = (package['maxLimit'] + package['minLimit']) / 2;
//       package['premium'] = 0.0;
//     }
//   }

//   void categorizePackages(List<dynamic> packages) {
//     for (var package in packages) {
//       String category = package['packageCategory'];
//       if (!categorizedPackages.containsKey(category)) {
//         categorizedPackages[category] = [];
//       }
//       categorizedPackages[category]?.add(package);
//     }
//   }

//   Future<void> fetchBenefitData() async {
//     try {
//       final response = await http.get(Uri.parse(
//           'http://157.175.211.34:8196/api/payer/claimconnect/package'));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         categorizePackages(data);
//         initializeSliderValues(data);
//         setState(() {
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (error) {
//       print('Error fetching data: $error');
//     }
//   }

//   void selectPackage(dynamic package, double value, bool selected) {
//     setState(() {
//       if (selected) {
//         selectedPackages.add(package);
//       } else {
//         selectedPackages.remove(package);
//       }
//       sliderValues[package] = value;
//       double rate = findRate(package['benefitRanges'], value);
//       double premium = value * rate / 100;
//       package['premium'] = selected ? premium : 0.0;
//       totalPremium = 0.0;
//       selectedPackages.forEach((packageItem) {
//         totalPremium += packageItem['premium'] ?? 0.0;
//       });
//     });
//     print('Total Premium: $totalPremium');

//     if (selected) {
//       // Check if the package already exists in selectedPackageList
//       int existingIndex = selectedPackageList.indexWhere((selectedPackage) =>
//           selectedPackage.packageName == package['packageName']);
//       if (existingIndex != -1) {
//         // If exists, update its value
//         double rate = findRate(package['benefitRanges'], value);
//         double premium = value * rate / 100;
//         selectedPackageList[existingIndex] =
//             selectedPackageList[existingIndex].updateValues(
//           newBenefit: value,
//           newPremium: premium,
//         );
//       } else {
//         // If doesn't exist, add it to selectedPackageList
//         double rate = findRate(package['benefitRanges'], value);
//         double premium = value * rate / 100;
//         SelectedPackageModel selectedPackage =
//             SelectedPackageModel(package['packageName'], value, premium);
//         selectedPackageList.add(selectedPackage);
//       }
//     } else {
//       // If not selected, remove it from selectedPackageList
//       selectedPackageList.removeWhere((selectedPackage) =>
//           selectedPackage.packageName == package['packageName']);
//     }
//     print('Selected Packages: $selectedPackageList');
//   }

//   double findRate(List<dynamic> benefitRanges, double value) {
//     for (var range in benefitRanges) {
//       double minLimit = range['minLimit'].toDouble();
//       double maxLimit = range['maxLimit'].toDouble();
//       double rate = range['rate'].toDouble();
//       if (value >= minLimit && value <= maxLimit) {
//         return rate;
//       }
//     }
//     return 0.0;
//   }

//   @override
//   void initState() {
//     super.initState();
//     totalPremium = 0.0;
//     fetchBenefitData();
//     startTimer();
//   }

//   void startTimer() {
//     Timer(const Duration(seconds: 5), () {
//       if (isLoading) {
//         setState(() {
//           isLoading = false;
//         });
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text("Failed to Load Data"),
//               content: const Text("Unable to fetch data from the server."),
//               actions: <Widget>[
//                 TextButton(
//                   child: const Text("OK"),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Benefit Page'),
//         backgroundColor: Colors.blue,
//       ),
//       backgroundColor: Colors.transparent, // Set background color of the page to transparent
//       body: Stack(
//          children: [
//           // Custom background with curves
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.lightBlue.shade200,
//                     Colors.lightBlue.shade400,
//                   ],
//                 ),
//               ),
//               child: CustomPaint(
//                 size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/2 ),
//                 painter: CurvePainter(),
//               ),
//             ),
//           ),
//        Padding(
//         padding: const EdgeInsets.all(0.0), 
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 1),
//               child: Text(
//                 'Total Premium: ${totalPremium.toStringAsFixed(2)}',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Expanded(
//               child: Center(
//                 child: isLoading
//                     ? CircularProgressIndicator()
//                     : categorizedPackages.isEmpty
//                         ? Text("No data available")
//                         : ListView(
//                             children: categorizedPackages.entries.map((entry) {
//                               String category = entry.key;
//                               List<dynamic> packages = entry.value;
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Padding(
//                                   //   padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//                                   //   child: Text(
//                                   //     '$category',
//                                   //     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                                   //   ),
//                                   // ),
                                   
//                                   Column(
//                                     children: packages.map((package) {
//                                       double minLimit =
//                                           package['minLimit'] != null
//                                               ? package['minLimit'].toDouble()
//                                               : 0.0;
//                                       double maxLimit =
//                                           package['maxLimit'] != null
//                                               ? package['maxLimit'].toDouble()
//                                               : 100.0;
//                                       double value = sliderValues[package] ??
//                                           (maxLimit + minLimit) / 2;
//                                       bool isSelected =
//                                           selectedPackages.contains(package);
                                        
//                                       return Column(

//                                         children: [
                                          
//                                           ListTile(
//                                             contentPadding: EdgeInsets.zero,
//                                             leading:Padding(
//                                               padding: const EdgeInsets.only(left: 4.0, top: 8.0, bottom: 8.0),
//                                             child: Checkbox(
                                              
//                                               value: isSelected,
//                                               onChanged: (bool? selected) {
//                                                 selectPackage(
//                                                     package,
//                                                     value ??
//                                                         (maxLimit + minLimit) /
//                                                             2,
//                                                     selected ?? false);
//                                               },
//                                               // visualDensity: VisualDensity.compact, // Reduce space around Checkbox
//                                               // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce tap target size
   
//                                             ),
//                                           ),
//                                             title:Padding(
//                                               padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                                             child: Text(
//                                               package['packageName'] ??
//                                                   'Package Name Not Available',
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.w800,
//                                                   fontSize: 17),
//                                             ),
//                                             ),
                                            
//                                           ),
//                                           if (isSelected)
//                                           Column(
                                            
//                                             children:[
//                                               Padding(
//                                                 padding:EdgeInsets.only(left: 40),
//                                                child:Row(
//                                               mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 Text(
//                                                     'Min Limit: ${package['minLimit']} birr'),
//                                                      SizedBox(width: 20),
//                                                      Padding(padding: const EdgeInsets.only(right: 10),
//                                                child: Text(
//                                                     'Max Limit: ${package['maxLimit']} birr'),
//                                                      ),  
                                                
//                                               ],
//                                             ),
//                                               ),
//                                           SizedBox(
//                                             width: 300,
                                            
//                                             child: Slider(
//                                               value: value ??
//                                                   (maxLimit + minLimit) / 2,
//                                               min: minLimit,
//                                               max: maxLimit,
//                                               onChanged: (newValue) {
//                                                 selectPackage(package, newValue,
//                                                     isSelected);
//                                               },
//                                               divisions:
//                                                   (maxLimit - minLimit) ~/ 10,
//                                               label:
//                                                   (isSelected && value != null)
//                                                       ? value.round().toString()
//                                                       : '0',
//                                             ),
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left:
//                                                         40), // Adjust the left margin value as needed
//                                                 child: Text(
//                                                   'Benefit: ${value.toStringAsFixed(2)}birr',
//                                                   style: const TextStyle(
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Padding(padding: const EdgeInsets.only(right: 10),
//                                              child: Text(
//                                                 'Premium: ${package['premium'] != null ? package['premium'].toStringAsFixed(2) : '0.00'}birr',
//                                                 style: const TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                           ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                         ],
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ],
//                               );
//                             }).toList(),
//                           ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => SummaryPage(
//                         selectedPackages: selectedPackageList,
//                         totalPremium: totalPremium,
//                       ),
//                     ),
//                   );
//                 },
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all<Color>(
//                       Colors.blue), // Set background color to blue
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.symmetric(
//                       vertical: 12.0, horizontal: 24.0),
//                   child: Text('Finish', style: TextStyle(fontSize: 18)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//          ]
//       )
//     );
//   }
// }

// // Custom painter for drawing curves
// class CurvePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     var path = Path();
//     path.moveTo(0, size.height * 0.4);
//     path.quadraticBezierTo(size.width * 0.2, size.height * 0.3, size.width * 0.4, size.height * 0.4);
//     path.quadraticBezierTo(size.width * 0.75, size.height * 0.6, size.width, size.height * 0.5);
//     path.lineTo(size.width, 0);
//     path.lineTo(0, 0);
//     path.close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;

//   @override
//   bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;
// }