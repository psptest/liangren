//
//  ROTabViewController.m
//  testlib
//  这个界面暂时丢弃
//  Created by Sen5 on 16/10/11.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import "ROTabViewController.h"
#import "prefrenceHeader.h"
#import "sceneViewController.h"
#import "RONavigationController.h"

@interface ROTabViewController ()

{
    NSMutableArray *_viewControllers;
}

@end

@implementation ROTabViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.tabBar.tintColor = kMainGreenColor;
        self.tabBar.translucent = NO;
        
        self.viewControllers = [self createViewControllers];
    }
    return self;
}

-(RONavigationController *)navigationControllerWithName:(NSString *)viecontrollerName title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage;
{
    UIViewController *cont = [[NSClassFromString(viecontrollerName) alloc]init];
    if ([cont isKindOfClass:NSClassFromString(@"sceneViewController")]) {
        sceneViewController *sce =(sceneViewController *)cont;
        sce.itemEachLine = 2;
    }
    
    RONavigationController *nav = [[RONavigationController alloc]initWithRootViewController:cont];
    nav.tabBarItem.title = title;
    
    
    UIImage *litImage = [UIImage imageNamed:normalImage];
    UIImage *litSelImage = [UIImage imageNamed:selectedImage];
    
    
    nav.tabBarItem.image = [litImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [litSelImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return nav;
}
#pragma mark - 视图控制器的创建
-(NSArray *)createViewControllers
{
    RONavigationController *dasNav = [self navigationControllerWithName:@"FavoriteDeviceController" title:    NSLocalizedString(@"Dashboard", nil) normalImage:@"tab_btn_Dashboard_nor" selectedImage:@"tab_btn_Dashboard_sel"];
    
    RONavigationController *myhNav = [self navigationControllerWithName:@"myHomeViewController" title:NSLocalizedString(@"myHome", nil)normalImage:@"tab_btn_myhome_nor" selectedImage:@"tab_btn_myhome_sel"];
    
    RONavigationController *sceNav = [self navigationControllerWithName:@"sceneViewController" title:NSLocalizedString(@"Scene", nil) normalImage:@"tab_btn_Scene_nor" selectedImage:@"tab_btn_Scene_sel"];
    
    RONavigationController *camNav = [self navigationControllerWithName:@"cameraViewController" title:NSLocalizedString(@"Camera", nil) normalImage:@"tab_btn_Camera_nor" selectedImage:@"tab_btn_Camera_sel"];
    
    RONavigationController *setNav = [self navigationControllerWithName:@"settingsViewController" title:NSLocalizedString(@"Settings", nil) normalImage:@"tab_btn_Setting_nor" selectedImage:@"tab_btn_Setting_sel"];
    
    NSArray *navArr =[[NSArray alloc]initWithObjects:dasNav,myhNav,sceNav,camNav,setNav ,nil];
    
    return navArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
