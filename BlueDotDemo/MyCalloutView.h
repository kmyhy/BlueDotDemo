//
//  KTCalloutView.h
//  Client
//
//  Created by qq on 2016/11/25.
//  Copyright © 2016年 qq. All rights reserved.
//

#import <UIKit/UIKit.h>

#define callout_bg_size CGSizeMake(86,94)
#define callout_avatar_size CGSizeMake(80,80)

@protocol MyCalloutViewDelegate <NSObject>

@required
-(void)calloutClicked;

@end
@interface MyCalloutView : UIControl
@property (nonatomic, strong) UIImage *image;
@property (weak,nonatomic)id<MyCalloutViewDelegate> delegate;
@end
