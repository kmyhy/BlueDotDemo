//
//  BlueCircle.m
//  Client
//
//  Created by qq on 2016/11/25.
//  Copyright © 2016年 qq. All rights reserved.
//

#import "BlueDot.h"

#define intrinsic_width 48

@interface BlueDot()<MyCalloutViewDelegate>{
    CADisplayLink *displayLink;
    CGFloat currentWidthPercent;
    int sign;
    
}
@property (nonatomic, strong, readwrite) MyCalloutView *calloutView;
@end

@implementation BlueDot

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    _defaultFillColor = [UIColor colorWithRed: 0.294 green: 0.635 blue: 0.933 alpha: 1.000];
    _selectFillColor = [UIColor redColor];
    _period = 0.5;
    _minPercent = 0.55;
    _maxPercent = 0.75;
    currentWidthPercent = _minPercent;
    sign = 1;
    _shadowRadius = 4;
    _width = 28;
    // Set placeholder image which specify view's size
    self.image = [UIImage imageNamed:@"blue_circle_transparent"];

    if([annotation isKindOfClass:[BlueDotAnnotation class]]){
        self.blueDotAnnotation = (BlueDotAnnotation*)annotation;
    }
    
    if (self.calloutView == nil)
    {
        self.calloutView = [[MyCalloutView alloc] initWithFrame:CGRectMake(0, 0, 80, 89)];
//        self.calloutView.center = CGPointMake(-5 + self.calloutOffset.x,
//                                              -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        self.calloutView.center = CGPointMake(intrinsic_width/2 -4,
                                              -89/2+(intrinsic_width-_width)/2);// 这里的 -4 是经验值
        self.calloutView.delegate = self;
        
        self.calloutView.image = self.blueDotAnnotation.image;
    }
    
    [self addSubview:self.calloutView];
    
    self.backgroundColor = [UIColor clearColor];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeUpdate:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self beginAnimate];
    
    return self;
}

-(void)drawRect:(CGRect)rect{
    
    [self  drawBlueDot];
}
-(void)setWidth:(CGFloat)width{
    
    _width = (width > intrinsic_width || width <0 )?intrinsic_width:width;
    
    self.calloutView.center = CGPointMake(intrinsic_width/2 -4,-89/2+(intrinsic_width-_width)/2);
//    [self setNeedsLayout];

}
-(void)drawBlueDot{
    
//    NSLog(@"x:%f,y:%f,w:%f,h:%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
//    CGRect frame = CGRectMake(0, 0, intrinsic_width,intrinsic_width);
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
    
    NSShadow *shadow = [NSShadow new];
    
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowOffset = CGSizeMake(0, 0);
    shadow.shadowBlurRadius = _shadowRadius;

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat width = _width-_shadowRadius*2;
    
    CGFloat innerWidth = currentWidthPercent*width;
//    NSLog(@"width:%f",innerWidth);
    
    UIColor* color = _blueDotAnnotation.selected ? _selectFillColor : _defaultFillColor;
    UIColor* color2 = [UIColor colorWithRed: 1.000 green: 1.000 blue: 1.000 alpha: 1.000];
    
    UIBezierPath* bgOvalPath = [UIBezierPath bezierPathWithArcCenter: center radius: width/2 startAngle: 0 * M_PI/180 endAngle: 360 * M_PI/180 clockwise: YES];
//    [bgOvalPath closePath];// Not exactly need this.
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
    [color2 setFill];
    [bgOvalPath fill];
    CGContextRestoreGState(context);
    
    UIBezierPath* circlePath = [UIBezierPath bezierPathWithArcCenter: center radius: innerWidth/2 startAngle: 0 * M_PI/180 endAngle: 360 * M_PI/180 clockwise: YES];
    [color setFill];
    [circlePath fill];
}
-(void) beginAnimate{
    displayLink.paused = NO;
}

-(void)endAnimate {
    displayLink.paused = YES;
}

-(void)timeUpdate:(CADisplayLink*)link {
    
    currentWidthPercent += sign*(link.duration*(_maxPercent-_minPercent)/_period);
    
    /* BlueRot 继承 MKAnnotationView，MKAnnotationView 是一种特殊的 UIView，它不会按帧率自动调用 drawRect 方法来绘制 UI（除了开头会调用 2 次）。因此我们需要手动触发 drawRect 方法（即发送 setNeedsDisplay 信息）。
     */
    [self setNeedsDisplay];
//    NSLog(@"current percent:%f",currentWidthPercent);
    //        NSLog("\(tick)")
    if (currentWidthPercent >= _maxPercent || currentWidthPercent <= _minPercent){
        sign = 0-sign;
    }
}

// MARK: - MyCalloutViewDelegate
-(void)calloutClicked{
    [_delegate blueDotClicked:self.annotation];
}

//此方法用于判断哪些点击是有效的，默认的行为是只有大头钉上的点击才会被处理，除此之外的点击交给 superview (即 mapview )处理。我们覆盖这个方法，让发生在 subview (这就包括了自定义 callout view）上的点击也会被处理。
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                return isInside;
        }
    }
    return isInside;
}
-(void)dealloc{
    if(displayLink.paused == NO){
        [self endAnimate];
        [displayLink invalidate];
    }
}
@end




