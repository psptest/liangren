//
//  PlayImageView.h
//  security
//
//  Created by sen5labs on 15/10/16.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayImageView;

typedef void(^CallBackBlock)(PlayImageView * playView);

typedef void(^FullViewButtonClickCallBack)(PlayImageView *playView);

@interface PlayImageView : UIView

@property (strong, nonatomic)  UIActivityIndicatorView *activityView;
@property (strong, nonatomic)  UIImageView *playImageView;
@property (strong, nonatomic)  UIImageView *centerImageView;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic,copy)  CallBackBlock callBackBlock;
@property (nonatomic,copy) FullViewButtonClickCallBack fullViewButtonCallBackBlock;


- (void)play;

- (void)pause;

- (void)stapAnimation;

- (void)refreshWithImage:(UIImage *)image;

@end
