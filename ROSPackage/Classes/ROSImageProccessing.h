//
//  ROSImageProccessing.h
//  ROSPackage
//
//  Created by ogawa on 2022/1/28.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ROSImageProccessing : NSObject

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
           convertBarrierColor: (UIColor *)convertBarrierColor;

@end

NS_ASSUME_NONNULL_END
