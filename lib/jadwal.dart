import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'longfeed.dart';
import 'shortfeed.dart';
import 'utama.dart';
import 'acc.dart';

void main() {
  runApp(JadwalPage());
}

class JadwalPage extends StatefulWidget {
  @override
  _JadwalPageState createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  bool isSwitched1 = false;
  bool isSwitched2 = false;
  List<dynamic> days = [];
  String time1 = '';

  @override
  void initState() {
    super.initState();
    fetchData(); // Memanggil fungsi fetchData saat initState dipanggil
  }

  Future<void> fetchData() async {
    try {
      // Mengambil dokumen dari Firestore
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('feeding_schedule')
          .doc('UJdlF8pk248n3VJ4m0uV')
          .get();

      // Memeriksa apakah dokumen ada dan data tidak kosong
      if (doc.exists) {
        // Mengambil nilai dari field days (yang merupakan List)
        days = doc['days'];

        // Mengambil nilai dari field time1 (yang merupakan String)
        time1 = doc['time1'];

        // Memanggil setState untuk memperbarui ftampilan dengan data baru
        setState(() {});
      } else {
        print('Dokumen tidak ditemukan!');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feeder Schedule',
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
              } else if (value == "Account") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccPage()),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Container(
              width: 350,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFDADADA),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Schedule',
                                style: TextStyle(
                                  color: Color(0xFFF05A28),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              SizedBox(height: 14),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // Rata kiri
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        days.isNotEmpty
                                            ? days[0]
                                            : 'Loading...',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 18,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            time1.isNotEmpty
                                                ? time1
                                                : 'Loading...',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
        ),
      ),
    );
  }
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
