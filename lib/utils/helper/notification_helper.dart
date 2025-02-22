import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../data/repositories/user_repository.dart';
import 'log.dart';
import 'package:timezone/timezone.dart' as tz;
var notification_channel_general_key = 'general_channel';
var notification_channel_general_title = 'General Notifications';
var notification_channel_general_description =
    'These are common notifications from the app.';
final navigatorKey = GlobalKey<NavigatorState>();
String token = "";

class NotificationHelper {
  static String notificationData = "data";
  static String notificationTitle = "title";
  static String notificationMessage = "message";
  static String notificationCustomData = "custom_data";
  static String notificationBody = "body";

  static void configureFirebase() {
    try {
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        logPrint('-->>> on message instance ${message?.data}');
        if (Platform.isAndroid) {
          if (message != null) {
            notificationOnLaunch(message);
          }
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        logPrint('-->>> on message ${message.data}');
        notificationOnMessage(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        logPrint("onMessageOpenedApp: $message");
        notificationOnResume(message);
      });

      FirebaseMessaging.onBackgroundMessage(notificationOnBackgroundMessage);
    } catch (e) {
      logPrint(e);
    }
  }

  static getToken() {
    FirebaseMessaging.instance.getToken().then((String? deviceToken) {
      logPrint('Notification token = $deviceToken');
      token = deviceToken ?? '';
      print("token  $token");
      UserRepository().setDeviceToken(token);
      //   settingsRepo.prefs?.setString('deviceToken', _deviceToken ?? '');
    }).catchError((e) {
      logPrint('Notification not configured');
    });
  }
}

//When app is minimize and notification clicked
Future notificationOnResume(RemoteMessage message) async {
  print('-->>> on resume $message');
  try {
    //if user logged in
    if (true) {
      dynamic newMessage;
      String body = '';
      String title = '';
      if (message.data.containsKey(NotificationHelper.notificationCustomData) &&
          message.data[NotificationHelper.notificationCustomData] != null) {
        newMessage = json
            .decode(message.data[NotificationHelper.notificationCustomData]);
      }

      if (message.data.containsKey(NotificationHelper.notificationTitle) &&
          message.data[NotificationHelper.notificationTitle] != null) {
        title = message.data[NotificationHelper.notificationTitle];
      }

      if (Platform.isIOS) {
        if (message.data.containsKey(NotificationHelper.notificationBody) &&
            message.data[NotificationHelper.notificationBody] != null) {
          body = message.data[NotificationHelper.notificationBody];
        }
      } else {
        if (message.data.containsKey(NotificationHelper.notificationMessage) &&
            message.data[NotificationHelper.notificationMessage] != null) {
          body = message.data[NotificationHelper.notificationMessage];
        }
      }
      getScheduleNotification(message.data, title, body);
      //redirect to screen
      /*     await NotificationHelper.redirectFromNotification(
          newMessage, title, body);*/
    }
  } catch (e) {
    logPrint(e);
  }
}

//When App is in foreground
Future notificationOnMessage(RemoteMessage message) async {
  //print('-->>> on message $message');
  // dynamic data = message.data['custom_data'];

  // dynamic newData = json.decode(message.data);

  String title = '';
  String body = '';

  if (message.data.containsKey(NotificationHelper.notificationTitle) &&
      message.data[NotificationHelper.notificationTitle] != null) {
    title = message.data[NotificationHelper.notificationTitle];
  }

  if (Platform.isIOS) {
    if (message.data.containsKey(NotificationHelper.notificationBody) &&
        message.data[NotificationHelper.notificationBody] != null) {
      body = message.data[NotificationHelper.notificationBody];
    }
  } else {
    if (message.data.containsKey(NotificationHelper.notificationMessage) &&
        message.data[NotificationHelper.notificationMessage] != null) {
      body = message.data[NotificationHelper.notificationMessage];
    }
  }

  if (Platform.isAndroid) {
    showNotification(message.data, title, body);
  }
}

