//
//  FooViewToolItemView.h
//  AFNetworking
//
//  Created by yunshan on 2019/7/31.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FooViewToolItemModel : NSObject
// 图片头像名称(支持图片名和图片地址)
@property (nonatomic, copy) NSString * iconName;
// item名称
@property (nonatomic, copy) NSString * itemName;
// model键值，建议用此值做区别
@property (nonatomic, copy) NSString * key;
@end

@interface FooViewToolItemView : UIView
@property (nonatomic, strong) FooViewToolItemModel * model;
@end

NS_ASSUME_NONNULL_END
