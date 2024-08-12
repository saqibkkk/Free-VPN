import 'package:firebase_remote_config/firebase_remote_config.dart';

class Config {
  static final _config = FirebaseRemoteConfig.instance;

  static const _defaultValues = {
    "interstitial_ad": "ca-app-pub-3940256099942544/1033173712",
    "native_ad": "ca-app-pub-3940256099942544/2247696110",
    "rewarded_ad": "ca-app-pub-3940256099942544/5224354917",
    "show_ads": true
  };

  static Future<void> initConfig() async {
    await _config.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 30),
    ));

    await _config.setDefaults(_defaultValues);
     await _config.fetchAndActivate();


    _config.onConfigUpdated.listen((event) async {
      await _config.activate();
    });
  }

  static get showAd => _config.getBool('show_ads');

  // ad ids
  static get showInterstitialAd => _config.getString('interstitial_ad');
  static get showNativeAd => _config.getString('native_ad');
  static get showRewardedAd => _config.getString('rewarded_ad');



  static get hideAds => !showAd;
}
