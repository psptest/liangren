//
//  twiceWidthScroll.m
//  security2.0
//
//  Created by Sen5 on 16/3/30.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "twiceWidthScroll.h"
#import "prefrenceHeader.h"
@interface twiceWidthScroll ()<UIScrollViewDelegate>

@end
@implementation twiceWidthScroll

+(id)twiceWidthScrollViewWithFrame:(CGRect)frame times:(NSInteger)times
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:frame];
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(frame)*times, CGRectGetHeight(frame));
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = YES;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    return scrollView;
}


@end
