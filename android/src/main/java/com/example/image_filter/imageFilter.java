package com.example.image_filter;

import io.flutter.plugin.common.MethodChannel;
import jp.co.cyberagent.android.gpuimage.GPUImage;
import jp.co.cyberagent.android.gpuimage.filter.GPUImageBrightnessFilter;
import jp.co.cyberagent.android.gpuimage.filter.GPUImageContrastFilter;
import jp.co.cyberagent.android.gpuimage.filter.GPUImageExposureFilter;
import jp.co.cyberagent.android.gpuimage.filter.GPUImageHighlightShadowFilter;
import jp.co.cyberagent.android.gpuimage.filter.GPUImageSaturationFilter;
import jp.co.cyberagent.android.gpuimage.filter.GPUImageSharpenFilter;
import jp.co.cyberagent.android.gpuimage.filter.GPUImageVibranceFilter;

import java.io.ByteArrayOutputStream;

import android.content.Context;
import android.graphics.Bitmap;

import java.util.Map;
import java.util.HashMap;

import android.util.Log;

// 图片滤镜类
public class imageFilter {
    // 定义字符串常量
    public static final String FILTER_EXPOSURE = "exposure";  // 曝光key
    public static final String FILTER_VIVIDNESS = "vividness";  // 鲜明度key
    public static final String FILTER_HIGHLIGHTS = "highlights";  // 高光key
    public static final String FILTER_SHADOW = "shadow";  // 阴影key
    public static final String FILTER_CONTRAST = "contrast";  // 对比度key
    public static final String FILTER_BRIGHTNESS = "brightness";  // 亮度key
    public static final String FILTER_NATURAL_SATURATION = "naturalSaturation";  // 自然饱和度key
    public static final String FILTER_SHARPNESS = "sharpness";  // 锐度key
    public static final String FILTER_CLARITY = "clarity";  // 清晰度key


    public static Map<String, Double> convertToDoubleMap(Map<String, Object> source) {
        Map<String, Double> result = new HashMap<String, Double>();
        for (Map.Entry<String, Object> entry : source.entrySet()) {
            double value = 0.0; // 默认值
            if (entry.getValue() instanceof Number) {
                value = ((Number) entry.getValue()).doubleValue();
            }
            result.put(entry.getKey(), value);
        }
        return result;
    }

    // 对图片添加滤镜
    public static void addFilter(final Context context, final Bitmap bitmap, final Map<String, Object> options, final MethodChannel.Result result) {
        // 转换 Map
        Map<String, Double> resultMap = convertToDoubleMap(options);
        // 使用 Log 输出 Map
        Log.d("Log", resultMap.toString());

        GPUImage gpuImage = new GPUImage(context);
        gpuImage.setImage(bitmap);
        if (resultMap.containsKey(FILTER_EXPOSURE)) {
            // 调整曝光
            final double value = exposureValue(resultMap.get(FILTER_EXPOSURE), 0, -10, 10);
            GPUImageExposureFilter filter = new GPUImageExposureFilter();
            Log.d("Log", String.valueOf(value));
            filter.setExposure((float) value);
            gpuImage.setFilter(filter);
        }
        if(resultMap.containsKey(FILTER_VIVIDNESS)){
            // 调整鲜明度
            final double value = exposureValue(resultMap.get(FILTER_VIVIDNESS), 0, -1, 1);
            GPUImageVibranceFilter filter=new GPUImageVibranceFilter();
            filter.setVibrance((float) value);
            gpuImage.setFilter(filter);
        }
        if(resultMap.containsKey(FILTER_HIGHLIGHTS) || resultMap.containsKey(FILTER_SHADOW)){
            // 调整 高光,阴影
            GPUImageHighlightShadowFilter filter=new GPUImageHighlightShadowFilter();
            final double highlights = resultMap.get(FILTER_HIGHLIGHTS)==null? 0 : resultMap.get(FILTER_HIGHLIGHTS);
            final double shadows = resultMap.get(FILTER_SHADOW)==null? 0 : resultMap.get(FILTER_SHADOW);
            filter.setHighlights((float) exposureValue(highlights, 0.3, 0, 1));
            filter.setShadows((float) exposureValue(shadows, 0, -1, 1));
            gpuImage.setFilter(filter);
        }
        if(resultMap.containsKey(FILTER_CONTRAST)){
            // 对比度
            final double value = exposureValue(resultMap.get(FILTER_CONTRAST), 1, 0, 4);
            GPUImageContrastFilter filter=new GPUImageContrastFilter();
            filter.setContrast((float) value);
            gpuImage.setFilter(filter);
        }
        if(resultMap.containsKey(FILTER_BRIGHTNESS)){
            // 亮度
            final double value = exposureValue(resultMap.get(FILTER_BRIGHTNESS), 0, -1, 1);
            GPUImageBrightnessFilter filter=new GPUImageBrightnessFilter();
            filter.setBrightness((float) value);
            gpuImage.setFilter(filter);
        }
        if(resultMap.containsKey(FILTER_NATURAL_SATURATION)){
            // 饱和度
            final double value = exposureValue(resultMap.get(FILTER_NATURAL_SATURATION), 1, 0, 2);
            GPUImageSaturationFilter filter=new GPUImageSaturationFilter();
            filter.setSaturation((float) value);
            gpuImage.setFilter(filter);
        }
        if(resultMap.containsKey(FILTER_SHARPNESS)){
            // 锐度
            final double value = exposureValue(resultMap.get(FILTER_SHARPNESS), 0, -4, 4);
            GPUImageSharpenFilter filter=new GPUImageSharpenFilter();
            filter.setSharpness((float) value);
            gpuImage.setFilter(filter);
        }
        Bitmap resultBitmap = gpuImage.getBitmapWithFilterApplied();
        // 转回 Uint8List
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        resultBitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream);
        result.success(outputStream.toByteArray());
    }

    // 计算数值
    public static double exposureValue(double percent, double defaultValue, double min, double max) {
        // 将百分比 percent限制在 -100 到 100 之间
        double newPercent = Math.max(-100, Math.min(100, percent));
        if (newPercent >= 0) {
            return defaultValue + (newPercent / 100) * (max - defaultValue);
        } else {
            return defaultValue + (newPercent / 100) * (defaultValue - min);
        }
    }
}
