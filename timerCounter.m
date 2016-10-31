//
//  timerCounter.m
//  testlib
//
//  Created by Sen5 on 16/10/10.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import "timerCounter.h"
@interface timerCounter()
{
    dispatch_source_t timer;
}
@property (weak, nonatomic) IBOutlet UIButton *begainBtn;
@property (nonatomic) BOOL isStart;
@property (nonatomic) BOOL isPause;
@property (nonatomic) BOOL isCreat;
@property (nonatomic,assign) int timeCount;
@end
@implementation timerCounter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
            _isCreat = YES;
        
        self.font = [UIFont systemFontOfSize:16];
        self.textColor = [UIColor whiteColor];
        
            //    每秒执行一次
            dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
            dispatch_source_set_event_handler(timer, ^{
                int hours = _timeCount / 3600;
                int minutes = (_timeCount - (3600*hours)) / 60;
                int seconds = _timeCount%60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hours,minutes,seconds];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //           ======在这根据自己的需求去刷新UI==============
                    self.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Recording", nil),strTime];
                    
                });
                _timeCount ++;
            });
            
            dispatch_resume(timer);
            
        
    }
    return self;
}
- (void )endCount {
    if (_isCreat){
        if (_isPause == YES) {
            dispatch_resume(timer);
            
        }
        dispatch_source_cancel(timer);
    //    [_begainBtn setTitle:@"开始" forState:UIControlStateNormal];
        [self removeFromSuperview];
        _isStart = NO;
        _timeCount = 0;
        _isCreat = NO;
    }
}

@end
