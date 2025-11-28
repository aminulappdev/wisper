import 'package:get/get.dart';
import 'package:wisper/app/core/services/network_caller/network_caller.dart';
import 'package:wisper/app/modules/homepage/controller/feed_post_controller.dart';
import 'package:wisper/app/modules/profile/controller/profile_controller.dart';


class ControllerBinder extends Bindings {
  @override 
  void dependencies() {
    Get.put(NetworkCaller());
    Get.put(ProfileController());
    Get.put(AllFeedPostController());
    
  }
}
