import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_app/features/task/pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/reusable_button_widget.dart';
import '../../../core/utils/theme.dart';

class ReductionFormScreen extends StatefulWidget {
  final int currentDay;

  const ReductionFormScreen({super.key, required this.currentDay});

  @override
  State<ReductionFormScreen> createState() => _ReductionFormScreenState();
}

class _ReductionFormScreenState extends State<ReductionFormScreen> {
  static final _formLogKey = GlobalKey<FormState>();
  final List<String> reasons = [
    'Cull',
    'Death',
    'Sold',
    'Lost/stolen',
    'Other'
  ];
  String _selectedReason = 'Cull';
  final TextEditingController _originalQuantityController =
      TextEditingController();
  final TextEditingController _reducedQuantityController =
      TextEditingController();
  DateTime _reductionDate = DateTime.now();
  final TextEditingController _notesController = TextEditingController();

  String? _selectedBatch;
  bool _isSubmitting = false;
  List<String> _batches = []; // New state variable to store fetched batches

  Stream<bool> _hasReductionLog(int day) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('reductionLogs')
          .where('userId', isEqualTo: user.uid)
          .where('day', isEqualTo: day)
          .snapshots()
          .map((snapshot) => snapshot.docs.isNotEmpty);
    } else {
      return Stream.value(false);
    }
  }

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

  @override
  void initState() {
    super.initState();
    _fetchBatches().then((batches) => setState(
        () => _batches = batches)); // Fetch and store batches on initState
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reduction Form',
          style: TextStyle(color: AppTheme.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.stop_circle_outlined,
              color: AppTheme.error700,
              size: 35,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Stop Tracking?'),
                    content: Text('Do you want to stop tracking?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final user = FirebaseAuth.instance.currentUser;
                          // Delete taskStartDate for current user doc
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .update({
                            'taskStartDate': FieldValue.delete(),
                            'isFarmingStarted': false,
                          });
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        },
                        child: Text('Stop'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Stop\nTracking',
              style: TextStyle(color: AppTheme.error700),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: StreamBuilder<bool>(
              stream: _hasReductionLog(widget.currentDay),
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
                                    SizedBox(height: 24.h),
                                    DropdownButtonFormField<String>(
                                      value: _selectedReason,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedReason = newValue!;
                                        });
                                      },
                                      items: reasons.map((String reason) {
                                        return DropdownMenuItem<String>(
                                          value: reason,
                                          child: Text(reason),
                                        );
                                      }).toList(),
                                      decoration: const InputDecoration(
                                          labelText: 'Reason for reducing',
                                          border: OutlineInputBorder()),
                                    ),
                                    SizedBox(height: 24.h),
                                    TextFormField(
                                      controller: _originalQuantityController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          labelText: 'Original Quantity',
                                          border: OutlineInputBorder()),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter original quantity';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 24.h),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          labelText: 'Quantity Reduced',
                                          border: OutlineInputBorder()),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter reduced quantity';
                                        } else if (int.parse(value) >
                                            int.parse(
                                                _originalQuantityController
                                                    .text)) {
                                          return 'Reduction cannot be more than original quantity';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 24.h),
                                    TextFormField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                        text: _reductionDate
                                            .toString()
                                            .substring(0, 10),
                                      ),
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: _reductionDate,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );
                                        if (pickedDate != null &&
                                            pickedDate != _reductionDate) {
                                          setState(() {
                                            _reductionDate = pickedDate;
                                          });
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          labelText: 'Reduction date',
                                          border: OutlineInputBorder()),
                                    ),
                                    SizedBox(height: 24.h),
                                    TextFormField(
                                      controller: _notesController,
                                      decoration: const InputDecoration(
                                          labelText: 'Short notes',
                                          border: OutlineInputBorder()),
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
                                                            'reductionLogs')
                                                        .add({
                                                      'userId': user.uid,
                                                      'batchName':
                                                          _selectedBatch,
                                                      'day': widget.currentDay,
                                                      'reason': _selectedReason,
                                                      'originalQuantity':
                                                          _originalQuantityController
                                                              .text,
                                                      'reducedQuantity':
                                                          _reducedQuantityController
                                                              .text,
                                                      'reductionDate':
                                                          _reductionDate,
                                                      'notes':
                                                          _notesController.text,
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
                          )
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
