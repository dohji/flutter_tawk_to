import 'dart:convert';
import 'dart:math';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/ui/global/components/buttons.dart';
import 'package:mefita/ui/global/helpers/style.dart';
import 'package:mefita/ui/global/helpers/text_input_decoration.dart';
import 'package:get/get.dart';


class SignUpStepTwo extends StatefulWidget {
  final int selectedRole;
  const SignUpStepTwo(this.selectedRole, {super.key});

  @override
  State<SignUpStepTwo> createState() => _SignUpStepTwoState();
}

class _SignUpStepTwoState extends State<SignUpStepTwo> {
  final _formKey = GlobalKey<FormState>();

  final nameTC = TextEditingController();
  final phoneTC = TextEditingController();
  final emailTC = TextEditingController();
  final passwordTC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: Text('Create Account', style: textTheme.titleLarge),
              backgroundColor: colorScheme.surface,
              surfaceTintColor: Colors.transparent,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // full name
                      TextFormField(
                        controller: nameTC,
                        decoration: InputDecoration(
                          hintText: 'Full name',
                          enabledBorder: inputBorder(colorScheme),
                          focusedBorder: inputBorderFocused(colorScheme),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? "Required" : null,
                      ),
                      const SizedBox(height: 20),

                      // phone (always)
                      TextFormField(
                        controller: phoneTC,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Phone number',
                          enabledBorder: inputBorder(colorScheme),
                          focusedBorder: inputBorderFocused(colorScheme),
                        ),
                        validator: (value) => !GetUtils.isPhoneNumber(value ?? '')
                            ? "Valid phone required"
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // only show email/password if NOT vehicle owner (0)
                      if (widget.selectedRole != 0) ...[
                        TextFormField(
                          controller: emailTC,
                          decoration: InputDecoration(
                            hintText: 'Email address',
                            enabledBorder: inputBorder(colorScheme),
                            focusedBorder: inputBorderFocused(colorScheme),
                          ),
                          validator: (value) =>
                          !GetUtils.isEmail(value ?? '')
                              ? "Valid email required"
                              : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordTC,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            enabledBorder: inputBorder(colorScheme),
                            focusedBorder: inputBorderFocused(colorScheme),
                          ),
                          validator: (value) =>
                          (value == null || value.length < 6)
                              ? "Min. 6 characters required"
                              : null,
                        ),
                        const SizedBox(height: 20),
                      ],

                      PrimaryButton(
                        label: 'Create Account',
                        isFullWidth: true,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // handle signup
                            // if widget.selectedRole == 0 → phone OTP flow
                            // else → go to provider/tower details screen
                          }
                        },
                      ),
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