import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/common/widgets/reusable_button_widget.dart';
import '../../../core/utils/theme.dart';
import '../../auth/pages/signup_screen.dart';

class StartTrackingButton extends StatelessWidget {
  const StartTrackingButton({
    super.key,
    required this.isUserNull,
  });

  final bool isUserNull;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isUserNull,
      child: SizedBox(
        width: double.infinity,
        child: ReusableButton(
          label: 'On Arrival',
          color: Colors.lightBlueAccent,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Start Tracking Process?'),
                  content: const Text(
                      'Do you want to start the farm tracking process?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // No button tapped
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // Yes button tapped
                        _showBatchForm(context);
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showBatchForm(BuildContext context) {
    final batchFormKey = GlobalKey<FormState>();
    String? batch;
    String? quantity;
    String? breed;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('breeds').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DropdownMenuItem<String>> breedDropdownItems = [];
              for (var doc in snapshot.data!.docs) {
                var breedName = doc['name'];
                breedDropdownItems.add(
                  DropdownMenuItem(
                    value: breedName,
                    child: Text(breedName),
                  ),
                );
              }

              return AlertDialog(
                title: const Text('Fill Batch Information'),
                content: Form(
                  key: batchFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Batch'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a batch';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          batch = value;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Quantity'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a quantity';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          quantity = value;
                        },
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: 'Breed'),
                        items: breedDropdownItems,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a breed';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          breed = value as String?;
                        },
                        onSaved: (value) {
                          breed = value as String?;
                        },
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cancel button tapped
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (batchFormKey.currentState!.validate()) {
                        batchFormKey.currentState!.save();
                        // Save batch information to Firestore
                        _saveBatchInfo(context, batch!, quantity!, breed!);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }

  void _saveBatchInfo(
      BuildContext context, String batch, String quantity, String breed) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      FirebaseFirestore.instance.collection('batches').add({
        'batch': batch,
        'quantity': quantity,
        'breed': breed,
        'userId': currentUser.uid,
        'timestamp': Timestamp.now(),
      }).then((value) {
        print('Batch information saved successfully');
        // Add start date to Firestore
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'taskStartDate': Timestamp.now(),
          // Set the start date to the current timestamp
          'isFarmingStarted': true,
        }).then((value) {
          print('Start date added to Firestore');
          // Add your code to start the farm process here
        }).catchError((error) {
          print('Failed to add start date: $error');
          // Handle the error
        });
        Navigator.of(context).pop(); // Close the dialog
      }).catchError((error) {
        print('Failed to save batch information: $error');
        // Handle the error
      });
    }
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
    required this.isUserNull,
  });

  final bool isUserNull;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isUserNull,
      child: SizedBox(
        width: double.infinity,
        child: ReusableButton(
          label: 'Signup to start tracking progress',
          color: AppTheme.buttonColor,
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
        ),
      ),
    );
  }
}
