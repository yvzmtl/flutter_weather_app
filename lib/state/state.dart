import 'package:get/get.dart';
import 'package:location/location.dart';

class MyStateController extends GetxController {
  var isEnableLocation = false.obs;
  var locationDate = LocationData.fromMap(<String, dynamic>{}).obs;

  var isLoading = false.obs;
}
