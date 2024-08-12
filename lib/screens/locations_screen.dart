import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn_basic_project/Controllers/native_add_controller.dart';
import 'package:vpn_basic_project/helpers/ad_helpers.dart';
import 'package:vpn_basic_project/helpers/config.dart';
import '../Controllers/location_controller.dart';
import '../Widgets/vpn_card.dart';
import '../main.dart';

class LocationsScreen extends StatelessWidget {
  LocationsScreen({super.key});

  final _controller = LocationController();
  final _adController = NativeAddController();

  Future<void> _refresh() async {
    // Fetch new VPN data
    await _controller.getVpnData();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.vpnList.isEmpty) _controller.getVpnData();

    _adController.ad = AdHelpers.showNativeAd(adController: _adController);
    return Obx(() => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).bottomNav,
          title: Text('Free Locations (${_controller.vpnList.length})'),
        ),
        bottomNavigationBar:

            // Config.hideAds ? null:
        _adController.ad != null && _adController.adLoaded.isTrue
        ? SizedBox(height: 100,
        child: SafeArea(child: AdWidget(ad: _adController.ad!,)))
        : null,
        body: _controller.isLoading.value
            ? _loadingWidget()
            : _controller.vpnList.isEmpty
                ? _noVPNFound()
                : _vpnData()));
  }

  Widget _vpnData() => RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
            itemCount: _controller.vpnList.length,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(
                top: mq.height * .015,
                bottom: mq.height * .1,
                left: mq.width * .04,
                right: mq.width * .04),
            itemBuilder: (context, index) => VpnCard(
                  vpn: _controller.vpnList[index],
                )),
      );

  _loadingWidget() => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              'assets/animations/loading.json',
              width: mq.width * .7,
            ),
            Text(
              'Loading VPNs...😌',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  _noVPNFound() => Center(
          child: Text(
        'No Any VPN Found! 😞',
        style: TextStyle(
            fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
      ));
}
