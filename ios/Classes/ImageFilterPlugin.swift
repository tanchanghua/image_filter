import Flutter
import UIKit

let exposureKey: String = "exposure" // 曝光key
let vividnessKey: String = "vividness" // 鲜明度key
let highlightsKey: String = "highlights" // 高光key
let shadowKey: String = "shadow" // 阴影key
let contrastKey: String = "contrast" // 对比度key
let brightnessKey: String = "brightness" // 亮度key
let naturalSaturationKey: String = "naturalSaturation" // 自然饱和度key
let sharpnessKey: String = "sharpness" // 锐度key
let clarityKey: String = "clarity" // 清晰度key

public class ImageFilterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "image_filter", binaryMessenger: registrar.messenger())
        let instance = ImageFilterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)

        case "imageAddFilter":
            guard let args = call.arguments as? [String: Any],
                  let imageData = args["image"] as? FlutterStandardTypedData,
                  let filterModel = (args["filterModel"] as? [String: Any])?.mapValues(convertToDouble)
            else {
                result(FlutterError(code: "INVALID_ARG", message: "image or filterModel missing", details: nil))
                return
            }
            imageAddFilter(imageData: imageData, filterMap: filterModel, result: result)

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

func convertToDouble(_ value: Any) -> Double {
    if let intValue = value as? Int {
        return Double(intValue)
    }
    if let strValue = value as? String, let intValue = Double(strValue) {
        return intValue
    }
    if let doubleValue = value as? Double {
        return doubleValue
    }
    return 0.0
}

