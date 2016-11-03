//
//  ROParamsView.h
//  secQre
//
//  Created by Sen5 on 16/11/1.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ROParamsView : UIView

//初始化
- (instancetype)initWithImage:(id )image  contents:(NSString *)contents;

- (instancetype )initWithContents:(NSString *)contents;

//更新显示内容
-(void )updateContents:(NSString *)contents;

@end
