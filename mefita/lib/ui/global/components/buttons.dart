import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mefita/ui/global/helpers/style.dart';
import 'package:get/get.dart';


class PrimaryButton extends StatelessWidget {
  final String? label;
  final Widget? text;
  final Function? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final bool? isFullWidth;
  final double? width;
  final OutlinedBorder? shape;
  const PrimaryButton({Key? key, @required this.label, this.backgroundColor, this.foregroundColor, @required this.onTap, this.isFullWidth, this.borderColor, this.text, this.width, this.shape}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    double wWidth = MediaQuery.of(context).size.width;
    return SizedBox(
        // width: double.maxFinite,
        // width: isFullWidth == true ? width : null,
        width: (isFullWidth == false && width == null) ? null : isFullWidth == true ? wWidth : width,
        // width: width * 0.5,

        // width: isFullWidth == null ? width : isFullWidth! ? width : null,
        height: AppButtonProps.buttonHeight,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.onPrimary,
            backgroundColor: backgroundColor ?? colorScheme.primary,
            // minimumSize: const Size(0, 36),
            shape: shape ?? RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppButtonProps.borderRadius)),
                side: BorderSide(color: borderColor ?? Colors.transparent, style: borderColor != null ? BorderStyle.solid : BorderStyle.none)
            ),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () => onTap!(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: text ?? Text(label!,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: foregroundColor ?? colorScheme.onPrimary),),
          ),
        ));
  }
}


class CustomButton extends StatelessWidget {
  final Widget? label;
  final Function? onTap;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final double? verticalPadding;
  final double? horizontalPadding;
  final bool? isFullWidth;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  const CustomButton({Key? key, @required this.label, required this.backgroundColor, this.width, this.height, @required this.onTap, this.isFullWidth, this.verticalPadding, this.horizontalPadding, this.borderRadius, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: isFullWidth! ? double.infinity : null,
        height: height ?? AppButtonProps.buttonHeight,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: backgroundColor,
            minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(AppButtonProps.borderRadius))
            ),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () => onTap!(),
          child: Padding(
            padding: padding ?? EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20, vertical: verticalPadding ?? 7),
            child: label!,
          ),
        ));
  }
}



class SecondaryButton extends StatelessWidget {
  final String? label;
  final Function? onTap;
  final bool? isFullWidth;
  const SecondaryButton({Key? key, @required this.label, @required this.onTap, this.isFullWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: isFullWidth == null ? double.infinity : isFullWidth! ? double.infinity : null,
        height: AppButtonProps.buttonHeight,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(Get.overlayContext!).colorScheme.primary.withOpacity(0.1),
            foregroundColor: Colors.white,
            // minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppButtonProps.borderRadius))
            ),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () => onTap!(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(label!,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Theme.of(Get.overlayContext!).colorScheme.onBackground),),
          ),
        ));
  }
}


class ButtonWithLeftIcon extends StatelessWidget {
  final String? label;
  final Widget icon;
  final Color? backgroundColor;
  final Color? foreColor;
  final Function? onTap;
  final bool? isFullWidth;
  const ButtonWithLeftIcon({Key? key, required this.label, required this.icon, this.backgroundColor, this.foreColor,  required this.onTap, this.isFullWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
        width: isFullWidth == null ? double.infinity : isFullWidth! ? double.infinity : null,
        height: AppButtonProps.buttonHeight,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor ?? colorScheme.primary,
            foregroundColor: Colors.white,
            // minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppButtonProps.borderRadius))
            ),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () => onTap!(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: 10),
                Text(label!,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: foreColor ?? Colors.white),
                ),
              ],
            ),
          ),
        ));
  }
}

class ButtonWithRightIcon extends StatelessWidget {
  final String? label;
  final Widget icon;
  final Color? backgroundColor;
  final Color? foreColor;
  final Function? onTap;
  final bool? isFullWidth;
  const ButtonWithRightIcon({Key? key, required this.label, required this.icon, this.backgroundColor, this.foreColor,  required this.onTap, this.isFullWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
        width: isFullWidth == null ? double.infinity : isFullWidth! ? double.infinity : null,
        height: AppButtonProps.buttonHeight,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor ?? colorScheme.primary,
            foregroundColor: Colors.white,
            // minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppButtonProps.borderRadius))
            ),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () => onTap!(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label!,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: foreColor ?? Colors.white),
                ),
                icon,
              ],
            ),
          ),
        ));
  }
}


class PrimaryTextButton extends StatelessWidget {
  final String? label;
  final Function? onTap;
  final Color color;
  const PrimaryTextButton({Key? key, @required this.label, required this.color, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            // minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppButtonProps.borderRadius))
            ),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () => onTap!(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(label!,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: color),),
          ),
        ));
  }
}


class CircleIconButton extends StatelessWidget {
  final Widget? icon;
  final double? size;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? splashColor;
  final bool? hasShadow;
  final bool? isMenuButton;
  final Function? onTap;
  const CircleIconButton({
    Key? key, this.icon, this.size = 40.0, this.backgroundColor, this.borderColor = Colors.transparent, this.splashColor, this.hasShadow = false, this.isMenuButton = false, this.onTap}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: hasShadow! ? BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: 8.0,
          )
        ],
      ) : const BoxDecoration(),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor!, width: borderColor?.value == 0 ? 0 : 1)
          ),
          child: InkWell(
            onTap: () => isMenuButton! ? Scaffold.of(context).openDrawer() : onTap!(),
            customBorder: const CircleBorder(
                side: BorderSide(color: Colors.red,width: 10)
            ),
            splashColor: splashColor,
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }
}


class CircleButton extends StatelessWidget {
  final Widget icon;
  final Color backgroundColor;
  final Color? borderColor;
  final Function onTap;
  final double? size;
  const CircleButton({Key? key, required this.icon, required this.backgroundColor, this.borderColor, this.size, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size ?? AppButtonProps.buttonHeight,
        height: size ?? AppButtonProps.buttonHeight,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: Colors.white,
            // minimumSize: const Size(0, 36),
            shape: CircleBorder(
                side: BorderSide(color: borderColor ?? Colors.transparent, style: borderColor != null ? BorderStyle.solid : BorderStyle.none)
            ),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () => onTap(),
          child: Center(child: icon),
        ));
  }
}


class TileButton extends StatelessWidget {
  final String? title;
  final String svgIcon;
  final Function? onTap;
  final Color color;
  final Color foregroundColor;
  const TileButton({Key? key, @required this.title, required this.color, required this.foregroundColor, @required this.onTap, required this.svgIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.sm))
            ),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () => onTap!(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: double.maxFinite),
                SvgPicture.asset(svgIcon, color: foregroundColor, height: 30, width: 30,),
                const SizedBox(height: 10),
                Text(title!,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: foregroundColor)),
              ],
            ),
          ),
        ));
  }
}