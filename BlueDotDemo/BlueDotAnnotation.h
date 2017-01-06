//
//  BlueCircleAnnotation.h
//  Client
//
//  Created by qq on 2016/11/26.
//  Copyright © 2016年 qq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface BlueDotAnnotation :NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat width;

@property (assign,nonatomic)BOOL selected;
@end
