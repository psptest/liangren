//
//  selectDeviceControlForSceneController.h
//  security2.0
//
//  Created by liuhuangshuzz on 7/5/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class sceneModel;
@protocol selectDeviceControlForSceneControllerDelegate <NSObject>
@optional
-(void)haveSeletedDevices:(NSArray *)devices isOpened:(BOOL)isOpened;
-(void)changedSceneModel:(sceneModel *)newModel;
@end
@interface selectDeviceControlForSceneController : UITableViewController

@property(nonatomic,weak)id<selectDeviceControlForSceneControllerDelegate>delegate;

-(id)initWithSceneModel:(sceneModel *)scene selectOpen:(BOOL)seletctOpen;
-(id)initWithOpendDevices:(NSArray *)opened closedModel:(NSArray *)closed selecctOpen:(BOOL )selectOpen;
@end
