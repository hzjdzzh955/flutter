// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'ink_well.dart';
import 'material_state.dart';
import 'theme_data.dart';

// Examples can assume:
// late BuildContext context;
// typedef MyAppHome = Placeholder;

/// The visual properties that most buttons have in common.
///
/// Buttons and their themes have a ButtonStyle property which defines the visual
/// properties whose default values are to be overridden. The default values are
/// defined by the individual button widgets and are typically based on overall
/// theme's [ThemeData.colorScheme] and [ThemeData.textTheme].
///
/// All of the ButtonStyle properties are null by default.
///
/// Many of the ButtonStyle properties are [MaterialStateProperty] objects which
/// resolve to different values depending on the button's state. For example
/// the [Color] properties are defined with `MaterialStateProperty<Color>` and
/// can resolve to different colors depending on if the button is pressed,
/// hovered, focused, disabled, etc.
///
/// These properties can override the default value for just one state or all of
/// them. For example to create a [ElevatedButton] whose background color is the
/// color scheme’s primary color with 50% opacity, but only when the button is
/// pressed, one could write:
///
/// ```dart
/// ElevatedButton(
///   style: ButtonStyle(
///     backgroundColor: MaterialStateProperty.resolveWith<Color?>(
///       (Set<MaterialState> states) {
///         if (states.contains(MaterialState.pressed)) {
///           return Theme.of(context).colorScheme.primary.withOpacity(0.5);
///         }
///         return null; // Use the component's default.
///       },
///     ),
///   ),
///   child: const Text('Fly me to the moon'),
///   onPressed: () {
///     // ...
///   },
/// ),
/// ```
///
/// In this case the background color for all other button states would fallback
/// to the ElevatedButton’s default values. To unconditionally set the button's
/// [backgroundColor] for all states one could write:
///
/// ```dart
/// ElevatedButton(
///   style: const ButtonStyle(
///     backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
///   ),
///   child: const Text('Let me play among the stars'),
///   onPressed: () {
///     // ...
///   },
/// ),
/// ```
///
/// Configuring a ButtonStyle directly makes it possible to very
/// precisely control the button’s visual attributes for all states.
/// This level of control is typically required when a custom
/// “branded” look and feel is desirable. However, in many cases it’s
/// useful to make relatively sweeping changes based on a few initial
/// parameters with simple values. The button styleFrom() methods
/// enable such sweeping changes. See for example:
/// [ElevatedButton.styleFrom], [FilledButton.styleFrom],
/// [OutlinedButton.styleFrom], [TextButton.styleFrom].
///
/// For example, to override the default text and icon colors for a
/// [TextButton], as well as its overlay color, with all of the
/// standard opacity adjustments for the pressed, focused, and
/// hovered states, one could write:
///
/// ```dart
/// TextButton(
///   style: TextButton.styleFrom(foregroundColor: Colors.green),
///   child: const Text('Let me see what spring is like'),
///   onPressed: () {
///     // ...
///   },
/// ),
/// ```
///
/// To configure all of the application's text buttons in the same
/// way, specify the overall theme's `textButtonTheme`:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     textButtonTheme: TextButtonThemeData(
///       style: TextButton.styleFrom(foregroundColor: Colors.green),
///     ),
///   ),
///   home: const MyAppHome(),
/// ),
/// ```
///
/// ## Material 3 button types
///
/// Material Design 3 specifies five types of common buttons. Flutter provides
/// support for these using the following button classes:
/// <style>table,td,th { border-collapse: collapse; padding: 0.45em; } td { border: 1px solid }</style>
///
/// | Type         | Flutter implementation  |
/// | :----------- | :---------------------- |
/// | Elevated     | [ElevatedButton]        |
/// | Filled       | [FilledButton]          |
/// | Filled Tonal | [FilledButton.tonal]    |
/// | Outlined     | [OutlinedButton]        |
/// | Text         | [TextButton]            |
///
/// {@tool dartpad}
/// This sample shows how to create each of the Material 3 button types with Flutter.
///
/// ** See code in examples/api/lib/material/button_style/button_style.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [ElevatedButtonTheme], the theme for [ElevatedButton]s.
///  * [FilledButtonTheme], the theme for [FilledButton]s.
///  * [OutlinedButtonTheme], the theme for [OutlinedButton]s.
///  * [TextButtonTheme], the theme for [TextButton]s.
@immutable
class ButtonStyle with Diagnosticable {
  /// Create a [ButtonStyle].
  const ButtonStyle({
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.overlayColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.padding,
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
    this.iconColor,
    this.iconSize,
    this.side,
    this.shape,
    this.mouseCursor,
    this.visualDensity,
    this.tapTargetSize,
    this.animationDuration,
    this.enableFeedback,
    this.alignment,
    this.splashFactory,
  });

