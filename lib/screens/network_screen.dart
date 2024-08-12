import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/Widgets/network_card.dart';
import 'package:vpn_basic_project/models/ip_details.dart';

import '../Rest_APIs/apis.dart';
import '../main.dart';
import '../models/network_data.dart';

class NetworkScreen extends StatelessWidget {
  final ipData = IpDetails.fromJson({}).obs;
   NetworkScreen({super.key});

  Future<void> _refresh() async {
    // Fetch new VPN data
    ipData.value = IpDetails.fromJson({});
    Apis.getIPDetails(ipData: ipData);
  }

  @override
  Widget build(BuildContext context) {

    Apis.getIPDetails(ipData: ipData);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Network Details'),
      ),
      body: Obx(() => RefreshIndicator(
        onRefresh: () => _refresh() ,
        child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
                left: mq.width * 0.04,
                right: mq.width * 0.04,
                top: mq.height * 0.01,
                bottom: mq.height * 0.1),
            children: [
              NetworkCard(
                  data: NetworkData(
                      icon: Icon(
                        CupertinoIcons.location_solid,
                        color: Colors.blue,
                      ),
                      subtitle: ipData.value.query,
                      title: 'IP Adresss')),
              NetworkCard(
                  data: NetworkData(
                      icon: Icon(
                        Icons.business,
                        color: Colors.orange,
                      ),
                      subtitle: ipData.value.isp,
                      title: 'Internet Provider')),
              NetworkCard(
                  data: NetworkData(
                      icon: Icon(
                        CupertinoIcons.location,
                        color: Colors.pink,
                      ),
                      subtitle: ipData.value.country.isEmpty
                          ? 'Fetching ...'
                          : '${ipData.value.city}, ${ipData.value.regionName}, ${ipData.value.country}',
                      title: 'Location')),
              NetworkCard(
                  data: NetworkData(
                      icon: Icon(
                        CupertinoIcons.location_solid,
                        color: Colors.brown,
                      ),
                      subtitle: ipData.value.zip,
                      title: 'Pin Code')),
              NetworkCard(
                  data: NetworkData(
                      icon: Icon(
                        CupertinoIcons.time,
                        color: Colors.green,
                      ),
                      subtitle: ipData.value.timezone,
                      title: 'Time Zone')),
            ],
          ),
      ),
      ),
    );
  }
}
