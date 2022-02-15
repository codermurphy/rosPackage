//
//  ROSImageProccessing.m
//  ROSPackage
//
//  Created by ogawa on 2022/1/28.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"


#ifdef __cplusplus
//#undef NO
#import <opencv2/cvconfig.h>
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#endif

#import "ROSImageProccessing.h"

@implementation ROSImageProccessing

/// 将pgm原始图片转为png图片
/// @param map pgm图片
/// @param negate If negate is false, p = (255 - x) / 255.0 f negate is true, p = x / 255.0
/// @param occupiedThresh 障碍物颜色阈值
/// @param freeThresh 自由通行颜色阈值
/// @param convertFreeColor 自由通行颜色
/// @param convertBarrierColor 障碍物颜色
+ (UIImage *)covertRosMapToPng: (UIImage *)map
                        negate: (BOOL)negate
                occupiedThresh: (float)occupiedThresh
                    freeThresh: (float)freeThresh
              convertFreeColor: (UIColor *)convertFreeColor
           convertBarrierColor: (UIColor *)convertBarrierColor; {
    
    
    cv::Mat src;
    UIImageToMat(map, src);
    
    const CGFloat *f_components = CGColorGetComponents(convertFreeColor.CGColor);
    uchar f_r = f_components[0] * 255;
    uchar f_g = f_components[1] * 255;
    uchar f_b = f_components[2] * 255;
    uchar f_a = f_components[3] * 255;
    
    const CGFloat *b_components = CGColorGetComponents(convertBarrierColor.CGColor);
    
    uchar b_r = b_components[0] * 255;
    uchar b_g = b_components[1] * 255;
    uchar b_b = b_components[2] * 255;
    uchar b_a = b_components[3] * 255;
    
    cv::Vec4b free_vec = cv::Vec4b(f_r,f_g,f_b,f_a);
    
    cv::Vec4b barrier_vec = cv::Vec4b(b_r,b_g,b_b,b_a);
    
    cv::Mat mat_8u4c,mat_8u3c,result;

    cvtColor(src, mat_8u3c, cv::COLOR_GRAY2BGR);
    
    std::vector<cv::Mat> mats = {mat_8u3c,src};
    merge(mats, mat_8u4c);
    
    cv::Mat tables = cv::Mat(1,256,CV_8UC4);
    uchar *tPtr = tables.ptr();
    for (int i = 0; i < 256; i ++) {
        float thresh = negate ? (float)i / 255.0 : (255.0 - (float)i) / 255.0;
        if (thresh > occupiedThresh) {
            tPtr[i * 4] = barrier_vec[0]; // Red
            tPtr[i * 4 + 1] = barrier_vec[1]; // Green
            tPtr[i * 4 + 2] = barrier_vec[2]; // Blue
            tPtr[i * 4 + 3] = barrier_vec[3]; // Alpha
        }
        else if (thresh < freeThresh) {
            tPtr[i * 4] = free_vec[0];
            tPtr[i * 4 + 1] = free_vec[1];
            tPtr[i * 4 + 2] = free_vec[2];
            tPtr[i * 4 + 3] = free_vec[3];
        }
        else {
            tPtr[i * 4] = 0;
            tPtr[i * 4 + 1] = 0;
            tPtr[i * 4 + 2] = 0;
            tPtr[i * 4 + 3] = 0;
        }

    }
    
    LUT(mat_8u4c, tables, result);
            
    return MatToUIImage(result);
}


@end
