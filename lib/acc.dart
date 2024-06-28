import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'longfeed.dart';
import 'shortfeed.dart';
import 'utama.dart';
import 'jadwal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AccPage(),
    );
  }
}

class AccPage extends StatefulWidget {
  @override
  _AccPageState createState() => _AccPageState();
}

class _AccPageState extends State<AccPage> {
  void _deleteUserDocument(String documentId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .delete()
        .then((value) => print('User document deleted'))
        .catchError((error) => print('Failed to delete user document: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF1D5E84),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "Account",
                  child: Text(
                    "Account",
                    style: TextStyle(
                      color: Color(0xFF1D5E84),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: "Home",
                  child: Text(
                    "Home",
                    style: TextStyle(
                      color: Color(0xFF1D5E84),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: "Short-term feeding",
                  child: Text(
                    "Short-term feeding",
                    style: TextStyle(
                      color: Color(0xFF1D5E84),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: "Long-term feeding",
                  child: Text(
                    "Long-term feeding",
                    style: TextStyle(
                      color: Color(0xFF1D5E84),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: "Feeder Schedule",
                  child: Text(
                    "Feeder Schedule",
                    style: TextStyle(
                      color: Color(0xFF1D5E84),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: "Logout",
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: Color(0xFF1D5E84),
                    ),
                  ),
                ),
              ];
            },
            onSelected: (String value) {
              if (value == "Logout") {
                showLogoutMenu(context);
              } else if (value == "Long-term feeding") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LongTermFeedingPage()),
                );
              } else if (value == "Short-term feeding") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShortTermFeedingPage()),
                );
              } else if (value == "Home") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              } else if (value == "Feeder Schedule") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JadwalPage()),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final userData = snapshot.data!.docs;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: userData.map((DocumentSnapshot document) {
                final username = document['username'];
                final documentId = document.id; // ID dokumen pengguna

                return Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: 330,
                      height: 110,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFDADADA),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteUserDocument(
                                    documentId); // Panggil fungsi untuk menghapus dokumen
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Color(0xFFF05A28),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        username,
                                        style: TextStyle(
                                          color: Color(0xFFF05A28),
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  void showLogoutMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tidak'),
            ),
          ],
        );
      },
    );
  }
}
