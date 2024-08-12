import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:vpn_basic_project/helpers/ad_helpers.dart';

import '../main.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      AdHelpers.precacheshowInterstitialAd();
      AdHelpers.precacheNativeAd();

      Get.off(() => HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: mq.height * .25,
              left: mq.width * .2,
              width: mq.width * .6,
              child: Image.asset('assets/images/vpn.png')),
          Positioned(
              top: mq.height * .55,
              width: mq.width,
              child: Text(
                textAlign: TextAlign.center,
                "Free VPN",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Theme.of(context).lightText),
              ))
        ],
      ),
    );
  }
}
