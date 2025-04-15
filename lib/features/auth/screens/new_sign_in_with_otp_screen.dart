import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor/common/widgets/validate_check.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/auth/domain/centralize_login_enum.dart';
import 'package:stackfood_multivendor/features/auth/widgets/sign_in/new_social_login_widget.dart';
import 'package:stackfood_multivendor/features/auth/widgets/sign_in/sign_in_view.dart';
import 'package:stackfood_multivendor/features/auth/widgets/social_login_widget.dart';
import 'package:stackfood_multivendor/features/auth/widgets/trams_conditions_check_box_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/order/screens/new_order_tracking_screen.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/centralize_login_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

import '../../../util/images.dart';

class NewSignInWithOtpScreen extends StatefulWidget {
  final bool exitFromApp;
  final bool backFromThis;
  final bool fromResetPassword;
  final Function(bool val)? isOtpViewEnable;
  const NewSignInWithOtpScreen(
      {super.key,
        required this.exitFromApp,
        required this.backFromThis,
        this.fromResetPassword = false,
        this.isOtpViewEnable});

  @override
  State<NewSignInWithOtpScreen> createState() => _NewSignInWithOtpScreenState();
}

class _NewSignInWithOtpScreenState extends State<NewSignInWithOtpScreen> {
  // final FocusNode _phoneFocus = FocusNode();
  // final FocusNode _passwordFocus = FocusNode();
  // final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // String? _countryDialCode;
  // GlobalKey<FormState>? _formKeyLogin;
  // bool _isOtpViewEnable = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _formKeyLogin = GlobalKey<FormState>();
  //   AuthController authController = Get.find<AuthController>();

  //   _countryDialCode = authController.getUserCountryCode().isNotEmpty
  //       ? authController.getUserCountryCode()
  //       : CountryCode.fromCountryCode(
  //               Get.find<SplashController>().configModel!.country!)
  //           .dialCode;
  //   _phoneController.text = authController.getUserNumber();
  //   _passwordController.text = authController.getUserPassword();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     bool isOtpActive = CentralizeLoginHelper.getPreferredLoginMethod(
  //                     Get.find<SplashController>()
  //                         .configModel!
  //                         .centralizeLoginSetup!,
  //                     _isOtpViewEnable)
  //                 .type ==
  //             CentralizeLoginType.otp ||
  //         CentralizeLoginHelper.getPreferredLoginMethod(
  //                     Get.find<SplashController>()
  //                         .configModel!
  //                         .centralizeLoginSetup!,
  //                     _isOtpViewEnable)
  //                 .type ==
  //             CentralizeLoginType.otpAndSocial;
  //     if (_countryDialCode != "" &&
  //         _phoneController.text != "" &&
  //         _phoneController.text.contains('@') &&
  //         isOtpActive) {
  //       _phoneController.text = '';
  //     } else if (_countryDialCode != "" &&
  //         _phoneController.text != "" &&
  //         !_phoneController.text.contains('@')) {
  //       authController.toggleIsNumberLogin(value: true);
  //     } else {
  //       authController.toggleIsNumberLogin(value: false);
  //     }
  //     authController.initCountryCode(
  //         countryCode: _countryDialCode != "" ? _countryDialCode : null);
  //   });

