import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refuelings_collector/models/refueling.dart';
import 'package:refuelings_collector/models/refuelings.dart';
import 'package:refuelings_collector/screens/form_page.dart';
import 'package:refuelings_collector/screens/root_page.dart';
import 'package:refuelings_collector/services/api_requester.dart';
import 'package:refuelings_collector/states/current_refueling.dart';
import 'package:refuelings_collector/states/current_user.dart';
import 'package:refuelings_collector/widgets/refueling_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Refuelings> _refuelings;

  void _fetchRefuelings() {
    setState(() {
      _refuelings = ApiRequester().getRefuelings();
    });
  }

  Future _refreshRefuelings() async {
    setState(() {
      _fetchRefuelings();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchRefuelings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Refuelings Collector',
              style: TextStyle(
                fontFamily: 'Pacifico',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.power_settings_new_rounded,
              color: Colors.red,
            ),
            onPressed: () {
              context.read<CurrentUser>().signOutUser();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => RootPage(),
                ),
                (route) => false,
              );
            },
          )
        ],
        elevation: 0,
      ),
      body: FutureBuilder<Refuelings>(
        future: _refuelings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.hasData) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Total Average Fuel Consumption: ${snapshot.data.totalAvg} L/100 KM',
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.list.length,
                      itemBuilder: (context, index) {
                        Refueling refueling =
                            snapshot.data.list.elementAt(index);
                        return RefuelingCard(refueling: refueling);
                      },
                    ),
                    onRefresh: _refreshRefuelings,
                  ),
                ),
              ],
            );
          } else {
            return RefreshIndicator(
              child: Center(
                child: Text(
                  'Nothing to show 🤷',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              onRefresh: _refreshRefuelings,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CurrentRefueling>().resetAverageFuel();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => RefuelingFormPage(
                    refueling: Refueling(),
                  )));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
