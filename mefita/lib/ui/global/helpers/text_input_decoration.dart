
import 'package:flutter/material.dart';
import 'package:mefita/ui/global/helpers/style.dart';

var inputBorder = (ColorScheme colorScheme) =>  OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
    borderSide: BorderSide(width: 1, color: colorScheme.onSurface.withOpacity(0.08))
    // borderSide: BorderSide(width: 0, color: colorScheme.onBackground.withOpacity(0.08))
);

var inputBorderFocused = (ColorScheme colorScheme) =>  OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
    borderSide: BorderSide(width: 1, color: colorScheme.onSurface.withOpacity(0.25))
    // borderSide: BorderSide(width: 0, color: colorScheme.onBackground.withOpacity(0.08))
);

var inputBorderError = (ColorScheme colorScheme) =>  OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
    borderSide: BorderSide(width: 1, color: colorScheme.onSurface.withOpacity(0.08))
    // borderSide: BorderSide(width: 0, color: colorScheme.onBackground.withOpacity(0.08))
);
