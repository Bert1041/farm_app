import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/reusable_button_widget.dart';
import '../../../core/utils/theme.dart';

class PerformanceLogScreen extends StatefulWidget {
  final int currentDay;

  const PerformanceLogScreen({super.key, required this.currentDay});

  @override
  State<PerformanceLogScreen> createState() => _PerformanceLogScreenState();
}

class _PerformanceLogScreenState extends State<PerformanceLogScreen> {
  static final _formLogKey = GlobalKey<FormState>();

  String? _selectedBatch;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _feedConsumptionController =
      TextEditingController();
  final TextEditingController _waterConsumptionController =
      TextEditingController();
  bool _isSubmitting = false;
  List<String> _batches = []; // New state variable to store fetched batches

  Future<List<String>> _fetchBatches() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('batches')
            .where('userId', isEqualTo: user.uid)
            .get();
        return querySnapshot.docs.map((doc) => doc['batch'] as String).toList();
      }
      return [];
    } catch (error) {
      print('Error fetching batches: $error');
      return [];
    }
  }

  Stream<bool> _checkIfDayExists(int day) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('performanceLogs')
          .where('userId', isEqualTo: user.uid)
          .where('day', isEqualTo: day)
          .snapshots()
          .map((snapshot) => snapshot.docs.isNotEmpty);
    } else {
      return Stream.value(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBatches().then((batches) => setState(
        () => _batches = batches)); // Fetch and store batches on initState
  }

  @override
  void dispose() {
    _weightController.dispose();
    _temperatureController.dispose();
    _feedConsumptionController.dispose();
    _waterConsumptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Performance Log Form',
          style: TextStyle(color: AppTheme.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: StreamBuilder<bool>(
            stream: _checkIfDayExists(widget.currentDay),
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return Center(
                  child: Text(
                    'You have successfully logged data for day ${widget.currentDay}.',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Form(
                    key: _formLogKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Day: ${widget.currentDay}',
                          style: const TextStyle(
                              fontSize: 18, color: AppTheme.secondary400),
                        ),
                        SizedBox(height: 24.h),
                        FutureBuilder<List<String>>(
                          future: null,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Column(
                                children: [
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      labelText: 'Select Batch',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: _selectedBatch,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedBatch = value;
                                      });
                                    },
                                    items: _batches
                                        .map<DropdownMenuItem<String>>((batch) {
                                      return DropdownMenuItem<String>(
                                        value: batch,
                                        child: Text(batch),
                                      );
                                    }).toList(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a batch';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 24.h),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _weightController,
                                    decoration: const InputDecoration(
                                      labelText: 'Weight (in grams)',
                                      hintText: 'Enter weight',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter weight';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 24.h),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _temperatureController,
                                    decoration: const InputDecoration(
                                      labelText: 'Temperature (in Celsius)',
                                      hintText: 'Enter temperature',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter temperature';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 24.h),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _feedConsumptionController,
                                    decoration: const InputDecoration(
                                      labelText:
                                          'Feed Consumption (in kilograms)',
                                      hintText: 'Enter feed consumption',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter feed consumption';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 24.h),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _waterConsumptionController,
                                    decoration: const InputDecoration(
                                      labelText:
                                          'Water Consumption (in liters)',
                                      hintText: 'Enter water consumption',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter water consumption';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 48.h),
                                  SizedBox(
                                    width: double.infinity,
                                    child: _isSubmitting
                                        ? const CircularProgressIndicator()
                                        : ReusableButton(
                                            label: 'SUBMIT',
                                            color: AppTheme.blackSecondary,
                                            onPressed: () {
                                              if (_formLogKey.currentState!
                                                  .validate()) {
                                                // Form is valid, submit data
                                                setState(() {
                                                  _isSubmitting = true;
                                                });
                                                final user = FirebaseAuth
                                                    .instance.currentUser;
                                                if (user != null) {
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'performanceLogs')
                                                      .add({
                                                    'userId': user.uid,
                                                    'batchName': _selectedBatch,
                                                    'weight':
                                                        _weightController.text,
                                                    'temperature':
                                                        _temperatureController
                                                            .text,
                                                    'feedConsumption':
                                                        _feedConsumptionController
                                                            .text,
                                                    'waterConsumption':
                                                        _waterConsumptionController
                                                            .text,
                                                    'day': widget.currentDay,
                                                    'timestamp':
                                                        Timestamp.now(),
                                                  }).then((_) {
                                                    print(
                                                        'Form data saved successfully');
                                                  }).catchError((error) {
                                                    print(
                                                        'Failed to save form data: $error');
                                                  });
                                                }
                                                setState(() {
                                                  _isSubmitting = false;
                                                });
                                              }
                                            },
                                          ),
                                  ),
                                ],
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
