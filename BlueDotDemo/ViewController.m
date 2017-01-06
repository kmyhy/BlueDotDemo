//
//  ViewController.m
//  BlueDotDemo
//
//  Created by qq on 2017/1/5.
//  Copyright © 2017年 qq. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "ViewController.h"
#import "BlueDot.h"
#import "BlueDotAnnotation.h"
// ShangHai
#define SH_LATITUDE 31.14
#define SH_LONGITUDE 121.29
// Span
#define SPAN_VALUE 0.1f


@interface ViewController ()<MKMapViewDelegate,BlueDotDelegate>{
        CADisplayLink *displayLink;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMapView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

// MARK: Private
/// 配置苹果地图
-(void)setupMapView{

    [self.mapView setDelegate:self];
    _mapView.showsCompass = NO;
    // set init region of the mapview
    CLLocationCoordinate2D center;
    center.latitude = SH_LATITUDE;
    center.longitude = SH_LONGITUDE;
    MKCoordinateSpan span;
    span.latitudeDelta = SPAN_VALUE;
    span.longitudeDelta = SPAN_VALUE;
    MKCoordinateRegion region;
    region.center = center;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
    
    // 添加小蓝点
    BlueDotAnnotation *anno=[[BlueDotAnnotation alloc]init];
    anno.coordinate=center;
    anno.image = [UIImage imageNamed:@"kid_avatar_2"];
    anno.selected = YES;
    anno.width = 38;
    [self.mapView addAnnotation:anno];
    
    anno=[[BlueDotAnnotation alloc]init];
    anno.coordinate=CLLocationCoordinate2DMake(SH_LATITUDE+0.02, SH_LONGITUDE+0.015);
    anno.image = [UIImage imageNamed:@"kid_avatar_2"];
    anno.selected = NO;
    anno.width = 16;
    [self.mapView addAnnotation:anno];
}
// MARK: - MKMapViewDelegate
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if([annotation isKindOfClass:[BlueDotAnnotation class]]){
        NSString* identifier = @"blue_dot";
        
        // 使用自定义的 BlueDot 代替 MAAnnotationView
        BlueDot* blueDot = (BlueDot*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(blueDot == nil){
            blueDot = [[BlueDot alloc]initWithAnnotation: annotation reuseIdentifier: identifier];
            blueDot.delegate = self;
        }
        blueDot.width = ((BlueDotAnnotation*)annotation).width;
        return blueDot;
    }
    return nil ;
}
// MARK: - BlueDotDelegate
-(void)blueDotClicked:(BlueDotAnnotation*)annotation{


    annotation.selected = !annotation.selected;
    
    // 刷新小蓝点
    [_mapView removeAnnotation:annotation];
    [_mapView addAnnotation:annotation];

    
}
@end
