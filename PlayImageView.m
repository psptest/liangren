//
//  PlayImageView.m
//  security
//
//  Created by sen5labs on 15/10/16.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import "PlayImageView.h"
#import "AppDelegate.h"

@interface PlayImageView () <UIScrollViewDelegate> {
    
    NSTimer * _timer;  //消失的时间
}

@property (nonatomic, assign) BOOL isHD;
@property (nonatomic, assign) BOOL isRotation;
@property (nonatomic, assign) BOOL isPreparePlaying;
@property (nonatomic, assign) BOOL isShowBtnView;
@property (nonatomic, assign) CGRect preRect;
@property (nonatomic, strong) UIView *preSuperView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation PlayImageView

- (void)awakeFromNib {
   // [self addGestureRecognizer:self.tapGesture];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

#pragma mark - public
- (void)play {
    self.isPreparePlaying = YES;
    self.centerImageView.hidden = YES;
    
    if (![self.activityView isAnimating]) {
        [self.activityView startAnimating];
    }
}

- (void)pause {
    [self.activityView stopAnimating];
    self.centerImageView.hidden = NO;
    self.isPlaying = NO;
}

- (void)stapAnimation {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t )(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isPlaying = YES;
        self.centerImageView.hidden = YES;
        [self.activityView stopAnimating];
    });
}

- (void)refreshWithImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.isPlaying || self.activityView.isAnimating) return ;
        self.isPlaying = YES;
        self.playImageView.image = image;
    });
}
#pragma mark - events
- (void)playTapClick:(id)sender {
    
    if (self.callBackBlock) {
        self.callBackBlock(self);
    }
    NSLog(@"playTapClick");
}

- (IBAction)fullViewBtnClick:(UIButton *)sender {
    NSLog(@"fullViewBtnClick");
    if (self.fullViewButtonCallBackBlock) {
        self.fullViewButtonCallBackBlock(self);
    }
}


#pragma mark - getter
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playTapClick:)];
    }
    return _tapGesture;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
}



@end
