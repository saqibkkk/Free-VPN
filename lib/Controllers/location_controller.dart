import 'package:get/get.dart';
import '../Rest_APIs/apis.dart';
import '../helpers/pref.dart';
import '../models/vpn_model.dart';

class LocationController extends GetxController {
  List<Vpn> vpnList = Pref.vpnList;
  final RxBool isLoading = false.obs;

  Future<void> getVpnData() async {
    isLoading.value = true;
    vpnList.clear();
    vpnList = await Apis.getVPNServers();
    isLoading.value = false;
  }
}
