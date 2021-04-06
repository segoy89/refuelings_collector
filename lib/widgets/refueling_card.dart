import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:refuelings_collector/models/refueling.dart';
import 'package:refuelings_collector/screens/form_page.dart';
import 'package:refuelings_collector/screens/home_page.dart';
import 'package:refuelings_collector/states/current_refueling.dart';

class RefuelingCard extends StatelessWidget {
  final Refueling refueling;

  RefuelingCard({Key key, @required this.refueling}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.275,
      secondaryActions: <Widget>[
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: EdgeInsets.only(left: 2.0),
          padding: EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 2.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconSlideAction(
            caption: 'Edit',
            color: Colors.grey[800],
            icon: Icons.edit,
            onTap: () {
              context
                  .read<CurrentRefueling>()
                  .refreshAverageFuel(refueling.liters, refueling.kilometers);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => RefuelingFormPage(
                        refueling: refueling,
                      )));
            },
          ),
        ),
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: EdgeInsets.only(right: 4.0),
          padding: EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 2.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Center(
                      child: Text('Delete'),
                    ),
                    content:
                        Text('Are you sure you want to delete this entry?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'No, wait!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          String _message = await context
                              .read<CurrentRefueling>()
                              .deleteEntry(refueling);
                          if (_message == 'success')
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => HomePage()),
                                (route) => false);
                        },
                        child: Text(
                          'Yes, delete it!',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      )
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
      child: Card(
        child: ListTile(
          title: Row(
            children: [
              Text(
                'Avg fuel consumption: ',
              ),
              Text(
                refueling.avgFuelConsumption.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kilometers: ${refueling.kilometers}',
                    ),
                    Text(
                      'Liters: ${refueling.liters}',
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text('Cost: ${refueling.cost ?? '---'} PLN'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Created at: ${DateFormat('yyyy-MM-dd HH:m:s').format(refueling.createdAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
