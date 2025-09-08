import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yapilacaklar_listesi/data/local_storage.dart';
import 'package:yapilacaklar_listesi/models/task.dart';
import 'package:yapilacaklar_listesi/pages/home_page.dart';

final locator = GetIt.instance;
void setup() {
  locator.registerSingleton<localStorage>(hiveLocalStorage());
}

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(taskAdapter());
  var taskBox = await Hive.openBox<task>('tasks');
  taskBox.values.forEach((element) {
    if (element.created.day != DateTime.now().day) {
      taskBox.delete(element.id);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await setupHive();
  setup();
  runApp(const myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.grey,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const homePage(),
    );
  }
}
