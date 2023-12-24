import 'package:flutter/material.dart';
import 'package:hey_amy/screen/home.dart';
import 'package:hey_amy/screen/loading.dart';

void main() =>  runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/',
  //routes is a map in java? = a dictionary in python?
  routes: {
    '/':(content) => const HomePage(),
    // '/':(content) => Loading(),
    // '/home':(content) => HomePage(),
  } ,
));
