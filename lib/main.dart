import 'package:flutter/material.dart';
import 'package:hey_amy/screen/home.dart';
import 'package:hey_amy/screen/loading.dart';
import 'package:hey_amy/screen/recorder.dart';

void main() =>  runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/',
  //routes is a map in java? = a dictionary in python?
  routes: {
    '/':(content) => Loading(),
    '/home':(content) => HomePage(),
  } ,
));

