import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'models/rate.dart';
import 'services/rate_service.dart';

class ExchangeRatesChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exchange Rates Chart'),
      ),
      body: Center(
        child: Consumer<RateService>(
          builder: (context, rateService, child) {
            if (rateService.rates.isEmpty) {
              return CircularProgressIndicator();
            } else {
             
              List<Rate> limitedRates = rateService.rates
                  .where((rate) => double.tryParse(rate.rate) != null)
                  .take(10)
                  .toList();

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: limitedRates.map((rate) {
                      return BarChartGroupData(
                        x: limitedRates.indexOf(rate),
                        barRods: [
                          BarChartRodData(
                            toY: double.tryParse(rate.rate) ?? 0,
                            color: Colors.blue,
                            width: 16,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            int index = value.toInt();
                            if (index < limitedRates.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  limitedRates[index].source + ' to ' + limitedRates[index].destination,
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            }
                            return Text('');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    gridData: FlGridData(show: true),
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