/// 图片添加滤镜
/// - Parameters:
///   - imageData: 图片
///   - filterMap: 滤镜参数
func imageAddFilter(imageData: FlutterStandardTypedData, filterMap: [String: Double], result: @escaping FlutterResult) {
    guard let uiImage = UIImage(data: imageData.data) else {
        // 处理错误
        result(FlutterError(code: "INVALID_ARG", message: "imageData.data INVALID", details: nil))
        return
    }

    // 转换为 CIImage
    guard var ciImage = CIImage(image: uiImage) else {
        // 处理错误
        result(FlutterError(code: "INVALID_ARG", message: "ciImage INVALID", details: nil))
        return
    }
    // 应用滤镜链
    if let filterValue = filterMap[exposureKey],
       let filter = CIFilter(name: "CIExposureAdjust")
    {
        // 1. 曝光调整 -10 - 10 def:0
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(filter.exposureValue(forPercentage: filterValue, EVKeyString: kCIInputEVKey), forKey: kCIInputEVKey)
        ciImage = filter.outputImage ?? ciImage
    }

    if let filterValue = filterMap[vividnessKey],
       let filter = CIFilter(name: "CIVibrance")
    {
        // 2. 鲜明度调整 -1 - 1 def:0
        print(filter.attributes)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(filter.exposureValue(forPercentage: filterValue, EVKeyString: kCIInputAmountKey), forKey: kCIInputAmountKey)
        ciImage = filter.outputImage ?? ciImage
    }

    if let filterValue = filterMap[highlightsKey] ?? filterMap[shadowKey],
       let filter = CIFilter(name: "CIHighlightShadowAdjust")
    {
        // 3. 高光，阴影调整
        print(filter.attributes)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        if let highlightsValue = filterMap[highlightsKey] {
            // 0.3 - 1 def 1
            filter.setValue(filter.exposureValue(forPercentage: highlightsValue, EVKeyString: "inputHighlightAmount"), forKey: "inputHighlightAmount")
        }
        if let shadowValue = filterMap[shadowKey] {
            // -1 - 1 def 0
            filter.setValue(filter.exposureValue(forPercentage: shadowValue, EVKeyString: "inputShadowAmount"), forKey: "inputShadowAmount")
        }
        ciImage = filter.outputImage ?? ciImage
    }

    if let filterValue = filterMap[contrastKey] ?? filterMap[brightnessKey] ?? filterMap[naturalSaturationKey],
       let filter = CIFilter(name: "CIColorControls")
    {
        print(filter.attributes)
        // 4. 对比度，亮度，自然饱和度调整
        filter.setValue(ciImage, forKey: kCIInputImageKey)

        if let contrastValue = filterMap[contrastKey] {
            // 0.25 - 4 def 1
            filter.setValue(filter.exposureValue(forPercentage: contrastValue, EVKeyString: kCIInputContrastKey), forKey: kCIInputContrastKey)
        }
        if let brightnessValue = filterMap[brightnessKey] {
            // -1 - 1 def 0
            filter.setValue(filter.exposureValue(forPercentage: brightnessValue, EVKeyString: kCIInputBrightnessKey), forKey: kCIInputBrightnessKey)
        }

        if let saturationValue = filterMap[naturalSaturationKey] {
            // 0 - 2 def 1
            filter.setValue(filter.exposureValue(forPercentage: saturationValue, EVKeyString: kCIInputSaturationKey), forKey: kCIInputSaturationKey)
        }

        ciImage = filter.outputImage ?? ciImage
    }
    if let filterValue = filterMap[sharpnessKey],
       let filter = CIFilter(name: "CISharpenLuminance")
    {
        print(filter.attributes)
        // 5. 锐度调整 // 0 - 2 def 0.4
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(filter.exposureValue(forPercentage: filterValue, EVKeyString: kCIInputSharpnessKey), forKey: kCIInputSharpnessKey)
        ciImage = filter.outputImage ?? ciImage
    }

    if let filterValue = filterMap[clarityKey],
       let filter = CIFilter(name: "CIUnsharpMask")
    {
        print(filter.attributes)
        // 6. 清晰度调整
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        // 0-100 def 2.5
        filter.setValue(filter.exposureValue(forPercentage: filterValue, EVKeyString: kCIInputRadiusKey), forKey: kCIInputRadiusKey) 
        // 0-1 def 0.5
        filter.setValue(filter.exposureValue(forPercentage: filterValue, EVKeyString: kCIInputIntensityKey), forKey: kCIInputIntensityKey)
        ciImage = filter.outputImage ?? ciImage
    }

    // 渲染为 CGImage
    let context = CIContext(options: nil)
    guard let outputCGImage = context.createCGImage(ciImage, from: ciImage.extent) else {
        result(FlutterError(code: "INVALID_ARG", message: " 渲染为 CGImage INVALID", details: nil))
        return
    }

    let finalUIImage = UIImage(cgImage: outputCGImage, scale: 1.0, orientation: uiImage.imageOrientation)
    // 转换为 Data
    guard let finalData = finalUIImage.pngData() ?? finalUIImage.jpegData(compressionQuality: 1.0) else {
        result(FlutterError(code: "INVALID_ARG", message: "转换为 Data INVALID", details: nil))
        return
    }
    result(FlutterStandardTypedData(bytes: finalData))
}

extension CIFilter {
    // 百分比获取值
    func exposureValue(forPercentage percentage: Double, EVKeyString: String) -> Double {
        // 从 attributes 中获取的属性
        let attributes = self.attributes
        guard let inputEVAttributes = attributes[EVKeyString] as? [String: Any],
              let minTem = inputEVAttributes[kCIAttributeSliderMin],
              let maxTem = inputEVAttributes[kCIAttributeSliderMax],
              let defTem = inputEVAttributes[kCIAttributeDefault]
        else {
            return 0.0
        }
        let minValue = convertToDouble(minTem)
        let maxValue = convertToDouble(maxTem)
        let defValue = convertToDouble(defTem)

        // 将百分比限制在 -100 到 100 之间
        let percent = max(-100, min(100, percentage))
        if percentage >= 0 {
            return defValue + (percent / 100) * (maxValue - defValue)
        } else {
            return defValue + (percent / 100) * (defValue - minValue)
        }
    }
}