  /// The style for a button's [Text] widget descendants.
  ///
  /// The color of the [textStyle] is typically not used directly, the
  /// [foregroundColor] is used instead.
  final MaterialStateProperty<TextStyle?>? textStyle;

  /// The button's background fill color.
  final MaterialStateProperty<Color?>? backgroundColor;

  /// The color for the button's [Text] and [Icon] widget descendants.
  ///
  /// This color is typically used instead of the color of the [textStyle]. All
  /// of the components that compute defaults from [ButtonStyle] values
  /// compute a default [foregroundColor] and use that instead of the
  /// [textStyle]'s color.
  final MaterialStateProperty<Color?>? foregroundColor;

  /// The highlight color that's typically used to indicate that
  /// the button is focused, hovered, or pressed.
  final MaterialStateProperty<Color?>? overlayColor;

  /// The shadow color of the button's [Material].
  ///
  /// The material's elevation shadow can be difficult to see for
  /// dark themes, so by default the button classes add a
  /// semi-transparent overlay to indicate elevation. See
  /// [ThemeData.applyElevationOverlayColor].
  final MaterialStateProperty<Color?>? shadowColor;

  /// The surface tint color of the button's [Material].
  ///
  /// See [Material.surfaceTintColor] for more details.
  final MaterialStateProperty<Color?>? surfaceTintColor;

  /// The elevation of the button's [Material].
  final MaterialStateProperty<double?>? elevation;

  /// The padding between the button's boundary and its child.
  final MaterialStateProperty<EdgeInsetsGeometry?>? padding;

  /// The minimum size of the button itself.
  ///
  /// The size of the rectangle the button lies within may be larger
  /// per [tapTargetSize].
  ///
  /// This value must be less than or equal to [maximumSize].
  final MaterialStateProperty<Size?>? minimumSize;

  /// The button's size.
  ///
  /// This size is still constrained by the style's [minimumSize]
  /// and [maximumSize]. Fixed size dimensions whose value is
  /// [double.infinity] are ignored.
  ///
  /// To specify buttons with a fixed width and the default height use
  /// `fixedSize: Size.fromWidth(320)`. Similarly, to specify a fixed
  /// height and the default width use `fixedSize: Size.fromHeight(100)`.
  final MaterialStateProperty<Size?>? fixedSize;

  /// The maximum size of the button itself.
  ///
  /// A [Size.infinite] or null value for this property means that
  /// the button's maximum size is not constrained.
  ///
  /// This value must be greater than or equal to [minimumSize].
  final MaterialStateProperty<Size?>? maximumSize;

  /// The icon's color inside of the button.
  ///
  /// If this is null, the icon color will be [foregroundColor].
  final MaterialStateProperty<Color?>? iconColor;

  /// The icon's size inside of the button.
  final MaterialStateProperty<double?>? iconSize;

  /// The color and weight of the button's outline.
  ///
  /// This value is combined with [shape] to create a shape decorated
  /// with an outline.
  final MaterialStateProperty<BorderSide?>? side;

  /// The shape of the button's underlying [Material].
  ///
  /// This shape is combined with [side] to create a shape decorated
  /// with an outline.
  final MaterialStateProperty<OutlinedBorder?>? shape;

