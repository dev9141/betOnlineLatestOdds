import 'package:bet_online_latest_odds/screens/login_screen.dart';
import 'package:bet_online_latest_odds/screens/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'assets/app_theme.dart';
import 'data/local/preference_manager.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'generated/l10n.dart';

import 'package:timezone/data/latest.dart' as tz;

import 'utils/helper/helper.dart';
import 'utils/helper/notification_helper.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  await PreferenceManager.init();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  //runApp(const MyApp());

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

// Disabling Crashlytics in development mode.
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@drawable/img_notification');
  const DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings(
    /*onDidReceiveLocalNotification: onDidReceiveLocalNotification*/);

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Allows only portrait mode
  ]).then((_) {
    runApp(MyApp());
  });
}
final navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
ValueNotifier<bool> isDarkTheme = ValueNotifier<bool>(false);

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    Helper.showBuildVersion();
    _checkNotificationPermission();
    NotificationHelper.configureFirebase();

    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkTheme,
      builder: (context, value, child) {
        isDarkTheme.value = MediaQuery.of(context).platformBrightness == Brightness.dark;
        print("isDarkTheme ${isDarkTheme.value}");
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Bet Online Latest Odds',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: AppTheme.lightTheme,
          /*darkTheme: AppTheme.darkTheme,*/
          themeMode:ThemeMode.system, /// set theme based on device theme
          home: setHome(),
        );
      },
    );
  }
  _checkNotificationPermission() async {
    // check permission
    firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    PermissionStatus status = await Permission.notification.status;

    if (status.isGranted) {
      // Get FCM Token
      if(PreferenceManager.getDeviceToken() == null || PreferenceManager.getDeviceToken() == "") {
        NotificationHelper.getToken();
      }
    } else {
      PermissionStatus status = await Permission.notification.request();
      if (status.isGranted) {
        // Get FCM Token
        NotificationHelper.getToken();
      }
    }
  }

}

Widget setHome() {
  /*if (UserRepository().getIsUserLoggedIn()) {
    return const ProfileWidget();
  } else {
    return const IntroScreen();
  }*/
  /*Map<String, String> formData = {
    "FirstName": "JohnDoe9",
    "EMail": "john.doe9@example.com",
    "PasswordJ": "Password123",
    "HomePhone": "6042011149",
  };

  return DynamicUrlWebView(
    firstUrl: "https://record.betonlineaffiliates.ag/_on42CIkH5pz-a8CTELPmZWNd7ZgqdRLk/1/", // Initial URL
    formData: formData,
  );*/
  return const SplashScreen();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
