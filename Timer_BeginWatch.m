//
//  Timer_BeginWatch.m
//  timer
//
//  Created by 郑琳 on 16/6/22.
//  Copyright © 2016年 郑琳. All rights reserved.
//

#import "Timer_BeginWatch.h"

#define kDefaultFireIntervalNormal  0.001
@implementation Timer_BeginWatch
-(id)initWithFrame:(CGRect)frame{

    if (self           = [super initWithFrame:frame]) {

    _date              = [NSDate date];
        [self start];
    }
    return self;
}
-(void)start{

    if(_timer == nil){

    _timer             = [NSTimer scheduledTimerWithTimeInterval:kDefaultFireIntervalNormal target:self selector:@selector(labelWithTimerSpan) userInfo:nil repeats:YES];

        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }

}

-(void)labelWithTimerSpan{
    //执行该方法时获取系统的时间
    NSDate *NewDate    = [NSDate date];

    NSTimeInterval late=[_date timeIntervalSince1970]*1;
    NSTimeInterval now=[NewDate timeIntervalSince1970]*1;

    //用新获取的系统时间减去初始的系统时间 得到一个时间差.（_date = [NSDate date] 没有设置 _date这个值本应是刚来到某个控制器页面时获取的时间值）
    NSTimeInterval cha = now-late;

    NSInteger timer    = (NSInteger)(cha *1000);
    NSInteger nowSpan  =  timer;

    //计算
    NSInteger SS       = nowSpan%1000;//毫秒
    nowSpan            = nowSpan/1000;
    NSInteger s        = nowSpan%60;//秒
    NSInteger m        = nowSpan/60;//分
   // NSInteger h        = m / 60;
    NSString *timerStr;
    //如果分 秒 毫秒 小于10 给对应的前面加一个0 显示两位数
    if (m < 10 && s <10) {
    timerStr           = [NSString stringWithFormat:@"Recording 0%ld:0%ld",m,s];
    }else if (m < 10) {

    timerStr           = [NSString stringWithFormat:@"Recording 0%ld:%ld",m,s];
    }else if (s<10) {

    timerStr           = [NSString stringWithFormat:@"Recording %ld:0%ld",m,s];
    }else{

    timerStr           = [NSString stringWithFormat:@"Recording %ld:%ld",m,s];
    }
    //判断毫秒小于0的时候
    if (SS<00) {

        [_timer setFireDate:[NSDate distantFuture]];//停止计时器
        [self TimerSecond];

    }else{
       self.text          = timerStr;
    }
}

-(void)TimerSecond{

    if (_delegate && [_delegate respondsToSelector:@selector(getUpdatelabel)]) {

        [_delegate getUpdatelabel];
    }

}


@end
