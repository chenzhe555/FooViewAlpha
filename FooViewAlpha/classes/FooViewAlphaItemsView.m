//
//  FooViewAlphaItemsView.m
//  AFNetworking
//
//  Created by yunshan on 2019/7/31.
//

#import "FooViewAlphaItemsView.h"
#import "FooViewAlphaUtil.h"

@interface FooViewAlphaItemsView ()
// 毛玻璃视图
@property (nonatomic, strong) UIVisualEffectView * effectView;
// 内容视图
@property (nonatomic, strong) UIView * contentView;
// items视图
@property (nonatomic, strong) UIView * itemsView;
@property (nonatomic, weak) id<FooViewAlphaItemsViewDelegate> delegate;
// 内容视图显示方向
@property (nonatomic, assign) FooViewAlphaItemsViewDirection showDirection;

// items数组
@property (nonatomic, strong) NSMutableArray<FooViewToolItemModel *> * itemsArray;
@end

@implementation FooViewAlphaItemsView

+(instancetype)shareManager
{
    static FooViewAlphaItemsView * view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [FooViewAlphaItemsView new];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(hide)]];
        view.itemsArray = [NSMutableArray array];
    });
    return view;
}

-(void)showWithDelegate:(id<FooViewAlphaItemsViewDelegate>)delegate y:(CGFloat)y direction:(FooViewAlphaItemsViewDirection)direction iconImage:(nonnull UIImage *)iconImage
{
    self.delegate = delegate;
    UIWindow * window = [FooViewAlphaUtil getMainWindow];
    self.frame = window.bounds;
    self.showDirection = direction;
    
    // 创建视图并动画显示
    self.effectView.alpha = 0;
    [self createItemsView];
    [self addToContentView:iconImage y:y];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.effectView.alpha = 1;
        weakSelf.contentView.frame = CGRectMake(direction == 1 ? 0 : self.bounds.size.width - self.contentView.bounds.size.width, self.contentView.frame.origin.y, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    }];
    
    [window addSubview:self];
}

-(void)addToolItems:(NSArray<FooViewToolItemModel *> *)arr
{
    [self.itemsArray addObjectsFromArray:arr];
}

-(void)hide
{
    __weak typeof(self) weakSelf = self;
    // 动画消失
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.effectView.alpha = 0;
        weakSelf.itemsView.alpha = 0;
        weakSelf.contentView.frame = CGRectMake(self.showDirection == FooViewAlphaItemsViewDirectionLeft ? -200 : self.bounds.size.width, weakSelf.contentView.frame.origin.y, weakSelf.contentView.bounds.size.width, weakSelf.contentView.bounds.size.height);
    } completion:^(BOOL finished) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(dlHideItemsView)]) {
            [weakSelf.delegate dlHideItemsView];
        }
        [weakSelf remove];
    }];
}


/**
 @brief 移除视图
 */
-(void)remove
{
    [self.itemsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
    self.itemsView = nil;
    self.effectView = nil;
    self.contentView = nil;
}


/**
 @brief 关闭当前悬浮工具视图
 */
-(void)closeAll
{
    [self remove];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dlCloseFooViewAlpha)]) {
        [self.delegate dlCloseFooViewAlpha];
    }
}

#pragma mark 辅助方法

/**
 @brief 内容视图添加子视图

 @param iconImage 头像
 */
-(void)addToContentView:(UIImage *)iconImage y:(CGFloat)y
{
    self.contentView.frame = CGRectMake(0, 0, 0, 50);

    // 头像
    UIImageView * iconImageView = [[UIImageView alloc] init];
    iconImageView.frame = CGRectMake(10, (self.contentView.bounds.size.height - 30)/2, 30, 30);
    iconImageView.image = iconImage;
    iconImageView.layer.cornerRadius = iconImageView.bounds.size.width/2;
    iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconImageView];
    
    // 文本
    UILabel * label = [[UILabel alloc] init];
    label.text = @"点击 X 关闭悬浮视图";
    label.font = [UIFont systemFontOfSize:12];
    CGFloat width = [FooViewAlphaUtil getStringWidth:label.text font:label.font];
    label.frame = CGRectMake(iconImageView.frame.origin.x + iconImageView.bounds.size.width + 10, (self.contentView.bounds.size.height - 20)/2, width, 20);
    [self.contentView addSubview:label];
    
    // 关闭按钮
    UIView * closeView = [[UIView alloc] init];
    closeView.frame = CGRectMake(label.frame.origin.x + label.bounds.size.width, 0, 40, self.contentView.bounds.size.height);
    [self.contentView addSubview:closeView];
    UIImageView * closeImageView = [[UIImageView alloc] init];
    closeImageView.frame = CGRectMake((closeView.bounds.size.width - 16)/2, (closeView.bounds.size.height - 16)/2, 16, 16);
    closeImageView.image = [UIImage imageNamed:@"close"];
    [closeView addSubview:closeImageView];
    [closeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAll)]];
    
    // 赋值self.contentView frame
    CGFloat allWidth = ceil(closeView.frame.origin.x + closeView.frame.size.width + 6);
    self.contentView.frame = CGRectMake(self.showDirection == 1 ? -allWidth : self.bounds.size.width, y > (self.itemsView.frame.origin.y + self.itemsView.bounds.size.height) ? y : (self.bounds.size.height - 150), allWidth, 50);
    
    // 圆角
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:self.showDirection == FooViewAlphaItemsViewDirectionLeft ? (UIRectCornerTopRight | UIRectCornerBottomRight) : (UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(self.contentView.bounds.size.height/2, self.contentView.bounds.size.height/2)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
}


/**
 @brief 创建工具栏Item视图
 */
-(void)createItemsView
{
    NSInteger lineCount = 4;
    CGFloat space = 20;
    CGFloat imageTextSpace = 5;
    CGFloat width = ceil(([UIScreen mainScreen].bounds.size.width - space*(lineCount + 1))/lineCount);
    CGFloat itemHeight = width + imageTextSpace + space;
    
    for (int i = 0; i < self.itemsArray.count; ++i) {
        FooViewToolItemView * view = [[FooViewToolItemView alloc] init];
        view.frame = CGRectMake((i%lineCount + 1) * space + (i%lineCount) * width, (i/lineCount) * itemHeight, width, itemHeight);
        view.model = self.itemsArray[i];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)]];
        [self.itemsView addSubview:view];
    }
    self.itemsView.frame = CGRectMake(0, 64, self.bounds.size.width, (self.itemsArray.count/lineCount + (self.itemsArray.count%lineCount == 0 ? 0 : 1)) * itemHeight);
}

-(void)itemClick:(UITapGestureRecognizer *)tap
{
    [self remove];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dlHideItemsView)]) {
        [self.delegate dlHideItemsView];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dlChooseToolItem:)]) {
        [self.delegate dlChooseToolItem:((FooViewToolItemView *)tap.view).model];
    }
}

#pragma mark 属性
-(UIVisualEffectView *)effectView
{
    if (!_effectView) {
        _effectView = [FooViewAlphaUtil generateVisualEffectView:self.bounds];
        [self addSubview:_effectView];
    }
    return _effectView;
}

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
    }
    return _contentView;
}

-(UIView *)itemsView
{
    if (!_itemsView) {
        _itemsView = [UIView new];
        [self addSubview:_itemsView];
    }
    return _itemsView;
}
@end
