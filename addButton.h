//
//  addButton.h
//  security2.0
//
//  Created by Sen5 on 16/4/5.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^buttonBlock)();
@interface addButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame clickBlock:(buttonBlock )clickBlock;

-(void)setImg:(UIImage *)img;
-(void)setHightImg:(UIImage *)img;
@end
