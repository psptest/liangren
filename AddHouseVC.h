//
//  AddHouseVC.h
//  security
//
//  Created by sen5labs on 15/9/30.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddHouseVCDelegate <NSObject>
-(void )AddHouseComplished;
@end
@interface AddHouseVC : UIViewController

@property(nonatomic,weak) id<AddHouseVCDelegate> delegate;
@end
