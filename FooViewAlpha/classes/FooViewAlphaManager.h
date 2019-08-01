//
//  FooViewAlphaManager.h
//  FooViewAlpha
//
//  Created by yunshan on 2019/7/29.
//  Copyright © 2019 chenzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloatWindowView.h"
#import "FooViewToolItemView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FooViewAlphaManager : NSObject

/**
 @brief 获取当前单例
 */
+(instancetype)shareManager;

/**
 @brief 打开悬浮按钮工具
 */
-(void)openFooViewAlpha;

/**
 @brief 添加工具数组
 */
-(void)addToolItems:(NSArray<FooViewToolItemModel *> *)arr;

/**
 @brief 选择某个工具回调事件
 */
-(void)chooseItem:(ToolItemTapCallback)callback;

#pragma mark 对悬浮视图的额外操作,截屏时可用
/**
 @brief 显示悬浮视图
 */
-(void)showFloatWindowView;
/**
 @brief 隐藏悬浮视图
 */
-(void)hideFloatWindowView;
@end

NS_ASSUME_NONNULL_END
