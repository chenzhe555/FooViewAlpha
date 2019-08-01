//
//  FooViewAlphaManager.m
//  FooViewAlpha
//
//  Created by yunshan on 2019/7/29.
//  Copyright © 2019 chenzhe. All rights reserved.
//

#import "FooViewAlphaManager.h"
#import "FooViewAlphaItemsView.h"

@implementation FooViewAlphaManager

+(instancetype)shareManager
{
    static FooViewAlphaManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FooViewAlphaManager new];
    });
    return manager;
}

-(void)openFooViewAlpha
{
    [[FloatWindowView shareManager] show];
}

-(void)addToolItems:(NSArray<FooViewToolItemModel *> *)arr
{
    [[FooViewAlphaItemsView shareManager] addToolItems:arr];
}

-(void)chooseItem:(ToolItemTapCallback)callback
{
    [[FloatWindowView shareManager] chooseItem:callback];
}

-(void)showFloatWindowView
{
    if ([FloatWindowView shareManager].hidden) [FloatWindowView shareManager].hidden = NO;
}

-(void)hideFloatWindowView
{
    if (![FloatWindowView shareManager].hidden) [FloatWindowView shareManager].hidden = YES;
}
@end
