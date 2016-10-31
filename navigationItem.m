//
//  navigationItem.m
//  security2.0
//
//  Created by Sen5 on 16/3/28.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "navigationItem.h"

@implementation navigationItem

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
       // NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor colorWithRed:11/255.0f green:29/255.0f blue:36/255.0f alpha:1.0]};
        
       // self.titleLabel.attributedText = [[NSAttributedString alloc]initWithString:title attributes:attDic];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:11/255.0f green:29/255.0f blue:36/255.0f alpha:1.0] forState:UIControlStateNormal];
    }
    return self;
}

@end
