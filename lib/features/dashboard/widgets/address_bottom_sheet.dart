import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stackfood_multivendor/common/widgets/custom_loader_widget.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/location/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor/features/address/widgets/address_card_widget.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/custom_button_widget.dart';
import '../../location/widgets/location_search_dialog.dart';
import '../../location/widgets/permission_dialog.dart';
import '../../splash/controllers/splash_controller.dart';
import '../../splash/controllers/theme_controller.dart';

class AddressBottomSheet extends StatefulWidget {
  final GoogleMapController? googleMapController;
  const AddressBottomSheet({super.key, this.googleMapController});

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {

  GoogleMapController? _mapController;
  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;

  @override
  void initState() {
    super.initState();

    Get.find<LocationController>().makeLoadingOff();

    _initialPosition = LatLng(
      double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
      double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40)
      ),
      clipBehavior: Clip.hardEdge,
      width: Dimensions.webMaxWidth,
      height: Get.height * 0.90,
      child: GetBuilder<LocationController>(builder: (locationController) {
        return Stack(children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target:  _initialPosition,
              zoom: 16,
            ),
            minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
            onMapCreated: (GoogleMapController mapController) {
              _mapController = mapController;

            },
            zoomControlsEnabled: false,
            onCameraMove: (CameraPosition cameraPosition) {
              _cameraPosition = cameraPosition;
            },
            onCameraMoveStarted: () {
              locationController.disableButton();
            },
            onCameraIdle: () {
              Get.find<LocationController>().updatePosition(_cameraPosition, false);
            },
            style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
          ),

          Center(child: !locationController.loading ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                decoration:BoxDecoration(
                  color: Colors.black,borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Text("Order_will_be_delivered_here".tr,style: robotoBlack.copyWith(fontSize: 15,color: Colors.white),),),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                  child: Image.asset(Images.pickMarker, height: 50, width: 50)),
            ],
          )

