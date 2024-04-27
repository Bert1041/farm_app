import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_app/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/reusable_app_bar_widget.dart';
import '../../../drawer.dart';
import '../widgets/breed_data.dart';
import 'farm_log_screen.dart';

class BenchmarkScreen extends StatefulWidget {
  final int currentDay;

  const BenchmarkScreen({super.key, required this.currentDay});

  @override
  State<BenchmarkScreen> createState() => _BenchmarkScreenState();
}

class _BenchmarkScreenState extends State<BenchmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context, widget.currentDay),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: CustomScrollView(
            slivers: [
              const ReusableAppBar(title: 'Observations'),
              SliverToBoxAdapter(
                child: Container(
                  color: AppTheme.backgroundColor,
                  width: double.infinity,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: 1.3,
                      children: [
                        FormCard(
                          icon: Icons.monitor_heart,
                          formName: 'Temperature',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TemperaturePage(),
                              ),
                            );
                          },
                        ),
                        FormCard(
                          icon: Icons.monitor_weight,
                          formName: 'Weight',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const WeightBenchmarkPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeightBenchmarkPage extends StatefulWidget {
  const WeightBenchmarkPage({super.key});

  @override
  WeightBenchmarkPageState createState() => WeightBenchmarkPageState();
}

class WeightBenchmarkPageState extends State<WeightBenchmarkPage> {
  List<String>? breeds;
  late String selectedBreed;

  bool rotateTable = false;

  void toggleRotation() {
    setState(() {
      rotateTable = !rotateTable;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBreeds();
  }

  Future<void> fetchBreeds() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('breeds').get();
      final List<String> fetchedBreeds =
          querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        breeds = fetchedBreeds;
        selectedBreed = breeds!.first;
      });
    } catch (error) {
      print('Error fetching breeds: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Benchmark',
          style: TextStyle(color: AppTheme.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: breeds == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Breed:',
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      children: breeds!.map((breed) {
                        return Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: ChoiceChip(
                            label: Text(breed),
                            selected: selectedBreed == breed,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  selectedBreed = breed;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(height: 20.h),
                  Text(
                    'Benchmark Table for $selectedBreed:',
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: RotatedBox(
                            quarterTurns: rotateTable ? -1 : 0,
                            child: _buildDataTable(selectedBreed)),
                      ), // Call a new method to build the table
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleRotation,
        tooltip: 'Rotate Table',
        child: Icon(rotateTable ? Icons.rotate_right : Icons.rotate_left),
      ),
    );
  }

  // New method to build the DataTable based on selectedBreed
  DataTable _buildDataTable(String breed) {
    switch (breed) {
      case 'Ross 308':
        return DataTable(
          headingRowColor: MaterialStateProperty.all(AppTheme.tile2),
          columns: const [
            DataColumn(label: Text('Day')),
            DataColumn(label: Text('Weight (g)')),
            DataColumn(label: Text('Daily Gain (g)')),
            DataColumn(label: Text('Av. Daily Gain (g)')),
            DataColumn(label: Text('Daily Intake (g)')),
            DataColumn(label: Text('Cum. Intake (g)')),
            DataColumn(label: Text('FCR')),
          ],
          rows: getRoss308Data()
              .map((row) => DataRow(cells: [
                    DataCell(Text(row['Day']!)),
                    DataCell(Text(row['Weight (g)']!)),
                    DataCell(Text(row['Daily Gain (g)']!)),
                    DataCell(Text(row['Av. Daily Gain (g)']!)),
                    DataCell(Text(row['Daily Intake (g)']!)),
                    DataCell(Text(row['Cum. Intake (g)']!)),
                    DataCell(Text(row['FCR']!)),
                  ]))
              .toList(),
        );
      case 'Cobb 500':
        return DataTable(
          headingRowColor: MaterialStateProperty.all(AppTheme.tile2),
          columns: const [
            DataColumn(label: Text('Day')),
            DataColumn(label: Text('Weight (g)')),
            DataColumn(label: Text('Daily Gain (g)')),
            DataColumn(label: Text('Av. Daily Gain (g)')),
            DataColumn(label: Text('Daily Intake (g)')),
            DataColumn(label: Text('Cum. Intake (g)')),
            DataColumn(label: Text('FCR')),
          ],
          rows: getCobb500Data()
              .map((row) => DataRow(cells: [
                    DataCell(Text(row['Day']!)),
                    DataCell(Text(row['Weight (g)']!)),
                    DataCell(Text(row['Daily Gain (g)']!)),
                    DataCell(Text(row['Av. Daily Gain (g)']!)),
                    DataCell(Text(row['Daily Intake (g)']!)),
                    DataCell(Text(row['Cum. Intake (g)']!)),
                    DataCell(Text(row['FCR']!)),
                  ]))
              .toList(),
        );
      case 'Arbor Acres Plus':
        return DataTable(
          headingRowColor: MaterialStateProperty.all(AppTheme.tile2),
          columns: const [
            DataColumn(label: Text('Day')),
            DataColumn(label: Text('Weight (g)')),
            DataColumn(label: Text('Daily Gain (g)')),
            DataColumn(label: Text('Av. Daily Gain (g)')),
            DataColumn(label: Text('Daily Intake (g)')),
            DataColumn(label: Text('Cum. Intake (g)')),
            DataColumn(label: Text('FCR')),
          ],
          rows: getArborAcresPlusData()
              .map((row) => DataRow(cells: [
                    DataCell(Text(row['Day']!)),
                    DataCell(Text(row['Weight (g)']!)),
                    DataCell(Text(row['Daily Gain (g)']!)),
                    DataCell(Text(row['Av. Daily Gain (g)']!)),
                    DataCell(Text(row['Daily Intake (g)']!)),
                    DataCell(Text(row['Cum. Intake (g)']!)),
                    DataCell(Text(row['FCR']!)),
                  ]))
              .toList(),
        );
      case 'Cobb 700':
        return DataTable(
          headingRowColor: MaterialStateProperty.all(AppTheme.tile2),
          columns: const [
            DataColumn(label: Text('Day')),
            DataColumn(label: Text('Weight (g)')),
            DataColumn(label: Text('Daily Gain (g)')),
            DataColumn(label: Text('Av. Daily Gain (g)')),
            DataColumn(label: Text('Daily Intake (g)')),
            DataColumn(label: Text('Cum. Intake (g)')),
            DataColumn(label: Text('FCR')),
          ],
          rows: getCobb700Data()
              .map((row) => DataRow(cells: [
                    DataCell(Text(row['Day']!)),
                    DataCell(Text(row['Weight (g)']!)),
                    DataCell(Text(row['Daily Gain (g)']!)),
                    DataCell(Text(row['Av. Daily Gain (g)']!)),
                    DataCell(Text(row['Daily Intake (g)']!)),
                    DataCell(Text(row['Cum. Intake (g)']!)),
                    DataCell(Text(row['FCR']!)),
                  ]))
              .toList(),
        );
      case 'Ross 708':
        return DataTable(
          headingRowColor: MaterialStateProperty.all(AppTheme.tile2),
          columns: const [
            DataColumn(label: Text('Day')),
            DataColumn(label: Text('Weight (g)')),
            DataColumn(label: Text('Daily Gain (g)')),
            DataColumn(label: Text('Av. Daily Gain (g)')),
            DataColumn(label: Text('Daily Intake (g)')),
            DataColumn(label: Text('Cum. Intake (g)')),
            DataColumn(label: Text('FCR')),
          ],
          rows: getRoss708Data()
              .map((row) => DataRow(cells: [
                    DataCell(Text(row['Day']!)),
                    DataCell(Text(row['Weight (g)']!)),
                    DataCell(Text(row['Daily Gain (g)']!)),
                    DataCell(Text(row['Av. Daily Gain (g)']!)),
                    DataCell(Text(row['Daily Intake (g)']!)),
                    DataCell(Text(row['Cum. Intake (g)']!)),
                    DataCell(Text(row['FCR']!)),
                  ]))
              .toList(),
        );
      default:
        return DataTable(
          columns: const [DataColumn(label: Text('No data for this breed'))],
          rows: const [],
        );
    }
  }
}

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({super.key});

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  bool rotateTable = false;

  void toggleRotation() {
    setState(() {
      rotateTable = !rotateTable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Temperature Data',
          style: TextStyle(color: AppTheme.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RotatedBox(
              quarterTurns: rotateTable ? -1 : 0,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(AppTheme.tile2),
                columns: const [
                  DataColumn(label: Text('Age (days)')),
                  DataColumn(label: Text('Dry Bulb Temperature at RH%')),
                  DataColumn(label: Text('50 RH%')),
                  DataColumn(label: Text('60 RH%')),
                  DataColumn(label: Text('70 RH%')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Day-old')),
                    DataCell(Text('36.0°C (96.8°F)')),
                    DataCell(Text('33.2°C (91.8°F)')),
                    DataCell(Text('30.8°C (87.4°F)')),
                    DataCell(Text('29.2°C (84.6°F)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('3')),
                    DataCell(Text('33.7°C (92.7°F)')),
                    DataCell(Text('31.2°C (88.2°F)')),
                    DataCell(Text('28.9°C (84.0°F)')),
                    DataCell(Text('27.3°C (81.1°F)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('6')),
                    DataCell(Text('32.5°C (90.5°F)')),
                    DataCell(Text('29.9°C (85.8°F)')),
                    DataCell(Text('27.7°C (81.9°F)')),
                    DataCell(Text('26.0°C (78.8°F)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('9')),
                    DataCell(Text('31.3°C (88.3°F)')),
                    DataCell(Text('28.6°C (83.5°F)')),
                    DataCell(Text('26.7°C (80.1°F)')),
                    DataCell(Text('25.0°C (77.0°F)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('12')),
                    DataCell(Text('30.2°C (86.4°F)')),
                    DataCell(Text('27.8°C (82.0°F)')),
                    DataCell(Text('25.7°C (78.3°F)')),
                    DataCell(Text('24.0°C (75.2°F)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('15')),
                    DataCell(Text('29.0°C (84.2°F)')),
                    DataCell(Text('26.8°C (80.2°F)')),
                    DataCell(Text('24.8°C (76.6°F)')),
                    DataCell(Text('23.0°C (73.4°F)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('18')),
                    DataCell(Text('27.7°C (81.9°F)')),
                    DataCell(Text('25.5°C (77.9°F)')),
                    DataCell(Text('23.6°C (74.5°F)')),
                    DataCell(Text('21.9°C (71.4°F)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('21')),
                    DataCell(Text('26.9°C (80.4°F)')),
                    DataCell(Text('24.7°C (76.5°F)')),
                    DataCell(Text('22.7°C (72.9°F)')),
                    DataCell(Text('21.3°C (70.3°F)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('24')),
                    DataCell(Text('25.7°C (78.3°F)')),
                    DataCell(Text('23.5°C (74.3°F)')),
                    DataCell(Text('21.7°C (71.1°F)')),
                    DataCell(Text('20.2°C (68.4°F)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('27')),
                    DataCell(Text('24.8°C (76.6°F)')),
                    DataCell(Text('22.7°C (72.9°F)')),
                    DataCell(Text('20.7°C (69.3°F)')),
                    DataCell(Text('19.3°C (66.7°F)')),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleRotation,
        tooltip: 'Rotate Table',
        child: Icon(rotateTable ? Icons.rotate_right : Icons.rotate_left),
      ),
    );
  }
}
