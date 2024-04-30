import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tflite_audio/tflite_audio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _sound = "Press the button to start";
  bool _recording = false;
  late Stream<Map<dynamic, dynamic>> result;

  Future<void> _sendEmail() async {
    final Email email = Email(
        body: '',
        subject: '[SoundSee Feedback]',
        recipients: ['dwaithmk@gmail.com'],
        cc: [],
        bcc: [],
        attachmentPaths: [],
        isHTML: false);
    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sorry, an error occurred.'),
        ),
      );
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    TfliteAudio.loadModel(
      model: 'lib/assets/model/soundclassifier_with_metadata.tflite',
      label: 'lib/assets/model/labels.txt',
      inputType: 'rawAudio',
      numThreads: 1,
      isAsset: true,
    );
  }

  void _recorder() async {
    String recognition = "";
    if (!_recording) {
      setState(() => _recording = true);
      result = TfliteAudio.startAudioRecognition(
        numOfInferences: 20,
        sampleRate: 44100,
        bufferSize: 43420,
      );
      result.listen(
        (event) {
          recognition = event["recognitionResult"];
        },
      ).onDone(
        () async {
          setState(
            () {
              _recording = false;
              _sound = recognition.split(" ")[1];
            },
          );
          // Insert data into Supabase on completion
          _insertIntoSupabase(_sound);
          // Vibrate after audio recognition and data insertion
          _performVibration();
        },
      );
    }
  }

// Function to insert data into Notification history table in Supabase DB

  Future<void> _insertIntoSupabase(String sound) async {
    final supabase = Supabase.instance.client;
    final currentTime = DateTime.now();
    String formattedTime = currentTime.toIso8601String();
    await supabase.from('notification_history').insert(
      [
        {
          'time': formattedTime,
          'label': sound,
        },
      ],
    );
  }

  void _performVibration() async {
    if (await Vibrate.canVibrate) {
      // Vibrate for 500ms
      Vibrate.vibrate();
      final Iterable<Duration> pauses = [
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 500),
      ];
      // vibrate - sleep 0.5s - vibrate - sleep 0.5s - vibrate -
      // sleep 0.5s - vibrate - sleep 0.5s - vibrate
      Vibrate.vibrateWithPauses(pauses);
    }
  }

  void _stop() {
    TfliteAudio.stopAudioRecognition();
    setState(() => _recording = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#0066FF"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  "SoundSee",
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text(
                "Home",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/home_page');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history_edu_outlined),
              title: const Text(
                "Notification History",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/notification_page');
              },
            ),
            ListTile(
              leading: const Icon(Icons.update_outlined),
              title: const Text(
                "Update Profile",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/updateuserprofile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback_outlined),
              title: const Text(
                "Feedback",
                style: TextStyle(fontSize: 20),
              ),
              onTap: _sendEmail,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                "Logout",
                style: TextStyle(fontSize: 20),
              ),
              onTap: signOut,
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(25),
              child: const Text(
                "What's happening around?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 45,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                  onPressed: _recorder,
                  color: _recording ? HexColor("#08B752") : HexColor("#08B752"),
                  textColor: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(25),
                  child: const Icon(Icons.mic, size: 60),
                ),
                MaterialButton(
                  onPressed: _stop,
                  color: _recording ? Colors.red : Colors.red,
                  textColor: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(25),
                  child: const Icon(Icons.mic_off, size: 60),
                ),
              ],
            ),
            Text(
              _sound,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      ),
    );
  }
}
