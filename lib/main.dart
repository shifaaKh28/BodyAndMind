import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:swe_project/FirebaseApi.dart';

// Import your screens
import 'package:swe_project/screens/trainee/login.dart';
import 'package:swe_project/screens/trainee/register.dart';
import 'package:swe_project/screens/trainer/dashboard.dart';
import 'package:swe_project/screens/trainer/login.dart';
import 'package:swe_project/screens/trainer/profile/profile_screen.dart';
import 'package:swe_project/screens/trainer/register.dart';
import 'package:swe_project/screens/trainee/dashboard.dart';


// Handle background notifications
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
}

// Initialize local notifications
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // Request permission for notifications
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("User granted permission: ${settings.authorizationStatus}");

    // Get and store the device token
    String? token = await messaging.getToken();
    if (token != null) {
      await storeUserFCMToken(token);
    }
    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground notification received: ${message.notification?.title}");
      showLocalNotification(message);
    });

    // Handle notification click when app is opened
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("User tapped on notification: ${message.notification?.title}");
    });
  }
}

Future<void> storeUserFCMToken(String token) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  DocumentReference userRef =
  FirebaseFirestore.instance.collection("users").doc(user.uid);

  await userRef.set({'fcmToken': token}, SetOptions(merge: true));
}

// Function to show a local notification
void showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'high_importance_channel', // Channel ID
    'High Importance Notifications', // Channel Name
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? "New Notification",
    message.notification?.body ?? "Check the app for updates!",
    platformChannelSpecifics,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Set up Firebase Messaging
  setupFirebaseMessaging();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Body & Mind Gym',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/traineeOptions': (context) => TraineeOptionsScreen(),
        '/traineeLogin': (context) => TraineeLoginScreen(),
        '/traineeRegister': (context) => TraineeRegisterScreen(),
        '/traineeDashboard': (context) => TraineeDashboard(),
        '/trainerLogin': (context) => TrainerLoginScreen(),
        '/trainerDashboard': (context) => TrainerDashboard(),
        '/trainerRegister': (context) => TrainerRegisterScreen(),
        '/trainerProfile': (context) => ProfileScreen(isTrainer: true),
        '/login': (context) => TraineeLoginScreen(), // Added for Trainee Options
        '/register': (context) => TraineeRegisterScreen(), // Added for Trainee Options
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/Cbum.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          // Main Content
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Welcome Section
              Column(
                children: [
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Body & Mind Gym',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Plan your workout instantly from the app',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
              // Role Selection Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionCard(
                    context,
                    icon: Icons.shield_outlined,
                    label: 'Trainer',
                    gradientColors: [Colors.orangeAccent, Colors.deepOrange],
                    onPressed: () {
                      Navigator.pushNamed(context, '/trainerLogin');
                    },
                  ),
                  _buildOptionCard(
                    context,
                    icon: Icons.person_outline,
                    label: 'Trainee',
                    gradientColors: [Colors.blueAccent, Colors.lightBlue],
                    onPressed: () {
                      Navigator.pushNamed(context, '/traineeLogin');
                    },
                  ),
                ],
              ),
              // Sign-up Option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member? ',
                    style: TextStyle(
                      color: Colors.white60,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/traineeRegister');
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Custom Button Card for Trainer & Trainee Options
  Widget _buildOptionCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required List<Color> gradientColors,
        required VoidCallback onPressed,
      }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 140,
        height: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.white),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TraineeOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainee Options'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/traineeLogin');
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/traineeRegister');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
