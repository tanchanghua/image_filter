import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_filter/imageFilterModel.dart';
import 'package:image_filter/image_filter.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImagePage(),
    );
  }
}

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  ui.Image? _image;
  Uint8List? afterImage;
  final imageFilterPlugin = ImageFilter();

  Future<void> _loadImageFromAssets(String path) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Image image = await decodeImageFromList(bytes);

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadImageFromAssets("assets/1.jpeg");
  }

  Future<Uint8List> imageToBytes(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void conver() async {
    final byte = await imageToBytes(_image!);
    // 输出byte 类型
    print(byte.runtimeType);
    final uint8List = await imageFilterPlugin.imageAddFilter(
        byte,
        ImageFilterModel(
          sharpness: -20,
          vividness: -21,
          highlights: 10,
        ));
    setState(() {
      afterImage = uint8List;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("显示 UI.Image")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _image == null
                ? CircularProgressIndicator()
                : SizedBox(
                    child: CustomPaint(
                      size: Size(_image!.width.toDouble(), _image!.height.toDouble()),
                      painter: ImagePainter(_image!),
                    ),
                  ),
            ElevatedButton(
              onPressed: conver,
              child: Text('转换'),
            ),
            if (afterImage != null)
              Image.memory(
                afterImage!,
              )
          ],
        ),
      ),
    );
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
