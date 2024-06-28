import 'package:flutter/material.dart';
import 'login.dart';
import 'jadwal.dart';
import 'shortfeed.dart';
import 'utama.dart';
import 'acc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: LongTermFeedingPage(),
  ));
}

class LongTermFeedingPage extends StatefulWidget {
  const LongTermFeedingPage({super.key});

  @override
  _LongTermFeedingPageState createState() => _LongTermFeedingPageState();
}

class _LongTermFeedingPageState extends State<LongTermFeedingPage> {
  TimeOfDay _timeOfDay1 = const TimeOfDay(hour: 00, minute: 00);
  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  List<String> _selectedDays = [];

  void _showDayPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DayPickerDialog(
          daysOfWeek: _daysOfWeek,
          selectedDays: _selectedDays,
          onSelectedDaysChanged: (List<String> newSelectedDays) {
            setState(() {
              _selectedDays = newSelectedDays;
              _sortSelectedDays();
            });
          },
        );
      },
    );
  }

  // Fungsi untuk mengurutkan hari yang dipilih
  void _sortSelectedDays() {
    _selectedDays.sort(
        (a, b) => _daysOfWeek.indexOf(a).compareTo(_daysOfWeek.indexOf(b)));
  }

  void _showTimePicker(int timeNumber) {
    showTimePicker(
      context: context,
      initialTime: _timeOfDay1,
    ).then((value) {
      setState(() {
        if (value != null) {
          switch (timeNumber) {
            case 1:
              _timeOfDay1 = value;
              break;
            case 2:
              break;
          }
        }
      });
    });
  }

  void _playButtonPressed() async {
    // Initialize Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Add data to Firestore
      await firestore
          .collection('feeding_schedule')
          .doc('UJdlF8pk248n3VJ4m0uV')
          .set({
        'days': _selectedDays,
        'time1': _timeOfDay1.format(context),
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The data was successfully saved to Firestore'),
        ),
      );

      // Redirect to JadwalPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => JadwalPage()),
      );
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save data: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Long-term feeding',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1D5E84),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: "Account",
                  child: Text("Account",
                      style: TextStyle(color: Color(0xFF1D5E84))),
                ),
                const PopupMenuItem(
                  value: "Home",
                  child:
                      Text("Home", style: TextStyle(color: Color(0xFF1D5E84))),
                ),
                const PopupMenuItem(
                  value: "Short-term feeding",
                  child: Text("Short-term feeding",
                      style: TextStyle(color: Color(0xFF1D5E84))),
                ),
                const PopupMenuItem(
                  value: "Long-term feeding",
                  child: Text("Long-term feeding",
                      style: TextStyle(color: Color(0xFF1D5E84))),
                ),
                const PopupMenuItem(
                  value: "Feeder Schedule",
                  child: Text("Feeder Schedule",
                      style: TextStyle(color: Color(0xFF1D5E84))),
                ),
                const PopupMenuItem(
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
              } else if (value == "Short-term feeding") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ShortTermFeedingPage()),
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
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 380,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFF05A28),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Days : ${_selectedDays.length > 2 ? "${_selectedDays.take(2).join(", ")}, ..." : _selectedDays.join(", ")}',
                        style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Time : ${_timeOfDay1.format(context)}',
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Image.asset(
                        'lib/assets/images/pulauindo.png',
                        width: 300, // Adjust width as needed
                        height: 90, // Adjust height as needed
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _showDayPicker,
                    child: const Text('Choose Days'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _showTimePicker(1),
                    child: const Text('Choose Time'),
                  ),
                  const SizedBox(height: 10),
                  IconButton(
                    onPressed: _playButtonPressed,
                    icon: const Icon(Icons.play_arrow),
                    iconSize: 50,
                    color: const Color(0xFFF05A28),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showLogoutMenu(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}

class DayPickerDialog extends StatefulWidget {
  final List<String> daysOfWeek;
  final List<String> selectedDays;
  final Function(List<String>) onSelectedDaysChanged;

  const DayPickerDialog({
    super.key,
    required this.daysOfWeek,
    required this.selectedDays,
    required this.onSelectedDaysChanged,
  });

  @override
  _DayPickerDialogState createState() => _DayPickerDialogState();
}

class _DayPickerDialogState extends State<DayPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Days'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.daysOfWeek.map((String day) {
            return ListTile(
              title: Text(day),
              trailing: Checkbox(
                value: widget.selectedDays.contains(day),
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null && value) {
                      widget.selectedDays.add(day);
                    } else {
                      widget.selectedDays.remove(day);
                    }
                    widget.onSelectedDaysChanged(widget.selectedDays);
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
