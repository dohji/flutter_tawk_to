import 'dart:convert';
import 'dart:math';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mefita/routes/app_routes.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/ui/global/components/buttons.dart';
import 'package:mefita/ui/global/helpers/style.dart';
import 'package:mefita/ui/global/helpers/text_input_decoration.dart';
import 'package:get/get.dart';

import '../signup/signup_step_one.dart';
import 'signin_controller.dart';

class SignInScreen extends StatefulWidget {

  const SignInScreen({Key? key})
      : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  GlobalController globalController = Get.find();
  SignInController signInController = Get.put(SignInController());
  final signInFormKey = GlobalKey<FormState>();

  late ScrollController _scrollController;
  // static const kExpandedHeight = 280.0;
  bool sliverAppBarExpanded = true;

  RxBool obscurePassword = true.obs;


  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          sliverAppBarExpanded = _isSliverAppBarExpanded;
        });
      });

  }

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset < MediaQuery.of(context).padding.top + (kToolbarHeight - kToolbarHeight * .2);
  }


  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar.large(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Get.isDarkMode ? Brightness.light : Brightness.dark,
                statusBarBrightness: Get.isDarkMode? Brightness.dark : Brightness.light,
              ),
              foregroundColor: colorScheme.onSurface,
              backgroundColor: colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              title: sliverAppBarExpanded
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back 👋🏽',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    )
                  ),
                  const SizedBox(height: 5),
                  Text("Enter your phone number to sign in to your account", style: textTheme.labelMedium),
                ],
              )
              : Text(
                  'Welcome Back',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal, vertical: 0),
                child: Form(
                  key: signInFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 27),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      //   child: Text('Phone Number',
                      //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                      //   ),
                      // ),
                      // const SizedBox(height: 5,),
                      Obx(() =>
                         TextFormField(
                          controller: signInController.phoneTC,
                          style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 30),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: GestureDetector(
                                onTap: () {
                                  // open country picker
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: true,
                                    onSelect: (Country country) {
                                      signInController.selectedCountry.value = country;
                                    },
                                    countryListTheme: CountryListThemeData(
                                      backgroundColor: colorScheme.surface,
                                      textStyle: textTheme.bodyMedium!.copyWith(color: colorScheme.onSurface),
                                      // bottomSheetHeight: 500, // Optional. Country list modal height
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(AppBorderRadius.sm),
                                        topRight: Radius.circular(AppBorderRadius.sm),
                                      ),
                                      searchTextStyle: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
                                      inputDecoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30),
                                        enabledBorder: inputBorder(colorScheme),
                                        focusedBorder: inputBorderFocused(colorScheme),
                                        errorBorder: inputBorder(colorScheme),
                                        focusedErrorBorder: inputBorderFocused(colorScheme),
                                        filled: true,
                                        fillColor: colorScheme.onSurface.withValues(alpha: 0.03),
                                        hintText: 'search',
                                        hintStyle: textTheme.bodyMedium!.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme.onSurface.withValues(alpha: 0.5)
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: colorScheme.onSurface.withValues(alpha: 0.03),
                                    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(signInController.selectedCountry.value?.flagEmoji ?? "", style: textTheme.titleLarge),
                                      const SizedBox(width: 4),
                                      Text("+${signInController.selectedCountry.value?.phoneCode ?? ""}",
                                        style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
                                      ),
                                      const SizedBox(width: 4),
                                      SvgPicture.asset("assets/svg/caret-down.svg", color: colorScheme.onSurface, height: 15, width: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                            enabledBorder: inputBorder(colorScheme),
                            focusedBorder: inputBorderFocused(colorScheme),
                            errorBorder: inputBorder(colorScheme),
                            focusedErrorBorder: inputBorderFocused(colorScheme),
                            filled: true,
                            fillColor: colorScheme.onSurface.withValues(alpha: 0.03),
                            hintText: 'phone number',
                            hintStyle: textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface.withValues(alpha: 0.5)
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          validator: (String? value) => !GetUtils.isPhoneNumber(value!)
                              ? "Valid phone required"
                              : null,
                        ),
                      ),
                      const SizedBox(height: 27),

                      Center(
                        child: PrimaryButton(
                          label: "Sign In",
                          isFullWidth: true,
                          onTap: () {
                            if (signInFormKey.currentState!.validate()){
                              // signInController.handleSignIn();
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 27/2),

                      // Divider with OR text in the middle

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            Expanded(child: Divider(color: colorScheme.onSurface.withValues(alpha: 0.1),)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text("OR", style: textTheme.labelMedium),
                            ),
                            Expanded(child: Divider(color: colorScheme.onSurface.withValues(alpha: 0.1),)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 27/2),

                      Center(
                        child: PrimaryButton(
                          label: "",
                          text: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/google.svg",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 20),
                              Text("Sign In with Google", style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          // foregroundColor: colorScheme.surface,
                          backgroundColor: Colors.transparent,
                          borderColor: colorScheme.onSurface.withValues(alpha: 0.1),
                          // width: double.maxFinite,
                          isFullWidth: true,
                          onTap: () {

                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      Center(
                        child: PrimaryButton(
                          label: "",
                          text: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/apple.svg",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 20),
                              Text("Sign In with Apple", style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          // foregroundColor: colorScheme.surface,
                          backgroundColor: Colors.transparent,
                          borderColor: colorScheme.onSurface.withValues(alpha: 0.1),
                          // width: double.maxFinite,
                          isFullWidth: true,
                          onTap: () {

                          },
                        ),
                      ),

                      const SizedBox(height: 27),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            // Get.toNamed(AppRoutes.signupStepOne);
                            Get.to(() => SignUpStepOne());
                          },
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Don't have an account yet? ",
                                      style: textTheme.labelSmall
                                  ),
                                  TextSpan(
                                    text: 'Create an account now to enjoy seamless auto service',
                                    style:textTheme.labelSmall?.copyWith(
                                        color: colorScheme.error,
                                        fontWeight: FontWeight.w600
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                      ),

                      SizedBox(height: AppPadding.vertical),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
