import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../header.dart';
import '../service/data_service.dart';
import 'package:weather_station_app/constants.dart';
import '../side_menu.dart';
import '../storage_details.dart';

class FreezePanesDataGridSource extends DataGridSource {
  List<Map<String, dynamic>> weatherList = [];

  @override
  List<DataGridRow> get rows => List<DataGridRow>.generate(
        weatherList.length,
        (index) {
          final rowData = weatherList[index];
          return DataGridRow(cells: [
            DataGridCell<String>(
              columnName: 'date',
              value: rowData['date'].toString(),
            ),
            DataGridCell<String>(
              columnName: 'hum_max',
              value: rowData['hum_max'],
            ),
            DataGridCell<String>(
              columnName: 'hum_min',
              value: rowData['hum_min'],
            ),
            DataGridCell<String>(
              columnName: 'hum_moy',
              value: rowData['hum_moy'],
            ),
            DataGridCell<String>(
              columnName: 'temp_max',
              value: rowData['temp_max'],
            ),
            DataGridCell<String>(
              columnName: 'temp_min',
              value: rowData['temp_min'],
            ),
            DataGridCell<String>(
              columnName: 'temp_moy',
              value: rowData['temp_moy'],
            ),
          ]);
        },
      );

  Future<void> fetchData() async {
    final dataService = DataService();
    weatherList = await dataService.getData();
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        final value = dataGridCell.value;
        return Container(
          color: secondaryColor,
          padding: EdgeInsets.all(5.0),
          alignment: Alignment.centerLeft,
          child: Text(
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              color: Colors.white, // Set the text color to white
            ),
            value != null ? value.toString() : '',
          ),
        );
      }).toList(),
    );
  }
}

class WeatherDataScreen extends StatefulWidget {
  @override
  _WeatherDataScreenState createState() => _WeatherDataScreenState();
}

class _WeatherDataScreenState extends State<WeatherDataScreen> {
  List<Map<String, dynamic>> weatherList = [];
  DateTime minDate = DateTime.now();
  DateTime maxDate = DateTime.now();

  final FreezePanesDataGridSource freezePanesDataGridSource =
      FreezePanesDataGridSource();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final dataService = DataService();
    weatherList = await dataService.getData();
    await freezePanesDataGridSource.fetchData();
    setState(() {});
  }

  void updateMinDate(DateTime newMinDate) {
    setState(() {
      minDate = newMinDate;
    });
  }

  void updateMaxDate(DateTime newMaxDate) {
    setState(() {
      maxDate = newMaxDate;
    });
  }

  void onFilterButtonPressed() {
    print('Filter button pressed!');
    print('Min Date: $minDate');
    print('Max Date: $maxDate');
  }

  DateTime parseDateTime(String dateTimeString) {
    final format = DateFormat('M/d/yyyy H:mm');
    final parsedDateTime = format.parse(dateTimeString);
    return parsedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        toolbarHeight: 150.0,
        title: Text('CLIMA sense'),
        leading: Container(
          child: Image.asset(
            '../assets/images/logoStationmeteo.png',
            height: 96,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              weatherList.isEmpty
                  ? CircularProgressIndicator()
                  : Row(
                      children: [
                        Expanded(
                            child: Container(
                          height: 1001,
                          child: StorageDetails(),
                        )),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 400.0),
                            height: 550.0,
                            child: Card(
                              color: bgColor,
                              child: Column(
                                children: [
                                  Container(
                                    // padding: EdgeInsets.all(10.7),
                                    child: Text(
                                      'Weather Station Data',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26.0,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.white,
                                    thickness: 2.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: LineChart(
                                        LineChartData(
                                          minX: 0,
                                          maxX: weatherList.length > 0
                                              ? weatherList.length.toDouble() -
                                                  1
                                              : 0,
                                          minY: 0,
                                          maxY: 100,
                                          titlesData: FlTitlesData(
                                            show: true,
                                            bottomTitles: SideTitles(
                                              showTitles: true,
                                              getTextStyles: (context, value) {
                                                final dateTime = parseDateTime(
                                                    weatherList[value.toInt()]
                                                        ['date']);
                                                final format =
                                                    DateFormat('H:mm');
                                                final formattedTime =
                                                    format.format(dateTime);
                                                return TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 14,
                                                );
                                              },
                                              getTitles: (value) {
                                                final dateTime = parseDateTime(
                                                    weatherList[value.toInt()]
                                                        ['date']);
                                                final format =
                                                    DateFormat('H:mm');
                                                final formattedTime =
                                                    format.format(dateTime);
                                                return formattedTime;
                                              },
                                              margin: 8,
                                            ),
                                            leftTitles: SideTitles(
                                              showTitles: true,
                                              getTextStyles: (context, value) =>
                                                  const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 14,
                                              ),
                                              getTitles: (value) {
                                                return value.toInt().toString();
                                              },
                                              margin: 8,
                                            ),
                                          ),
                                          borderData: FlBorderData(
                                            show: true,
                                            border: Border.all(
                                              color: bgColor,
                                              width: 1,
                                            ),
                                          ),
                                          lineBarsData: [
                                            LineChartBarData(
                                              spots: List.generate(
                                                weatherList.length,
                                                (index) => FlSpot(
                                                  index.toDouble(),
                                                  double.tryParse(
                                                          weatherList[index]
                                                              ['hum_moy']) ??
                                                      0.0,
                                                ),
                                              ),
                                              isCurved: true,
                                              colors: const [
                                                Color.fromARGB(255, 0, 134, 179)
                                              ],
                                              barWidth: 3,
                                              isStrokeCapRound: true,
                                              dotData: FlDotData(show: true),
                                              belowBarData:
                                                  BarAreaData(show: false),
                                            ),
                                            LineChartBarData(
                                              spots: List.generate(
                                                weatherList.length,
                                                (index) => FlSpot(
                                                  index.toDouble(),
                                                  double.tryParse(
                                                          weatherList[index]
                                                              ['temp_moy']) ??
                                                      0.0,
                                                ),
                                              ),
                                              isCurved: true,
                                              colors: const [
                                                Color.fromARGB(255, 255, 153, 0)
                                              ],
                                              barWidth: 3,
                                              isStrokeCapRound: true,
                                              dotData: FlDotData(show: true),
                                              belowBarData:
                                                  BarAreaData(show: false),
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
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 1001.0,
                            child: SfDataGrid(
                              source: freezePanesDataGridSource,
                              frozenColumnsCount: 1,
                              columns: [
                                GridColumn(
                                  columnName: 'date',
                                  label: Container(
                                    padding: EdgeInsets.all(5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'date',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'hum_max',
                                  label: Container(
                                    padding: EdgeInsets.all(8.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Humidity in % max',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'hum_min',
                                  label: Container(
                                    padding: EdgeInsets.all(8.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Humidity in % min',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'hum_moy',
                                  label: Container(
                                    padding: EdgeInsets.all(8.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Humidity in % moy',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'temp_max',
                                  label: Container(
                                    padding: EdgeInsets.all(8.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Temperature in °C max',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'temp_min',
                                  label: Container(
                                    padding: EdgeInsets.all(8.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Temperature in °C min',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'temp_moy',
                                  label: Container(
                                    padding: EdgeInsets.all(8.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Temperature in °C moy',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WeatherDataScreen(),
  ));
}