  //   if (!kIsWeb) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       FocusScope.of(context).requestFocus(_phoneFocus);
  //     });
  //   }
  // }
  final ScrollController _scrollController = ScrollController();
  // Color bgColor = Colors.transparent;
  Color textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(() {
    //   final currentPosition = _scrollController.position.pixels;
    //   if (currentPosition >= 100) {
    //     // bgColor = Colors.white.withOpacity(0.8);
    //     textColor = Colors.white;
    //     setState(() {});
    //   } else if (currentPosition <= 100) {
    //     // bgColor = Colors.transparent;
    //     textColor = Colors.black;

    //     setState(() {});
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          // const SignInBg(),
          Container(
            height: Get.height,
            color: Colors.white,
            // decoration: BoxDecoration(
            //   // color: Theme.of(context).primaryColor.withOpacity(0.10),
            //     image: const DecorationImage(
            //       fit: BoxFit.fitWidth,
            //       image: AssetImage(Images.signinBG),
            //     ),
            // ),
            child: Container(
              padding: const EdgeInsets.only(left: 12, right: 12),
              // color: bgColor,
              child: SingleChildScrollView(
                controller: _scrollController,
               // physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100),
                    Center(
                      child: Text(
                        'enter_your_mobile'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Center(
                      child: Text(
                        'we_will_send_whatsapp'.tr,
                        style: TextStyle(
                          fontSize: 15,
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // const SizedBox(height: 20),
                    // TextFormField(
                    //   keyboardType: TextInputType.phone,
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     contentPadding:
                    //         EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //       borderSide: BorderSide(color: Colors.grey),
                    //     ),
                    //     prefixIcon: Padding(
                    //       padding: const EdgeInsets.only(left: 12),
                    //       child: DropdownButtonHideUnderline(
                    //         child: DropdownButton<String>(
                    //           value: '+212',
                    //           style: TextStyle(
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.w500,
                    //               color: Colors.black),
                    //           items: [
                    //             DropdownMenuItem(
                    //               value: '+212',
                    //               child: Text('+212'),
                    //             ),
                    //             DropdownMenuItem(
                    //               value: '+1',
                    //               child: Text('+1'),
                    //             ),
                    //             DropdownMenuItem(
                    //               value: '+91',
                    //               child: Text('+91'),
                    //             ),
                    //           ],
                    //           onChanged: (value) {},
                    //         ),
                    //       ),
                    //     ),
                    //     hintText: '20 1721 8749',
                    //     hintStyle: TextStyle(
                    //         color: Colors.grey,
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w500),
                    //   ),
                    // ),
                    SizedBox(height: 20,),

                    SignInView(
                      exitFromApp: widget.exitFromApp,
                      backFromThis: widget.backFromThis,
                      fromResetPassword: widget.fromResetPassword,
                      isOtpViewEnable: (v) {},
                      oldStyleLoginPage: false,
                    ),

                    // NewSocialLoginWidget(),
                    // _cutomWidget(
                    //   context,
                    //   authController,
                    //   phoneController: _phoneController,
                    //   phoneFocus: _phoneFocus,
                    //   countryDialCode: _countryDialCode,
                    //   onCountryChanged: (CountryCode countryCode) =>
                    //       _countryDialCode = countryCode.dialCode,
                    //   onClickLoginButton: () {
                    //     _otpLogin(Get.find<AuthController>(), _countryDialCode!,
                    //         CentralizeLoginType.otp);
                    //   },
                    //   socialEnable: false,
                    // ),

                    // const SizedBox(height: 20),
                    // // Login button
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Get.to(() => NewOrderTrackingScreen());
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.green,
                    //     foregroundColor: Colors.white,
                    //     minimumSize: Size(double.infinity, 50),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //   ),
                    //   child: Text(
                    //     'Login',
                    //     style: TextStyle(fontSize: 18),
                    //   ),
                    // ),
                    // const SizedBox(height: 20),
                    // Row(
                    //   children: [
                    //     Expanded(child: Divider(endIndent: 16)),
                    //     Text(
                    //       'Or sign in with',
                    //       style: TextStyle(
                    //           color: Colors.grey,
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 10),
                    //     ),
                    //     Expanded(child: Divider(indent: 16)),
                    //   ],
                    // ),
                    // const SizedBox(height: 24),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     SocialIconButton(onTap: (){},image: 'assets/image/google.png',),
                    //     SizedBox(width: 44),
                    //     SocialIconButton(onTap: (){},image: 'assets/image/ios.png',),
                    //     SizedBox(width: 44),
                    //     SocialIconButton(onTap: (){},image: 'assets/image/facebook.png',),
                    //   ],
                    // ),
                    // const SizedBox(height: 20),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Checkbox(value: true, onChanged: (value) {}),
                    //     Flexible(
                    //       child: Text(
                    //         'By logging in, I am accepting the Terms of service and the Privacy policy',
                    //         style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 10,
                    //             fontWeight: FontWeight.w500),
                    //         textAlign: TextAlign.start,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  // void _otpLogin(AuthController authController, String countryDialCode,
  //     CentralizeLoginType loginType) async {
  //   String phone = _phoneController.text.trim();
  //   String numberWithCountryCode = countryDialCode + phone;
  //   PhoneValid phoneValid =
  //       await CustomValidator.isPhoneValid(numberWithCountryCode);
  //   numberWithCountryCode = phoneValid.phone;

  //   if (_formKeyLogin!.currentState!.validate()) {
  //     if (!phoneValid.isValid) {
  //       showCustomSnackBar('invalid_phone_number'.tr);
  //     } else {
  //       authController
  //           .otpLogin(
  //               phone: numberWithCountryCode,
  //               otp: '',
  //               loginType: loginType.name,
  //               verified: '',
  //               alreadyInApp: widget.backFromThis)
  //           .then((response) {
  //         if (response.isSuccess) {
  //           _processOtpSuccessSetup(
  //               response, authController, phone, countryDialCode);
  //         } else {
  //           showCustomSnackBar(response.message);
  //         }
  //       });
  //     }
  //   }
  // }

  Widget _cutomWidget(
      BuildContext context,
      AuthController authController, {
        required TextEditingController phoneController,
        required FocusNode phoneFocus,
        required String? countryDialCode,
        required Function(CountryCode countryCode)? onCountryChanged,
        required Function() onClickLoginButton,
        required bool socialEnable,
      }) {
    return Column(
      children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),
        CustomTextFieldWidget(
          hintText: 'xxx-xxx-xxxxx'.tr,
          controller: phoneController,
          focusNode: phoneFocus,
          inputAction: TextInputAction.done,
          inputType: TextInputType.phone,
          isPhone: true,
          onCountryChanged: onCountryChanged,
          countryDialCode: countryDialCode ??
              Get.find<LocalizationController>().locale.countryCode,
          labelText: 'phone'.tr,
          required: true,
          validator: (value) => ValidateCheck.validateEmptyText(
              value, "please_enter_phone_number".tr),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => authController.toggleRememberMe(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    side: BorderSide(color: Theme.of(context).hintColor),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: Theme.of(context).primaryColor,
                    value: authController.isActiveRememberMe,
                    onChanged: (bool? isChecked) =>
                        authController.toggleRememberMe(),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text('remember_me'.tr, style: robotoRegular),
              ],
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        TramsConditionsCheckBoxWidget(
            authController: authController, fromDialog: true),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        CustomButtonWidget(
          buttonText: 'login'.tr,
          radius: Dimensions.radiusDefault,
          isBold: true,
          isLoading: authController.isLoading,
          onPressed: onClickLoginButton,
          fontSize: Dimensions.fontSizeDefault,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        socialEnable
            ? const SocialLoginWidget(onlySocialLogin: false)
            : const SizedBox(),
      ],
    );
  }
}

class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    super.key,
    required this.image,
    required this.onTap,
  });

  final String image;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return CustomInkWellWidget(
      onTap: onTap,
      radius: 16,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(48)),
        child: Image.asset(image),
      ),
    );
  }
}

class SignInBg extends StatelessWidget {
  const SignInBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.6,
      decoration: BoxDecoration(
        // color: Theme.of(context).primaryColor.withOpacity(0.10),
          image: const DecorationImage(
              image: AssetImage(Images.loginBgSvg), fit: BoxFit.fitHeight)),
    );
  }
}
