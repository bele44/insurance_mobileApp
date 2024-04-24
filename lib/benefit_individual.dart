import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'summary_individual.dart';
import 'selected_package_provider.dart';
import 'selected_package_model.dart';
import 'package:provider/provider.dart';

class BenefitPage extends StatelessWidget {
  const BenefitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (
      
       _BenefitPageContent()
    );
  }
}

class _BenefitPageContent extends StatefulWidget {
  @override
  _BenefitPageContentState createState() => _BenefitPageContentState();
}

class _BenefitPageContentState extends State<_BenefitPageContent> {
  //double totalPremium = 0.0;
  Map<String, List<dynamic>> categorizedPackages = {};
  Map<dynamic, double> sliderValues = {};
  List<SelectedPackageModel> selectedPackageList = [];
  bool isLoading = true;

  void initializeSliderValues(List<dynamic> packages) {
    for (var package in packages) {
      sliderValues[package] = (package['maxLimit'] + package['minLimit']) / 2;
      package['premium'] = 0.0;
    }
  }

  void categorizePackages(List<dynamic> packages) {
    for (var package in packages) {
      String category = package['packageCategory'];
      if (!categorizedPackages.containsKey(category)) {
        categorizedPackages[category] = [];
      }
      categorizedPackages[category]?.add(package);
    }
  }

  Future<void> fetchBenefitData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.6:3000/package'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        categorizePackages(data);
        initializeSliderValues(data);
        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    //totalPremium = 0.0;
    fetchBenefitData();
    startTimer();
  }

void startTimer() {
    Timer(const Duration(seconds: 5), () {
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Failed to Load Data"),
              content: const Text("Unable to fetch data from the server."),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Benefit Page'),
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Colors
            .transparent, 
        body: Stack(children: [
      
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
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: Consumer<SelectedPackageProvider>(
                    builder: (context, provider, _) {
                     
                      double totalPremium = provider.totalPremium;
                      return Text(
                        'Total Premium: ${totalPremium.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator()
                        : categorizedPackages.isEmpty
                            ? Text("No data available")
                            : ListView(
                                children:
                                    categorizedPackages.entries.map((entry) {
                                  String category = entry.key;
                                  List<dynamic> packages = entry.value;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: packages.map((package) {
                                          double minLimit =
                                              package['minLimit'] != null
                                                  ? package['minLimit']
                                                      .toDouble()
                                                  : 0.0;
                                          double maxLimit =
                                              package['maxLimit'] != null
                                                  ? package['maxLimit']
                                                      .toDouble()
                                                  : 100.0;
                                          double value =
                                              sliderValues[package] ??
                                                  (maxLimit + minLimit) / 2;

                                         
                                         
                                          return Column(
                                            children: [
                                              Consumer<SelectedPackageProvider>(
                                                builder:
                                                    (context, provider, _) {
                                                  bool isSelected = provider
                                                      .isSelected(package);
                                                  return ListTile(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    leading: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4.0,
                                                              top: 8.0,
                                                              bottom: 8.0),
                                                      child: Checkbox(
                                                        value: isSelected,
                                                        onChanged:
                                                            (bool? selected) {
                                                          if (selected !=
                                                              null) {
                                                            if (selected) {
                                                              provider
                                                                  .addSelectedPackage(
                                                                      package);
                                                            } else {
                                                              provider
                                                                  .removeSelectedPackage(
                                                                      package);
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    
                                                    title: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0,
                                                              bottom: 8.0),
                                                      child: Text(
                                                        package['packageName'] ??
                                                            'Package Name Not Available',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              
                                              Column(
                                                children: [
                                                  
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 40),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            'Min Limit: ${package['minLimit']} birr'),
                                                        SizedBox(width: 20),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10),
                                                          child: Text(
                                                              'Max Limit: ${package['maxLimit']} birr'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Consumer<
                                                      SelectedPackageProvider>(
                                                    builder:
                                                        (context, provider, _) {
                                                      return SizedBox(
                                                        width: 300,
                                                        child: Slider(
                                                          value: value ??
                                                              (maxLimit +
                                                                      minLimit) /
                                                                  2,
                                                          min: minLimit,
                                                          max: maxLimit,
                                                          onChanged:
                                                              (newValue) {
                                                            setState(() {
                                                              sliderValues[
                                                                      package] =
                                                                  newValue;
                                                            });
                                                           
                                                            provider
                                                                .updateSelectedPackage(
                                                                    package,
                                                                    newValue);
                                                          },
                                                          divisions: (maxLimit -
                                                                  minLimit) ~/
                                                              10,
                                                          label: value
                                                              .round()
                                                              .toString(),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  Consumer<
                                                      SelectedPackageProvider>(
                                                    builder:
                                                        (context, provider, _) {
                                                     
                                                      double premium =
                                                          provider.premiums[
                                                                  package] ??
                                                              0.0;

                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left:
                                                                        40),
                                                            child: Text(
                                                              'Benefit: ${value.toStringAsFixed(2)}birr',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 8),
                                                            child: Text(
                                                              'Premium: ${premium.toStringAsFixed(2)} birr',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                              
                                            ],
                                          );






                                        }).toList(),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
  onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SummaryPage(),
    ),
  );
},


                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue), 
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      child: Text('Finish', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
        )
        );
  }
}
