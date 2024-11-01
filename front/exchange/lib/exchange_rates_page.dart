import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/rate.dart';
import 'services/rate_service.dart';

class ExchangeRatesPage extends StatefulWidget {
  @override
  _ExchangeRatesPageState createState() => _ExchangeRatesPageState();
}

class _ExchangeRatesPageState extends State<ExchangeRatesPage> {
  String _searchQuery = '';
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exchange Rates'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: Consumer<RateService>(
          builder: (context, rateService, child) {
            if (rateService.rates.isEmpty) {
              return CircularProgressIndicator();
            } else {
              List<Rate> filteredRates = rateService.rates.where((rate) {
                return rate.source.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                       rate.destination.toLowerCase().contains(_searchQuery.toLowerCase());
              }).toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          sortColumnIndex: _sortColumnIndex,
                          sortAscending: _sortAscending,
                          columns: [
                            DataColumn(
                              label: Text('Source'),
                              onSort: (columnIndex, ascending) {
                                setState(() {
                                  _sortColumnIndex = columnIndex;
                                  _sortAscending = ascending;
                                  filteredRates.sort((a, b) => a.source.compareTo(b.source));
                                  if (!ascending) {
                                    filteredRates = filteredRates.reversed.toList();
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              label: Text('Destination'),
                              onSort: (columnIndex, ascending) {
                                setState(() {
                                  _sortColumnIndex = columnIndex;
                                  _sortAscending = ascending;
                                  filteredRates.sort((a, b) => a.destination.compareTo(b.destination));
                                  if (!ascending) {
                                    filteredRates = filteredRates.reversed.toList();
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              label: Text('Rate'),
                              onSort: (columnIndex, ascending) {
                                setState(() {
                                  _sortColumnIndex = columnIndex;
                                  _sortAscending = ascending;
                                  filteredRates.sort((a, b) => double.parse(a.rate).compareTo(double.parse(b.rate)));
                                  if (!ascending) {
                                    filteredRates = filteredRates.reversed.toList();
                                  }
                                });
                              },
                            ),
                          ],
                          rows: filteredRates.map((rate) {
                            return DataRow(cells: [
                              DataCell(Text(rate.source)),
                              DataCell(Text(rate.destination)),
                              DataCell(Text(rate.rate)),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}