void showNotification(Map<String, dynamic> data, String title, String body) {
  Map<String, String> payload = Map<String, String>();
  data.forEach((key, value) {
    payload[key] = value != null ? value.toString() : "";
  });

  // AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //         id: 10,
  //         channelKey: notification_channel_basic_key,
  //         title: data['title'],
  //         body: data['body'],
  //         payload: payload));

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      notification_channel_general_key, notification_channel_general_title,
      channelDescription: notification_channel_general_description,
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
      color: const Color(0xFFFFFFFF),
      styleInformation: BigTextStyleInformation(body));
  var iOSPlatformChannelSpecifics =
      const DarwinNotificationDetails(presentSound: true, sound: 'default');
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  //int counter = PreferenceManager.getInt(sessionNotificationCounter);
  //PreferenceManager.setInt(sessionNotificationCounter, counter + 1);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
/*  flutterLocalNotificationsPlugin.show(1, title, body, platformChannelSpecifics,
      payload: jsonEncode(payload));*/

  var scheduledTime = DateTime.now().add(Duration(minutes : 5));

  flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      title,
      body,
      tz.TZDateTime.from(
        scheduledTime,
        tz.local,
      ) ,const NotificationDetails(
      android: AndroidNotificationDetails(
          'your channel id', 'your channel name',
          channelDescription: 'your channel description')),
      //androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
  androidAllowWhileIdle: true);
}


getScheduleNotification(Map<String, dynamic> data, String title, String body){
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
/*  flutterLocalNotificationsPlugin.show(1, title, body, platformChannelSpecifics,
      payload: jsonEncode(payload));*/

  var scheduledTime = DateTime.now().add(Duration(minutes : 2));

  flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      title,
      body,
      tz.TZDateTime.from(
        scheduledTime,
        tz.local,
      ) ,const NotificationDetails(
      android: AndroidNotificationDetails(
          'your channel id', 'your channel name',
          channelDescription: 'your channel description')),
      //androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true);
}
Future notificationOnLaunch(RemoteMessage message) async {
  try {
    String body = '';
    String title = '';
    dynamic newMessage;
    if (message.data.containsKey(NotificationHelper.notificationCustomData) &&
        message.data[NotificationHelper.notificationCustomData] != null) {
      newMessage =
          json.decode(message.data[NotificationHelper.notificationCustomData]);
    }

    if (message.data.containsKey(NotificationHelper.notificationTitle) &&
        message.data[NotificationHelper.notificationTitle] != null) {
      title = message.data[NotificationHelper.notificationTitle];
    }

    if (Platform.isIOS) {
      if (message.data.containsKey(NotificationHelper.notificationBody) &&
          message.data[NotificationHelper.notificationBody] != null) {
        body = message.data[NotificationHelper.notificationBody];
      }
    } else {
      if (message.data.containsKey(NotificationHelper.notificationMessage) &&
          message.data[NotificationHelper.notificationMessage] != null) {
        body = message.data[NotificationHelper.notificationMessage];
      }
    }
    getScheduleNotification(message.data, title, body);

    // redirect to screen
    /*await NotificationHelper.redirectFromNotification(
        newMessage, title, body);*/
  } catch (e) {
    logPrint(e);
  }
}

@pragma('vm:entry-point')
Future<void> notificationOnBackgroundMessage(RemoteMessage message) async {
  //print('notificationOnBackgroundMessage --->>> $message');
  if (message.data.containsKey(NotificationHelper.notificationCustomData) &&
      message.data[NotificationHelper.notificationCustomData] != null) {}

  if (message.data.containsKey(NotificationHelper.notificationTitle) &&
      message.data[NotificationHelper.notificationTitle] != null) {
    String title = message.data[NotificationHelper.notificationTitle];
  }

  String body;
  if (Platform.isIOS) {
    if (message.data.containsKey(NotificationHelper.notificationBody) &&
        message.data[NotificationHelper.notificationBody] != null) {
      body = message.data[NotificationHelper.notificationBody];
    }
  } else {
    if (message.data.containsKey(NotificationHelper.notificationMessage) &&
        message.data[NotificationHelper.notificationMessage] != null) {
      body = message.data[NotificationHelper.notificationMessage];
    }
  }

  //await NotificationHelper.insertNotificationInDB(newMessage, title, body);
}
