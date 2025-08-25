import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/ui/global/auth/signup/signup_controller.dart';
import 'package:mefita/ui/global/components/buttons.dart';
import 'package:mefita/ui/global/helpers/style.dart';
import 'package:mefita/ui/global/helpers/text_input_decoration.dart';
import 'package:get/get.dart';
import 'package:mefita/utils/constants.dart';

class SignUpStepTwoVehicleOwnerScreen extends StatefulWidget {

  const SignUpStepTwoVehicleOwnerScreen({Key? key})
      : super(key: key);

  @override
  State<SignUpStepTwoVehicleOwnerScreen> createState() => _SignUpStepTwoVehicleOwnerScreenState();
}

class _SignUpStepTwoVehicleOwnerScreenState extends State<SignUpStepTwoVehicleOwnerScreen> {

  GlobalController globalController = Get.find();
  SignUpController signUpController = Get.put(SignUpController());
  final signUpStep2VehicleOwnerFormKey = GlobalKey<FormState>();

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
              excludeHeaderSemantics: false,
              title: sliverAppBarExpanded
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    )
                  ),
                  const SizedBox(height: 5),
                  Text("Tell us your name and phone number", style: textTheme.labelMedium),
                ],
              )
              : Text(
                  'Create Account',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal, vertical: 0),
                child: Form(
                  key: signUpStep2VehicleOwnerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Container(
                      //   height: 5,
                      //   width: 20,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(10),
                      //     color: colorScheme.primary,
                      //   ),
                      // ),

                      const SizedBox(height: 27),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('Full Name',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      TextFormField(
                        controller: signUpController.nameTC,
                        style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 30),
                          enabledBorder: inputBorder(colorScheme),
                          focusedBorder: inputBorderFocused(colorScheme),
                          errorBorder: inputBorder(colorScheme),
                          focusedErrorBorder: inputBorderFocused(colorScheme),
                          filled: true,
                          fillColor: colorScheme.onSurface.withValues(alpha: 0.03),
                          hintText: 'name as on your ID',
                          hintStyle: textTheme.bodyMedium!.copyWith(
                            // fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface.withValues(alpha: 0.5)
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: (String? value) => !GetUtils.isNull(value!)
                            ? "Name is required"
                            : null,
                      ),
                      const SizedBox(height: 27),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('Phone Number',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Obx(() =>
                         TextFormField(
                          controller: signUpController.phoneTC,
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
                                      signUpController.selectedCountry.value = country;
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
                                    color: colorScheme.onSurface.withValues(alpha: 0.04),
                                    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(signUpController.selectedCountry.value?.flagEmoji ?? "", style: textTheme.titleLarge),
                                      const SizedBox(width: 4),
                                      Text("+${signUpController.selectedCountry.value?.phoneCode ?? ""}",
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
                              // fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface.withValues(alpha: 0.5)
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: (String? value) => !GetUtils.isPhoneNumber(value!)
                              ? "Valid phone required"
                              : null,
                        ),
                      ),
                      const SizedBox(height: 27),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('Email Address',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      TextFormField(
                        controller: signUpController.emailTC,
                        style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 30),
                          enabledBorder: inputBorder(colorScheme),
                          focusedBorder: inputBorderFocused(colorScheme),
                          errorBorder: inputBorder(colorScheme),
                          focusedErrorBorder: inputBorderFocused(colorScheme),
                          filled: true,
                          fillColor: colorScheme.onSurface.withValues(alpha: 0.03),
                          hintText: 'optional',
                          hintStyle: textTheme.bodyMedium!.copyWith(
                            // fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface.withValues(alpha: 0.5)
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: (String? value) {
                          if (value!.trim().isEmpty) {
                            return null;
                          }else if (!GetUtils.isEmail(value)) {
                            return "Email is invalid";
                          }
                          return null;
                        }
                      ),
                      const SizedBox(height: 27*2),

                      Center(
                        child: PrimaryButton(
                          label: "Continue",
                          isFullWidth: true,
                          onTap: () {
                            if (signUpStep2VehicleOwnerFormKey.currentState!.validate()){
                              signUpController.handleSignUp({
                                "name": signUpController.nameTC.text.trim(),
                                "phone": signUpController.phoneTC.text.trim(),
                                "email": signUpController.emailTC.text.trim(),
                                "country": signUpController.selectedCountry.value?.name ?? "",
                                "type": UserType.vehicleOwner,
                              });
                            }
                          },
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
