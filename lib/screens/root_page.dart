import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refuelings_collector/screens/home_page.dart';
import 'package:refuelings_collector/screens/sign_in_page.dart';
import 'package:refuelings_collector/screens/splash.dart';
import 'package:refuelings_collector/states/current_user.dart';

enum AuthStatus {
  uninitialized,
  notLoggedIn,
  loggedIn,
}

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.uninitialized;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    bool _hasActiveToken = await context.watch<CurrentUser>().hasValidToken();
    setState(() {
      _authStatus =
          _hasActiveToken ? AuthStatus.loggedIn : AuthStatus.notLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_authStatus) {
      case AuthStatus.notLoggedIn:
        page = SignInPage();
        break;
      case AuthStatus.loggedIn:
        page = HomePage();
        break;
      default:
        page = Splash();
        break;
    }

    return page;
  }
}
