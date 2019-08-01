//
//  FooViewAlphaUtil.h
//  FooViewAlpha
//
//  Created by yunshan on 2019/7/29.
//  Copyright © 2019 chenzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FooViewAlphaUtil : NSObject

/**
 @brief 获取Window实例
 */
+(UIWindow *)getMainWindow;

/**
 @brief 生成毛玻璃效果
 */
+(UIVisualEffectView *)generateVisualEffectView:(CGRect)bounds;

/**
 @brief 生成毛玻璃效果&圆角
 */
+(UIVisualEffectView *)generateVisualEffectView:(CGRect)bounds corners:(UIRectCorner)corners;


/**
 @brief 获取显示文本宽度
 */
+(CGFloat)getStringWidth:(NSString *)string font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
