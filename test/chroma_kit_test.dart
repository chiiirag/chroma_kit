import 'package:flutter_test/flutter_test.dart';
import 'package:chroma_kit/chroma_kit.dart';

void main() {
  test('ChromaKit can be instantiated', () {
    const toolkit = ChromaKit();

    expect(toolkit, isA<ChromaKit>());
  });
}
