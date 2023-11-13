import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class Loading extends StatefulWidget {
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  // String time = 'loading';


  void _ini_setup() async {
    // WorldTime instance = WorldTime(location: 'Berlin', flag:'germany.png', url:'Europe/Berlin');
    // await instance.getTime();
    // // print(instance.time);
    // // setState(() {
    // //   time = instance.time;
    // // });
    //transfering data with "arguments" to home.dart?
    //   //I SHOULD LEARN WHAT MOUNTED PROPERTY IS!
    //   Navigator.pushReplacementNamed(context, '/home', arguments: {
    //     'location': instance.location,
    //     'flag': instance.flag,
    //     'time': instance.time,
    //     'isDaytime': instance.isDaytime,
    //   });

     await Future.delayed(const Duration(seconds: 2),() async {

         await Navigator.pushNamed(context,'/home');
         setState(() {});
     });
  }

  @override
  void initState() {
    super.initState();

    _ini_setup();
    // print('hey there!');
  }

  @override
  void dispose() {
    super.dispose();
    // print('hey there!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        // color: const Color(0xFF765EFC)
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset(
            //   "assets/images/logo.png",
            //   width: 48,
            // ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      // color: Colors.green,
                      color: Colors.black,
                      // backgroundColor: Colors.amberAccent,
                      backgroundColor: Colors.grey,
                      strokeWidth: 2.0,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Text(
                      'Loading...',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
