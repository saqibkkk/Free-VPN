import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart';
import '../helpers/my_dialogues.dart';
import '../helpers/pref.dart';
import '../models/ip_details.dart';
import '../models/vpn_model.dart';

class Apis {
  static Future<List<Vpn>> getVPNServers() async {
    final List<Vpn> vpnList = [];

    try {
      final res = await get(Uri.parse('https://www.vpngate.net/api/iphone/'));
      final csvString = res.body.split("#")[1].replaceAll('*', '');

      List<List<dynamic>> list = const CsvToListConverter().convert(csvString);

      final header = list[0];

      for (int i = 1; i < list.length - 1; ++i) {
        Map<String, dynamic> tempJson = {};
        for (int j = 0; j < header.length; ++j) {
          tempJson.addAll({header[j].toString(): list[i][j]});
        }
        vpnList.add(Vpn.fromJson(tempJson));
      }
    } catch (e) {
      MyDialogs.error(msg: 'Check you Internet Connection');
      print('Error: $e');
    }
    vpnList.shuffle();
    if(vpnList.isNotEmpty){
      Pref.vpnList = vpnList;
    }
    return vpnList;
  }




  static Future<void> getIPDetails({required Rx<IpDetails> ipData}) async {

    try {
      final res = await get(Uri.parse('http://ip-api.com/json/'));
      final data = jsonDecode(res.body);
      ipData.value = IpDetails.fromJson(data);
    } catch (e) {
      MyDialogs.error(msg: 'Check you Internet Connection');
      print('Error: $e');
    }
  }
}
