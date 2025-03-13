import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'imageFilterModel.dart';
import 'image_filter_platform_interface.dart';

/// An implementation of [ImageFilterPlatform] that uses method channels.
class MethodChannelImageFilter extends ImageFilterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('image_filter');

  @override
  Future<Uint8List?> imageAddFilter(Uint8List image, ImageFilterModel filterModel) async {
    final result = await methodChannel.invokeMethod<Uint8List>('imageAddFilter',{
      'image': image,
      'filterModel': filterModel.toMap()
    });
    return result;
  }
}