  /// The cursor for a mouse pointer when it enters or is hovering over
  /// this button's [InkWell].
  final MaterialStateProperty<MouseCursor?>? mouseCursor;

  /// Defines how compact the button's layout will be.
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// See also:
  ///
  ///  * [ThemeData.visualDensity], which specifies the [visualDensity] for all widgets
  ///    within a [Theme].
  final VisualDensity? visualDensity;

  /// Configures the minimum size of the area within which the button may be pressed.
  ///
  /// If the [tapTargetSize] is larger than [minimumSize], the button will include
  /// a transparent margin that responds to taps.
  ///
  /// Always defaults to [ThemeData.materialTapTargetSize].
  final MaterialTapTargetSize? tapTargetSize;

  /// Defines the duration of animated changes for [shape] and [elevation].
  ///
  /// Typically the component default value is [kThemeChangeDuration].
  final Duration? animationDuration;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// Typically the component default value is true.
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  /// The alignment of the button's child.
  ///
  /// Typically buttons are sized to be just big enough to contain the child and its
  /// padding. If the button's size is constrained to a fixed size, for example by
  /// enclosing it with a [SizedBox], this property defines how the child is aligned
  /// within the available space.
  ///
  /// Always defaults to [Alignment.center].
  final AlignmentGeometry? alignment;

  /// Creates the [InkWell] splash factory, which defines the appearance of
  /// "ink" splashes that occur in response to taps.
  ///
  /// Use [NoSplash.splashFactory] to defeat ink splash rendering. For example:
  /// ```dart
  /// ElevatedButton(
  ///   style: ElevatedButton.styleFrom(
  ///     splashFactory: NoSplash.splashFactory,
  ///   ),
  ///   onPressed: () { },
  ///   child: const Text('No Splash'),
  /// )
  /// ```
  final InteractiveInkFeatureFactory? splashFactory;

