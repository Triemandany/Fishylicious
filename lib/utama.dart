import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'login.dart'; // Pastikan file login.dart sudah diimport
import 'jadwal.dart';
import 'shortfeed.dart';
import 'longfeed.dart';
import 'acc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String nextFeedingTime = "halooo";
  String nextFeedingDay = "";
  String formattedDuration = "00:00:00"; // Inisialisasi awal

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk memperbarui waktu makan berikutnya saat halaman dimuat
    updateNextFeedingTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'lib/assets/images/Logo.png',
              height: 30,
            ),
            SizedBox(width: 10),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "Account",
                  child: Text("Account"),
                ),
                PopupMenuItem(
                  value: "Home",
                  child: Text("Home"),
                ),
                PopupMenuItem(
                  value: "Short-term feeding",
                  child: Text("Short-term feeding"),
                ),
                PopupMenuItem(
                  value: "Long-term feeding",
                  child: Text("Long-term feeding"),
                ),
                PopupMenuItem(
                  value: "Feeder Schedule",
                  child: Text("Feeder Schedule"),
                ),
                PopupMenuItem(
                  value: "Logout",
                  child: Text("Logout"),
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
              } else if (value == "Short-term feeding") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShortTermFeedingPage()),
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
        iconTheme: IconThemeData(size: 24),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('feeding_schedule')
            .doc('UJdlF8pk248n3VJ4m0uV')
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Data not found"));
          }

          var data = snapshot.data!;
          var days = data['days'];
          var time1 = data['time1'];

          if (days is List && days.isNotEmpty) {
            var feedingDay = days[0];
            var parsedTime = DateFormat("HH:mm a").parse(time1);
            var now = DateTime.now();
            var nextFeedingDateTime =
                _getNextFeedingDateTime(feedingDay, parsedTime);
            var difference = nextFeedingDateTime.difference(now);

            // Update nilai formattedDuration
            formattedDuration = _formatDuration(difference);

            if (difference.isNegative) {
              // Jika perbedaan waktu negatif (waktu berikutnya sudah lewat)
              formattedDuration = "Has passed";
            } else {
              formattedDuration = _formatDuration(difference);
            }

            // Panggil fungsi saveNextFeedingTime untuk menyimpan data terbaru
            saveNextFeedingTime(formattedDuration);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Welcome to Fishy Licious!",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 26),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          width: 300,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Color(0xFF1D5E84),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                        "Next feeding time",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                        "$formattedDuration",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                        "Your connections:",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                        "Online",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10.0, right: 16.0),
                                  child: Image.asset(
                                    'lib/assets/images/akuarium.png',
                                    height: 120,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShortTermFeedingPage()),
                              );
                            },
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Color(0xFFF05A28),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "Short-term feeding",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Image.asset(
                                      'lib/assets/images/ikan1.png',
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LongTermFeedingPage()),
                              );
                            },
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Color(0xFFF05A28),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "Long-term feeding",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Image.asset(
                                      'lib/assets/images/ikan2.png',
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => JadwalPage()),
                                );
                              },
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF05A28),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "Feeder Schedule",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Image.asset(
                                      'lib/assets/images/jadwal.png',
                                      width: 100,
                                      height: 100,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text("Data not found"));
          }
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

  DateTime _getNextFeedingDateTime(String dayName, DateTime time) {
    var nextDate = _getNextDateForDay(dayName);

    return DateTime(
        nextDate.year, nextDate.month, nextDate.day, time.hour, time.minute);
  }

  String _formatDuration(Duration duration) {
    return '${duration.inHours} Hours';
  }

  DateTime _getNextDateForDay(String dayName) {
    var now = DateTime.now();
    DateFormat('EEEE').format(now);

    while (DateFormat('EEEE').format(now) != dayName) {
      now = now.add(Duration(days: 1));
    }

    return now;
  }

  void saveNextFeedingTime(String nextFeedingTime) {
    FirebaseFirestore.instance
        .collection('feeding_schedule')
        .doc('UJdlF8pk248n3VJ4m0uV') // Ganti dengan ID dokumen yang sesuai
        .update({
          'next_feeding': nextFeedingTime,
        })
        .then((value) => print("Waktu berikutnya untuk memberi makan disimpan"))
        .catchError(
            (error) => print("Gagal menyimpan waktu berikutnya: $error"));
  }

  void updateNextFeedingTime() {
    var formattedDuration =
        _formatDuration(Duration(hours: 0, minutes: 0, seconds: 0));
    saveNextFeedingTime(formattedDuration);
  }
}
