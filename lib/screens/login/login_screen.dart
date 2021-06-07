import 'package:depokbersih/core/models/login_model.dart';
import 'package:depokbersih/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  LoginModel? _loginModel;
  bool _showPassword = false;
  SnackBar? snackBar;

  Future<void> login(LoginModel loginModel) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: loginModel.email, password: loginModel.password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(
            userCredential: userCredential.user,
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
      snackBar =
      SnackBar(content: Text('Check your Email or Password.'));
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(snackBar!);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
              ElevatedButton(
                onPressed: () {
                  _loginModel = LoginModel(_emailEditingController.text,
                      _passwordEditingController.text);
                  login(_loginModel!);
                },
                child: Text("Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
