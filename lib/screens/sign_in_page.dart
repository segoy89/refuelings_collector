import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refuelings_collector/screens/home_page.dart';
import 'package:refuelings_collector/states/current_user.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _loginUser(String email, String password, BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      if (await _currentUser.signInUser(email, password)) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => HomePage()), (_) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect email/password!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Refuelings Collector',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50.0,
                vertical: 20.0,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _userController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'email',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'password',
                        prefixIcon: Icon(Icons.lock_outline)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      _loginUser(_userController.text, _passwordController.text,
                          context);
                    },
                    icon: Icon(
                      Icons.login,
                      size: 15,
                    ),
                    label: context.watch<CurrentUser>().isLoading
                        ? Text('Signing In...')
                        : Text('Sign In'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
