import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late int _inputTime;
  late Duration _duration;
  late Timer _timer;
  bool _isPaused = false; // Variable yang menunjukkan apakah waktu ter pause
  bool _isTimeUp = false; // Variable yang menunjukkan apakah waktu sudah habis
  bool _isStarted = false; // Variable yang menunjukkan apakah countdown sudah dimulai

  @override
  void initState() {
    super.initState();
    _inputTime = 0;
    _duration = Duration(seconds: 0);
  }

  void _startCountdown() {
    if (_inputTime > 0) {
      _duration = Duration(seconds: _inputTime);
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (!_isPaused) {
          setState(() {
            if (_duration.inSeconds > 0) {
              _duration -= Duration(seconds: 1);
            } else {
              _timer.cancel();
              _isTimeUp = true; // bertujuan untuk meengatur waktu habis saat countdown selesai
            }
          });
        }
      });
      _isStarted = true; // bertujuan untuk ngeset countdown untuk dimulai setelah menekan tombol Start
    }
  }

  void _pauseCountdown() {
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeCountdown() {
    setState(() {
      _isPaused = false;
    });
  }

  void _resetCountdown() {
    _timer.cancel();
    setState(() {
      _duration = Duration(seconds: 0);
      _isPaused = false;
      _isTimeUp = false; // Reset variable waktu habis saat mereset countdown
      _isStarted = false; // Reset variable countdown sudah dimulai saat mereset countdown
    });
  }

  void _restartCountdown() {
    setState(() {
      _inputTime = 0;
      _duration = Duration(seconds: 0);
      _isPaused = false;
      _isTimeUp = false;
      _isStarted = false;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Ultimate Countdown Timer'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient (
            colors: [
              Colors.blue,
                Colors.purple,
            ],
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter time (seconds)',
                labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
  keyboardType: TextInputType.number,
  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
  onChanged: (value) {
    setState(() {
      _inputTime = int.tryParse(value) ?? 0;
    });
  },
),
            
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isStarted ? null : _startCountdown,
              child: Text('Start'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 253, 0, 232),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      _isTimeUp ? 'Times Up!!' : '${_duration.inHours.toString().padLeft(2, '0')}:${(_duration.inMinutes % 60).toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: _isTimeUp ? 20 : 64, 
                        color: _isTimeUp ? Color.fromARGB(255, 244, 54, 54) : Colors.black,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Roboto'
  ),
),
                    SizedBox(height: 20),
                    if (_isTimeUp)
                      ElevatedButton(
                        onPressed: _restartCountdown,
                        child: Text('Restart?'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 253, 0, 232),
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: _isPaused ? _resumeCountdown : _pauseCountdown,
                            child: Text(_isPaused ? 'Resume' : 'Pause'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: _resetCountdown,
                            child: Text('Reset'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
