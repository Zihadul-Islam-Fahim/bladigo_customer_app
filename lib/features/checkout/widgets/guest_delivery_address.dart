import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../location/controllers/location_controller.dart';
import '../../location/screens/pick_map_screen.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../splash/controllers/splash_controller.dart';
import '../../splash/controllers/theme_controller.dart';

class GuestDeliveryAddress extends StatefulWidget {
  final CheckoutController checkoutController;
  final TextEditingController guestNameTextEditingController;
  final TextEditingController guestNumberTextEditingController;
  final TextEditingController guestEmailController;
  final FocusNode guestNumberNode;
  final FocusNode guestEmailNode;


  const GuestDeliveryAddress(
      {super.key,
      required this.checkoutController,
      required this.guestNameTextEditingController,
      required this.guestNumberTextEditingController,
      required this.guestNumberNode,
      required this.guestEmailController,
      required this.guestEmailNode});

  @override
  State<GuestDeliveryAddress> createState() => _GuestDeliveryAddressState();
}

class _GuestDeliveryAddressState extends State<GuestDeliveryAddress> {
  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;

  @override
  void initState() {
    _initCall();
    super.initState();
  }

  _initCall()async{
    Get.find<LocationController>().setAddressTypeIndex(0, notify: false);
    if (Get.find<AuthController>().isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }

      _initialPosition = LatLng(
        double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lat ?? '0'),
        double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lng ?? '0'),
      );

  }

  @override
  Widget build(BuildContext context) {
    bool takeAway = (widget.checkoutController.orderType == 'take_away');
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    AddressModel address = AddressHelper.getAddressFromSharedPref()!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.fontSizeDefault),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: isDesktop
                ? Dimensions.paddingSizeLarge
                : Dimensions.paddingSizeSmall,
            vertical: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          // color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          // boxShadow: [
          //   BoxShadow(
          //       color: Colors.grey.withOpacity(0.1),
          //       spreadRadius: 1,
          //       blurRadius: 10,
          //       offset: const Offset(0, 1))
          // ],
        ),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(takeAway ? 'contact_information'.tr : 'Delivery Location'.tr,
              style: robotoMedium.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              // border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2)),
            ),
            child: takeAway
                ? Column(children: [
                    Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(children: [
                        CustomTextFieldWidget(
                          showTitle: true,
                          titleText: 'contact_person_name'.tr,
                          hintText: ' ',
                          inputType: TextInputType.name,
                          controller: widget.guestNameTextEditingController,
                          nextFocus: widget.guestNumberNode,
                          capitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        CustomTextFieldWidget(
                          showTitle: true,
                          titleText: 'contact_person_number'.tr,
                          hintText: ' ',
                          controller: widget.guestNumberTextEditingController,
                          focusNode: widget.guestNumberNode,
                          nextFocus: widget.guestEmailNode,
                          inputType: TextInputType.phone,
                          isPhone: true,
                          onCountryChanged: (CountryCode countryCode) {
                            widget.checkoutController.countryDialCode =
                                countryCode.dialCode;
                          },
                          countryDialCode:
                              widget.checkoutController.countryDialCode ??
                                  Get.find<LocalizationController>()
                                      .locale
                                      .countryCode,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        CustomTextFieldWidget(
                          showTitle: true,
                          titleText: 'email'.tr,
                          hintText: ' ',
                          controller: widget.guestEmailController,
                          focusNode: widget.guestEmailNode,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.emailAddress,
                        ),
                      ]),
                    ),
                  ])
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: Dimensions.paddingSizeDefault),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5),
                        child:GetBuilder<LocationController>(builder: (locationController) {
                          final checkoutController = Get.find<CheckoutController>();
                            return Container(
                              height: 180,width: double.infinity,
                              child:        Container(
                                height: isDesktop ? 260 : 145,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  // border: Border.all(width: 1.5, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: Stack(clipBehavior: Clip.none, children: [

                                    GoogleMap(
                                      initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 17),
                                      minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                                      onTap: isDesktop ? null : (latLng) async {
                                        await Get.toNamed(
                                                            RouteHelper.getEditAddressRoute(
                                                                checkoutController.guestAddress,
                                                                fromGuest: true));
                                      },
                                      zoomControlsEnabled: false,
                                      compassEnabled: false,
                                      indoorViewEnabled: true,
                                      mapToolbarEnabled: false,
                                      onCameraIdle: () {
                                        locationController.updatePosition(_cameraPosition, true);
                                      },
                                      onCameraMove: ((position) => _cameraPosition = position),
                                      onMapCreated: (GoogleMapController controller) {
                                        locationController.setMapController(controller);

                                          locationController.getCurrentLocation(true, mapController: controller);

                                      },
                                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                                        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                                        Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
                                        Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
                                        Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
                                        Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
                                      },
                                      style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                                    ),

                                    locationController.loading ? const Center(child: CircularProgressIndicator()) : const SizedBox(),

                                    Center(
                                      child: !locationController.loading ? Image.asset(Images.pickMarker, height: 50, width: 50) : const CircularProgressIndicator(),
                                    ),





                                  ]),
                                ),
                              ),
                            );
                          }
                        )
                        // Row(children: [
                        //   checkoutController.guestAddress == null
                        //       ? Flexible(
                        //           child: Row(
                        //             children: [
                        //               Text("no_contact_information_added".tr,
                        //                   style: robotoMedium.copyWith(
                        //                       fontSize:
                        //                           Dimensions.fontSizeSmall,
                        //                       color: Theme.of(context)
                        //                           .colorScheme
                        //                           .error)),
                        //               const SizedBox(
                        //                   width: Dimensions.paddingSizeSmall),
                        //               Icon(Icons.error,
                        //                   color: Theme.of(context)
                        //                       .colorScheme
                        //                       .error,
                        //                   size: 15),
                        //               const Spacer(),
                        //             ],
                        //           ),
                        //         )
                        //       : Flexible(
                        //           child: Row(children: [
                        //             Flexible(
                        //               flex: 4,
                        //               child: Row(children: [
                        //                 Icon(Icons.person,
                        //                     color: Theme.of(context)
                        //                         .disabledColor,
                        //                     size: 20),
                        //                 const SizedBox(
                        //                     width: Dimensions
                        //                         .paddingSizeExtraSmall),
                        //                 Flexible(
                        //                   child: Text(
                        //                     checkoutController.guestAddress!
                        //                         .contactPersonName!,
                        //                     style: robotoBold,
                        //                     maxLines: 1,
                        //                     overflow: TextOverflow.ellipsis,
                        //                   ),
                        //                 ),
                        //               ]),
                        //             ),
                        //             const SizedBox(
                        //                 width: Dimensions.paddingSizeSmall),
                        //             Flexible(
                        //               flex: 6,
                        //               child: Row(children: [
                        //                 Icon(Icons.phone,
                        //                     color: Theme.of(context)
                        //                         .disabledColor,
                        //                     size: 20),
                        //                 const SizedBox(
                        //                     width: Dimensions
                        //                         .paddingSizeExtraSmall),
                        //                 Flexible(
                        //                   child: Text(
                        //                     checkoutController.guestAddress!
                        //                         .contactPersonNumber!,
                        //                     style: robotoBold,
                        //                     maxLines: 1,
                        //                     overflow: TextOverflow.ellipsis,
                        //                   ),
                        //                 ),
                        //               ]),
                        //             ),
                        //             const SizedBox(
                        //                 width: Dimensions.paddingSizeSmall),
                        //           ]),
                        //         ),
                        //   takeAway
                        //       ? const SizedBox()
                        //       : InkWell(
                        //           onTap: () async {
                        //             var address = await Get.toNamed(
                        //                 RouteHelper.getEditAddressRoute(
                        //                     checkoutController.guestAddress,
                        //                     fromGuest: true));
                        //             if (address != null) {
                        //               checkoutController
                        //                   .setGuestAddress(address);
                        //               checkoutController.getDistanceInKM(
                        //                 LatLng(double.parse(address.latitude),
                        //                     double.parse(address.longitude)),
                        //                 LatLng(
                        //                     double.parse(checkoutController
                        //                         .restaurant!.latitude!),
                        //                     double.parse(checkoutController
                        //                         .restaurant!.longitude!)),
                        //               );
                        //             }
                        //           },
                        //           child: Image.asset(Images.editDelivery,
                        //               height: 20,
                        //               width: 20,
                        //               color: Theme.of(context).primaryColor),
                        //         ),
                        // ]),
                      ),
                      const Divider(),
                      SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomAssetImageWidget(
                                    Images.restLocation,
                                    height: 30,
                                    width: 30,
                                  ),
                                  SizedBox(width: 4),
                                  if (widget.checkoutController.guestAddress == null)
                                    Text("no_contact_information_added".tr,
                                        style: robotoMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeSmall,
                                            color: Colors.red))
                                  else
                                    Text(
                                      "address".tr,
                                      style: robotoMedium.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                ],
                              ),
                              widget.checkoutController.guestAddress == null
                                  ? const SizedBox()
                                  : const SizedBox(
                                      height: Dimensions.paddingSizeSmall),
                              Text(
                                widget.checkoutController.guestAddress == null
                                    ? address.address!
                                    : widget.checkoutController
                                        .guestAddress!.address!,
                                style: robotoRegular,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              widget.checkoutController.guestAddress == null
                                  ? const SizedBox()
                                  : const SizedBox(
                                      height: Dimensions.paddingSizeSmall),
                              (widget.checkoutController.guestAddress != null &&
                                      widget.checkoutController
                                              .guestAddress!.email !=
                                          null)
                                  ? Row(children: [
                                      Text('${'email'.tr} - ',
                                          style: robotoRegular.copyWith(
                                              color: Theme.of(Get.context!)
                                                  .disabledColor)),
                                      Flexible(
                                          child: Text(
                                              widget.checkoutController
                                                      .guestAddress!.email ??
                                                  '',
                                              style: robotoRegular,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis)),
                                    ])
                                  : const SizedBox(),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              widget.checkoutController.guestAddress == null
                                  ? const SizedBox()
                                  : Row(children: [
                                      widget.checkoutController
                                                  .guestAddress!.house !=
                                              null
                                          ? Flexible(
                                              child: Row(children: [
                                                Text('${'house'.tr} - ',
                                                    style: robotoRegular.copyWith(
                                                        color: Theme.of(
                                                                Get.context!)
                                                            .disabledColor)),
                                                Flexible(
                                                    child: Text(
                                                        widget.checkoutController
                                                                .guestAddress!
                                                                .house ??
                                                            '',
                                                        style: robotoRegular,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis)),
                                              ]),
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                          width: Dimensions
                                              .paddingSizeExtraSmall),
                                      widget.checkoutController
                                                  .guestAddress!.floor !=
                                              null
                                          ? Flexible(
                                              child: Row(children: [
                                                Text('${'floor'.tr} - ',
                                                    style: robotoRegular.copyWith(
                                                        color: Theme.of(
                                                                Get.context!)
                                                            .disabledColor)),
                                                Flexible(
                                                    child: Text(
                                                        widget.checkoutController
                                                                .guestAddress!
                                                                .floor ??
                                                            '',
                                                        style: robotoRegular,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis)),
                                              ]),
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                          width: Dimensions
                                              .paddingSizeExtraSmall),
                                    ]),
                            ]),
                      ),
                      SizedBox(height: Dimensions.paddingSizeSmall),
                    ],
                  ),
          ),
          SizedBox(height: Dimensions.paddingSizeExtraSmall),
        ]),
      ),
    );
  }
}
