import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mefita/services/api/general_apis.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/ui/global/components/buttons.dart';
import 'package:mefita/ui/global/helpers/style.dart';
import 'package:mefita/ui/global/helpers/text_input_decoration.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pinput/pinput.dart';
import 'package:shimmer/shimmer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mime_type/mime_type.dart';


class Globals{

  static Widget loadingWidget({Color? color}){
    return SizedBox(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(
          strokeWidth: 5,
          backgroundColor: Colors.black.withOpacity(0.05),
          color: color,
        )
    );
  }

  static showSuccessToast(String message, {String? title}){
    if (Get.isSnackbarOpen) {
      Get.back();
    }

    Get.rawSnackbar(
      backgroundColor: Colors.green.shade600,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      borderColor: Colors.green,
      borderRadius: 10,
      boxShadows: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          blurRadius: 8.0,
        )
      ],
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white,),
      messageText: Text(
        message,
        style: Get.theme.textTheme.bodyMedium!.copyWith(color: Colors.white,),
      ),
    );
  }

  static showErrorToast(String message, {String? title}){
    if (Get.isSnackbarOpen) {
      Get.back();
    }

    Get.rawSnackbar(
      backgroundColor: Colors.red.shade400,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      borderColor: Colors.red,
      borderRadius: 10,
      boxShadows: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          blurRadius: 8.0,
        )
      ],
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error, color: Colors.white,),
      messageText: Text(
        message,
        style: Get.theme.textTheme.bodyMedium!.copyWith(color: Colors.white,),
      ),
    );
  }

  static showInfoToast(String message, {String? title, SnackPosition? snackPosition = SnackPosition.TOP}){
    if (Get.isSnackbarOpen) {
      Get.back();
    }

    Get.rawSnackbar(
      backgroundColor: Colors.white,
      snackPosition: snackPosition!,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      borderColor: Colors.white,
      borderRadius: 10,
      boxShadows: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          blurRadius: 8.0,
        )
      ],
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info, color: Colors.black,),
      messageText: Text(
        message,
        style: Get.theme.textTheme.bodyMedium!.copyWith(color: Colors.black,),
      ),
    );

  }

  static showLoadingDialog(){
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    if(Get.overlayContext!.mounted){
      CustomProgressDialog progressDialog = CustomProgressDialog(
        // globalController.buildContext,
        Get.overlayContext!,
        dismissable: false,
        loadingWidget: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                ),
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                    // height: 25,
                    // width: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/loading.gif',
                          height: 50,
                        ),
                        // SizedBox(
                        //     height: 25,
                        //     width: 25,
                        //     child: CircularProgressIndicator( color: Colors.white, backgroundColor: Colors.black.withOpacity(0.05))
                        // ),
                        // const SizedBox(width: 10),
                        // Text(message, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    )
                )
            ),
          ),
        ),
      );
      progressDialog.show();
    }
  }

  static hideLoadingDialog(){
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    if(Get.overlayContext!.mounted){
      Get.back();
    }
  }

  static infoDialog({String? title, Widget? content, required Widget image, Function? okayTap, bool? canDismiss = true, String? okayText = "okay"}){
    ColorScheme colorScheme = Get.theme.colorScheme;
    BuildContext? context = Get.overlayContext;
    AlertDialog(
      elevation: 0,
      backgroundColor: colorScheme.secondary,
      scrollable: true,
      insetPadding: const EdgeInsets.all(20.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      content: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: colorScheme.onBackground.withOpacity(0.03),
                    shape: BoxShape.circle
                ),
                child: image
            ),

            const SizedBox(height: 15),

            Text(title!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onBackground)
            ),

            const SizedBox(height: 10),

            content!,

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  label: "",
                  text: Text(
                    okayText!,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: colorScheme.onPrimary),
                  ),
                  backgroundColor: colorScheme.primary,
                  isFullWidth: true,
                  onTap: () => okayTap != null ? okayTap() : Navigator.of(context!).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    ).show(context!, dialogTransitionType: DialogTransitionType.NONE, barrierDismissible: canDismiss!, barrierColor: Colors.black.withOpacity(0.5));
  }

  static errorDialog({String? title, Widget? content, required Widget image, Function? okayTap}){
    ColorScheme colorScheme = Get.theme.colorScheme;
    BuildContext? context = Get.overlayContext;
    AlertDialog(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      scrollable: false,
      insetPadding: const EdgeInsets.all(20.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      content: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    // color: Colors.green,
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle
                ),
                child: image
            ),

            const SizedBox(height: 15),

            Text(title!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),

            const SizedBox(height: 10),

            content!,

            const SizedBox(height: 30),

            PrimaryButton(
              label: "",
              text: Text(
                'Okay',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
              backgroundColor: colorScheme.primary,
              isFullWidth: true,
              onTap: () => okayTap != null ? okayTap() : Navigator.of(context!).pop(),
            ),
          ],
        ),
      ),
    ).show(context!, dialogTransitionType: DialogTransitionType.NONE, barrierDismissible: true, barrierColor: Colors.black.withOpacity(0.5));
  }

  static successDialog({String? title, Widget? content, required Widget image, Function? okayTap}){
    ColorScheme colorScheme = Get.theme.colorScheme;
    BuildContext? context = Get.overlayContext;
    AlertDialog(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      scrollable: false,
      insetPadding: const EdgeInsets.all(20.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      content: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    // color: Colors.green,
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle
                ),
                child: image
            ),

            const SizedBox(height: 15),

            Text(title!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface)
            ),

            const SizedBox(height: 10),

            content!,

            const SizedBox(height: 30),

            PrimaryButton(
              label: "Okay",
              backgroundColor: colorScheme.primary,
              isFullWidth: true,
              onTap: () => okayTap != null ? okayTap() : Navigator.of(context!).pop(),
            ),
          ],
        ),
      ),
    ).show(context!, dialogTransitionType: DialogTransitionType.NONE, barrierDismissible: true, barrierColor: Colors.black.withOpacity(0.5));
  }

  static primaryConfirmDialog({String? title, Widget? content, required Widget image, Function? okayTap, Function? cancelTap, String? okayText, String? cancelText}){
    ColorScheme colorScheme = Get.theme.colorScheme;
    BuildContext? context = Get.overlayContext;
    AlertDialog(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      scrollable: false,
      insetPadding: const EdgeInsets.all(20.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      content: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: colorScheme.onSurface.withOpacity(0.08),
                    shape: BoxShape.circle
                ),
                child: image
            ),

            const SizedBox(height: 15),

            Text(title!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onBackground)
            ),

            const SizedBox(height: 10),

            content!,

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                PrimaryButton(
                  label: "",
                  text: Text(
                    cancelText ?? 'No, cancel',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: colorScheme.onBackground),
                  ),
                  backgroundColor: Colors.transparent,
                  isFullWidth: false,
                  onTap: () => cancelTap != null ? cancelTap() : Navigator.of(context!).pop(),
                ),
                const SizedBox(width: 20,),
                PrimaryButton(
                  label: okayText ?? 'Yes, continue',
                  backgroundColor: colorScheme.primary,
                  isFullWidth: false,
                  onTap: () => okayTap != null ? okayTap() : Navigator.of(context!).pop(),
                )
              ],
            ),
          ],
        ),
      ),
    ).show(context!, dialogTransitionType: DialogTransitionType.NONE, barrierDismissible: true, barrierColor: Colors.black.withOpacity(0.5));
  }


  static setPinDialog(){

    GlobalController globalController = Get.find();

    ColorScheme colorScheme = Get.theme.colorScheme;
    TextTheme textTheme = Get.theme.textTheme;
    BuildContext? context = Get.overlayContext;

    final TextEditingController pinController = TextEditingController();
    final FocusNode focusNode = FocusNode();
    final GlobalKey<FormState> pinFormKey = GlobalKey<FormState>();

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
      textStyle: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600)
    );

    AlertDialog(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      scrollable: false,
      insetPadding: const EdgeInsets.all(20.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      content: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text("Set 4-Digit PIN", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text("This PIN will be required every time you redeem a coupon. Make sure to choose something you’ll remember and keep it private, don’t share it with anyone.", style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 40),

            FractionallySizedBox(
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: pinFormKey,
                  child: Pinput(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    controller: pinController,
                    focusNode: focusNode,
                    defaultPinTheme: defaultPinTheme,
                    errorTextStyle: textTheme.bodySmall!.copyWith(color: colorScheme.error),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      height: 68,
                      width: 64,
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      return value!.length == 4 ? null : 'Enter 4 digit code';
                    },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      debugPrint('onCompleted: $pin');
                    },
                    onChanged: (value) {
                      debugPrint('onChanged: $value');
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            PrimaryButton(
              label: "Okay",
              backgroundColor: colorScheme.primary,
              isFullWidth: true,
              onTap: () async {
                focusNode.unfocus();
                if (pinFormKey.currentState!.validate()){
                  bool res = await globalController.setPin(pin: pinController.text);
                  if (res){
                    Get.back();
                    successDialog(
                      title: 'PIN Successfully Set',
                      content: Text('Do not share it with anyone',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Get.theme.colorScheme.onSurface),
                      ),
                      image: const Icon(Icons.check_circle, size: 40, color: Colors.green),
                      okayTap: (){
                        Get.back();
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    ).show(context!, dialogTransitionType: DialogTransitionType.NONE, barrierDismissible: false, barrierColor: Colors.black.withOpacity(0.5));
  }

  static changePinDialog(){

    GlobalController globalController = Get.find();

    ColorScheme colorScheme = Get.theme.colorScheme;
    TextTheme textTheme = Get.theme.textTheme;
    BuildContext? context = Get.overlayContext;

    final TextEditingController oldPinController = TextEditingController();
    final TextEditingController newPinController = TextEditingController();
    final FocusNode focusNode = FocusNode();
    final GlobalKey<FormState> changePinFormKey = GlobalKey<FormState>();

    final defaultPinTheme = PinTheme(
        width: 56,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.transparent),
        ),
        textStyle: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600)
    );

    AlertDialog(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      scrollable: false,
      insetPadding: const EdgeInsets.all(20.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      content: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text("Change PIN", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text("Enter your old pin and a new 4-digit number to change your pin.", style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 25),

            FractionallySizedBox(
              widthFactor: 1,
              child: Form(
                key: changePinFormKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text("Current Pin", style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onSurface), textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 5),
                      Pinput(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        showCursor: false,
                        controller: oldPinController,
                        focusNode: focusNode,
                        defaultPinTheme: defaultPinTheme,
                        errorTextStyle: textTheme.bodySmall!.copyWith(color: colorScheme.error),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          height: 68,
                          width: 64,
                          decoration: defaultPinTheme.decoration!.copyWith(
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyWith(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          return value!.length == 4 ? null : 'Enter 4 digit code';
                        },
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        onCompleted: (pin) {
                          debugPrint('onCompleted: $pin');
                        },
                        onChanged: (value) {
                          debugPrint('onChanged: $value');
                        },
                      ),

                      const SizedBox(height: 25),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text("New Pin", style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onSurface), textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 5),
                      Pinput(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        showCursor: false,
                        controller: newPinController,
                        // focusNode: focusNode,
                        defaultPinTheme: defaultPinTheme,
                        errorTextStyle: textTheme.bodySmall!.copyWith(color: colorScheme.error),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          height: 68,
                          width: 64,
                          decoration: defaultPinTheme.decoration!.copyWith(
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyWith(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          return value!.length == 4 ? null : 'Enter 4 digit code';
                        },
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        onCompleted: (pin) {
                          debugPrint('onCompleted: $pin');
                        },
                        onChanged: (value) {
                          debugPrint('onChanged: $value');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            PrimaryButton(
              label: "Okay",
              backgroundColor: colorScheme.primary,
              isFullWidth: true,
              onTap: () async {
                focusNode.unfocus();
                if (changePinFormKey.currentState!.validate()){
                  bool res = await globalController.changePin(pin: newPinController.text, oldPin: oldPinController.text);
                  if (res){
                    Get.back();
                    successDialog(
                      title: 'PIN Successfully Changed',
                      content: Text('Do not share it with anyone',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Get.theme.colorScheme.onSurface),
                      ),
                      image: const Icon(Icons.check_circle, size: 40, color: Colors.green),
                      okayTap: (){
                        Get.back();
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    ).show(context!, dialogTransitionType: DialogTransitionType.NONE, barrierDismissible: true, barrierColor: Colors.black.withOpacity(0.5));
  }


  static Future<bool> showTrackingConsentDialog() async {
    BuildContext context = Get.overlayContext!;
    ColorScheme colorScheme = Get.theme.colorScheme;
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: colorScheme.secondary,
          scrollable: false,
          insetPadding: const EdgeInsets.all(20.0),
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.none,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          // title: Text("Analytics Tracking"),
          // content: Text("We use analytics to improve your experience. Do you allow data collection?"),
          // actions: [
          //   TextButton(
          //     onPressed: () => Navigator.of(context).pop(false),
          //     child: Text("No"),
          //   ),
          //   TextButton(
          //     onPressed: () => Navigator.of(context).pop(true),
          //     child: Text("Yes"),
          //   ),
          // ],
          content: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        color: colorScheme.onBackground.withOpacity(0.08),
                        shape: BoxShape.circle
                    ),
                    child: Icon(Icons.privacy_tip_rounded, size: 40, color: colorScheme.onBackground.withOpacity(0.5)),
                ),

                const SizedBox(height: 15),

                Text("Your Privacy Matters",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onBackground)
                ),

                const SizedBox(height: 10),

                Text("We use analytics to understand how you use our app and improve your experience. "
                     "This data helps us enhance features and fix issues. Would you like to allow us to collect anonymous usage data?",
                  style: TextStyle(fontSize: 14, color: colorScheme.onBackground),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton(
                      label: "",
                      text: Text(
                        'no',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: colorScheme.onBackground),
                      ),
                      backgroundColor: Colors.transparent,
                      isFullWidth: false,
                      onTap: () => Navigator.of(context).pop(false),
                    ),
                    const SizedBox(width: 20,),
                    PrimaryButton(
                      label:'yes',
                      backgroundColor: colorScheme.primary,
                      isFullWidth: false,
                      onTap: () => Navigator.of(context).pop(true),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ) ?? false;
  }

  static Widget buildShimmerContainer({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[200]!,
      // highlightColor: Colors.grey[100]!,
      child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          )
      ),
    );
  }

  /**************************************************************
  *************************************************************
                          FUNCTIONS
  *************************************************************
  **************************************************************/
  static String formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final sameYear = now.year == dateTime.year;

    if (sameYear) {
      return DateFormat('MMM d').format(dateTime);
    } else {
      return DateFormat('yMMMMd').format(dateTime);
    }
  }

  static String daysUntilTimestamp(DateTime timestamp) {
    DateTime now = DateTime.now();
    Duration difference = timestamp.difference(now);
    int daysLeft = difference.inDays;

    if (daysLeft == 1) {
      return '1 day left';
    } else {
      return '$daysLeft days left';
    }
  }

  static String formatDateTime({
    required String dateString,
    required bool isTime,
    bool isFull = false,
    bool isTimePast = false,
  }) {
    DateTime dateTime = DateTime.parse(dateString);
    DateTime now = DateTime.now();

    if (isTimePast) {
      bool isToday = dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day;

      if (isToday) {
        return DateFormat('hh:mm a').format(dateTime);
      } else {
        return DateFormat('MMM d • hh:mm a').format(dateTime);
      }
    }

    if (isFull) {
      return DateFormat('MMMM d, y • h:mm a').format(dateTime);
    } else if (isTime) {
      return DateFormat('hh:mm a').format(dateTime);
    } else {
      return DateFormat('MMMM d, y').format(dateTime);
    }
  }

  static String formatAmountWithThousandSeparators(num amount) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(amount);
  }

  static String getCurrentDate(){
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat('d MMMM, y');
    return dateFormat.format(now);
  }

  static String getCurrentTime(){
    DateTime now = DateTime.now();
    DateFormat timeFormat = DateFormat('h:mm a');
    return timeFormat.format(now);
  }

  static String greeting(){
    DateTime now = DateTime.now();
    int hour = now.hour;
    if (hour < 12) {
      return 'good morning';
    } else if (hour < 17) {
      return 'good afternoon';
    } else {
      return 'good evening';
    }
  }

  static Future<void> pickImage(
      BuildContext context, {
        required void Function(String imagePath) onPick,
        int targetSizeBytes = 300 * 1024, // 300KB default
        int minQuality = 10,
        int qualityStep = 15,
        ImageSource source = ImageSource.camera,
      }) async {
    try {
      final _imagePicker = ImagePicker();
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 100,
      );

      if (image == null) return;

      // Validate MIME type
      final mimeType = mime(image.path);
      if (mimeType == null || !mimeType.startsWith('image/')) {
        Globals.showErrorToast("Kindly select a valid image");
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final originalFile = File(image.path);
      final originalSize = await originalFile.length();

      // If already under target size, use original
      if (originalSize <= targetSizeBytes) {
        onPick(image.path);
        return;
      }

      final baseOutputPath = p.join(
          tempDir.path,
          "compressed_${DateTime.now().millisecondsSinceEpoch}"
      );

      // Calculate initial dimensions based on file size
      int targetWidth = 1080;
      int targetHeight = 1080;

      // Scale down dimensions for very large files
      if (originalSize > (2 * 1024 * 1024)) { // > 2MB
        targetWidth = 800;
        targetHeight = 800;
      } else if (originalSize > (1 * 1024 * 1024)) { // > 1MB
        targetWidth = 900;
        targetHeight = 900;
      }

      File? compressedFile;
      int quality = 85; // Start with slightly lower quality for efficiency

      // First attempt with dimension scaling
      final firstAttemptPath = "${baseOutputPath}_scaled.jpg";
      var result = await FlutterImageCompress.compressAndGetFile(
        image.path,
        firstAttemptPath,
        quality: quality,
        minWidth: targetWidth,
        minHeight: targetHeight,
      );

      if (result != null) {
        final resultFile = File(result.path);
        final size = await resultFile.length();
        print("Scaled attempt: quality=$quality, dimensions=${targetWidth}x$targetHeight, size=${(size / 1024).toStringAsFixed(1)} KB");

        if (size <= targetSizeBytes) {
          compressedFile = resultFile;
        } else {
          // Clean up failed attempt
          await resultFile.delete().catchError((_) {});
        }
      }

      // If scaling wasn't enough, use binary search for quality
      if (compressedFile == null) {
        int lowQuality = minQuality;
        int highQuality = quality;
        File? bestResult;

        while (lowQuality <= highQuality) {
          final midQuality = (lowQuality + highQuality) ~/ 2;
          final attemptPath = "${baseOutputPath}_q$midQuality.jpg";

          result = await FlutterImageCompress.compressAndGetFile(
            image.path,
            attemptPath,
            quality: midQuality,
            minWidth: targetWidth,
            minHeight: targetHeight,
          );

          if (result == null) break;

          final resultFile = File(result.path);
          final size = await resultFile.length();
          print("Binary search: quality=$midQuality, size=${(size / 1024).toStringAsFixed(1)} KB");

          if (size <= targetSizeBytes) {
            // Clean up previous best result
            await bestResult?.delete().catchError((_) {});
            bestResult = resultFile;
            lowQuality = midQuality + 1; // Try higher quality
          } else {
            // Clean up failed attempt
            await resultFile.delete().catchError((_) {});
            highQuality = midQuality - 1; // Try lower quality
          }
        }

        compressedFile = bestResult;
      }

      // Fallback: aggressive dimension reduction if still too large
      if (compressedFile == null && targetWidth > 600) {
        print("Attempting aggressive compression with smaller dimensions");
        final fallbackPath = "${baseOutputPath}_fallback.jpg";

        result = await FlutterImageCompress.compressAndGetFile(
          image.path,
          fallbackPath,
          quality: minQuality,
          minWidth: 600,
          minHeight: 600,
        );

        if (result != null) {
          final resultFile = File(result.path);
          final size = await resultFile.length();
          print("Fallback attempt: size=${(size / 1024).toStringAsFixed(1)} KB");

          if (size <= targetSizeBytes) {
            compressedFile = resultFile;
          } else {
            await resultFile.delete().catchError((_) {});
          }
        }
      }

      if (compressedFile == null) {
        Globals.showErrorToast("Could not compress image below ${(targetSizeBytes / 1024).toInt()}KB");
        return;
      }

      final finalSize = await compressedFile.length();
      print("Final compressed image: ${(finalSize / 1024).toStringAsFixed(1)} KB");

      onPick(compressedFile.path);

    } catch (e) {
      print("Image compression error: $e");
      Globals.showErrorToast("Failed to pick image: ${e.toString()}");
    }
  }


}