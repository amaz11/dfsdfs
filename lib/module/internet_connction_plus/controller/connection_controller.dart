import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionController extends GetxController {
  // RxBool observable to monitor the internet connection status
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeConnectionListener();
  }

  // Method to listen for connection changes
  void _initializeConnectionListener() {
    InternetConnection().onStatusChange.listen((status) {
      switch (status) {
        case InternetStatus.connected:
          isConnected.value = true;
          break;
        case InternetStatus.disconnected:
          isConnected.value = false;
          break;
      }
    });
  }
}
