import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp/Data/Models/Removedvehicle.dart';
import 'package:testapp/Data/Repositories/Removed_vehilce_repository.dart';

class RemovedVehicleScreen extends StatefulWidget {
  const RemovedVehicleScreen({Key? key}) : super(key: key);

  @override
  _RemovedVehicleScreenState createState() => _RemovedVehicleScreenState();
}

class _RemovedVehicleScreenState extends State<RemovedVehicleScreen> {
  final RemovedVehicleRepository _repository = RemovedVehicleRepository();
  List<RemovedVehicle> _vehicles = [];
  bool _isLoading = false;
  late String _currentTime;
  late String _currentDate;
  late Timer _timer;
  final int _rowsPerPage = 20;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize current date and time
    _updateTime();
    _updateDate();
    // Update date and time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _updateTime();
        _updateDate();
      });
    });
    _fetchData();
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    _currentTime = DateFormat('hh:mm a').format(now);
  }

  void _updateDate() {
    final now = DateTime.now();
    _currentDate = DateFormat('MMM dd, yyyy').format(now);
  }

  void _onPreviousPage() {
    setState(() {
      _pageIndex = (_pageIndex - 1).clamp(0, (_calculateTotalPages() - 1));
    });
  }

  void _onNextPage() {
    setState(() {
      _pageIndex = (_pageIndex + 1).clamp(0, (_calculateTotalPages() - 1));
    });
  }

  int _calculateTotalPages() {
    return (_vehicles.length / _rowsPerPage).ceil();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final vehicles = await _repository.fetchRemovedVehicles();
      setState(() {
        _vehicles = vehicles;
      });
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? LinearProgressIndicator(
        backgroundColor: Colors.grey[200],
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffea6238)),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(onPressed: _fetchData, icon: const Icon(Icons.refresh)),
                  SizedBox(
                    width: 600,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Name, Email, phone, registeded",
                        hintStyle: const TextStyle(color: Colors.grey),
                        fillColor: Colors.grey.withOpacity(0.5),
                        filled: true,
                        suffixIcon: const Icon(Icons.search_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: _pageIndex == 0 ? null : _onPreviousPage,
                      ),
                      Text('${_pageIndex + 1} of ${_calculateTotalPages()}'),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: _pageIndex == (_calculateTotalPages() - 1) ? null : _onNextPage,
                      ),
                    ],
                  ),
                  const SizedBox(width: 15,)
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20.0),
                    child: DataTable(
                      columnSpacing: 5.0,
                      headingRowColor: MaterialStateProperty.resolveWith(
                              (states) => const Color(0xffea6238)
                      ),
                      headingTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12, // Adjust heading font size
                      ),
                      headingRowHeight: 50.0,
                      dataRowHeight: 50.0,
                      dividerThickness: 0,
                      dataTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                      ),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Vehicle ID',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Vehicle Capacity',
                            textAlign: TextAlign.center, // Center align the heading
                          ),
                        ),

                        DataColumn(
                          label: Text(
                            'Vehicle Number',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Created at',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Remove Access',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      rows: _vehicles.skip(_pageIndex * _rowsPerPage).take(_rowsPerPage).toList().asMap().entries.map((entry) {
                        final int index = entry.key + (_pageIndex * _rowsPerPage);
                        final RemovedVehicle vehicle = entry.value;
                        final Color color = index.isOdd ? Colors.grey[300]! : Colors.grey[100]!;
                        return DataRow(
                          color: MaterialStateProperty.all(color),
                          cells: [
                            DataCell(
                              Text(
                                vehicle.vehicleId,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(vehicle.vehicleCapacity),
                            ),
                            DataCell(
                              Text(vehicle.vehicleNumber, textAlign: TextAlign.center,),
                            ),
                            DataCell(
                              Text(
                                DateFormat('MMM dd, yyyy').format(DateTime.parse(vehicle.registered)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              IconButton(
                                onPressed: () => _repository.removeVehicleAccess(vehicle.vehicleNumber),
                                icon: const Icon(Icons.add_circle_outline, color: Color(0xffea6238)),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
