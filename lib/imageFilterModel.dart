// 图片滤镜模型
class ImageFilterModel {
  // 使用 百分比数值
  final int? exposure; // 曝光-20
  final int? vividness; // 鲜明度-21
  final int? highlights; // 高光+10  安卓端中测试发现没有什么效果
  final int? shadow; // 阴影+15  安卓端中测试发现没有什么效果
  final int? contrast; // 对比度+24
  final int? brightness; // 亮度+24
  final int? naturalSaturation; // 自然饱和度+5
  final int? sharpness; // 锐度+40
  final int? clarity; // 清晰度+15

  ImageFilterModel({
    this.exposure,
    this.vividness,
    this.highlights,
    this.shadow,
    this.contrast,
    this.brightness,
    this.naturalSaturation,
    this.sharpness,
    this.clarity,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'exposure': exposure,
      'vividness': vividness,
      'highlights': highlights,
      'shadow': shadow,
      'contrast': contrast,
      'brightness': brightness,
      'naturalSaturation': naturalSaturation,
      'sharpness': sharpness,
      'clarity': clarity,
    };
    map.removeWhere((key, value) => value == null);
    map.map((key, value){
      return MapEntry(key, value.toString());
    });
    return map;
  }
}
