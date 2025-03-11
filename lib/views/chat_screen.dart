import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';
import '../helper/local_storage.dart';

import '../routes/routes.dart';
import '../utils/config.dart';
import '../utils/custom_color.dart';
import '../utils/dimensions.dart';
import '../utils/strings.dart';
import '../widgets/api/custom_loading_api.dart';
import '../widgets/api/toast_message.dart';
import '../widgets/appbar/appbar_widget.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/inputs_widgets/send_input_field.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await controller.speechStopMethod();
        return true;
      },
      child: Scaffold(
        appBar: AppBarWidget(
          context: context,
          onBackClick: () {
            controller.speechStopMethod();
            Get.back();
          },
          appTitle: "SJC App".tr,
          onPressed: () {
            _showDialog(context);
          },
        ),
        body: _mainBody(context),
      ),
    );
  }

  _mainBody(BuildContext context) {
    return Obx(
          () => Column(
        children: [
          Expanded(
            flex: 5,
            child: _buildList(),
          ),
          Expanded(
            flex: 0,
            child: Obx(() => Visibility(
                visible: controller.isLoading,
                child: const CustomLoadingAPI())),
          ),
          Expanded(flex: 0, child: _submitButton(context)),
          SizedBox(height: Dimensions.heightSize)
        ],
      ),
    );
  }

  _submitButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          Visibility(
            visible: LocalStorage.isFreeUser(),
            child: Column(
              children: [
                Visibility(
                  visible: controller.count.value == 0,
                  child: Text(
                    '${Strings.youCanSend.tr} 5 ${Strings.messagesToTheBot.tr} ',
                    style: const TextStyle(color: CustomColor.primaryColor),
                  ),
                ),

              ],
            ),
          ),

          _suggestedWidget(context),

          SendInputField(
            icon: Icon(
              Icons.mic_none_sharp,
              color: controller.isListening.value
                  ? CustomColor.primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.5),
            ),
            hintText: Strings.typeYour.tr,
            onTap: () async{
              if (controller.chatController.text.isNotEmpty) {
                controller.proccessChat();

                Future.delayed(const Duration(milliseconds: 50))
                    .then((_) => controller.scrollDown());
              }
            },
            voiceTab: () {
              controller.listen(context);
            },
            controller: controller.chatController,
          ),
        ],
      ),
    );
  }

  _suggestedWidget(BuildContext context) {
    return Obx(() => controller.isLoading2.value
        ? const CustomLoadingAPI()
        : SizedBox(
      height: 25,
      width: double.infinity,
      child: ListView.separated(
          padding: EdgeInsets.only(left: Dimensions.widthSize * 1),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                openCustomBottomSheet(context, controller.suggestedData[index]);
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(Dimensions.radius * .7),
                    color: Get.isDarkMode
                        ? CustomColor.primaryColor.withOpacity(0.2)
                        : CustomColor.primaryColor
                ),
                child: Text(
                  controller.suggestedData[index]['catName'],
                  style: const TextStyle(color: CustomColor.whiteColor),
                ),
              ),
            );
          },
          separatorBuilder: (_, i) => const SizedBox(width: 5),
          itemCount: controller.suggestedData.length),
    ));
  }

  void openCustomBottomSheet(BuildContext context, data) {
    showModalBottomSheet(
      context: context,

      builder: (BuildContext context) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.all(Dimensions.widthSize),
          child: Stack(
            children: [
              Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "SUGGESTED QUESTIONS",
                    style: TextStyle(
                      // fontSize: 14.sp,
                        color: CustomColor.primaryColor,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const Divider(),

                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: data["questions"].length,
                        itemBuilder: (context, index){
                          return ListTile(
                            title: Text(
                              data["questions"][index],
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor.withOpacity(.6)
                              ),
                            ),
                            onTap: () {
                              controller.chatController.text = "";
                              controller.chatController.text = data["questions"][index];
                              Navigator.pop(context);
                            },
                          );
                        }
                    ),
                  )
                ],
              ),
              Positioned(
                  right: -5,
                  top: -15,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    onPressed: (){
                      Get.back();
                    },
                  )
              )
            ],
          ),
        );
      },
    );
  }
  _buildList() {
    var languageList = LocalStorage.getLanguage();
    return Obx(() => ListView.builder(
      controller: controller.scrollController,
      itemCount: controller.itemCount.value,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return ChatMessageWidget(
            onStop: () {
              controller.speechStopMethod();
            },
            onLongPress: () {
              Clipboard.setData(ClipboardData(
                  text: controller.messages.value[index].text));
            },
            onSpeech: () {
              controller.speechMethod(controller.messages.value[index].text,
                  '${languageList[0]}-${languageList[1]}');
              controller.voiceSelectedIndex.value = index;
            },
            text: controller.messages.value[index].text,
            chatMessageType:
            controller.messages.value[index].chatMessageType,
            index: index);
      },
    ));
  }

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.widthSize * 3,
                vertical: Dimensions.heightSize),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,

            ),
          );
        });
  }
}