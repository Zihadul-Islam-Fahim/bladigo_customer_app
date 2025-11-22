import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/onboard/controllers/onboard_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Get.find<OnBoardingController>().getOnBoardingList();
    return GetBuilder<OnBoardingController>(builder: (onBoardingController) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(0, 161, 41, 1),

        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).primaryColor.withOpacity(0.05),
        //   actions: [
        //     onBoardingController.selectedIndex == 2 ? const SizedBox() : InkWell(
        //       onTap: () {
        //         _configureToRouteInitialPage();
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        //         child: Text('skip'.tr, style: robotoBold.copyWith(color: Theme.of(context).disabledColor)),
        //       ),
        //     ),
        //     const SizedBox(width: 30),
        //   ],
        // ),
        body: onBoardingController.onBoardingList != null ? Container(

          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(Images.onboardImage),fit: BoxFit.contain)
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: PageView.builder(
                controller: _pageController,
                itemCount: onBoardingController.onBoardingList!.length,
                itemBuilder: (context, index) {
                  return Column(mainAxisAlignment: MainAxisAlignment.start, children: [

                    Stack(alignment: Alignment.bottomCenter, children: [

                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.55, width: MediaQuery.of(context).size.width,
                      //   child: CustomAssetImageWidget(
                      //     onBoardingController.onBoardingList![index].frameImageUrl,
                      //     width: MediaQuery.of(context).size.width,
                      //     fit: BoxFit.fill,
                      //     color: Theme.of(context).primaryColor,
                      //   ),
                      // ),

                      Positioned(
                        bottom: 120,
                        child: CustomAssetImageWidget(
                          Images.onboardImage,
                          width: MediaQuery.of(context).size.width * 0.60,
                          fit: BoxFit.fill,
                        ),
                      ),

                    ]),

                    Text(
                      onBoardingController.onBoardingList![index].title,
                      style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text(
                        onBoardingController.onBoardingList![index].description,
                        style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                        textAlign: TextAlign.center,
                      ),
                    ),


                  ]);
                },
                onPageChanged: (index) {
                  onBoardingController.changeSelectIndex(index);
                },

              ),
            ),


            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraLarge),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: _pageIndicators(onBoardingController, context),
                // ),

                Stack(children: [

                  // Center(
                  //   child: SizedBox(
                  //     height: 50, width: 50,
                  //     child: CircularProgressIndicator(
                  //       value: (onBoardingController.selectedIndex + 1) / onBoardingController.onBoardingList!.length,
                  //       valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  //       backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  //     ),
                  //   ),
                  // ),

                  Positioned(

                    child: InkWell(
                      focusColor: Colors.transparent,highlightColor: Colors.transparent,hoverColor: Colors.transparent,splashColor: Colors.transparent,
                      onTap: (){
                        _configureToRouteInitialPage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white
                        ),
                        height: 55,
                        width: Get.width * 0.92,
                        margin: EdgeInsets.symmetric(vertical: 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Center(child: Text("get_started".tr,style: robotoBold.copyWith(fontSize: 18),)),


                      ),
                    ),
                  ),

                ]),

              ]),
            ),

          ]),
        ) : const Center(child: CircularProgressIndicator()),
      );
    });
  }

  List<Widget> _pageIndicators(OnBoardingController onBoardingController, BuildContext context) {
    List<Container> indicators = [];

    for (int i = 0; i < onBoardingController.onBoardingList!.length; i++) {
      indicators.add(
        Container(
          width: i == onBoardingController.selectedIndex ? 24 : 7, height: 7,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: i == onBoardingController.selectedIndex ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.40),
            borderRadius: i == onBoardingController.selectedIndex ? BorderRadius.circular(50) : BorderRadius.circular(25),
          ),
        ),
      );
    }
    return indicators;
  }

  void _configureToRouteInitialPage() async {
    Get.find<SplashController>().disableIntro();
    await Get.find<AuthController>().guestLogin();
    if (AddressHelper.getAddressFromSharedPref() != null) {
      Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
    } else {
      Get.find<SplashController>().navigateToLocationScreen('splash', offNamed: true);
    }
  }
}