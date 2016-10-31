//
//  DisConnectedBtn.h
//  security
//
//  Created by sen5labs on 15/10/28.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DisConnectedBtnDelegate <NSObject>
-(void )disConnectedBtnClicked;
@end
typedef NS_ENUM(NSInteger, DisConnectedReason) {
    
    // p2p 要修改
    DisConnectedFailed = 0,             // 网络错误
    DisConnectedP2PConnectError,        // 连接错误
    DisConnectedNoHouse,                // 没有房子
    DIsConnectedReconnect,              // 正在重连
    DisConnectedCheckUserIDFail,        // userIDcheck fail
};

@interface DisConnectedBtn : UIButton

@property (nonatomic,assign) DisConnectedReason reason;
@property(nonatomic,weak) id<DisConnectedBtnDelegate > delegate;

+ (instancetype)disConnectedBtn;
/**
 *  刷新错误原因
 *
 *  @param wrongSeason DisConnectedReason
 */
- (void)setWithWrongSeason:(DisConnectedReason )wrongSeason;
-(DisConnectedReason )getWithWrongSeason;


-(void )animationWithFlag:(BOOL )flag;

//弹出警告视图 并自动消失
- (void )setAlarms:(NSString *)alarms;

@end
