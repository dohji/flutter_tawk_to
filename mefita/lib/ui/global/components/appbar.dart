import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mefita/ui/global/helpers/style.dart';
import 'package:get/get.dart';

import 'buttons.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext ctx;
  final String title;
  final bool showBackButton;
  final bool? showBorder;
  final Color? backgroundColor;
  final Color? textColor;
  final List<Widget> actionButtons;
  const CustomAppBar({Key? key, required this.ctx, required this.title, required this.showBackButton, required this.actionButtons, this.showBorder = true, this.backgroundColor, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Get.isDarkMode? Brightness.light : Brightness.dark,
      ),
    );

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 6, right: 16, left: 16, bottom: 6),
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.background,
        // color: colorScheme.surface,
        border: showBorder == true ? Border(
          bottom: BorderSide(
            color: colorScheme.onBackground,
            width: 0.17,
          ),
        ) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Row(
            children: [
              if (showBackButton)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleIconButton(
                    icon: SvgPicture.asset(
                      'assets/svg/s-arrow-left.svg',
                      height: 20,
                      color: Get.theme.colorScheme.onBackground,
                      // color: Get.theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                    backgroundColor: Colors.transparent,
                    hasShadow: false,
                    size: 40,
                    onTap: () => Get.back(),
                  ),
                ),

              Padding(
                padding: EdgeInsets.only(left: showBackButton ? 0 : 8.0),
                child: Text(
                  title,
                  style: TextStyle(
                      color: colorScheme.onBackground,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),


          if (actionButtons.isNotEmpty)
          Container(width: 40),

          if (actionButtons.isNotEmpty)
          Row(
            children: [
                for (Widget button in actionButtons)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: button,
                  )
            ],
          )

        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(MediaQuery.of(ctx).padding.top + kToolbarHeight + 4);
}



class IndexAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext ctx;
  final String title;
  final bool showBackButton;
  final bool centerTitle;
  final List<Widget> actionButtons;
  final Function()? onBackButtonPressed;
  const IndexAppBar({Key? key, required this.ctx, required this.title, required this.showBackButton, required this.actionButtons, this.onBackButtonPressed, this.centerTitle = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        // statusBarIconBrightness: Get.isDarkMode? Brightness.light : Brightness.dark,
      ),
    );

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 6, right: 16, left: 16, bottom: 6),
      height: 108,
      // height: preferredSize.height,
      decoration: BoxDecoration(
          color: colorScheme.primary,
          // border: Border(
          //   bottom: BorderSide(
          //     color: colorScheme.primary,
          //     width: 0,
          //   ),
          // ),
        // borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(AppBorderRadius.sm),
        //   bottomRight: Radius.circular(AppBorderRadius.sm),
        // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          if (centerTitle)...[
            if (showBackButton)...[
              CircleIconButton(
                icon: SvgPicture.asset(
                  'assets/svg/s-arrow-left.svg',
                  height: 20,
                  color: Get.theme.colorScheme.onPrimary,
                ),
                backgroundColor: Colors.transparent,
                hasShadow: false,
                size: 40,
                onTap: () => onBackButtonPressed != null ? onBackButtonPressed!() : Get.back(),
              ),
            ]else...[
              if (actionButtons.isEmpty)
                Container(width: 40),
            ],

            Text(
              title,
              style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
          ]else...[
            Row(
              children: [
                if (showBackButton)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleIconButton(
                      icon: SvgPicture.asset(
                        'assets/svg/s-arrow-left.svg',
                        height: 20,
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                      backgroundColor: Colors.transparent,
                      hasShadow: false,
                      size: 40,
                      onTap: () => onBackButtonPressed != null ? onBackButtonPressed!() : Get.back(),
                    ),
                  ),

                Padding(
                  padding: EdgeInsets.only(left: showBackButton ? 0 : 8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (actionButtons.isEmpty)
            Container(width: 40),

          if (actionButtons.isNotEmpty)
            Row(
              children: [
                for (Widget button in actionButtons)
                  Padding(
                    padding: EdgeInsets.only(left: button == actionButtons.first ? 0 : 8.0),
                    child: button,
                  )
              ],
            )

        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(MediaQuery.of(ctx).padding.top + kToolbarHeight + 4);
}