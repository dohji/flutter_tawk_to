import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mefita/ui/global/helpers/style.dart';

class AssetCard extends StatelessWidget {
  final Map<String, dynamic> asset;
  final EdgeInsetsGeometry margin;
  final double width;
  final bool isOneInRow;
  final bool? isSelected;
  final bool? animate;
  final Function onTap;
  const AssetCard({Key? key, required this.asset, required this.margin, required this.width, required this.isOneInRow, this.isSelected = false, required this.onTap, this.animate = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: isSelected! ? colorScheme.surfaceContainer : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        border: Border.all(color: isSelected! ? colorScheme.primary : Colors.grey.shade300)
      ),
      child: InkWell(
        onTap: () => onTap(),
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          child: Stack(
            // clipBehavior: Clip.none,
            children: [

              if (asset["type"] == "motorbike")...[
                Positioned(
                  right: isOneInRow ? -150 : -130,
                  top: isOneInRow ? -30 : -5,
                  child: Image.asset("assets/images/motorbike.webp", width: width, fit: BoxFit.cover)
                      .animate()
                      .slideX(
                    begin: animate! ? 1.0 : 0.0,
                    end: 0.0,
                    curve: Curves.easeOut,
                    duration: 500.ms,
                  )
                      .fadeIn(duration: 500.ms),
                ),
              ] else if (asset["type"] == "vehicle")...[
                Positioned(
                  right: isOneInRow ? -100 : -100,
                  top: isOneInRow ? -80 : -40,
                  child: Image.asset("assets/images/vehicle.png", width: width, fit: BoxFit.cover)
                      .animate()
                      .slideX(
                    begin: animate! ? 1.0 : 0.0,
                    end: 0.0,
                    curve: Curves.easeOut,
                    duration: 500.ms,
                  )
                      .fadeIn(duration: 500.ms),
                ),
              ] else if (asset["type"] == "agricultural" || asset["type"] == "heavy_equipment")...[
                Positioned(
                  right: isOneInRow ? -150 : -125,
                  top: isOneInRow ? -5 : 20,
                  child: Image.asset("assets/images/tractor.webp", width: width * 0.9, fit: BoxFit.cover)
                      .animate()
                      .slideX(
                    begin: animate! ? 1.0 : 0.0,
                    end: 0.0,
                    curve: Curves.easeOut,
                    duration: 500.ms,
                  )
                      .fadeIn(duration: 500.ms),
                ),
              ] else if (asset["type"] == "boat")...[
                Positioned(
                  right: isOneInRow ? -170 : -160,
                  bottom: isOneInRow ? -15 : -10,
                  child: Image.asset("assets/images/boat.png", width: width, fit: BoxFit.cover)
                      .animate()
                      .slideX(
                    begin: animate! ? 1.0 : 0.0,
                    end: 0.0,
                    curve: Curves.easeOut,
                    duration: 500.ms,
                  )
                      .fadeIn(duration: 500.ms),
                ),
              ] else if (asset["type"] == "generator")...[
                Positioned(
                  right: isOneInRow ? -110 : -110,
                  top: isOneInRow ? 0 : 20,
                  child: Image.asset("assets/images/generator.webp", width: width * 0.6, fit: BoxFit.cover)
                      .animate()
                      .slideX(
                    begin: animate! ? 1.0 : 0.0,
                    end: 0.0,
                    curve: Curves.easeOut,
                    duration: 500.ms,
                  )
                      .fadeIn(duration: 500.ms),
                ),
              ] else ...[
                Positioned(
                  right: isOneInRow ? -100 : -100,
                  top: isOneInRow ? -80 : -40,
                  child: Image.asset("assets/images/vehicle.png", width: width, fit: BoxFit.cover)
                      .animate()
                      .slideX(
                    begin: animate! ? 1.0 : 0.0,
                    end: 0.0,
                    curve: Curves.easeOut,
                    duration: 500.ms,
                  )
                      .fadeIn(duration: 500.ms),
                ),
              ],

              Padding(
                padding: EdgeInsets.all(AppPadding.horizontal),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildType(asset["type"]),
                    const SizedBox(height: 5),
                    Text(asset["name"], style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
                    Text("${asset["identifier"]}", style: textTheme.bodyMedium),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

Widget buildType(String type){
  String formattedType = type.replaceAll('_', ' ').split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.grey.shade400,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      formattedType,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
    ),
  );
}