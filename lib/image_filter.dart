
import 'dart:typed_data';

import 'imageFilterModel.dart';
import 'image_filter_platform_interface.dart';

class ImageFilter {
  // 图片添加滤镜
  Future<Uint8List?> imageAddFilter(Uint8List image, ImageFilterModel filterModel){
    return ImageFilterPlatform.instance.imageAddFilter(image,filterModel);
  }
}
