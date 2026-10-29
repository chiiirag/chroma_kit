import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChromaKitExampleApp());
}

class ChromaKitExampleApp extends StatelessWidget {
  const ChromaKitExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chroma Kit Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ColorDemoPage(),
    );
  }
}

class ColorDemoPage extends StatefulWidget {
  const ColorDemoPage({super.key});

  @override
  State<ColorDemoPage> createState() => _ColorDemoPageState();
}

class _ColorDemoPageState extends State<ColorDemoPage> {
  final TextEditingController _hexController = TextEditingController(
    text: '#7C4DFF',
  );

  ChromaColor _color = ChromaColor.fromHex('#7C4DFF');
  String? _error;

  void _updateColor() {
    try {
      final newColor = ChromaColor.fromHex(_hexController.text);

      setState(() {
        _color = newColor;
        _error = null;
      });
    } on FormatException {
      setState(() {
        _error = 'Invalid HEX. Try #7C4DFF or #FF8000.';
      });
    }
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hsl = _color.hsl;

    return Scaffold(
      appBar: AppBar(title: const Text('Chroma Kit')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 190,
            decoration: BoxDecoration(
              color: _color.color,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                _color.toHex(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black45)],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _hexController,
            decoration: InputDecoration(
              labelText: 'HEX color',
              hintText: '#7C4DFF',
              border: const OutlineInputBorder(),
              errorText: _error,
              suffixIcon: IconButton(
                onPressed: _updateColor,
                icon: const Icon(Icons.check),
                tooltip: 'Apply color',
              ),
            ),
            onSubmitted: (_) => _updateColor(),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _updateColor,
            child: const Text('Apply HEX color'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Color details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _detail('HEX', _color.toHex()),
          _detail('ARGB', _color.toHex(includeAlpha: true)),
          _detail('Red', '${_color.red}'),
          _detail('Green', '${_color.green}'),
          _detail('Blue', '${_color.blue}'),
          _detail('Alpha', '${_color.alpha}'),
          _detail('Opacity', _color.opacity.toStringAsFixed(2)),
          _detail('Hue', '${hsl.hue.toStringAsFixed(1)}°'),
          _detail(
            'Saturation',
            '${(hsl.saturation * 100).toStringAsFixed(1)}%',
          ),
          _detail('Lightness', '${(hsl.lightness * 100).toStringAsFixed(1)}%'),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _color = _color.withOpacity(0.5);
                _hexController.text = _color.toHex(includeAlpha: true);
                _error = null;
              });
            },
            icon: const Icon(Icons.opacity),
            label: const Text('Set 50% opacity'),
          ),
        ],
      ),
    );
  }

  Widget _detail(String label, String value) {
    return ListTile(
      dense: true,
      title: Text(label),
      trailing: SelectableText(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
