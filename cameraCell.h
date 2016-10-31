//
//  cameraCell.h
//  security2.0
//
//  Created by Sen5 on 16/3/24.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayImageView.h"

@class cameraCell;
@protocol cameraCellDelegate <NSObject>

-(void )playBtnClick:(cameraCell *)cell;
-(void )fullBtnClick:(cameraCell *)cell;

@end
@class DeviceModel;

@interface cameraCell : UITableViewCell

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) int index;

@property (nonatomic,weak) id<cameraCellDelegate > delegate;


// 实例化
-(instancetype )initWithFrame:(CGRect)frame camera:(DeviceModel *)camera;

/**
 *  预设回调参数
 *
 *  @param url   弃用了
 *  @param index 表示第几个Camera
 *  @param block 点击回调
 */
- (void)preToPlayWith:(NSString *)url index:(NSInteger)index callBackBlock:(CallBackBlock)block;

/**
 *  全屏按钮回调
 *
 *  @param block 全屏按钮回调block
 */
- (void)setFullViewButtonClickCallBackBlock:(FullViewButtonClickCallBack)block;


- (void)pause;

- (void)startPlay;

- (void)stopAnimation;

@property(nonatomic,copy)NSString *cameraID;

-(void )createControlViews;
-(void)refreshUIWithModel:(DeviceModel *)mod;

@end
