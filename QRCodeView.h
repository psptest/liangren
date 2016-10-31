//
//  QRCodeView.h
//  security
//
//  Created by sen5labs on 15/9/30.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock)(id obj);

@interface QRCodeView : UIView

/**
 *  开始扫描
 *
 *  @param block 扫描到有效二维码 回调
 *
 *  @return 开始扫描是否成功，在模拟器中 会失败
 */
- (BOOL)startReadingWithCompletBlock:(CompleteBlock)block;

-(void )setRecommands:(NSString *)recommands;

/**
 *  停止扫描
 */
- (void)stopReading;

@end
