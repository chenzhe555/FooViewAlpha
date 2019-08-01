//
//  FooViewAlphaUtil.m
//  FooViewAlpha
//
//  Created by yunshan on 2019/7/29.
//  Copyright © 2019 chenzhe. All rights reserved.
//

#import "FooViewAlphaUtil.h"
#import <UIKit/UIKit.h>

@implementation FooViewAlphaUtil
+(UIWindow *)getMainWindow
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window)
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}

+(UIVisualEffectView *)generateVisualEffectView:(CGRect)bounds
{
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = bounds;
    effectView.alpha = 0.8;
    return effectView;
}

+(UIVisualEffectView *)generateVisualEffectView:(CGRect)bounds corners:(UIRectCorner)corners
{
    // 设置毛玻璃效果
    UIVisualEffectView * effectView = [self generateVisualEffectView:bounds];
    
    // 设置圆角
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:effectView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(effectView.bounds.size.height/2, effectView.bounds.size.height/2)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = effectView.bounds;
    maskLayer.path = maskPath.CGPath;
    
    effectView.layer.mask = maskLayer;
    return effectView;
}

+(CGFloat)getStringWidth:(NSString *)string font:(UIFont *)font
{
    return [string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil].size.width;
}
@end


