import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'jadwal.dart';
import 'longfeed.dart';
import 'utama.dart';
import 'acc.dart';

void main() {
  runApp(ShortTermFeedingPage());
}

class ShortTermFeedingPage extends StatefulWidget {
  const ShortTermFeedingPage({Key? key}) : super(key: key);

  @override
  State<ShortTermFeedingPage> createState() => _ShortTermFeedingPageState();
}

class _ShortTermFeedingPageState extends State<ShortTermFeedingPage> {
  var hour = 0;
  var minute = 0;
  var timeFormat = "AM";
  bool isOn = false; // state to manage on/off button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Short-term feeding',
          style: TextStyle(color: Colors.white),
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
                  child: Text("Account",
                      style: TextStyle(color: Color(0xFF1D5E84))),
                ),
                PopupMenuItem(
                  value: "Home",
                  child:
                      Text("Home", style: TextStyle(color: Color(0xFF1D5E84))),
                ),
                PopupMenuItem(
                  value: "Short-term feeding",
                  child: Text("Short-term feeding",
                      style: TextStyle(color: Color(0xFF1D5E84))),
                ),
                PopupMenuItem(
                  value: "Long-term feeding",
                  child: Text("Long-term feeding",
                      style: TextStyle(color: Color(0xFF1D5E84))),
                ),
                PopupMenuItem(
                  value: "Feeder Schedule",
                  child: Text("Feeder Schedule",
                      style: TextStyle(color: Color(0xFF1D5E84))),
                ),
                PopupMenuItem(
                  value: "Logout",
                  child: Text("Logout",
                      style: TextStyle(color: Color(0xFF1D5E84))),
                ),
              ];
            },
            onSelected: (String value) {
              if (value == "Logout") {
                showLogoutMenu(context);
              } else if (value == "Feeder Schedule") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JadwalPage()),
                );
              } else if (value == "Long-term feeding") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LongTermFeedingPage()),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isOn ? 'Feeding is On' : 'Feeding is Off',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  isOn = !isOn;
                });
                // Call the function to update Firestore
                updateServoStateInFirestore(isOn);
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: isOn ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void updateServoStateInFirestore(bool state) async {
  try {
    await FirebaseFirestore.instance
        .collection('servoData')
        .doc('UJdlF8pk248n3VJ4m0uV') // Ganti dengan ID dokumen yang benar
        .update({'servoPosition': state});
    print('Servo state updated successfully');
  } catch (e) {
    print('Failed to update servo state: $e');
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

void saveDataToDatabase(int hour, int minute, String timeFormat) {
  // Implementasi penyimpanan data ke database
}
