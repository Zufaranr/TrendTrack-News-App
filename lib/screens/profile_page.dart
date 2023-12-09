import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trendtrack/components/botnavbar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? _user;
  String _username = "", _phoneNumber = "";

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _loadPhoneNumber();
  }

  Future<void> _loadPhoneNumber() async {
    if (_user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await _firestore.collection('users').doc(_user!.uid).get();

        if (userSnapshot.exists) {
          setState(() {
            _username = userSnapshot.get('username') ?? "";
            _phoneNumber = userSnapshot.get('phoneNumber') ?? "";
          });
        }
      } catch (e) {
        print("Error loading phone number: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to the home screen when the back button is pressed
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BottNavBar()),
          (route) => false,
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'My Profile',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/images/zufar.jpg'),
              ),
              SizedBox(height: 20),
              Text(
                _username,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  leading: Icon(Icons.email),
                  title: Text('${_user?.email}'),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(_phoneNumber),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
