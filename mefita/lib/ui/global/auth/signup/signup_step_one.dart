import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/ui/global/components/buttons.dart';
import 'package:mefita/ui/global/helpers/style.dart';
import 'package:get/get.dart';
import 'package:mefita/utils/constants.dart';
import 'signup_step_two.dart';

// class SignUpStepOne extends StatefulWidget {
//   const SignUpStepOne({super.key});
//
//   @override
//   State<SignUpStepOne> createState() => _SignUpStepOneState();
// }
// class _SignUpStepOneState extends State<SignUpStepOne> {
//   final _formKey = GlobalKey<FormState>();
//
//   // 0 = vehicle owner, 1 = provider, 2 = tower
//   RxInt selectedRoleIndex = 0.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme  = Theme.of(context).textTheme;
//
//     return Scaffold(
//       backgroundColor: colorScheme.surface,
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: CustomScrollView(
//           slivers: [
//             SliverAppBar.large(
//               title: Text('Create Account', style: textTheme.titleLarge),
//               backgroundColor: colorScheme.surface,
//               surfaceTintColor: Colors.transparent,
//             ),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Select your role",
//                         style:
//                         textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
//
//                     const SizedBox(height: 16),
//
//                     Obx(() => Column(
//                       children: [
//                         _roleTile(
//                           title: "Vehicle Owner",
//                           value: 0,
//                           selected: selectedRoleIndex.value == 0,
//                         ),
//                         const SizedBox(height: 12),
//                         _roleTile(
//                           title: "Service Provider",
//                           value: 1,
//                           selected: selectedRoleIndex.value == 1,
//                         ),
//                         const SizedBox(height: 12),
//                         _roleTile(
//                           title: "Tower / Tow Truck",
//                           value: 2,
//                           selected: selectedRoleIndex.value == 2,
//                         ),
//                       ],
//                     )),
//
//                     const SizedBox(height: 32),
//                     PrimaryButton(
//                         label: "Continue",
//                         isFullWidth: true,
//                         onTap: () {
//                           // go to step 2
//                           Get.to(() => SignUpStepTwo(selectedRoleIndex.value));
//                         }),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _roleTile({required String title, required int value, bool selected = false}) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return GestureDetector(
//       onTap: () => selectedRoleIndex.value = value,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
//         decoration: BoxDecoration(
//           color: selected ? colorScheme.primary.withOpacity(.08) : colorScheme.surface,
//           borderRadius: BorderRadius.circular(AppBorderRadius.md),
//           border: Border.all(
//             color: selected ? colorScheme.primary : colorScheme.outlineVariant,
//           ),
//         ),
//         child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
//       ),
//     );
//   }
// }

class SignUpStepOne extends StatefulWidget {

  const SignUpStepOne({Key? key})
      : super(key: key);

  @override
  State<SignUpStepOne> createState() => _SignUpStepOneState();
}

class _SignUpStepOneState extends State<SignUpStepOne> {

  GlobalController globalController = Get.find();

  // RxInt selectedRoleIndex = 0.obs;
  RxString selectedUserType = UserType.vehicleOwner.obs;
  late ScrollController _scrollController;
  bool sliverAppBarExpanded = true;

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
              foregroundColor: colorScheme.onBackground,
              backgroundColor: colorScheme.background,
              surfaceTintColor: Colors.transparent,
              title: sliverAppBarExpanded
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Create Account',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onBackground,
                      )
                  ),
                  const SizedBox(height: 5),
                  Text("Choose how you want to use Mefita", style: textTheme.labelMedium!.copyWith(color: colorScheme.onBackground)),
                ],
              )
                  : Text(
                  'Create Account',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onBackground)
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 27),

                    Obx(() => Column(
                      children: [
                        _roleTile(
                          title: "Vehicle Owner",
                          subTitle: "Request repairs or towing",
                          svgIcon: "assets/svg/vehicle-owner.svg",
                          value: UserType.vehicleOwner,
                          selected: selectedUserType.value == UserType.vehicleOwner,
                        ),
                        const SizedBox(height: 12),
                        _roleTile(
                          title: "Service Provider",
                          subTitle: "Offer auto repair services",
                          svgIcon: "assets/svg/service-provider.svg",
                          value: UserType.serviceProvider,
                          selected: selectedUserType.value == UserType.serviceProvider,
                        ),
                        const SizedBox(height: 12),
                        _roleTile(
                          title: "Towing Operator",
                          subTitle: "Receive and handle tow requests",
                          svgIcon: "assets/svg/towing-operator.svg",
                          value: UserType.towingOperator,
                          selected: selectedUserType.value == UserType.towingOperator,
                        ),
                      ],
                    )),

                    const SizedBox(height: 27 * 2),

                    Center(
                      child: PrimaryButton(
                        label: "Continue",
                        isFullWidth: true,
                        onTap: () {

                        },
                      ),
                    ),

                    SizedBox(height: AppPadding.vertical),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _roleTile({required String title, required String subTitle, required String svgIcon, required String value, bool selected = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width / 3;
    return GestureDetector(
      onTap: () => selectedUserType.value = value,
      child: Container(
        width: double.maxFinite,
        // height: width,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary.withOpacity(.08) : colorScheme.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: selected ? colorScheme.primary.withOpacity(.1) : colorScheme.onSurface.withOpacity(.04),
                shape: BoxShape.circle,
              ),
                child: SvgPicture.asset(svgIcon, height: 40, width: 40)
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      subTitle,
                      style: Theme.of(context).textTheme.bodySmall
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }


}