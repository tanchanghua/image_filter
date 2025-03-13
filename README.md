# 图片滤镜

# image_filter

图片添加滤镜


| 滤镜  | 安卓端 | ios端 |
| --- | --- | ---- |
| 曝光  | ✅   | ✅    |
| 鲜明度 | ✅   | ✅    |
| 高光  | ✅   | ✅    |
| 阴影  | ✅   | ✅    |
| 对比度 | ✅   | ✅    |
| 饱和度 | ✅   | ✅    |
| 锐度  | ✅   | ✅    |
| 清晰度 | ❌   | ✅    |

### 安卓端使用 gpuimage 库 实现

```dart
dependencies {
    implementation 'jp.co.cyberagent.android:gpuimage:2.1.0'
    testImplementation 'junit:junit:4.13.2'
    testImplementation 'org.mockito:mockito-core:5.0.0'
}
```

### ios 端使用 CIFilter 实现

# 使用说明

```dart
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
// 展示转换后的图片
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
```

### 参数说明

ImageFilterModel  模型的参数， 使用百分比范围值， 最大 100 ， 最小 -100，

0-100 映射为 对应滤镜的默认值至最大值

0 至-100  映射为 对应滤镜的默认值至最小值

如： 图片曝光的调节有效值是 -10 至 10 ,默认值是0，  你传的参数 exposure=-20， 计算得出使用 -2 值去调整图片曝光

## Getting Started

This project is a starting point for a Flutter

[plug-in package](https://flutter.dev/developing-packages/),

a specialized package that includes platform-specific implementation code for

Android and/or iOS.

For help getting started with Flutter development, view the

[online documentation](https://flutter.dev/docs), which offers tutorials,

samples, guidance on mobile development, and a full API reference.

