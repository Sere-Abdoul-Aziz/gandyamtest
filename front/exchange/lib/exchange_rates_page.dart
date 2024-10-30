import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/rate_service.dart';

class ExchangeRatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exchange Rates'),
      ),
      body: Center(
        child: Consumer<RateService>(
          builder: (context, rateService, child) {
            if (rateService.rates.isEmpty) {
              return CircularProgressIndicator();
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Source')),
                      DataColumn(label: Text('Destination')),
                      DataColumn(label: Text('Rate')),
                    ],
                    rows: rateService.rates.map((rate) {
                      return DataRow(cells: [
                        DataCell(Text(rate.source)),
                        DataCell(Text(rate.destination)),
                        DataCell(Text(rate.rate)),
                      ]);
                    }).toList(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}