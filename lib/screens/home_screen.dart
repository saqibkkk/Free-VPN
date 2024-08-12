import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vpn_basic_project/Widgets/watch_ad_dialog.dart';
import 'package:vpn_basic_project/helpers/ad_helpers.dart';
import 'package:vpn_basic_project/helpers/config.dart';
import 'package:vpn_basic_project/screens/network_screen.dart';
import '../Controllers/home_controller.dart';
import '../Services/vpn_engine.dart';
import '../Widgets/countdown_timer.dart';
import '../Widgets/home_card.dart';
import '../helpers/my_dialogues.dart';
import '../helpers/pref.dart';
import '../main.dart';
import '../models/vpn_status.dart';
import 'locations_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).bottomNav,
          leading: Icon(CupertinoIcons.home),
          title: Text('Free VPN'),
          actions: [
            IconButton(
                onPressed: () {
                  if (Config.hideAds) {
                    Get.changeThemeMode(
                        Pref.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                    Pref.isDarkMode = !Pref.isDarkMode;
                    return;
                  }
                  Get.dialog(WatchAdDialog(
                    onComplete: () {
                      AdHelpers.showRewardedAd(onComplete: () {
                        Get.changeThemeMode(
                            Pref.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                        Pref.isDarkMode = !Pref.isDarkMode;
                      });
                    },
                  ));
                },
                icon: Icon(Icons.brightness_medium, size: 24)),
            IconButton(
                padding: EdgeInsets.only(right: 8),
                onPressed: () {
                  Get.to(NetworkScreen());
                },
                icon: Icon(CupertinoIcons.info, size: 24)),
          ],
        ),
        bottomNavigationBar: _changeLocation(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: mq.height * .02,
              width: double.maxFinite,
            ),
            Obx(() => _vpnButton()),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeCard(
                      title: _controller.vpn.value.countryLong.isEmpty
                          ? 'Country'
                          : _controller.vpn.value.countryLong,
                      subtitle: 'Free',
                      icon: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue,
                        child: _controller.vpn.value.countryLong.isEmpty
                            ? Icon(
                                Icons.vpn_lock_rounded,
                                color: Colors.white,
                              )
                            : null,
                        backgroundImage: _controller
                                .vpn.value.countryLong.isEmpty
                            ? null
                            : AssetImage(
                                'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png'),
                      )),
                  HomeCard(
                      title: _controller.vpn.value.countryLong.isEmpty
                          ? '100 ms'
                          : _controller.vpn.value.ping + 'ms',
                      subtitle: 'Ping',
                      icon: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.orange,
                        child: Icon(
                          Icons.equalizer_rounded,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            ),
            StreamBuilder<VpnStatus?>(
              initialData: VpnStatus(),
              stream: VpnEngine.vpnStatusSnapshot(),
              builder: (context, snapshot) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeCard(
                      title: "${snapshot.data?.byteIn ?? "0 kbps"}",
                      subtitle: 'Download',
                      icon: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.arrow_downward_rounded,
                          color: Colors.white,
                        ),
                      )),
                  HomeCard(
                      title: "${snapshot.data?.byteOut ?? "0 kbps"}",
                      subtitle: 'Upload',
                      icon: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            ),
          ],
        ));
  }

  // VPN Button
  Widget _vpnButton() => Column(
        children: [
          Semantics(
            button: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                _controller.connectToVpn();
                if (_controller.vpnState.value == VpnEngine.vpnConnected) {
                  MyDialogs.success(msg: 'VPN in Disconnected');
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _controller.getButtonColor.withOpacity(.2),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _controller.getButtonColor.withOpacity(.3),
                  ),
                  child: Container(
                    width: mq.height * .15,
                    height: mq.height * .15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _controller.getButtonColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.power_settings_new,
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          _controller.getButtonText,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: mq.height * .015, bottom: mq.height * .02),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
            child: Text(
              _controller.vpnState.value == VpnEngine.vpnDisconnected
                  ? 'Not Connected'
                  : _controller.vpnState.replaceAll('_', ' ').toUpperCase(),
              style: TextStyle(fontSize: 15),
            ),
          ),
          Obx(() => CountdownTimer(
                  startTimer:
                      _controller.vpnState.value == VpnEngine.vpnConnected)
              // CountdownTimer(startTimer: _controller.startTimer.value)
              ),
        ],
      );

  // Change Server Location
  Widget _changeLocation(BuildContext context) => SafeArea(
        child: Semantics(
          child: InkWell(
            onTap: () {
              Get.to(() => LocationsScreen());
            },
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
              color: Theme.of(context).bottomNav,
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.globe,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Change Location',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
