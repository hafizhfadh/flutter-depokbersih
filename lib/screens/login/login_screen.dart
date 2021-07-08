import 'package:depokbersih/core/helper/secure_storage.dart';
import 'package:depokbersih/core/models/login_model.dart';
import 'package:depokbersih/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? userCredential;
  AuthModel? _authModel;
  bool _showPassword = false;
  SnackBar? snackBar;

  Future<void> _checkIfLogin() async {
    try {
      if (_auth.currentUser!.uid == await SecureStorage().getUuid()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(
              userCredential: _auth.currentUser,
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _login(AuthModel loginModel) async {
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
          email: loginModel.email, password: loginModel.password);
      await SecureStorage().persistEmailAndUuid(
          userCredential!.user!.email!, userCredential!.user!.uid);
      snackBar =
          SnackBar(content: Text('Welcome ${userCredential!.user!.email}.'));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(
            userCredential: userCredential!.user,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackBar = SnackBar(content: Text('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        snackBar =
            SnackBar(content: Text('Wrong password provided for that user.'));
      }
      snackBar = SnackBar(content: Text('Check your Email or Password.'));
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(snackBar!);
    }
  }

  Future<void> _register(AuthModel loginModel) async {
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: loginModel.email, password: loginModel.password);
      await SecureStorage().persistEmailAndUuid(
          userCredential!.user!.email!, userCredential!.user!.uid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(
            userCredential: userCredential!.user,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackBar = SnackBar(content: Text('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        snackBar =
            SnackBar(content: Text('Wrong password provided for that user.'));
      }
      snackBar = SnackBar(content: Text('Check your Email or Password.'));
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(snackBar!);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfLogin();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(
                "assets/svg/login.svg",
                width: 300,
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "DEPOKBERSIH",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.blueAccent),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _emailEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    obscureText: _showPassword,
                    controller: _passwordEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        child: Icon(_showPassword
                            ? Icons.lock_outline
                            : Icons.lock_open_outlined),
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _authModel = AuthModel(
                            _emailEditingController.text,
                            _passwordEditingController.text,
                          );
                          _login(_authModel!);
                        },
                        child: Text("Login"),
                      ),
                      Text("OR"),
                      ElevatedButton(
                        onPressed: () {
                          _authModel = AuthModel(
                            _emailEditingController.text,
                            _passwordEditingController.text,
                          );
                          _register(_authModel!);
                        },
                        child: Text("Register"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
