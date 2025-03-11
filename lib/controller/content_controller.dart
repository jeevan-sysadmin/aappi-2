import 'package:flutter/services.dart';

import '../helper/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/api_services.dart';
import '../utils/strings.dart';
import '../widgets/api/toast_message.dart';
import 'main_controller.dart';

class ContentController extends GetxController {

  @override
  void onInit() {
    count.value = LocalStorage.getContentCount();
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await AdManager.loadUnityRewardedAd();
    });
  }

  final textController = TextEditingController();
  final selectTypeController = TextEditingController();
  RxString textResponse = ''.obs;

  RxBool isResponseVisible = false.obs;

  RxBool isLoading = false.obs;

  void proccessChat() async {
    addTextCount();

    isLoading.value = true;

    var input = "${Strings.writeContent.tr} ${Strings.about.tr} ${textController.text} ${Strings.forText.tr} ${selectTypeController.text}";
    textController.clear();
    isResponseVisible.value = false;
    update();


    update();
  }




  clearConversation() {
    textResponse.value = '';
    update();
  }

  RxInt count = 0.obs;

  addTextCount() async {
    debugPrint("-------${count.value.toString()}--------");
    count.value++;

    if(LocalStorage.isLoggedIn()) {
      MainController.updateContentCount(count.value);
    }
  }


  void copyResponse(BuildContext context) async{
    await Clipboard.setData(ClipboardData(text: textResponse.value));
    ToastMessage.success("Copied");
  }
}
