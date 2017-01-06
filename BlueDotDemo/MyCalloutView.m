//
//  KTCalloutView.m
//  Client
//
//  Created by qq on 2016/11/25.
//  Copyright © 2016年 qq. All rights reserved.
//

#import "MyCalloutView.h"

@interface MyCalloutView()
@property (nonatomic, strong) UIImageView *ivBg;
@property (strong,nonatomic) UIButton* button;

@end

@implementation MyCalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    // 添加背景图片
    CGRect rect = CGRectMake(0, 0, callout_bg_size.width,callout_bg_size.height);
    self.ivBg = [[UIImageView alloc]initWithFrame:rect];
    self.ivBg.image = [UIImage imageNamed:@"kid_avatar_bg"];
    self.ivBg.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ivBg];
    
    rect = CGRectMake(3, 3, callout_avatar_size.width, callout_avatar_size.height);
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = rect;
    
    self.button.layer.cornerRadius = callout_avatar_size.width / 2;
    self.button.clipsToBounds = YES;
    
    [self.button setImage:[UIImage imageNamed:@"kid_avatar_empty"] forState:UIControlStateNormal];
    // 这句没有用了，MKMapKit 默认会使用 mapview 来拦截触摸事件
    [self.button addTarget:self action:@selector(btnAvatarClicked:) forControlEvents:UIControlEventTouchUpInside];
  
    [self addSubview:self.button];
}
- (void)setImage:(UIImage *)image
{
    [self.button setImage:image forState:UIControlStateNormal];
}

-(void)btnAvatarClicked:(UIButton*)sender{
    [_delegate calloutClicked];
}
@end
