import 'package:flutter/material.dart';
import 'model/pallete.dart';
import 'screen/home.dart';

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await ApiUtil().loadAPIkey();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //[debugShowCheckedModeBanner]:
      //remove the banner on the top right corner of screen
      debugShowCheckedModeBanner: false,
      // title: 'Hey Amy',
      theme: ThemeData.light(
      ).copyWith(
        scaffoldBackgroundColor: Pallete.whiteColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Pallete.whiteColor,
        ),
      ),

      home: const HomePage(),
    );
  }
}
