//
//  FloatWindowView.h
//  FooViewAlpha
//
//  Created by yunshan on 2019/7/29.
//  Copyright © 2019 chenzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooViewToolItemView.h"

// 点击Item回调函数
typedef void(^ToolItemTapCallback)(FooViewToolItemModel * __nullable model);

NS_ASSUME_NONNULL_BEGIN

@interface FloatWindowView : UIView

/**
 @brief 获取当前悬浮视图单例
 */
+(instancetype)shareManager;

/**
 @brief 显示悬浮视图
 */
-(void)show;

/**
 @brief 选择某个工具回调事件
 */
-(void)chooseItem:(ToolItemTapCallback)callback;
@end

NS_ASSUME_NONNULL_END
