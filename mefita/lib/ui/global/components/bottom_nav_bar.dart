import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        // color: Colors.black87,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSecondaryContainer.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: SvgPicture.asset(
                "assets/svg/fuel.svg",
                color: currentIndex == 0
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                height: 26, width: 26
            ),
            selectedIcon: SvgPicture.asset(
                "assets/svg/fuel.svg",
                color: currentIndex == 0
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                height: 26, width: 26
            ),
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavBarItem(
            icon: SvgPicture.asset(
                "assets/svg/dt-refuel.svg",
                color: currentIndex == 1
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                height: 26, width: 26
            ),
            selectedIcon: SvgPicture.asset(
                "assets/svg/dt-refuel.svg",
                color: currentIndex == 1
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                height: 26, width: 26
            ),
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavBarItem(
            icon: SvgPicture.asset(
                "assets/svg/fuel.svg",
                color: currentIndex == 2
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                height: 26, width: 26
            ),
            selectedIcon: SvgPicture.asset(
                "assets/svg/fuel.svg",
                color: currentIndex == 2
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                height: 26, width: 26
            ),
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),

        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final Widget icon;
  final Widget selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        highlightColor: colorScheme.surfaceContainer,
        splashColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.surfaceContainer
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: isSelected
                ? KeyedSubtree(
              key: const ValueKey('selected'),
              child: selectedIcon,
            )
                : KeyedSubtree(
              key: const ValueKey('unselected'),
              child: icon,
            ),
          ),
        ),
      ),
    );

  }
} 