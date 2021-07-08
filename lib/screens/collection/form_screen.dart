import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key, this.userCredential}) : super(key: key);
  final User? userCredential;

  @override
  _FormScreenState createState() => _FormScreenState();
}

enum TrashType { organic, inorganic }

class _FormScreenState extends State<FormScreen> {

  TrashType val = TrashType.organic;
  TextEditingController _weightController = TextEditingController();
  SnackBar? snackBar;

  Future<void> _save() async {
    CollectionReference trash = FirebaseFirestore.instance.collection('trash');
    try {
      return trash.add({
        'uid': widget.userCredential!.uid, // John Doe
        'weight': _weightController.text, // Stokes and Sons
        'type': val == TrashType.organic ? "Organic" : "Inorganic" // 42
      }).then((value) {
        snackBar = SnackBar(content: Text('Data berhasil disimpan.'));
      })
          .catchError((error) => print("Failed to add user: $error"));
    } catch(e) {
      print(e);
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(snackBar!);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Create"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            SizedBox(height: 30,),
            Text("Trash Type", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            ListTile(
              title: Text("Organic"),
              leading: Radio(
                value: TrashType.organic,
                groupValue: val,
                onChanged: (TrashType? value) {
                  setState(() {
                    val = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Inorganic"),
              leading: Radio(
                value: TrashType.inorganic,
                groupValue: val,
                onChanged: (TrashType? value) {
                  setState(() {
                    val = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 20,),
            Text("Trash Weight (KG)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            TextField(
              keyboardType: TextInputType.number,
              controller: _weightController,
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: _save, child: Text("SAVE"))
          ],
        ),
      ),
    );
  }
}
