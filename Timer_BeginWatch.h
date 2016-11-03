//
//  Timer_BeginWatch.h
//  timer
//
//  Created by 郑琳 on 16/6/22.
//  Copyright © 2016年 郑琳. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Timer_BeginWatchDelegate <NSObject>

@optional
-(void)getUpdatelabel;

@end
@interface Timer_BeginWatch : UILabel

@property (nonatomic) NSInteger TimerSpan;


@property (weak, nonatomic) id<Timer_BeginWatchDelegate>delegate;
@property (strong, nonatomic) NSTimer *timer;//计时器
@property (strong, nonatomic) NSDate *date;

-(void)start;

-(void)labelWithTimerSpan;
@end
