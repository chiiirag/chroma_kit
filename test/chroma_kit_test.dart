import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChromaColor construction', () {
    test('creates a color with opaque alpha by default', () {
      final color = ChromaColor(red: 255, green: 128, blue: 0);

      expect(color.red, 255);
      expect(color.green, 128);
      expect(color.blue, 0);
      expect(color.alpha, 255);
      expect(color.opacity, 1);
    });

    test('rejects channels outside the valid range', () {
      expect(
        () => ChromaColor(red: -1, green: 0, blue: 0),
        throwsArgumentError,
      );

      expect(
        () => ChromaColor(red: 256, green: 0, blue: 0),
        throwsArgumentError,
      );

      expect(
        () => ChromaColor(red: 0, green: 0, blue: 0, alpha: 256),
        throwsArgumentError,
      );
    });
  });

  group('HEX conversion', () {
    test('parses six-digit HEX', () {
      final color = ChromaColor.fromHex('#FF8000');

      expect(color.red, 255);
      expect(color.green, 128);
      expect(color.blue, 0);
      expect(color.alpha, 255);
    });

    test('parses eight-digit ARGB HEX', () {
      final color = ChromaColor.fromHex('#80FF8000');

      expect(color.alpha, 128);
      expect(color.red, 255);
      expect(color.green, 128);
      expect(color.blue, 0);
    });

    test('parses three-digit shorthand HEX', () {
      final color = ChromaColor.fromHex('#F80');

      expect(color, ChromaColor(red: 255, green: 136, blue: 0));
    });

    test('parses four-digit shorthand ARGB HEX', () {
      final color = ChromaColor.fromHex('#8F00');

      expect(color.alpha, 136);
      expect(color.red, 255);
      expect(color.green, 0);
      expect(color.blue, 0);
    });

    test('accepts whitespace, lowercase, and 0x prefix', () {
      expect(
        ChromaColor.fromHex('  #ff8000  '),
        ChromaColor.fromHex('0xFF8000'),
      );
    });

    test('formats RGB HEX without alpha by default', () {
      final color = ChromaColor(red: 255, green: 128, blue: 0, alpha: 128);

      expect(color.toHex(), '#FF8000');
    });

    test('formats ARGB HEX when alpha is requested', () {
      final color = ChromaColor(red: 255, green: 128, blue: 0, alpha: 128);

      expect(color.toHex(includeAlpha: true), '#80FF8000');
    });

    test('can omit the leading hash', () {
      final color = ChromaColor(red: 255, green: 0, blue: 16);

      expect(color.toHex(leadingHash: false), 'FF0010');
    });

    test('rejects invalid HEX input', () {
      for (final input in [
        '',
        '#',
        '#12',
        '#12345',
        '#1234567',
        '#123456789',
        '#GGGGGG',
        '#12 3456',
      ]) {
        expect(
          () => ChromaColor.fromHex(input),
          throwsFormatException,
          reason: 'Expected "$input" to be rejected',
        );
      }
    });
  });

  group('Flutter Color conversion', () {
    test('converts to and from Flutter Color', () {
      final original = ChromaColor(red: 25, green: 100, blue: 200, alpha: 180);

      final converted = ChromaColor.fromColor(original.color);

      expect(converted, original);
    });
  });

  group('HSL conversion', () {
    test('converts pure red from HSL', () {
      final color = ChromaColor.fromHsl(hue: 0, saturation: 1, lightness: 0.5);

      expect(color.red, 255);
      expect(color.green, 0);
      expect(color.blue, 0);
    });

    test('preserves alpha during HSL construction', () {
      final color = ChromaColor.fromHsl(
        hue: 210,
        saturation: 0.5,
        lightness: 0.4,
        alpha: 128,
      );

      expect(color.alpha, 128);
    });

    test('exposes HSL components', () {
      final color = ChromaColor(red: 255, green: 0, blue: 0);

      expect(color.hsl.hue, closeTo(0, 0.01));
      expect(color.hsl.saturation, closeTo(1, 0.01));
      expect(color.hsl.lightness, closeTo(0.5, 0.01));
    });

    test('rejects invalid HSL components', () {
      expect(
        () =>
            ChromaColor.fromHsl(hue: double.nan, saturation: 1, lightness: 0.5),
        throwsArgumentError,
      );

      expect(
        () => ChromaColor.fromHsl(hue: 0, saturation: 1.1, lightness: 0.5),
        throwsArgumentError,
      );

      expect(
        () => ChromaColor.fromHsl(hue: 0, saturation: 1, lightness: -0.1),
        throwsArgumentError,
      );

      expect(
        () => ChromaColor.fromHsl(
          hue: 0,
          saturation: 1,
          lightness: 0.5,
          alpha: 300,
        ),
        throwsArgumentError,
      );
    });
  });

  group('Opacity and copying', () {
    test('converts opacity to alpha', () {
      final color = ChromaColor(red: 10, green: 20, blue: 30).withOpacity(0.5);

      expect(color.alpha, 128);
      expect(color.opacity, closeTo(128 / 255, 0.0001));
    });

    test('rejects invalid opacity', () {
      final color = ChromaColor(red: 0, green: 0, blue: 0);

      expect(() => color.withOpacity(-0.1), throwsArgumentError);
      expect(() => color.withOpacity(1.1), throwsArgumentError);
      expect(() => color.withOpacity(double.infinity), throwsArgumentError);
    });

    test('copyWith changes only requested channels', () {
      final original = ChromaColor(red: 10, green: 20, blue: 30, alpha: 40);

      final copy = original.copyWith(green: 200);

      expect(copy, ChromaColor(red: 10, green: 200, blue: 30, alpha: 40));

      expect(original.green, 20);
    });

    test('withAlpha validates the new channel', () {
      final color = ChromaColor(red: 0, green: 0, blue: 0);

      expect(() => color.withAlpha(256), throwsArgumentError);
    });
  });

  group('Value equality', () {
    test('colors with identical channels are equal', () {
      final first = ChromaColor(red: 1, green: 2, blue: 3);
      final second = ChromaColor(red: 1, green: 2, blue: 3);

      expect(first, second);
      expect(first.hashCode, second.hashCode);
    });

    test('alpha participates in equality', () {
      final opaque = ChromaColor(red: 1, green: 2, blue: 3);
      final transparent = ChromaColor(red: 1, green: 2, blue: 3, alpha: 128);

      expect(opaque, isNot(transparent));
    });
  });
}
