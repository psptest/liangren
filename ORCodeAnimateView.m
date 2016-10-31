//
//  ORCodeAnimateView.m
//  UIPageViewController
//
//  Created by sen5labs on 15/10/9.
//  Copyright © 2015年 sen5. All rights reserved.
//  扫描动画

#import "ORCodeAnimateView.h"
#import "UILabel+StringFrame.h"

#import "prefrenceHeader.h"

#define kLineDistance 10

@interface ORCodeAnimateView()

@property (nonatomic, strong) CALayer *lineLayer;       // 扫描中间一直在动的那根线

@property (nonatomic, assign) CGFloat width;            // 中间透明的宽度

@property (nonatomic, strong) CABasicAnimation *moveAnimation;  // 移动动画

@property (nonatomic, strong) UILabel *tipLabel;        // 显示文字

@end

@implementation ORCodeAnimateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lineLayer.position = CGPointMake(self.center.x, self.center.y - 0.5*self.width - 70);
    self.tipLabel.center = CGPointMake(self.center.x, self.center.y + 0.5*self.width);
    [self starAnimation];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    // CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.7);
    //  CGContextSetRGBFillColor(context, 0, 0, 0, 0.7);
    
    UIBezierPath* path1 = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath* path2 = [UIBezierPath bezierPathWithRect:CGRectMake(self.center.x - 0.5*self.width , self.center.y - 0.5*self.width - 70, self.width, self.width)];
    
    CGContextAddPath(context, path1.CGPath);
    CGContextAddPath(context, path2.CGPath);
    
    CGContextEOFillPath(context);
    
    CGContextSetRGBStrokeColor(context, 0, 191, 195, 1);
    
    CGContextSetLineWidth(context, 2);
    
    CGContextMoveToPoint(context, self.center.x - 0.5*self.width-kLineDistance, self.center.y - 0.5*self.width - 40);
    CGContextAddLineToPoint(context, self.center.x - 0.5*self.width-kLineDistance, self.center.y - 0.5*self.width - 70-kLineDistance);
    CGContextAddLineToPoint(context, self.center.x - 0.5*self.width + 30, self.center.y - 0.5*self.width - 70-kLineDistance);
    
    CGContextMoveToPoint(context, self.center.x + 0.5*self.width+kLineDistance, self.center.y - 0.5*self.width - 40);
    CGContextAddLineToPoint(context, self.center.x + 0.5*self.width+kLineDistance, self.center.y - 0.5*self.width - 70-kLineDistance);
    CGContextAddLineToPoint(context, self.center.x + 0.5*self.width - 30, self.center.y - 0.5*self.width - 70-kLineDistance);
    
    CGContextMoveToPoint(context, self.center.x + 0.5*self.width+kLineDistance, self.center.y + 0.5*self.width - 100);
    CGContextAddLineToPoint(context, self.center.x + 0.5*self.width+kLineDistance, self.center.y + 0.5*self.width - 70+kLineDistance);
    CGContextAddLineToPoint(context, self.center.x + 0.5*self.width - 30, self.center.y + 0.5*self.width - 70+kLineDistance);
    
    CGContextMoveToPoint(context, self.center.x - 0.5*self.width-kLineDistance, self.center.y + 0.5*self.width - 100);
    CGContextAddLineToPoint(context, self.center.x - 0.5*self.width-kLineDistance, self.center.y + 0.5*self.width - 70+kLineDistance);
    CGContextAddLineToPoint(context, self.center.x - 0.5*self.width + 30, self.center.y + 0.5*self.width - 70+kLineDistance);
    
    [kMainGreenColor setStroke];
    
    CGContextDrawPath(context, kCGPathStroke);
    
}

- (void)setupUI {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:self.lineLayer];
    [self addSubview:self.tipLabel];
}

- (void)applicationDidBecomeActive {
    MYLog(@"applicationDidBecomeActive");
    [self starAnimation];
}

- (void)starAnimation {
    [self.lineLayer addAnimation:self.moveAnimation forKey:@"moveAnimation"];
}

- (CALayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CALayer layer];
        _lineLayer.bounds = CGRectMake(0, 0, self.width - 30, 3);
        _lineLayer.backgroundColor = kMainGreenColor.CGColor;
        _lineLayer.cornerRadius = 0.75;
     //  _lineLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"QR"].CGImage);
    }
    return _lineLayer;
}

- (CABasicAnimation *)moveAnimation {
    if (!_moveAnimation) {
        CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        CGPoint point = CGPointMake(super.center.x, super.center.y - 0.5*self.width - 70);
        moveAnimation.fromValue = [NSValue valueWithCGPoint:point];
        moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x,
                                                                      point.y + self.width)];
        moveAnimation.autoreverses = YES;
        moveAnimation.repeatCount = MAXFLOAT;
        moveAnimation.duration = 1.0;
        
        _moveAnimation = moveAnimation;
    }
    
    return _moveAnimation;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        UILabel *label = [[UILabel alloc] init];
        //        label.backgroundColor = [UIColor redColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = [UIFont systemFontOfSize:14.0];
        label.numberOfLines = 0;
        label.text = NSLocalizedString(@"Scan_QRCode", nil);
        CGSize size = [label boundingRectWithSize:CGSizeMake(self.width - 50, 2000)];
        label.frame = CGRectMake(0, 0, size.width, size.height);
        
        _tipLabel = label;
        
    }
    return _tipLabel;
}

- (CGFloat)width {
    return 250;
}

@end
