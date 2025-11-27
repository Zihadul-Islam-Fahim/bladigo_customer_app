import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';/**/
import 'package:stackfood_multivendor/common/widgets/validate_check.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/auth/widgets/social_login_widget.dart';
import 'package:stackfood_multivendor/features/auth/widgets/trams_conditions_check_box_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class OtpLoginWidget extends StatelessWidget {
  final TextEditingController phoneController;
  final FocusNode phoneFocus;
  final String? countryDialCode;
  final Function(CountryCode countryCode)? onCountryChanged;
  final Function() onClickLoginButton;
  final bool socialEnable;
  final bool oldStyleLoginPage;
  const OtpLoginWidget({
    super.key,
    required this.phoneController,
    required this.phoneFocus,
    required this.onCountryChanged,
    required this.countryDialCode,
    required this.onClickLoginButton,
    this.socialEnable = false,
    this.oldStyleLoginPage = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return GetBuilder<AuthController>(builder: (authController) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? Dimensions.paddingSizeLarge : 0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (oldStyleLoginPage)
            Align(
              alignment: Alignment.topLeft,
              child: Text('login'.tr,
                  style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge)),
            ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          CustomTextFieldWidget(
            hintText: 'xxx-xxx-xxxxx'.tr,
            controller: phoneController,
            focusNode: phoneFocus,
            fillColor: Theme.of(context).disabledColor.withOpacity(0.1),
            inputAction: TextInputAction.done,
            inputType: TextInputType.phone,
            isPhone: true,
            onCountryChanged: onCountryChanged,
            countryDialCode: countryDialCode ??
                Get.find<LocalizationController>().locale.countryCode,
            labelText: 'phone'.tr,
            titleText: 'phone'.tr,
            showLabelText: false,
            showTitle: true,
            required: true,
            validator: (value) => ValidateCheck.validateEmptyText(
                value, "please_enter_phone_number".tr),
            showBorder: false,

          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: InkWell(
          //     onTap: () => authController.toggleRememberMe(),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         SizedBox(
          //           height: 10,
          //           width: 24,
          //           child: Checkbox(
          //             side: BorderSide(
          //                 color: GetPlatform.isAndroid
          //                     ? Colors.white
          //                     : Theme.of(context).hintColor),
          //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //             activeColor: Theme.of(context).colorScheme.primary,
          //             value: authController.isActiveRememberMe,
          //             onChanged: (bool? isChecked) =>
          //                 authController.toggleRememberMe(),
          //           ),
          //         ),
          //         const SizedBox(width: Dimensions.paddingSizeSmall),
          //         Text('remember_me'.tr,
          //             style: robotoRegular.copyWith(
          //                 color: GetPlatform.isAndroid ? Colors.white : null)),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(height: Dimensions.paddingSizeLarge),
          // TramsConditionsCheckBoxWidget(
          //     authController: authController, fromDialog: true),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          CustomButtonWidget(
            // height: isDesktop ? 50 : null,
            // width:  isDesktop ? 250 : null,
            buttonText: 'continue'.tr,
            radius: 50,
            // radius: Dimensions.radiusDefault,
            isBold: isDesktop ? false : true,
            isLoading: authController.isLoading,
          //  color: GetPlatform.isAndroid ? Colors.white : null,
            textColor: GetPlatform.isAndroid ? Colors.black : null,
            onPressed: onClickLoginButton,
            fontSize: isDesktop
                ? Dimensions.fontSizeSmall
                : Dimensions.fontSizeExtraLarge,
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          socialEnable
              ? const SocialLoginWidget(onlySocialLogin: false)
              : const SizedBox(),
          socialEnable && isDesktop
              ? const SizedBox(height: Dimensions.paddingSizeLarge)
              : const SizedBox(),
          !socialEnable
              ? const SizedBox(height: 200)
              : const SizedBox(height: 100),
        ]),
      );
    });
  }
}
