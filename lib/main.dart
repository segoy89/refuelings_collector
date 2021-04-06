import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refuelings_collector/screens/root_page.dart';
import 'package:refuelings_collector/states/current_refueling.dart';
import 'package:refuelings_collector/states/current_user.dart';

void main() {
  runApp(RefuelingsApp());
}

class RefuelingsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentUser>(create: (_) => CurrentUser()),
        ChangeNotifierProvider<CurrentRefueling>(
            create: (_) => CurrentRefueling()),
      ],
      child: MaterialApp(
        title: 'Refuelings Collector',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.green[700],
          brightness: Brightness.dark,
          fontFamily: 'Montserrat',
          scaffoldBackgroundColor: Colors.grey[900],
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith(
              (states) => Colors.grey,
            )),
          ),
        ),
        home: RootPage(),
      ),
    );
  }
}
