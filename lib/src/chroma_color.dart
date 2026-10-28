import 'package:flutter/material.dart' show Color, HSLColor;

/// An immutable, validated representation of a color.
///
/// RGB and alpha channels range from 0 to 255.
/// Hue ranges from 0 to 360 degrees.
/// HSL saturation and lightness range from 0 to 1.
///
/// HEX strings use the following conventions:
/// - `#RGB`: shorthand RGB
/// - `#ARGB`: shorthand alpha, RGB
/// - `#RRGGBB`: RGB
/// - `#AARRGGBB`: alpha, RGB
///
/// Alpha-first HEX notation matches Flutter's ARGB integer convention.
final class ChromaColor {
  /// Creates a color from red, green, blue, and optional alpha channels.
  ///
  /// Each channel must be an integer from 0 through 255.
  factory ChromaColor({
    required int red,
    required int green,
    required int blue,
    int alpha = 255,
  }) {
    _validateChannel('red', red);
    _validateChannel('green', green);
    _validateChannel('blue', blue);
    _validateChannel('alpha', alpha);

    return ChromaColor._(red: red, green: green, blue: blue, alpha: alpha);
  }

  const ChromaColor._({
    required this.red,
    required this.green,
    required this.blue,
    required this.alpha,
  });

  /// Creates a color by parsing a HEX string.
  ///
  /// Accepts an optional leading `#` or `0x` prefix.
  /// Parsing is case-insensitive and ignores surrounding whitespace.
  ///
  /// Throws [FormatException] if the string is invalid.
  factory ChromaColor.fromHex(String input) {
    var hex = input.trim();

    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    } else if (hex.toLowerCase().startsWith('0x')) {
      hex = hex.substring(2);
    }

    if (!RegExp(r'^[0-9a-fA-F]+$').hasMatch(hex)) {
      throw FormatException('Invalid HEX color: "$input".', input);
    }

    switch (hex.length) {
      case 3:
        final red = int.parse('${hex[0]}${hex[0]}', radix: 16);
        final green = int.parse('${hex[1]}${hex[1]}', radix: 16);
        final blue = int.parse('${hex[2]}${hex[2]}', radix: 16);

        return ChromaColor(red: red, green: green, blue: blue);

      case 4:
        final alpha = int.parse('${hex[0]}${hex[0]}', radix: 16);
        final red = int.parse('${hex[1]}${hex[1]}', radix: 16);
        final green = int.parse('${hex[2]}${hex[2]}', radix: 16);
        final blue = int.parse('${hex[3]}${hex[3]}', radix: 16);

        return ChromaColor(red: red, green: green, blue: blue, alpha: alpha);

      case 6:
        final value = int.parse(hex, radix: 16);

        return ChromaColor(
          red: (value >> 16) & 0xFF,
          green: (value >> 8) & 0xFF,
          blue: value & 0xFF,
        );

      case 8:
        final value = int.parse(hex, radix: 16);

        return ChromaColor(
          alpha: (value >> 24) & 0xFF,
          red: (value >> 16) & 0xFF,
          green: (value >> 8) & 0xFF,
          blue: value & 0xFF,
        );

      default:
        throw FormatException(
          'HEX colors must contain 3, 4, 6, or 8 digits.',
          input,
        );
    }
  }

  /// Creates a color from a Flutter [Color].
  factory ChromaColor.fromColor(Color color) {
    final value = color.toARGB32();

    return ChromaColor(
      alpha: (value >> 24) & 0xFF,
      red: (value >> 16) & 0xFF,
      green: (value >> 8) & 0xFF,
      blue: value & 0xFF,
    );
  }

  /// Creates a color from HSL components.
  ///
  /// [hue] must be between 0 and 360, inclusive.
  /// [saturation] and [lightness] must be between 0 and 1.
  /// [alpha] must be between 0 and 255.
  factory ChromaColor.fromHsl({
    required double hue,
    required double saturation,
    required double lightness,
    int alpha = 255,
  }) {
    if (!hue.isFinite || hue < 0 || hue > 360) {
      throw ArgumentError.value(hue, 'hue', 'Must be between 0 and 360.');
    }

    if (!saturation.isFinite || saturation < 0 || saturation > 1) {
      throw ArgumentError.value(
        saturation,
        'saturation',
        'Must be between 0 and 1.',
      );
    }

    if (!lightness.isFinite || lightness < 0 || lightness > 1) {
      throw ArgumentError.value(
        lightness,
        'lightness',
        'Must be between 0 and 1.',
      );
    }

    _validateChannel('alpha', alpha);

    final color = HSLColor.fromAHSL(
      alpha / 255,
      hue,
      saturation,
      lightness,
    ).toColor();

    return ChromaColor.fromColor(color);
  }

  /// The red channel, from 0 through 255.
  final int red;

  /// The green channel, from 0 through 255.
  final int green;

  /// The blue channel, from 0 through 255.
  final int blue;

  /// The alpha channel, from 0 (transparent) through 255 (opaque).
  final int alpha;

  /// The opacity as a value between 0 and 1.
  double get opacity => alpha / 255;

  /// The color represented as a Flutter [Color].
  Color get color => Color.fromARGB(alpha, red, green, blue);

  /// The color represented as an [HSLColor].
  HSLColor get hsl => HSLColor.fromColor(color);

  /// Converts the color to HEX.
  ///
  /// By default, returns `#RRGGBB`.
  /// Set [includeAlpha] to return `#AARRGGBB`.
  /// Set [leadingHash] to false to omit the `#`.
  String toHex({bool includeAlpha = false, bool leadingHash = true}) {
    final channels = <int>[if (includeAlpha) alpha, red, green, blue];

    final hex = channels
        .map((channel) => channel.toRadixString(16).padLeft(2, '0'))
        .join()
        .toUpperCase();

    return leadingHash ? '#$hex' : hex;
  }

  /// Returns a copy with selected channels replaced.
  ChromaColor copyWith({int? red, int? green, int? blue, int? alpha}) {
    return ChromaColor(
      red: red ?? this.red,
      green: green ?? this.green,
      blue: blue ?? this.blue,
      alpha: alpha ?? this.alpha,
    );
  }

  /// Returns a copy with the specified opacity.
  ///
  /// Opacity must be finite and between 0 and 1.
  ChromaColor withOpacity(double opacity) {
    if (!opacity.isFinite || opacity < 0 || opacity > 1) {
      throw ArgumentError.value(opacity, 'opacity', 'Must be between 0 and 1.');
    }

    return copyWith(alpha: (opacity * 255).round());
  }

  /// Returns a copy with the specified alpha channel.
  ChromaColor withAlpha(int alpha) => copyWith(alpha: alpha);

  static void _validateChannel(String name, int value) {
    if (value < 0 || value > 255) {
      throw ArgumentError.value(value, name, 'Must be between 0 and 255.');
    }
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChromaColor &&
            other.red == red &&
            other.green == green &&
            other.blue == blue &&
            other.alpha == alpha;
  }

  @override
  int get hashCode => Object.hash(red, green, blue, alpha);

  @override
  String toString() {
    return 'ChromaColor('
        'red: $red, '
        'green: $green, '
        'blue: $blue, '
        'alpha: $alpha'
        ')';
  }
}
