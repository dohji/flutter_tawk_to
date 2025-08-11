import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/ui/global/components/appbar.dart';
import 'package:mefita/ui/global/helpers/globals.dart';
import 'package:mefita/ui/global/helpers/style.dart';
import 'package:mefita/utils/constants.dart';
import 'package:get/get.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>{

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    GlobalController globalController = Get.find();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light
      ),
    );

    String userName = globalController.userProfile.value["name"] ?? "";
    String userType = globalController.tokenData["user"]["role"];
    String firstName = userName.split(" ").first;
    String imageUrl = globalController.userProfile.value["image"] ?? "";

    return Scaffold(
      appBar: IndexAppBar(
        ctx: context,
        title: 'Account',
        showBackButton: true,
        centerTitle: false,
        actionButtons: [
          TextButton(
            onPressed: () {
              globalController.logout();
            },
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onPrimaryContainer,
              backgroundColor: colorScheme.primaryContainer,
              minimumSize: const Size(0, 36),
              splashFactory: NoSplash.splashFactory,
            ),
            child: Text("Logout", style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
          )
        ],
      ),
      body: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.sm), topRight: Radius.circular(AppBorderRadius.sm)),
            color: colorScheme.background
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal, vertical: AppPadding.vertical),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (imageUrl.isNotEmpty)...[
                          GestureDetector(
                            onTap: (){
                              Get.to(() => AccountScreen());
                            },
                            behavior: HitTestBehavior.opaque,
                            child: CachedNetworkImage(imageUrl: imageUrl,
                                imageBuilder: (context, imageProvider) => Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colorScheme.secondary.withOpacity(0.6),
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colorScheme.secondary.withOpacity(0.6),
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colorScheme.secondary.withOpacity(0.6),
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/user_avatar.jpg"),
                                    ),
                                  ),
                                )
                            ),
                          ),
                        ]else ...[
                          GestureDetector(
                            onTap: (){
                              Get.to(() => AccountScreen());
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: colorScheme.secondary.withOpacity(0.6),
                                    width: 2,
                                  ),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/user_avatar.jpg"),
                                  )
                              ),
                            ),
                          )
                        ],

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userName,
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis
                              ),
                              // const SizedBox(height: 4),
                              Text(globalController.userProfile.value["email"], style: textTheme.bodySmall),
                            ],
                          ),
                        ),

                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Name ", style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 20),
                  Flexible(child: Text(globalController.userProfile.value["name"], style: textTheme.bodyMedium)),
                ],
              ),
              const SizedBox(height: 20),
              DottedDashedLine(height: 0, width: double.maxFinite, axis: Axis.horizontal, dashColor: colorScheme.onSurface.withOpacity(0.1)),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Email ", style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 20),
                  Flexible(child: Text(globalController.userProfile.value["email"], style: textTheme.bodyMedium)),
                ],
              ),
              const SizedBox(height: 20),
              DottedDashedLine(height: 0, width: double.maxFinite, axis: Axis.horizontal, dashColor: colorScheme.onSurface.withOpacity(0.1)),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Phone ", style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 20),
                  Flexible(child: Text(globalController.userProfile.value["phone"], style: textTheme.bodyMedium)),
                ],
              ),
              const SizedBox(height: 20),
              DottedDashedLine(height: 0, width: double.maxFinite, axis: Axis.horizontal, dashColor: colorScheme.onSurface.withOpacity(0.1)),
              const SizedBox(height: 20),


              // if (userType == UserType.institution_driver)...[
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text("Pin Code ", style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              //       const SizedBox(width: 20),
              //       TextButton(
              //         onPressed: () {
              //           Globals.changePinDialog();
              //         },
              //         style: TextButton.styleFrom(
              //           foregroundColor: colorScheme.onPrimaryContainer,
              //           backgroundColor: colorScheme.primaryContainer,
              //           minimumSize: const Size(0, 36),
              //           splashFactory: NoSplash.splashFactory,
              //         ),
              //         child: Text("Change Pin", style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
              //       )
              //     ],
              //   ),
              //   const SizedBox(height: 20),
              //   DottedDashedLine(height: 0, width: double.maxFinite, axis: Axis.horizontal, dashColor: colorScheme.onSurface.withOpacity(0.1)),
              //   const SizedBox(height: 20),
              // ],

            ],
          ),
        ),
      ),

    );
  }

}

