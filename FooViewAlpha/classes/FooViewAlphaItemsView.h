//
//  FooViewAlphaItemsView.h
//  AFNetworking
//
//  Created by yunshan on 2019/7/31.
//

#import <UIKit/UIKit.h>
#import "FooViewToolItemView.h"

typedef NS_ENUM(NSInteger, FooViewAlphaItemsViewDirection) {
    FooViewAlphaItemsViewDirectionLeft = 1,
    FooViewAlphaItemsViewDirectionRight
};

@protocol FooViewAlphaItemsViewDelegate <NSObject>
// 隐藏当前视图
-(void)dlHideItemsView;
// 关闭悬浮视图
-(void)dlCloseFooViewAlpha;
// 选择某个工具类
-(void)dlChooseToolItem:(FooViewToolItemModel * __nullable)model;
@end

NS_ASSUME_NONNULL_BEGIN

@interface FooViewAlphaItemsView : UIView
/**
 @brief 获取当前实例
 */
+(instancetype)shareManager;

-(void)showWithDelegate:(id<FooViewAlphaItemsViewDelegate>)delegate y:(CGFloat)y direction:(FooViewAlphaItemsViewDirection)direction iconImage:(UIImage *)iconImage;

/**
 @brief 添加工具数组
 */
-(void)addToolItems:(NSArray<FooViewToolItemModel *> *)arr;
@end

NS_ASSUME_NONNULL_END
