import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_filter/imageFilterModel.dart';
import 'package:image_filter/image_filter.dart';
import 'package:image_filter/image_filter_platform_interface.dart';
import 'package:image_filter/image_filter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockImageFilterPlatform
    with MockPlatformInterfaceMixin
    implements ImageFilterPlatform {

  @override
  Future<Uint8List?> imageAddFilter(Uint8List image, ImageFilterModel filterModel) {
    // TODO: implement imageAddFilter
    throw UnimplementedError();
  }
}

void main() {
  final ImageFilterPlatform initialPlatform = ImageFilterPlatform.instance;

  test('$MethodChannelImageFilter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelImageFilter>());
  });

  test('getPlatformVersion', () async {
    // MockImageFilterPlatform fakePlatform = MockImageFilterPlatform();
    // ImageFilterPlatform.instance = fakePlatform;

    // expect(await imageFilterPlugin.getPlatformVersion(), '42');
  });
}
