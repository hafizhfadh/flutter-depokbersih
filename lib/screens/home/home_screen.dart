import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depokbersih/core/helper/secure_storage.dart';
import 'package:depokbersih/screens/collection/form_screen.dart';
import 'package:depokbersih/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.userCredential}) : super(key: key);

  final User? userCredential;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _logout() async {
    await SecureStorage().removeEmailAndUuid();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AuthScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => FormScreen(userCredential: widget.userCredential,),
            ),
          ),
          child: Icon(Icons.add),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.only(top: 20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.userCredential!.email}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          ElevatedButton(
                              onPressed: _logout, child: Text("LOGOUT"))
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('trash')
                      .where("uid", isEqualTo: widget.userCredential!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (!streamSnapshot.hasData) return Text('Loading data... Please wait');
                    if (streamSnapshot.hasData) {
                      return ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                          return Card(
                            margin: EdgeInsets.all(10),
                            child: ListTile(
                              title: Text(documentSnapshot['type']),
                              subtitle: Text(documentSnapshot['weight'].toString()),
                            ),
                          );
                        },
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
