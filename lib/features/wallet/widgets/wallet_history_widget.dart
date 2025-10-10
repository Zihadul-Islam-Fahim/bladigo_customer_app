import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/wallet/domain/models/wallet_filter_body_model.dart';
import 'package:stackfood_multivendor/features/wallet/controllers/wallet_controller.dart';
import 'package:stackfood_multivendor/features/wallet/widgets/history_cart_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../common/widgets/custom_snackbar_widget.dart';
import '../../../helper/price_converter.dart';
import '../../../util/images.dart';
import '../../splash/controllers/splash_controller.dart';
import 'add_fund_dialogue_widget.dart';

class WalletHistoryWidget extends StatelessWidget {
  const WalletHistoryWidget({super.key});

  List<PopupMenuEntry> _generateFilteredMethod(BuildContext context, List<WalletFilterBodyModel>? walletFilterList, WalletController walletController) {
    List<PopupMenuEntry> entryList = [];
    for(int i=0; i < walletFilterList!.length; i++){
      entryList.add(PopupMenuItem<int>(value: i, child: Text(
        walletFilterList[i].title!.tr,
        style: robotoMedium.copyWith(
          color: walletFilterList[i].value == walletController.type
              ? Theme.of(context).textTheme.bodyMedium!.color
              : Theme.of(context).disabledColor,
        ),
      )));
    }
    return entryList;
  }

  String _setUpFilteredName(List<WalletFilterBodyModel>? walletFilterList, WalletController walletController) {
    String filterName = '';
    for(int i=0; i < walletController.walletFilterList.length; i++) {
      if (walletController.walletFilterList[i].value == walletController.type) {
        filterName = walletController.walletFilterList[i].title!.tr;
      } else if (walletController.type == 'all') {
        filterName = '';
      }
    }
    return filterName;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (walletController) {
        List<PopupMenuEntry> entryList = _generateFilteredMethod(context, walletController.walletFilterList, walletController);
        String filterName = _setUpFilteredName(walletController.walletFilterList, walletController);

        return GetBuilder<ProfileController>(
          builder: (profileController) {
            return Column(children: [

              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 20,left: 10),
                      child: Image.asset(Images.walletBottomNav,width: 40,)),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              child: Row(
                children: [

                  SizedBox(width: 5,),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('wallet_amount'.tr,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge1, color: Colors.black),overflow: TextOverflow.ellipsis,),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            PriceConverter.convertPrice(profileController.userInfoModel?.walletBalance??0), textDirection: TextDirection.ltr,overflow: TextOverflow.ellipsis,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge1, color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          // Get.find<SplashController>().configModel!.addFundStatus! ? JustTheTooltip(
                          //   backgroundColor: Colors.black87,
                          //   controller: tooltipController,
                          //   preferredDirection: AxisDirection.down,
                          //   tailLength: 14,
                          //   tailBaseWidth: 20,
                          //   content: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Text(
                          //       'if_you_want_to_add_fund_to_your_wallet_then_click_add_fund_button'.tr,
                          //       style: robotoRegular.copyWith(color: Colors.white),
                          //     ),
                          //   ),
                          //   child: InkWell(
                          //     onTap: () => tooltipController.showTooltip(),
                          //     child: Icon(Icons.info_outline, color: Theme.of(context).cardColor),
                          //   ),
                          // ) : const SizedBox(),
                        ]),
                  ]),
                  Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("top_up".tr,style: TextStyle(color: Colors.black),),
                      SizedBox(height: 5,),

                      Get.find<SplashController>().configModel!.addFundStatus! ? InkWell(
                        onTap: (){
                          if(Get.find<SplashController>().configModel!.digitalPayment!) {
                            Get.dialog(
                              const Dialog(
                                shadowColor: Colors.transparent,
                                backgroundColor: Colors.transparent,
                                surfaceTintColor: Colors.transparent,
                                insetPadding: EdgeInsets.zero,
                                child: SizedBox(width: 500, child: AddFundDialogueWidget()),
                              ),
                            );
                          } else {
                            showCustomSnackBar('currently_digital_payment_is_not_available'.tr);
                          }

                        },
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(0, 191, 99, 1)),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(Icons.add,color: Colors.white,),
                        ),
                      ) : const SizedBox(),
                    ],
                  ),

                ],
              ),
              ),

              Padding(
                padding: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeExtraLarge),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      'wallet_history'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(
                      filterName,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                    ),

                  ]),

                  PopupMenuButton<dynamic>(
                    offset: const Offset(-20, 20),
                    itemBuilder: (BuildContext context) => entryList,
                    onSelected: (dynamic value) {
                      walletController.setWalletFilerType(walletController.walletFilterList[value].value!);
                      walletController.getWalletTransactionList('1', false, walletController.type);
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                        border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 2),
                        child: Row(children: [
                          Text(
                            'filter'.tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                          ),

                          const Icon(Icons.arrow_drop_down, size: 18),
                        ]),
                      ),
                    ),
                  ),

                ]),
              ),
              walletController.transactionList != null ? walletController.transactionList!.isNotEmpty ? GridView.builder(
                key: UniqueKey(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 50,
                  mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0.01,
                  childAspectRatio: ResponsiveHelper.isDesktop(context) ? 7 : 4.45,
                  crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 1,
                ),
                physics:  const NeverScrollableScrollPhysics(),
                shrinkWrap:  true,
                itemCount: walletController.transactionList!.length ,
                padding: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 28 : 15),
                itemBuilder: (context, index) {
                  return HistoryCartWidget(index: index, data: walletController.transactionList);
                },
              ) : NoDataScreen(title: 'no_transaction_yet'.tr, isEmptyTransaction: true) : WalletShimmer(walletController: walletController),

              walletController.isLoading ? const Center(child: Padding(
                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CircularProgressIndicator(),
              )) : const SizedBox(),


            ]);
          }
        );
      }
    );
  }
}


class WalletShimmer extends StatelessWidget {
  final WalletController walletController;
  const WalletShimmer({super.key, required this.walletController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: UniqueKey(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 50,
        mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0.01,
        childAspectRatio: ResponsiveHelper.isDesktop(context) ? 5 : 4.1,
        crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 1,
      ),
      physics:  const NeverScrollableScrollPhysics(),
      shrinkWrap:  true,
      itemCount: 10,
      padding: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 28 : 25),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: walletController.transactionList == null,
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(height: 8, width: 50, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 10),
                    Container(height: 8, width: 70, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Container(height: 8, width: 50, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 8),
                    Container(height: 8, width: 70, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  ]),
                ],
              ),
              Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge), child: Divider(color: Theme.of(context).disabledColor)),
            ],
            ),
          ),
        );
      },
    );
  }
}