              : const CircularProgressIndicator()),

          Positioned(
            top: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
            child: LocationSearchDialog(mapController: _mapController, pickedLocation: locationController.pickAddress!),
            /*child: InkWell(
                onTap: () => Get.dialog(LocationSearchDialog(mapController: _mapController)),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                  child: Row(children: [
                    Icon(Icons.location_on, size: 25, color: Theme.of(context).primaryColor),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Expanded(
                      child: Text(
                        locationController.pickAddress!,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Icon(Icons.search, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),
                  ]),
                ),
              ),*/
          ),

          Positioned(
            bottom: 80, right: Dimensions.paddingSizeSmall,
            child: FloatingActionButton(
              mini: true, backgroundColor: Theme.of(context).cardColor,
              onPressed: () => _checkPermission(() {
                Get.find<LocationController>().getCurrentLocation(false, mapController: _mapController);
              }),
              child: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
            ),
          ),

          Positioned(
            bottom: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
            child: CustomButtonWidget(
              buttonText: locationController.inZone ?  'pick_location'.tr
                  : 'service_not_available_in_this_area'.tr,
              isLoading: locationController.isLoading,
              onPressed: (locationController.buttonDisabled || locationController.loading) ? null
                  : () => _onPickAddressButtonPressed(locationController),
            ),
          ),

        ]);
      }),
    );





    //   Container(
    //   decoration: BoxDecoration(
    //     color: Theme.of(context).cardColor,
    //     borderRadius : const BorderRadius.only(
    //       topLeft: Radius.circular(Dimensions.paddingSizeExtraLarge),
    //       topRight : Radius.circular(Dimensions.paddingSizeExtraLarge),
    //     ),
    //   ),
    //   child: GetBuilder<AddressController>(
    //     builder: (addressController) {
    //       AddressModel? selectedAddress = AddressHelper.getAddressFromSharedPref();
    //       return Column(mainAxisSize: MainAxisSize.min, children: [
    //
    //         Center(
    //           child: Container(
    //             margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
    //             height: 3, width: 40,
    //             decoration: BoxDecoration(
    //                 color: Theme.of(context).highlightColor,
    //                 borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
    //             ),
    //           ),
    //         ),
    //
    //         Flexible(
    //           child: SingleChildScrollView(
    //             padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
    //             child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
    //
    //               Text('${'hey_welcome_back'.tr}\n${'which_location_do_you_want_to_select'.tr}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
    //               const SizedBox(height: Dimensions.paddingSizeLarge),
    //
    //               addressController.addressList != null && addressController.addressList!.isEmpty ? Column(children: [
    //
    //                 Image.asset(Images.address, width: 150),
    //                 const SizedBox(height: Dimensions.paddingSizeLarge),
    //
    //                 Text(
    //                   'you_dont_have_any_saved_address_yet'.tr, textAlign: TextAlign.center,
    //                   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
    //                 ),
    //                 const SizedBox(height: Dimensions.paddingSizeLarge),
    //
    //               ]) : const SizedBox(),
    //
    //               addressController.addressList != null && addressController.addressList!.isEmpty
    //                   ? const SizedBox(height: Dimensions.paddingSizeLarge) : const SizedBox(),
    //
    //               Align(
    //                 alignment: addressController.addressList != null && addressController.addressList!.isNotEmpty ? Alignment.centerLeft : Alignment.center,
    //                 child: TextButton.icon(
    //                   onPressed: () => _onCurrentLocationButtonPressed(),
    //                   style: TextButton.styleFrom(
    //                     backgroundColor: addressController.addressList != null && addressController.addressList!.isEmpty
    //                         ? Theme.of(context).primaryColor : Colors.transparent,
    //                   ),
    //
    //                   icon:  Icon(Icons.my_location, color: addressController.addressList != null && addressController.addressList!.isEmpty
    //                       ? Theme.of(context).cardColor : Theme.of(context).primaryColor),
    //                   label: Text('use_current_location'.tr, style: robotoMedium.copyWith(color: addressController.addressList != null && addressController.addressList!.isEmpty
    //                       ? Theme.of(context).cardColor : Theme.of(context).primaryColor)),
    //                 ),
    //               ),
    //               const SizedBox(height: Dimensions.paddingSizeSmall),
    //
    //               addressController.addressList != null ? addressController.addressList!.isNotEmpty ? Container(
    //                 decoration: BoxDecoration(
    //                   color: Theme.of(context).primaryColor.withOpacity(0.05),
    //                   borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
    //                 ),
    //                 padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
    //                 child: ListView.builder(
    //                   physics: const NeverScrollableScrollPhysics(),
    //                   padding: EdgeInsets.zero,
    //                   shrinkWrap: true,
    //                   itemCount: addressController.addressList!.length > 5 ? 5 : addressController.addressList!.length,
    //                   itemBuilder: (context, index) {
    //                     bool selected = false;
    //                     if(selectedAddress!.id == addressController.addressList![index].id){
    //                       selected = true;
    //                     }
    //                     return Center(child: SizedBox(width: 700, child: AddressCardWidget(
    //                       address: addressController.addressList![index],
    //                       fromAddress: false, isSelected: selected, fromDashBoard: true,
    //                       onTap: () {
    //                         Get.dialog(const CustomLoaderWidget(), barrierDismissible: false);
    //                         AddressModel address = addressController.addressList![index];
    //                         Get.find<LocationController>().saveAddressAndNavigate(
    //                           address, false, null, false, ResponsiveHelper.isDesktop(context),
    //                         );
    //                       },
    //                     )));
    //                   },
    //                 ),
    //               ) : const SizedBox() : const Center(child: CircularProgressIndicator()),
    //
    //               SizedBox(height: addressController.addressList != null && addressController.addressList!.isEmpty ? 0 : Dimensions.paddingSizeSmall),
    //
    //               addressController.addressList != null && addressController.addressList!.isNotEmpty ? TextButton.icon(
    //                 onPressed: () => Get.toNamed(RouteHelper.getAddAddressRoute(false, 0)),
    //                 icon: const Icon(Icons.add_circle_outline_sharp),
    //                 label: Text('add_new_address'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
    //               ) : const SizedBox(),
    //
    //             ]),
    //           ),
    //         ),
    //       ]);
    //     }
    //   ),
    // );
  }

  void _onPickAddressButtonPressed(LocationController locationController) {
    if(locationController.pickPosition.latitude != 0 && locationController.pickAddress!.isNotEmpty) {
      // if(widget.fromAddAddress) {
      //   if(widget.googleMapController != null) {
      //     widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
      //       locationController.pickPosition.latitude, locationController.pickPosition.longitude,
      //     ), zoom: 17)));
      //     locationController.addAddressData();
      //   }
      //   Get.back();
      // }else {
        AddressModel address = AddressModel(
          latitude: locationController.pickPosition.latitude.toString(),
          longitude: locationController.pickPosition.longitude.toString(),
          addressType: 'others', address: locationController.pickAddress,
        );
        locationController.saveAddressAndNavigate(address, false, null, false, ResponsiveHelper.isDesktop(Get.context));
      // }
    }else {
      showCustomSnackBar('pick_an_address'.tr);
    }
  }



  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    }else {
      onTap();
    }
  }

  void _onCurrentLocationButtonPressed() {
    Get.find<LocationController>().checkPermission(() async {
      Get.dialog(const CustomLoaderWidget(), barrierDismissible: false);
      AddressModel address = await Get.find<LocationController>().getCurrentLocation(true);
      ZoneResponseModel response = await Get.find<LocationController>().getZone(address.latitude, address.longitude, false);
      if(response.isSuccess) {
        Get.find<LocationController>().saveAddressAndNavigate(
          address, false, '', false, ResponsiveHelper.isDesktop(Get.context),
        );
      }else {
        Get.back();
        Get.toNamed(RouteHelper.getPickMapRoute(RouteHelper.accessLocation, false));
        showCustomSnackBar('service_not_available_in_current_location'.tr);
      }
    });
  }
}
