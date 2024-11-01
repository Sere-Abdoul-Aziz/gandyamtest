import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/rate.dart';
import 'services/rate_service.dart';
import 'exchange_rates_page.dart';
import 'exchange_rates_chart_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RateService>(
      create: (context) => RateService()..autoRefreshRates(),
      child: MaterialApp(
        title: 'Finance App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.blue),
            bodyText1: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<RateService>(context, listen: false).getRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance App'),
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/profil.png'),
            onBackgroundImageError: (exception, stackTrace) {
              print('Error loading image: $exception');
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text('Refresh Rates'),
              onTap: () async {
                await Provider.of<RateService>(context, listen: false).refreshRates();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.table_chart),
              title: Text('View Rates'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExchangeRatesPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('View Rates Chart'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExchangeRatesChartPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () async {
                    await Provider.of<RateService>(context, listen: false).refreshRates();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 24),
                        SizedBox(width: 8),
                        Text('Refresh Rates', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExchangeRatesPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.table_chart, size: 24),
                        SizedBox(width: 8),
                        Text('View Rates', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExchangeRatesChartPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bar_chart, size: 24),
                        SizedBox(width: 8),
                        Text('View Rates Chart', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text('Recent Transactions', style: Theme.of(context).textTheme.headline6),
              SizedBox(height: 16),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(text: 'Recent'),
                          Tab(text: 'This Month'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ListView(
                              children: [
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: Icon(Icons.monetization_on),
                                    title: Text('Transaction 1'),
                                    subtitle: Text('Details of transaction 1'),
                                    trailing: Text('- \$100'),
                                  ),
                                ),
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: Icon(Icons.monetization_on),
                                    title: Text('Transaction 2'),
                                    subtitle: Text('Details of transaction 2'),
                                    trailing: Text('- \$200'),
                                  ),
                                ),
                              ],
                            ),
                            ListView(
                              children: [
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: Icon(Icons.monetization_on),
                                    title: Text('Transaction 3'),
                                    subtitle: Text('Details of transaction 3'),
                                    trailing: Text('- \$300'),
                                  ),
                                ),
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: Icon(Icons.monetization_on),
                                    title: Text('Transaction 4'),
                                    subtitle: Text('Details of transaction 4'),
                                    trailing: Text('- \$400'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
