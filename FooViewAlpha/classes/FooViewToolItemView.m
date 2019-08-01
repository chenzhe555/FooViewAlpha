//
//  FooViewToolItemView.m
//  AFNetworking
//
//  Created by yunshan on 2019/7/31.
//

#import "FooViewToolItemView.h"
@implementation FooViewToolItemModel

@end

@interface FooViewToolItemView ()
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * textLabel;
@end

@implementation FooViewToolItemView

-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}

-(UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

-(void)setModel:(FooViewToolItemModel *)model
{
    _model = model;
    self.iconImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
    self.iconImageView.layer.cornerRadius = self.bounds.size.width/2;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.image = [UIImage imageNamed:_model.iconName];
    
    self.textLabel.text = _model.itemName;
    self.textLabel.frame = CGRectMake(0, self.bounds.size.width + 5, self.bounds.size.width, 20);
}
@end
