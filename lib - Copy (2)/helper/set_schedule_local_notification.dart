
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../model/schedule/schedule_model.dart';
import 'permissions.dart';

class SetScheduleNotification{

  static setSchedule(ScheduleModel schedule)async{
    final permissionGranted = await requestScheduleExactAlarmPermission();
    if (permissionGranted) {
      await checkScheduleNotification(schedule);
    } else {
      debugPrint("Need to permission alarm");
    }
  }

  static checkScheduleNotification(ScheduleModel schedule) {
      _scheduleNotification(schedule);
  }

  static Future<void> _scheduleNotification(ScheduleModel schedule) async {

    const androidNotificationDetails = AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: "channel description",
        sound: RawResourceAndroidNotificationSound("alarm"),
        enableVibration: true,
        playSound: true
    );

    const iosNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      // sound:
    );
    const notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails
    );

    /// once
    if(schedule.scheduleType == "Once"){
      var now = DateTime.now();
      // print(now);
      DateTime date = DateTime.parse("${schedule.date} ${schedule.time}");

      if (date.isBefore(now)) {
        await removeIDNotification(schedule.id);
      } else {
        final tzTime = tz.TZDateTime.from(date, tz.local);
        await _set(schedule, tzTime, notificationDetails);
      }
    }

    /// daily todo
    else if(schedule.scheduleType == "Daily"){
      var now = DateTime.now();
      String nowDate = "${now.year}-${now.month}-${now.day}";
      DateTime date = DateTime.parse("$nowDate ${schedule.time}");

      final tzTime = tz.TZDateTime.from(date, tz.local);
      await _set(schedule, tzTime, notificationDetails);
    }

    ///weekly todo
    else if(schedule.scheduleType == "Weekly"){

    }
  }

  static Future<void> _set(ScheduleModel schedule, tz.TZDateTime tzTime, NotificationDetails notificationDetails) async{
    await FlutterLocalNotificationsPlugin().zonedSchedule(
      schedule.id,
      schedule.title,
      schedule.description,
      tzTime,
      notificationDetails,
      // ignore: deprecated_member_use
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint("${schedule.title} is setted =>  ${tzTime.day}:${tzTime.hour}:${tzTime.minute}");
  }



  static Future<void> removeIDNotification(int id) async {
      final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
      await notifications.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
    await notifications.cancelAll();
  }
}