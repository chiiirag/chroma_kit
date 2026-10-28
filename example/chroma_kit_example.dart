import 'package:chroma_kit/chroma_kit.dart';

void main() {
  final color = ChromaColor.fromHex('#7C4DFF');

  print('HEX: ${color.toHex()}');
  print('ARGB: ${color.toHex(includeAlpha: true)}');

  print('RGB: ${color.red}, ${color.green}, ${color.blue}');
  print('Alpha: ${color.alpha}');
  print('Opacity: ${color.opacity}');

  final hsl = color.hsl;

  print('HSL: ${hsl.hue}, ${hsl.saturation}, ${hsl.lightness}');

  final translucentColor = color.withOpacity(0.5);

  print('50% opacity: ${translucentColor.toHex(includeAlpha: true)}');
}
