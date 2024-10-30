import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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
              
              List<Rate> limitedRates = rateService.rates.take(10).toList();

              List<charts.Series<Rate, String>> series = [
                charts.Series(
                  id: 'ExchangeRates',
                  data: limitedRates,
                  domainFn: (Rate rate, _) => rate.source + ' to ' + rate.destination,
                  measureFn: (Rate rate, _) => double.tryParse(rate.rate) ?? 0,
                  labelAccessorFn: (Rate rate, _) => rate.rate,
                )
              ];
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: 400,
                  width: 800,
                  child: charts.BarChart(
                    series,
                    animate: true,
                    vertical: false,
                    barRendererDecorator: charts.BarLabelDecorator<String>(),
                    domainAxis: charts.OrdinalAxisSpec(),
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