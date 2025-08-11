import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/ui/global/components/buttons.dart';
import 'package:mefita/ui/global/helpers/style.dart';
import 'package:mefita/ui/global/helpers/text_input_decoration.dart';
import 'package:get/get.dart';

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

    // AnnotatedRegion<SystemUiOverlayStyle>(
    //   value: SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Get.isDarkMode ? Brightness.light : Brightness.dark,
    //     statusBarBrightness: Get.isDarkMode? Brightness.dark : Brightness.light,
    //   ),

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
                  Text("Enter your email and password to login to your account", style: textTheme.labelMedium),
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

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('Email',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      TextFormField(
                        controller: signInController.emailTC,
                        style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onBackground),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 30),
                          enabledBorder: inputBorder(colorScheme),
                          focusedBorder: inputBorderFocused(colorScheme),
                          errorBorder: inputBorder(colorScheme),
                          focusedErrorBorder: inputBorderFocused(colorScheme),
                          filled: true,
                          fillColor: colorScheme.onSurface.withValues(alpha: 0.03),
                          hintText: 'jane@email.com',
                          hintStyle: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface.withValues(alpha: 0.5)
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (String? value) => !GetUtils.isEmail(value!)
                            ? "Valid email required"
                            : null,
                      ),

                      const SizedBox(height: 27),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('Password',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Obx(() =>
                        TextFormField(
                          controller: signInController.passwordTC,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          obscureText: obscurePassword.value,
                          style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onBackground),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 30),
                              enabledBorder: inputBorder(colorScheme),
                              focusedBorder: inputBorderFocused(colorScheme),
                              errorBorder: inputBorder(colorScheme),
                              focusedErrorBorder: inputBorderFocused(colorScheme),
                              filled: true,
                              fillColor: colorScheme.onSurface.withValues(alpha: 0.03),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: IconButton(
                                    onPressed: (){
                                      obscurePassword.value = !obscurePassword.value;
                                    },
                                    icon: obscurePassword.value ?
                                    const Icon(Icons.visibility, color: Colors.grey) :
                                    const Icon(Icons.visibility_off, color: Colors.grey)
                                ),
                              ),
                            ),
                          validator: (String? value) => value!.trim().isEmpty
                          ? "Required"
                          : null,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextButton(
                          onPressed: () {
                            // Get.to(() => const ResetPasswordScreen());
                          },
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Forgotten your password? ",
                                      style: textTheme.labelSmall
                                  ),

                                  TextSpan(
                                    text: 'Reset Password',
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

                      const SizedBox(height: 27*2),

                      Center(
                        child: PrimaryButton(
                          label: "Login",
                          // foregroundColor: colorScheme.surface,
                          // backgroundColor: colorScheme.onBackground,
                          // width: double.maxFinite,
                          isFullWidth: true,
                          onTap: () {
                            if (signInFormKey.currentState!.validate()){
                              signInController.handleSignIn();
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 27/2),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            // Get.to(() => const SignUpScreen());
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
                                    text: 'Create an account now to have fuel delivered to your doorstep',
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
