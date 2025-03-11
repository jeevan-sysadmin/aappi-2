import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';
import '../helper/local_storage.dart';
import '../routes/routes.dart';
import '../utils/assets.dart';
import '../utils/config.dart';
import '../utils/custom_color.dart';
import '../utils/dimensions.dart';
import '../utils/strings.dart';
import '../widgets/api/toast_message.dart';
import '../widgets/app_name_widget.dart';
import 'drawer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    });
  }

  @override
  Widget build(BuildContext context) {
    RxBool isDark = Get.isDarkMode.obs;

    return Scaffold(
      drawer: DrawerWidget(isDark: isDark),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Visibility(
            visible: LocalStorage.isLoggedIn(),
            child: IconButton(
              onPressed: () {
                _showMenuDialog(context);
              },
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _pageIconAnTitle(isDark),
          _buttonsWidget(context, isDark),

        ],
      ),
    );
  }

  _buttonsWidget(BuildContext context, isDark) {
    return Flexible(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Visibility(
              visible: LocalStorage.getChatStatus(),
              child: _buildContainer(context, isDark,
                  title: "Notice Board",
                  subTitle: "Keep Track of the New Events in St.John's College",
                  iconPath: Assets.messages, onTap: () async {
                    Get.toNamed(Routes.chatScreen);

                  })),



          Visibility(
              visible: LocalStorage.getScheduleStatus(),
              child: _buildContainer(context, isDark,
                  title: "Pay Your Fees Online".tr,
                  subTitle: "Get Scheduled Reminders on Advanced Stock Analyis",
                  iconPath: Assets.paypal,

                  onTap: () async {
                    if (LocalStorage.isFreeUser()) {

                      Get.toNamed(Routes.setScheduleScreen);
                    } else {
                      Get.toNamed(Routes.setScheduleScreen);
                    }
                  })),


        ],
      ),
    );
  }

  _pageIconAnTitle(isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        _animatedTextWidget(isDark),
      ],
    );
  }

  _animatedTextWidget(isDark) {
    return Padding(
        padding: const EdgeInsets.only(top: 18.0), child: Obx(()=> AppNameWidget(isDark: isDark.value)));
  }







  _buildContainer(BuildContext context, isDark,
      {required String title,
      required String subTitle,
      required VoidCallback onTap,
      required String iconPath}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.all(Dimensions.defaultPaddingSize * 0.5),
        margin: EdgeInsets.symmetric(
          vertical: Dimensions.heightSize * 0.5,
          horizontal: Dimensions.widthSize * 2,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius),
            border: Border.all(
                color: (isDark.value
                        ? CustomColor.whiteColor
                        : CustomColor.primaryColor)
                    .withOpacity(1.0),
                width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 70,
                width: 70,
                child: SvgPicture.asset(
                  iconPath,
                  color: (isDark.value
                      ? CustomColor.whiteColor
                      : CustomColor.primaryColor),
                ),
            ),
            SizedBox(width: Dimensions.widthSize),

            Text(
              title,
              style: TextStyle(
                  color: (isDark.value
                      ? CustomColor.whiteColor
                      : CustomColor.primaryColor),
                  fontWeight: FontWeight.w500,
                  fontSize: Dimensions.defaultTextSize * 1.8),
            ),


          ],
        ),
      ),
    );
  }











  _showMenuDialog(BuildContext context) {
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
              children: List.generate(
                  controller.menuList.length,
                  (index) => Container(
                        alignment: Alignment.centerLeft,
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 0.5,
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.widthSize * 1,
                            vertical: Dimensions.heightSize * 0.5),
                        child: TextButton(
                            onPressed: () {
                              // if(LocalStorage.showAdPermissioned() && LocalStorage.getAdMobStatus()){
                              //     AdMobHelper.getInterstitialAdLoad();
                              //   }
                              if (index == 0) {
                                Get.back();
                                showAlertDialog(context);
                              }
                            },
                            child: Text(
                              controller.menuList[index].tr,
                              style: const TextStyle(
                                  color: CustomColor.blackColor),
                            )),
                      )),
            ),
          );
        });
  }

  void showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Get.back();
        controller.deleteAccount();
      },
    );

    Widget cancelButton = TextButton(
      child: Text(
        Strings.cancel.tr,
        style: const TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Get.back();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        Strings.alert.tr,
        style: const TextStyle(color: Colors.red),
      ),
      content: Text(
        Strings.deleteYourAccount.tr,
        style: const TextStyle(color: CustomColor.primaryColor),
      ),
      actions: [okButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