  /// Returns a copy of this ButtonStyle with the given fields replaced with
  /// the new values.
  ButtonStyle copyWith({
    MaterialStateProperty<TextStyle?>? textStyle,
    MaterialStateProperty<Color?>? backgroundColor,
    MaterialStateProperty<Color?>? foregroundColor,
    MaterialStateProperty<Color?>? overlayColor,
    MaterialStateProperty<Color?>? shadowColor,
    MaterialStateProperty<Color?>? surfaceTintColor,
    MaterialStateProperty<double?>? elevation,
    MaterialStateProperty<EdgeInsetsGeometry?>? padding,
    MaterialStateProperty<Size?>? minimumSize,
    MaterialStateProperty<Size?>? fixedSize,
    MaterialStateProperty<Size?>? maximumSize,
    MaterialStateProperty<Color?>? iconColor,
    MaterialStateProperty<double?>? iconSize,
    MaterialStateProperty<BorderSide?>? side,
    MaterialStateProperty<OutlinedBorder?>? shape,
    MaterialStateProperty<MouseCursor?>? mouseCursor,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return ButtonStyle(
      textStyle: textStyle ?? this.textStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      overlayColor: overlayColor ?? this.overlayColor,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      elevation: elevation ?? this.elevation,
      padding: padding ?? this.padding,
      minimumSize: minimumSize ?? this.minimumSize,
      fixedSize: fixedSize ?? this.fixedSize,
      maximumSize: maximumSize ?? this.maximumSize,
      iconColor: iconColor ?? this.iconColor,
      iconSize: iconSize ?? this.iconSize,
      side: side ?? this.side,
      shape: shape ?? this.shape,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      visualDensity: visualDensity ?? this.visualDensity,
      tapTargetSize: tapTargetSize ?? this.tapTargetSize,
      animationDuration: animationDuration ?? this.animationDuration,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      alignment: alignment ?? this.alignment,
      splashFactory: splashFactory ?? this.splashFactory,
    );
  }

  /// Returns a copy of this ButtonStyle where the non-null fields in [style]
  /// have replaced the corresponding null fields in this ButtonStyle.
  ///
  /// In other words, [style] is used to fill in unspecified (null) fields
  /// this ButtonStyle.
  ButtonStyle merge(ButtonStyle? style) {
    if (style == null) {
      return this;
    }
    return copyWith(
      textStyle: textStyle ?? style.textStyle,
      backgroundColor: backgroundColor ?? style.backgroundColor,
      foregroundColor: foregroundColor ?? style.foregroundColor,
      overlayColor: overlayColor ?? style.overlayColor,
      shadowColor: shadowColor ?? style.shadowColor,
      surfaceTintColor: surfaceTintColor ?? style.surfaceTintColor,
      elevation: elevation ?? style.elevation,
      padding: padding ?? style.padding,
      minimumSize: minimumSize ?? style.minimumSize,
      fixedSize: fixedSize ?? style.fixedSize,
      maximumSize: maximumSize ?? style.maximumSize,
      iconColor: iconColor ?? style.iconColor,
      iconSize: iconSize ?? style.iconSize,
      side: side ?? style.side,
      shape: shape ?? style.shape,
      mouseCursor: mouseCursor ?? style.mouseCursor,
      visualDensity: visualDensity ?? style.visualDensity,
      tapTargetSize: tapTargetSize ?? style.tapTargetSize,
      animationDuration: animationDuration ?? style.animationDuration,
      enableFeedback: enableFeedback ?? style.enableFeedback,
      alignment: alignment ?? style.alignment,
      splashFactory: splashFactory ?? style.splashFactory,
    );
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      textStyle,
      backgroundColor,
      foregroundColor,
      overlayColor,
      shadowColor,
      surfaceTintColor,
      elevation,
      padding,
      minimumSize,
      fixedSize,
      maximumSize,
      iconColor,
      iconSize,
      side,
      shape,
      mouseCursor,
      visualDensity,
      tapTargetSize,
      animationDuration,
      enableFeedback,
      alignment,
      splashFactory,
    ];
    return Object.hashAll(values);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ButtonStyle &&
        other.textStyle == textStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.overlayColor == overlayColor &&
        other.shadowColor == shadowColor &&
        other.surfaceTintColor == surfaceTintColor &&
        other.elevation == elevation &&
        other.padding == padding &&
        other.minimumSize == minimumSize &&
        other.fixedSize == fixedSize &&
        other.maximumSize == maximumSize &&
        other.iconColor == iconColor &&
        other.iconSize == iconSize &&
        other.side == side &&
        other.shape == shape &&
        other.mouseCursor == mouseCursor &&
        other.visualDensity == visualDensity &&
        other.tapTargetSize == tapTargetSize &&
        other.animationDuration == animationDuration &&
        other.enableFeedback == enableFeedback &&
        other.alignment == alignment &&
        other.splashFactory == splashFactory;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MaterialStateProperty<TextStyle?>>(
        'textStyle', textStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'backgroundColor', backgroundColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'foregroundColor', foregroundColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'overlayColor', overlayColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'shadowColor', shadowColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'surfaceTintColor', surfaceTintColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<double?>>(
        'elevation', elevation,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<MaterialStateProperty<EdgeInsetsGeometry?>>(
            'padding', padding,
            defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Size?>>(
        'minimumSize', minimumSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Size?>>(
        'fixedSize', fixedSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Size?>>(
        'maximumSize', maximumSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'iconColor', iconColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<double?>>(
        'iconSize', iconSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<BorderSide?>>(
        'side', side,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<OutlinedBorder?>>(
        'shape', shape,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<MouseCursor?>>(
        'mouseCursor', mouseCursor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<VisualDensity>(
        'visualDensity', visualDensity,
        defaultValue: null));
    properties.add(EnumProperty<MaterialTapTargetSize>(
        'tapTargetSize', tapTargetSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Duration>(
        'animationDuration', animationDuration,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('enableFeedback', enableFeedback,
        defaultValue: null));
    properties.add(DiagnosticsProperty<AlignmentGeometry>(
        'alignment', alignment,
        defaultValue: null));
  }

  /// Linearly interpolate between two [ButtonStyle]s.
  static ButtonStyle? lerp(ButtonStyle? a, ButtonStyle? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return ButtonStyle(
      textStyle: MaterialStateProperty.lerp<TextStyle?>(
          a?.textStyle, b?.textStyle, t, TextStyle.lerp),
      backgroundColor: MaterialStateProperty.lerp<Color?>(
          a?.backgroundColor, b?.backgroundColor, t, Color.lerp),
      foregroundColor: MaterialStateProperty.lerp<Color?>(
          a?.foregroundColor, b?.foregroundColor, t, Color.lerp),
      overlayColor: MaterialStateProperty.lerp<Color?>(
          a?.overlayColor, b?.overlayColor, t, Color.lerp),
      shadowColor: MaterialStateProperty.lerp<Color?>(
          a?.shadowColor, b?.shadowColor, t, Color.lerp),
      surfaceTintColor: MaterialStateProperty.lerp<Color?>(
          a?.surfaceTintColor, b?.surfaceTintColor, t, Color.lerp),
      elevation: MaterialStateProperty.lerp<double?>(
          a?.elevation, b?.elevation, t, lerpDouble),
      padding: MaterialStateProperty.lerp<EdgeInsetsGeometry?>(
          a?.padding, b?.padding, t, EdgeInsetsGeometry.lerp),
      minimumSize: MaterialStateProperty.lerp<Size?>(
          a?.minimumSize, b?.minimumSize, t, Size.lerp),
      fixedSize: MaterialStateProperty.lerp<Size?>(
          a?.fixedSize, b?.fixedSize, t, Size.lerp),
      maximumSize: MaterialStateProperty.lerp<Size?>(
          a?.maximumSize, b?.maximumSize, t, Size.lerp),
      iconColor: MaterialStateProperty.lerp<Color?>(
          a?.iconColor, b?.iconColor, t, Color.lerp),
      iconSize: MaterialStateProperty.lerp<double?>(
          a?.iconSize, b?.iconSize, t, lerpDouble),
      side: _lerpSides(a?.side, b?.side, t),
      shape: MaterialStateProperty.lerp<OutlinedBorder?>(
          a?.shape, b?.shape, t, OutlinedBorder.lerp),
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
      visualDensity: t < 0.5 ? a?.visualDensity : b?.visualDensity,
      tapTargetSize: t < 0.5 ? a?.tapTargetSize : b?.tapTargetSize,
      animationDuration: t < 0.5 ? a?.animationDuration : b?.animationDuration,
      enableFeedback: t < 0.5 ? a?.enableFeedback : b?.enableFeedback,
      alignment: AlignmentGeometry.lerp(a?.alignment, b?.alignment, t),
      splashFactory: t < 0.5 ? a?.splashFactory : b?.splashFactory,
    );
  }

  // Special case because BorderSide.lerp() doesn't support null arguments
  static MaterialStateProperty<BorderSide?>? _lerpSides(
      MaterialStateProperty<BorderSide?>? a,
      MaterialStateProperty<BorderSide?>? b,
      double t) {
    if (a == null && b == null) {
      return null;
    }
    return _LerpSides(a, b, t);
  }
}

class _LerpSides implements MaterialStateProperty<BorderSide?> {
  const _LerpSides(this.a, this.b, this.t);

  final MaterialStateProperty<BorderSide?>? a;
  final MaterialStateProperty<BorderSide?>? b;
  final double t;

  @override
  BorderSide? resolve(Set<MaterialState> states) {
    final BorderSide? resolvedA = a?.resolve(states);
    final BorderSide? resolvedB = b?.resolve(states);
    if (resolvedA == null && resolvedB == null) {
      return null;
    }
    if (resolvedA == null) {
      return BorderSide.lerp(
          BorderSide(width: 0, color: resolvedB!.color.withAlpha(0)),
          resolvedB,
          t);
    }
    if (resolvedB == null) {
      return BorderSide.lerp(resolvedA,
          BorderSide(width: 0, color: resolvedA.color.withAlpha(0)), t);
    }
    return BorderSide.lerp(resolvedA, resolvedB, t);
  }
}
