//
//  FloatWindowView.m
//  FooViewAlpha
//
//  Created by yunshan on 2019/7/29.
//  Copyright © 2019 chenzhe. All rights reserved.
//

#import "FloatWindowView.h"
#import "FooViewAlphaUtil.h"
#import "FooViewAlphaItemsView.h"

// 悬浮视图状态值
typedef NS_ENUM(NSInteger, FloatViewStatus) {
    FloatViewStatusFixed = 1,   // 悬浮不动
    FloatViewStatusTouchBegin,  // 正准备移动
    FloatViewStatusTouchMoved,  // 移动ing
};

@interface FloatWindowView ()<FooViewAlphaItemsViewDelegate>
// 图标视图
@property (nonatomic, strong) UIImageView * iconImageView;
// 左边毛玻璃视图
@property (nonatomic, strong) UIVisualEffectView * leftEffectView;
// 右边毛玻璃视图
@property (nonatomic, strong) UIVisualEffectView * rightEffectView;
// 移动显示的毛玻璃视图
@property (nonatomic, strong) UIVisualEffectView * radiusEffectView;

// 图标宽度
@property (nonatomic, assign) CGFloat iconWidth;
// 图标内间隙
@property (nonatomic, assign) CGFloat iconPadding;
// 屏幕宽度
@property (nonatomic, assign) CGFloat screenWidth;
// 屏幕高度
@property (nonatomic, assign) CGFloat screenHeight;
// 悬浮状态
@property (nonatomic, assign) FloatViewStatus floatViewStatus;
// 边界控制值
@property (nonatomic, assign) CGFloat boundaryLimitSpace;
// 工具item点击事件
@property (nonatomic, copy) ToolItemTapCallback itemClickCallback;
@end

@implementation FloatWindowView

+(instancetype)shareManager
{
    static FloatWindowView * view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [FloatWindowView new];
        view.screenWidth = [UIScreen mainScreen].bounds.size.width;
        view.screenHeight = [UIScreen mainScreen].bounds.size.height;
        view.iconWidth = 20;
        view.iconPadding = 10;
        view.boundaryLimitSpace = 0;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(showItemsView)]];
    });
    return view;
}

-(void)show
{
    if (self.superview == nil) {
        UIWindow * window = [FooViewAlphaUtil getMainWindow];
        
        self.frame = CGRectMake(0, 100, self.iconWidth*2 + self.iconPadding*2, self.iconWidth*2 + self.iconPadding*2);
        [self modifyFloatView:1];
        
        self.iconImageView.frame = CGRectMake(self.iconPadding, self.iconPadding, self.iconWidth*2, self.iconWidth*2);
        self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width/2;
        self.iconImageView.layer.masksToBounds = YES;
        [window addSubview:self];
        self.hidden = NO;
    }
}

-(void)chooseItem:(ToolItemTapCallback)callback
{
    self.itemClickCallback = callback;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.floatViewStatus = FloatViewStatusTouchBegin;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // 移动后开始变化显示状态
    if (self.floatViewStatus == FloatViewStatusTouchBegin) {
        [self modifyFloatView:2];
    }
    UITouch *touch = [touches anyObject];
    // 当前触摸点
    CGPoint currentPoint = [touch locationInView:self.superview];
    
    CGFloat height = self.bounds.size.height/2;
    // 边界碰撞控制
    if (!(currentPoint.x - height <= self.boundaryLimitSpace || currentPoint.x + height >= (self.screenWidth - self.boundaryLimitSpace) || currentPoint.y - height <= self.boundaryLimitSpace || currentPoint.y + height >= (self.screenHeight - self.boundaryLimitSpace))) {
        self.center = currentPoint;
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    // 当前结束触摸点
    CGPoint currentPoint = [touch locationInView:self.superview];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(currentPoint.x <= self.screenWidth/2 ? 0 : self.screenWidth - self.bounds.size.width, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self modifyFloatView:1];
    }];
}

#pragma mark 工具栏视图
/**
 @brief 显示工具栏视图
 */
-(void)showItemsView
{
    self.hidden = YES;
    [[FooViewAlphaItemsView shareManager] showWithDelegate:self y:self.frame.origin.y direction:(self.frame.origin.x < self.screenWidth/2 ? FooViewAlphaItemsViewDirectionLeft : FooViewAlphaItemsViewDirectionRight) iconImage:self.iconImageView.image];
}

#pragma mark 辅助方法


/**
 @brief 纠正悬浮视图坐标(临时方案)
 */
-(void)correctFloatViewFrame
{
    self.frame = CGRectMake(self.frame.origin.x <= self.screenWidth/2 ? 0 : self.screenWidth - self.bounds.size.width, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
}

/**
 @brief 修改悬浮框显示状态

 @param type 1.根据坐标决定左右显示状态 2.移动状态
 */
-(void)modifyFloatView:(NSInteger)type
{
    if (type == 1) type = self.frame.origin.x < self.screenWidth/2 ? 1 : 3;
    
    self.floatViewStatus = type == 2 ? FloatViewStatusTouchMoved : FloatViewStatusFixed;
    self.leftEffectView.hidden = type == 1 ? NO : YES;
    self.rightEffectView.hidden = type == 3 ? NO : YES;
    self.radiusEffectView.hidden = type == 2 ? NO : YES;
    [self correctFloatViewFrame];
}

#pragma mark FooViewAlphaItemsViewDelegate 回调方法

-(void)dlHideItemsView
{
    self.hidden = NO;
    [self modifyFloatView:1];
}

-(void)dlCloseFooViewAlpha
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
    self.iconImageView = nil;
    self.leftEffectView = nil;
    self.rightEffectView = nil;
    self.radiusEffectView = nil;
}

-(void)dlChooseToolItem:(FooViewToolItemModel *)model
{
    if (self.itemClickCallback) self.itemClickCallback(model);
}

#pragma mark 属性值

-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"alpha_icon"];
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}

-(UIVisualEffectView *)leftEffectView
{
    if (!_leftEffectView) {
        _leftEffectView = [FooViewAlphaUtil generateVisualEffectView:self.bounds corners:UIRectCornerTopRight | UIRectCornerBottomRight];
        [self addSubview:_leftEffectView];
    }
    return _leftEffectView;
}

-(UIVisualEffectView *)rightEffectView
{
    if (!_rightEffectView) {
        _rightEffectView = [FooViewAlphaUtil generateVisualEffectView:self.bounds corners:UIRectCornerTopLeft | UIRectCornerBottomLeft];
        [self addSubview:_rightEffectView];
    }
    return _rightEffectView;
}

-(UIVisualEffectView *)radiusEffectView
{
    if (!_radiusEffectView) {
        _radiusEffectView = [FooViewAlphaUtil generateVisualEffectView:self.bounds corners:UIRectCornerAllCorners];
        [self addSubview:_radiusEffectView];
    }
    return _radiusEffectView;
}
@end
