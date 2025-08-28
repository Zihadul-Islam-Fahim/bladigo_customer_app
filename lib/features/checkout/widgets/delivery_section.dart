import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/address/widgets/address_card_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/guest_delivery_address.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/location/widgets/permission_dialog.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_dropdown_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../profile/controllers/profile_controller.dart';
import '../../splash/controllers/splash_controller.dart';
import '../../splash/controllers/theme_controller.dart';

class DeliverySection extends StatefulWidget {
  final CheckoutController checkoutController;
  final LocationController locationController;
  final TextEditingController guestNameTextEditingController;
  final TextEditingController guestNumberTextEditingController;
  final TextEditingController guestEmailController;
  final FocusNode guestNumberNode;
  final FocusNode guestEmailNode;
  const DeliverySection(
      {super.key,
      required this.checkoutController,
      required this.locationController,
      required this.guestNameTextEditingController,
      required this.guestNumberTextEditingController,
      required this.guestNumberNode,
      required this.guestEmailController,
      required this.guestEmailNode});

  @override
  State<DeliverySection> createState() => _DeliverySectionState();
}

class _DeliverySectionState extends State<DeliverySection> {
  @override
  void initState() {
    super.initState();
    bool isGuestLoggedIn = Get.find<AuthController>().isGuestLoggedIn();
    if (!isGuestLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.checkoutController.address.isNotEmpty &&
            widget.checkoutController.address.length >= 2) {
          widget.checkoutController.setAddressIndex(1);
        }
      });
    }
    _initCall();
  }

  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;



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
    bool isGuestLoggedIn = Get.find<AuthController>().isGuestLoggedIn();

    bool takeAway = (widget.checkoutController.orderType == 'take_away');
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    GlobalKey<CustomDropdownState> dropDownKey =
        GlobalKey<CustomDropdownState>();
    AddressModel addressModel;

    return Column(children: [
      // _deliveryToWidget(context),
      isGuestLoggedIn
          ? GuestDeliveryAddress(
              checkoutController: widget.checkoutController,
              guestNumberNode: widget.guestNumberNode,
              guestNameTextEditingController:
                  widget.guestNameTextEditingController,
              guestNumberTextEditingController:
                  widget.guestNumberTextEditingController,
              guestEmailController: widget.guestEmailController,
              guestEmailNode: widget.guestEmailNode,
            )
          : !takeAway
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 0 : Dimensions.fontSizeDefault),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: isDesktop
                              ? Dimensions.paddingSizeLarge
                              : Dimensions.paddingSizeSmall,
                          vertical: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        // color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                        // boxShadow: [
                        //   BoxShadow(
                        //       color: Colors.grey.withOpacity(0.1),
                        //       spreadRadius: 1,
                        //       blurRadius: 10,
                        //       offset: const Offset(0, 1))
                        // ],
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Delivery Location'.tr,
                                      style: robotoMedium.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      )),
                                  CustomInkWellWidget(
                                    onTap: () async {
                                      dropDownKey.currentState
                                          ?.toggleDropdown();
                                    },
                                    radius: Dimensions.radiusDefault,
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Dimensions.paddingSizeSmall,
                                          horizontal:
                                              Dimensions.paddingSizeSmall),
                                      // child: Icon(Icons.arrow_drop_down_rounded,
                                      //     size: 40),
                                      child:

                                      Text(
                                        'Change',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault),
                                  color: Colors.transparent,
                                  border:
                                      Border.all(color: Colors.transparent)),
                              child: CustomDropdown<int>(
                                key: dropDownKey,
                                hideIcon: true,
                                onChange: (int? value, int index) async {
                                  if (value == -1) {
                                    var address = await Get.toNamed(
                                        RouteHelper.getAddAddressRoute(
                                            true,
                                            widget.checkoutController
                                                .restaurant!.zoneId));
                                    if (address != null) {
                                      widget.checkoutController.insertAddresses(
                                          Get.context!, address,
                                          notify: true);

                                      widget
                                          .checkoutController
                                          .streetNumberController
                                          .text = address.road ?? '';
                                      widget.checkoutController.houseController
                                          .text = address.house ?? '';
                                      widget.checkoutController.floorController
                                          .text = address.floor ?? '';

                                      widget.checkoutController.getDistanceInKM(
                                        LatLng(double.parse(address.latitude),
                                            double.parse(address.longitude)),
                                        LatLng(
                                            double.parse(widget
                                                .checkoutController
                                                .restaurant!
                                                .latitude!),
                                            double.parse(widget
                                                .checkoutController
                                                .restaurant!
                                                .longitude!)),
                                      );
                                    }
                                  } else if (value == -2) {
                                    _checkPermission(() async {
                                      addressModel = await widget
                                          .locationController
                                          .getCurrentLocation(true,
                                              mapController: null,
                                              showSnackBar: true);

                                      if (addressModel.zoneIds!.isNotEmpty) {
                                        widget.checkoutController
                                            .insertAddresses(
                                                Get.context!, addressModel,
                                                notify: true);

                                        widget.checkoutController
                                            .getDistanceInKM(
                                          LatLng(
                                            widget.locationController.position
                                                .latitude,
                                            widget.locationController.position
                                                .longitude,
                                          ),
                                          LatLng(
                                              double.parse(widget
                                                  .checkoutController
                                                  .restaurant!
                                                  .latitude!),
                                              double.parse(widget
                                                  .checkoutController
                                                  .restaurant!
                                                  .longitude!)),
                                        );
                                      }
                                    });
                                  } else {
                                    widget.checkoutController.getDistanceInKM(
                                      LatLng(
                                        double.parse(widget.checkoutController
                                            .address[value!].latitude!),
                                        double.parse(widget.checkoutController
                                            .address[value].longitude!),
                                      ),
                                      LatLng(
                                          double.parse(widget.checkoutController
                                              .restaurant!.latitude!),
                                          double.parse(widget.checkoutController
                                              .restaurant!.longitude!)),
                                    );
                                    widget.checkoutController
                                        .setAddressIndex(value);

                                    widget.checkoutController
                                        .streetNumberController.text = widget
                                            .checkoutController
                                            .address[value]
                                            .road ??
                                        '';
                                    widget.checkoutController.houseController
                                        .text = widget.checkoutController
                                            .address[value].house ??
                                        '';
                                    widget.checkoutController.floorController
                                        .text = widget.checkoutController
                                            .address[value].floor ??
                                        '';
                                  }
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 0,
                                  width: double.infinity,
                                  padding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  primaryColor: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeExtraSmall),
                                ),
                                items: widget.checkoutController.addressList,
                                child: const SizedBox(),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5),
                                child:GetBuilder<LocationController>(builder: (locationController) {
                                  final checkoutController = Get.find<CheckoutController>();
                                  return Container(
                                    height: 120,width: double.infinity,
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
                                                      fromGuest: false));
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
                                            // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                                            //   Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                                            //   Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
                                            //   Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
                                            //   Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
                                            //   Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
                                            // },
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

                            ),
                            Container(
                              constraints: BoxConstraints(
                                  minHeight: ResponsiveHelper.isDesktop(context)
                                      ? 90
                                      : 75),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusDefault),
                                // color: Theme.of(context)
                                //     .primaryColor
                                //     .withOpacity(0.1),
                                // border: Border.all(
                                //     color: Theme.of(context).primaryColor,
                                //     width: 0.3),
                              ),
                              child: AddressCardWidget(
                                address: (widget.checkoutController.address
                                                .length -
                                            1) >=
                                        widget.checkoutController.addressIndex
                                    ? widget.checkoutController.address[
                                        widget.checkoutController.addressIndex]
                                    : widget.checkoutController.address[0],
                                fromAddress: false,
                                fromCheckout: true,
                              ),
                            ),
                            // SizedBox(
                            //     height: ResponsiveHelper.isDesktop(context)
                            //         ? Dimensions.paddingSizeExtraLarge
                            //         : Dimensions.paddingSizeLarge),
                            // !ResponsiveHelper.isDesktop(context)
                            //     ? CustomTextFieldWidget(
                            //         hintText: 'write_street_number'.tr,
                            //         labelText: 'street_number'.tr,
                            //         inputType: TextInputType.streetAddress,
                            //         focusNode: checkoutController.streetNode,
                            //         nextFocus: checkoutController.houseNode,
                            //         controller: checkoutController
                            //             .streetNumberController,
                            //       )
                            //     : const SizedBox(),
                            // SizedBox(
                            //     height: !ResponsiveHelper.isDesktop(context)
                            //         ? Dimensions.paddingSizeLarge
                            //         : 0),
                            // Row(
                            //   children: [
                            //     ResponsiveHelper.isDesktop(context)
                            //         ? Expanded(
                            //             child: CustomTextFieldWidget(
                            //               hintText: 'write_street_number'.tr,
                            //               labelText: 'street_number'.tr,
                            //               inputType:
                            //                   TextInputType.streetAddress,
                            //               focusNode:
                            //                   checkoutController.streetNode,
                            //               nextFocus:
                            //                   checkoutController.houseNode,
                            //               controller: checkoutController
                            //                   .streetNumberController,
                            //               showTitle: false,
                            //             ),
                            //           )
                            //         : const SizedBox(),
                            //     SizedBox(
                            //         width: ResponsiveHelper.isDesktop(context)
                            //             ? Dimensions.paddingSizeSmall
                            //             : 0),
                            //     Expanded(
                            //       child: CustomTextFieldWidget(
                            //         hintText: 'write_house_number'.tr,
                            //         labelText: 'house'.tr,
                            //         inputType: TextInputType.text,
                            //         focusNode: checkoutController.houseNode,
                            //         nextFocus: checkoutController.floorNode,
                            //         controller:
                            //             checkoutController.houseController,
                            //         showTitle: false,
                            //       ),
                            //     ),
                            //     const SizedBox(
                            //         width: Dimensions.paddingSizeSmall),
                            //     Expanded(
                            //       child: CustomTextFieldWidget(
                            //         hintText: 'write_floor_number'.tr,
                            //         labelText: 'floor'.tr,
                            //         inputType: TextInputType.text,
                            //         focusNode: checkoutController.floorNode,
                            //         inputAction: TextInputAction.done,
                            //         controller:
                            //             checkoutController.floorController,
                            //         showTitle: false,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(
                            //     height: Dimensions.paddingSizeExtraSmall),
                          ]),
                    ),
                  ),
                )
              : const SizedBox(),
    ]);
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    } else if (permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    } else {
      onTap();
    }
  }

  Widget _deliveryToWidget(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Change',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 24,
                  color: Colors.grey.withOpacity(.2),
                ),
                // const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      Images.home,
                      height: 33,
                      width: 33,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Home',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Up to 2 Base, 5 veg options, 3 proteins choices & 5 toppings included',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
