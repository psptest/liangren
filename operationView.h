//
//  operationView.h
//  security2.0
//
//  Created by Sen5 on 16/3/28.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    kLeftButton = 101,
    kMiddleButotn,
    kRightButton,
} kButtonTag;
@protocol operatonViewDelegate <NSObject>

-(void)oprerationButtonClicked:(NSInteger )tag;

@end

@interface operationView : UIView

@property(nonatomic,weak)id<operatonViewDelegate>delegate;

-(void )selectAnyBtn:(NSUInteger )btn_tag;
@end
