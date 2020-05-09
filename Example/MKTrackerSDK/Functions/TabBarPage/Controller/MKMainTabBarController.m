//
//  MKMainTabBarController.m
//  MKContactTracker
//
//  Created by aa on 2020/4/22.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKMainTabBarController.h"

#import "MKAdvertiserPageController.h"
#import "MKScannerPageController.h"
#import "MKSettingController.h"
#import "MKDeviceInfoController.h"

@interface MKMainTabBarController ()

/// 当触发01:修改密码成功,02:恢复出厂设置,03:两分钟之内没有通信,04:关机这几种类型的断开连接的时候，就不需要显示断开连接的弹窗了，只需要显示对应的弹窗
@property (nonatomic, assign)BOOL disconnectType;

@end

@implementation MKMainTabBarController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"MKMainTabBarController销毁");
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    if (![[self.navigationController viewControllers] containsObject:self]){
        [[MKContactTrackerCentralManager shared] disconnect];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubPages];
    [self statusMonitoring];
    [[MKContactTrackerCentralManager shared] notifyDisconnectType:YES];
}

#pragma mark - Notification event
- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    //00:连接一分钟之内没有输入密码,01:修改密码成功,02:恢复出厂设置,03:两分钟之内没有通信,04:关机
    self.disconnectType = YES;
    if ([type isEqualToString:@"01"]) {
        [self showAlertWithMsg:@"Password changed successfully! Please reconnect the device." title:@"Change Password"];
        return;
    }
    if ([type isEqualToString:@"02"]) {
        [self showAlertWithMsg:@"Factory reset successfully! Please reconnect the device." title:@"Factory Reset"];
        return;
    }
    if ([type isEqualToString:@"04"] || [type isEqualToString:@"03"]) {
        [self showAlertWithMsg:@"The Beacon is disconnected." title:@"Dismiss"];
        return;
    }
}

- (void)centralManagerStateChanged{
    if (self.disconnectType) {
        return;
    }
    if ([MKContactTrackerCentralManager shared].centralStatus != MKCentralManagerStateEnable) {
        [self showAlertWithMsg:@"The current system of bluetooth is not available!" title:@"Dismiss"];
    }
}

- (void)deviceConnectStateChanged {
    if (self.disconnectType) {
        return;
    }
    [self showAlertWithMsg:@"The Beacon is disconnected." title:@"Dismiss"];
    return;
}

- (void)gotoRootViewController{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKNeedResetRootControllerToScanPage" object:nil userInfo:nil];
}

#pragma mark - Private method

- (void)statusMonitoring{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoRootViewController)
                                                 name:@"MKCentralDeallocNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoRootViewController)
                                                 name:@"MKPopToRootViewControllerNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centralManagerStateChanged)
                                                 name:mk_centralManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:mk_deviceDisconnectTypeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectStateChanged)
                                                 name:mk_peripheralConnectStateChangedNotification
                                               object:nil];
}

/**
 当前手机蓝牙不可用、锁定状态改为不可用的时候，提示弹窗
 
 @param msg 弹窗显示的内容
 */
- (void)showAlertWithMsg:(NSString *)msg title:(NSString *)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf gotoRootViewController];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

/**
 eddStone设备的连接状态发生改变提示弹窗
 */
- (void)disconnectAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dismiss"
                                                                             message:@"The device is disconnected"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoRootViewController];
    }];
    [alertController addAction:exitAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UI

- (void)loadSubPages {
    MKAdvertiserPageController *advPage = [[MKAdvertiserPageController alloc] init];
    advPage.tabBarItem.title = @"ADVERTISER";
    advPage.tabBarItem.image = LOADIMAGE(@"advTabBarItemUnselected", @"png");
    advPage.tabBarItem.selectedImage = LOADIMAGE(@"advTabBarItemSelected", @"png");
    UINavigationController *advNav = [[UINavigationController alloc] initWithRootViewController:advPage];

    MKScannerPageController *scannerPage = [[MKScannerPageController alloc] init];
    scannerPage.tabBarItem.title = @"SCANNER";
    scannerPage.tabBarItem.image = LOADIMAGE(@"scannerTabBarItemUnselected", @"png");
    scannerPage.tabBarItem.selectedImage = LOADIMAGE(@"scannerTabBarItemSelected", @"png");
    UINavigationController *scannerNav = [[UINavigationController alloc] initWithRootViewController:scannerPage];

    MKSettingController *setting = [[MKSettingController alloc] init];
    setting.tabBarItem.title = @"SETTING";
    setting.tabBarItem.image = LOADIMAGE(@"settingTabBarItemUnselected", @"png");
    setting.tabBarItem.selectedImage = LOADIMAGE(@"settingTabBarItemSelected", @"png");
    UINavigationController *settingPage = [[UINavigationController alloc] initWithRootViewController:setting];
    
    MKDeviceInfoController *deviceInfo = [[MKDeviceInfoController alloc] init];
    deviceInfo.tabBarItem.title = @"DEVICE";
    deviceInfo.tabBarItem.image = LOADIMAGE(@"deviceTabBarItemUnselected", @"png");
    deviceInfo.tabBarItem.selectedImage = LOADIMAGE(@"deviceTabBarItemSelected", @"png");
    UINavigationController *deviceInfoPage = [[UINavigationController alloc] initWithRootViewController:deviceInfo];
    
    self.viewControllers = @[advNav,scannerNav,settingPage,deviceInfoPage];
}

@end
