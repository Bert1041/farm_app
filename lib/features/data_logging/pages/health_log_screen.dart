import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/reusable_button_widget.dart';
import '../../../core/utils/theme.dart';

class HealthFormScreen extends StatefulWidget {
  final int currentDay;

  const HealthFormScreen({super.key, required this.currentDay});

  @override
  State<HealthFormScreen> createState() => _HealthFormScreenState();
}

class _HealthFormScreenState extends State<HealthFormScreen> {
  static final _formLogKey = GlobalKey<FormState>();
  List<String> _batches = []; // New state variable to store fetched batches

  // Use maps to store checkbox selections for each category
  final Map<String, bool> _feathers = {
    "Normal": false,
    "Ruffled": false,
    "Missing": false,
  };
  final Map<String, bool> _leg = {
    "Normal": false,
    "Swollen": false,
    "Limping": false,
  };
  final Map<String, bool> _beak_tongue = {
    "Normal": false,
    "Discolored": false,
    "Overgrown": false,
  };
  final Map<String, bool> _eyes = {
    "Normal": false,
    "Watery": false,
    "Irritated": false,
  };
  final Map<String, bool> _respiratory = {
    "Normal": false,
    "Wheezing": false,
    "Labored Breathing": false,
  };
  final Map<String, bool> _behaviour = {
    "Normal": false,
    "Active": false,
    "Inactive": false,
    "Aggressive": false,
  };

  final Map<String, bool> _vent = {
    "Normal": false,
    "Dirty": false,
    "Loose Droppings": false,
  };

  final Map<String, bool> _skin = {
    "Normal": false,
    "Blemishes": false,
    "Scratches": false,
    "Hock burn Marks": false,
    "Blisters": false,
  };

  final Map<String, bool> _crop = {
    "Normal": false,
    "Firm": false,
    "Litter": false,
  };

  void _handleCheckboxChange(String category, String option, bool value) {
    setState(() {
      switch (category) {
        case 'feathers':
          _feathers[option] = value;
          break;
        case 'leg':
          _leg[option] = value;
          break;
        case 'beak':
          _beak_tongue[option] = value;
          break;
        case 'eyes':
          _eyes[option] = value;
          break;
        case 'respiratory':
          _respiratory[option] = value;
          break;
        case 'behavior':
          _behaviour[option] = value;
          break;
        case 'vent':
          _vent[option] = value;
          break;
        case 'skin':
          _skin[option] = value;
          break;
        case 'crop':
          _crop[option] = value;
          break;
      }
    });
  }

  String? _selectedBatch;
  bool _isSubmitting = false;

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
          .collection('healthLogs')
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Health Log Form',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          .map<DropdownMenuItem<String>>(
                                              (batch) {
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
                                    const Text(
                                      'Feathers:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Column(
                                      children: _feathers.entries.map((entry) {
                                        return CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(entry.key),
                                          value: entry.value,
                                          onChanged: (value) =>
                                              _handleCheckboxChange('feathers',
                                                  entry.key, value!),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 24.h),
                                    const Text(
                                      'Leg:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Column(
                                      children: _leg.entries.map((entry) {
                                        return CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(entry.key),
                                          value: entry.value,
                                          onChanged: (value) =>
                                              _handleCheckboxChange(
                                                  'leg', entry.key, value!),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 24.h),
                                    const Text(
                                      'Beak:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Column(
                                      children:
                                          _beak_tongue.entries.map((entry) {
                                        return CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(entry.key),
                                          value: entry.value,
                                          onChanged: (value) =>
                                              _handleCheckboxChange(
                                                  'beak', entry.key, value!),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 24.h),
                                    const Text(
                                      'Eyes:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Column(
                                      children: _eyes.entries.map((entry) {
                                        return CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(entry.key),
                                          value: entry.value,
                                          onChanged: (value) =>
                                              _handleCheckboxChange(
                                                  'eyes', entry.key, value!),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 24.h),
                                    const Text(
                                      'Respiratory System:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Column(
                                      children:
                                          _respiratory.entries.map((entry) {
                                        return CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(entry.key),
                                          value: entry.value,
                                          onChanged: (value) =>
                                              _handleCheckboxChange(
                                                  'respiratory',
                                                  entry.key,
                                                  value!),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 24.h),
                                    const Text(
                                      'Behavior:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Column(
                                      children: _behaviour.entries.map((entry) {
                                        return CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(entry.key),
                                          value: entry.value,
                                          onChanged: (value) =>
                                              _handleCheckboxChange('behavior',
                                                  entry.key, value!),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 24.h),
                                    const Text(
                                      'Vent:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Column(
                                      children: _vent.entries.map((entry) {
                                        return CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(entry.key),
                                          value: entry.value,
                                          onChanged: (value) =>
                                              _handleCheckboxChange(
                                                  'vent', entry.key, value!),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 24.h),
                                    const Text(
                                      'Skin:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Column(
                                      children: _skin.entries.map((entry) {
                                        return CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(entry.key),
                                          value: entry.value,
                                          onChanged: (value) =>
                                              _handleCheckboxChange(
                                                  'skin', entry.key, value!),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 24.h),
                                    const Text(
                                      'Crop:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Column(
                                      children: _crop.entries.map((entry) {
                                        return CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(entry.key),
                                          value: entry.value,
                                          onChanged: (value) =>
                                              _handleCheckboxChange(
                                                  'crop', entry.key, value!),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 24.h),
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
                                                            'healthLogs')
                                                        .add({
                                                      'userId': user.uid,
                                                      'batchName':
                                                          _selectedBatch,
                                                      'day': widget.currentDay,
                                                      'feathers': _feathers,
                                                      'leg': _leg,
                                                      'beak': _beak_tongue,
                                                      'eyes': _eyes,
                                                      'respiratory':
                                                          _respiratory,
                                                      'behavior': _behaviour,
                                                      'vent': _vent,
                                                      'skin': _skin,
                                                      'crop': _crop,
                                                      'timestamp':
                                                          Timestamp.now(),
                                                    }).then((_) {
                                                      print(
                                                          'Form data saved successfully');
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Form data saved successfully'),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      );
                                                    }).catchError((error) {
                                                      print(
                                                          'Failed to save form data: $error');
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Failed to save form data: $error'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }).whenComplete(() {
                                                      setState(() {
                                                        _isSubmitting = false;
                                                      });
                                                    });
                                                  }
                                                }
                                              },
                                            ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
