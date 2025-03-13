import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'imageFilterModel.dart';
import 'image_filter_method_channel.dart';

abstract class ImageFilterPlatform extends PlatformInterface {
  /// Constructs a ImageFilterPlatform.
  ImageFilterPlatform() : super(token: _token);

  static final Object _token = Object();

  static ImageFilterPlatform _instance = MethodChannelImageFilter();

  /// The default instance of [ImageFilterPlatform] to use.
  ///
  /// Defaults to [MethodChannelImageFilter].
  static ImageFilterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ImageFilterPlatform] when
  /// they register themselves.
  static set instance(ImageFilterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Uint8List?> imageAddFilter(Uint8List image, ImageFilterModel filterModel) {
    throw UnimplementedError('imageAddFilter() has not been implemented.');
  }
}
