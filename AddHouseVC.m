////  AddHouseVC.m//  security////  Created by sen5labs on 15/9/30.//  Copyright © 2015年 sen5. All rights reserved.//#import "AddHouseVC.h"#import "UIViewController+MBProgressHUD.h"#import "QRCodeView.h"#import "NSString+Check.h"#import "HouseModelHandle.h"#import "UIView+MBProgressHUD.h"#import "Des3Handle.h"#import "prefrenceHeader.h"@interface AddHouseVC ()@property (nonatomic, strong) QRCodeView            * qrCodeView;          // 扫描动画@end@implementation AddHouseVC- (void)viewDidLoad {    [super viewDidLoad];    [self setupUI];    }- (void)setupUI {        [self addBackBtn:NSLocalizedString(@"Add_New_Home", nil])];      [self.view addSubview:self.qrCodeView];        [self.qrCodeView setRecommands:NSLocalizedString(@"Scan_QRCode", nil)];    __weak typeof(self) weakSelf = self;        [self.qrCodeView startReadingWithCompletBlock:^(id obj) {                //成功回调        [weakSelf.qrCodeView stopReading];        weakSelf.qrCodeView.hidden = YES;                // 扫描到了字符串        [weakSelf updateWithSuccess:[weakSelf checkQRString:obj]];        MYLog(@"the string is %@",obj);    }];    //  [self updateWithSuccess:[self checkQRString:@"JMfWglcvnHCW5T8ZB9mivvaR08dKj3HW"]];    }#pragma mark - 判断字符串- (BOOL)checkQRString:(NSString *)des3String {        // 字符串是3des 加密的  需要解密    NSString * textString = [Des3Handle TripleDES:des3String encryptOrDecrypt:kCCDecrypt];    if (textString.length > 6) {        // 解密出来的是一个 长度大于6的字符串  要去掉后六位 就是我们所需要的did        NSString * did = [textString substringToIndex:textString.length - 6];        if (did && ![did isEqualToString:@""]) {            //判断address是否存在 如果存在 显示hourse is exist            if ([[HouseModelHandle shareHouseHandle] isExistHouseWithAdress:did]) {                                //连接成功 显示Hub                [self showWithTime:hubAnimationTime title:NSLocalizedString(@"House_Existed", nil)];                return NO;                            } else {                                //如果没有 则添加                [[HouseModelHandle shareHouseHandle] addWithAddress:did];                return YES;            }        } else {                     [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Something_Wrong_QR", nil)];            return NO;        }    } else {               [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Something_Wrong_QR", nil)];    }        return NO;}//更新UI- (void)updateWithSuccess:(BOOL)success {     if (success){                [self showWithTime:hubAnimationTime title:NSLocalizedString(@"House_Added", nil)];                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hubAnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{                        //弹出控制器            [self.navigationController popViewControllerAnimated:YES];                        [_delegate AddHouseComplished];        });    } else {                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hubAnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{            //弹出控制器            [self.navigationController popViewControllerAnimated:YES];        });    }        }//显示名字编辑控制器- (void)showEditNameVC {    //为什么一定要用lastObject呢 这只是没有的情况下添加之后 才会去修改最后一个 如果是已经存在的 那就不是最后一个 同时也没有必要去修改名称#if 0    HouseModel *model = [[HouseModelHandle shareHouseHandle].houses lastObject];    RenameEditVC * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RenameEditVC"];    vc.preName = model.name;    vc.houseModel = model;    //    vc.compeleteHandle = ^(NSString * name) {    //        model.name = name;    //        [[HouseModelHandle shareHouseHandle] updateWithHouse:model];    //    };    [self.navigationController pushViewController:vc animated:YES];    //将当前试图控制器删除    NSMutableArray <UIViewController *>* arr = [self.navigationController.viewControllers mutableCopy];    [arr removeObject:self];    self.navigationController.viewControllers = arr;#endif    }- (QRCodeView *)qrCodeView {    if (!_qrCodeView) {        _qrCodeView = [[QRCodeView alloc] initWithFrame:self.view.bounds];    }    return _qrCodeView;}@end