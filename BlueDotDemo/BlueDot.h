//
//  BlueCircle.h
//  Client
//
//  Created by qq on 2016/11/25.
//  Copyright © 2016年 qq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MyCalloutView.h"
#import "BlueDotAnnotation.h"

@protocol BlueDotDelegate <NSObject>
@required
-(void)blueDotClicked:(BlueDotAnnotation*)annotation;

@end

@interface BlueDot : MKAnnotationView
@property (nonatomic, assign)CGFloat period;

@property (nonatomic, assign)CGFloat minPercent;

@property (nonatomic, assign)CGFloat maxPercent;

@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat shadowRadius;

@property (nonatomic, strong)UIColor* defaultFillColor ;
@property (nonatomic, strong)UIColor* selectFillColor;

@property (nonatomic, readonly)MyCalloutView *calloutView;
@property (nonatomic, strong) BlueDotAnnotation* blueDotAnnotation;
@property (nonatomic,weak)id<BlueDotDelegate> delegate;


@end
