import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/helpers/ad_helpers.dart';
import '../Services/vpn_engine.dart';
import '../helpers/my_dialogues.dart';
import '../helpers/pref.dart';
import '../models/vpn_config.dart';
import '../models/vpn_model.dart';

class HomeController extends GetxController {

  final Rx<Vpn> vpn = Pref.vpn.obs;

  final vpnState = VpnEngine.vpnDisconnected.obs;

  void connectToVpn() async{
    if(vpn.value.openVPNConfigDataBase64.isEmpty) {
      MyDialogs.info(msg: 'Select a Location \'Chang Location\'');

      return;
    }

    if (vpnState.value == VpnEngine.vpnDisconnected) {

      final data = Base64Decoder().convert(vpn.value.openVPNConfigDataBase64);

      final config = Utf8Decoder().convert(data);

      final vpnConfig = VpnConfig(country: vpn.value.countryLong, username: 'vpn', password: 'vpn', config: config);

      ///Start if stage is disconnected
      AdHelpers.showInterstitialAd(onComplete: ()async{await VpnEngine.startVpn(vpnConfig);});
    } else {
      ///Stop if stage is "not" disconnected
      VpnEngine.stopVpn();
    }
  }

  Color get getButtonColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Colors.blue;
      case VpnEngine.vpnConnected:
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  String get getButtonText {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return 'Tap to Connect';
      case VpnEngine.vpnConnected:
        return 'Disconnect';
      default:
        return 'Connecting...';
    }
  }
}
