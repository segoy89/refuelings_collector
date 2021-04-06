import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refuelings_collector/models/refueling.dart';
import 'package:refuelings_collector/screens/home_page.dart';
import 'package:refuelings_collector/screens/root_page.dart';
import 'package:refuelings_collector/states/current_refueling.dart';
import 'package:refuelings_collector/states/current_user.dart';

class RefuelingFormPage extends StatelessWidget {
  final Refueling refueling;
  RefuelingFormPage({Key key, @required this.refueling}) : super(key: key);

  final TextEditingController _consumption = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  _validatePresence(String value) {
    if (value == null || value.isEmpty) {
      return 'Must be filled up!';
    } else if (num.tryParse(value) == 0) {
      return 'Value must be other than 0!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _consumption.text = (context.watch<CurrentRefueling>().averageFuel ??
            refueling.avgFuelConsumption)
        .toStringAsFixed(2);

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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (refueling.id != null) ? 'Edit entry' : 'New entry',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  onChanged: (value) {
                    refueling.liters = double.parse(
                      (value.isEmpty || value == '.') ? '0' : value,
                    );
                    context.read<CurrentRefueling>().refreshAverageFuel(
                        refueling.liters, refueling.kilometers);
                  },
                  validator: (value) => _validatePresence(value),
                  initialValue: refueling.liters.toStringAsFixed(2),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d{0,2}"))
                  ],
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.local_gas_station),
                    labelText: 'Liters',
                    suffixText: 'L',
                  ),
                ),
                TextFormField(
                  onChanged: (value) {
                    refueling.kilometers = double.parse(
                      (value.isEmpty || value == '.') ? '0' : value,
                    );
                    context.read<CurrentRefueling>().refreshAverageFuel(
                        refueling.liters, refueling.kilometers);
                  },
                  validator: (value) => _validatePresence(value),
                  initialValue: refueling.kilometers.toStringAsFixed(2),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d{0,2}"))
                  ],
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.add_road),
                    labelText: 'Distance',
                    suffixText: 'KM',
                  ),
                ),
                TextFormField(
                  enabled: false,
                  controller: _consumption,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d{0,2}"))
                  ],
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.time_to_leave),
                    labelText: 'Average fuel consumption',
                    suffixText: 'L/100 KM',
                  ),
                ),
                TextFormField(
                  onChanged: (value) => refueling.cost = value,
                  initialValue: refueling.cost,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d{0,2}"))
                  ],
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.money),
                    labelText: 'Cost',
                    suffixText: 'PLN',
                  ),
                ),
                TextFormField(
                  onChanged: (value) => refueling.note = value,
                  initialValue: refueling.note,
                  maxLines: 4,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      transform: Matrix4.translationValues(0, -20, 0),
                      child: Icon(Icons.sticky_note_2),
                    ),
                    labelText: 'Note',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            String _message =
                await context.read<CurrentRefueling>().saveEntry(refueling);
            if (_message == 'success')
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false);
            else
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(_message)));
          }
        },
        icon: Icon(Icons.check),
        label: Text(
          context.watch<CurrentRefueling>().isLoading ? 'Saving...' : 'Save',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
