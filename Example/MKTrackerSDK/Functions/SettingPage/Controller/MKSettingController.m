//
//  MKSettingController.m
//  MKContactTracker
//
//  Created by aa on 2020/4/22.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKSettingController.h"

#import "MKContactTrackerTextCell.h"
#import "MKSwitchStatusCell.h"

#import "MKSwitchStatusCellModel.h"

#import "MKUpdateController.h"
#import "MKTriggerSensitivityView.h"
#import "MKScannWindowConfigView.h"

@interface MKSettingController ()<UITableViewDelegate, UITableViewDataSource, MKSwitchStatusCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, strong)UITextField *passwordField;

@property (nonatomic, strong)UITextField *passwordTextField;

@property (nonatomic, strong)UITextField *confirmTextField;

/// 对于04类型的设备，不支持ADV Trigger功能
@property (nonatomic, assign)BOOL supportAdvTrigger;

@end

@implementation MKSettingController

- (void)dealloc {
    NSLog(@"MKSettingController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *deviceType = [[NSUserDefaults standardUserDefaults] objectForKey:@"MKTrackerDeviceType"];
    self.supportAdvTrigger = [deviceType isEqualToString:@"05"];
    [self loadSubViews];
    [self loadTableDatas];
    [self startReadStatus];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKPopToRootViewControllerNotification" object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //
        if (indexPath.row == 0) {
            //设置密码
            [self setPassword];
            return;
        }
        if (indexPath.row == 1) {
            //恢复出厂设置
            [self factoryReset];
            return;
        }
        if (indexPath.row == 2) {
            //dfu
            MKUpdateController *vc = [[MKUpdateController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            return;
        }
        if (self.supportAdvTrigger && indexPath.row == 3) {
            //灵敏度
            [self triggerSensitivityMethod];
            return;
        }
        //设置Scan Window
        [self scanWindowMethod];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    return self.section1List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKContactTrackerTextCell *cell = [MKContactTrackerTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    MKSwitchStatusCell *cell = [MKSwitchStatusCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKSwitchStatusCellDelegate
- (void)needChangedCellSwitchStatus:(BOOL)isOn row:(NSInteger)row {
//    if (row == 0) {
//        //设备扫描状态
//        [self setScanStatusEnable:isOn];
//        return;
//    }
    if (row == 0) {
        //可连接状态
        [self setConnectEnable:isOn];
        return;
    }
    if (row == 1) {
        //按键开关
        [self setButtonPowerStatusEnable:isOn];
        return;
    }
    if (row == 2) {
        //关机
        [self powerOff];
        return;
    }
}

#pragma mark - interface
- (void)startReadStatus {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    dispatch_async(self.configQueue, ^{
//        NSDictionary *scanStatusDic = [self readScanStatus];
//        if (![scanStatusDic[@"success"] boolValue]) {
//            moko_dispatch_main_safe(^{
//                [[MKHudManager share] hide];
//                [self.view showCentralToast:@"Read scan status error!"];
//            });
//            return ;
//        }
        NSDictionary *connectDic = [self readConnectableStatus];
        if (![connectDic[@"success"] boolValue]) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Read connectable status error!"];
            });
            return ;
        }
        NSDictionary *buttonPower = [self readButtonPowerStatus];
        if (![buttonPower[@"success"] boolValue]) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Read button power status error!"];
            });
            return ;
        }
//        MKSwitchStatusCellModel *scannerModel = self.section1List[0];
//        scannerModel.isOn = [scanStatusDic[@"isOn"] boolValue];
        MKSwitchStatusCellModel *connectModel = self.section1List[0];
        connectModel.isOn = [connectDic[@"isOn"] boolValue];
        MKSwitchStatusCellModel *buttonPowerModel = self.section1List[1];
        buttonPowerModel.isOn = [buttonPower[@"isOn"] boolValue];
        moko_dispatch_main_safe(^{
            [[MKHudManager share] hide];
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        });
    });
}

- (NSDictionary *)readTriggerSensitivity {
    __block NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [MKTrackerInterface readMovementSensitivityWithSucBlock:^(id  _Nonnull returnData) {
        [resultDic setValue:@(YES) forKey:@"success"];
        [resultDic setValue:returnData[@"result"][@"sensitivity"] forKey:@"sensitivity"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        [resultDic setValue:@(NO) forKey:@"success"];
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return resultDic;
}

- (NSDictionary *)readScanStatus {
    __block NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [MKTrackerInterface readScanStatusWithSucBlock:^(id  _Nonnull returnData) {
        [resultDic setValue:@(YES) forKey:@"success"];
        [resultDic setValue:returnData[@"result"][@"isOn"] forKey:@"isOn"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        [resultDic setValue:@(NO) forKey:@"success"];
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return resultDic;
}

- (NSDictionary *)readConnectableStatus {
    __block NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [MKTrackerInterface readConnectableWithSucBlock:^(id  _Nonnull returnData) {
        [resultDic setValue:@(YES) forKey:@"success"];
        [resultDic setValue:returnData[@"result"][@"isOn"] forKey:@"isOn"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        [resultDic setValue:@(NO) forKey:@"success"];
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return resultDic;
}

- (NSDictionary *)readButtonPowerStatus {
    __block NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [MKTrackerInterface readButtonPowerWithSucBlock:^(id  _Nonnull returnData) {
        [resultDic setValue:@(YES) forKey:@"success"];
        [resultDic setValue:returnData[@"result"][@"isOn"] forKey:@"isOn"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        [resultDic setValue:@(NO) forKey:@"success"];
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return resultDic;
}

- (NSDictionary *)readScanWindow {
    __block NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [MKTrackerInterface readScanWindowDataWithSucBlock:^(id  _Nonnull returnData) {
        [resultDic setValue:@(YES) forKey:@"success"];
        [resultDic setValue:returnData[@"result"][@"value"] forKey:@"type"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        [resultDic setValue:@(NO) forKey:@"success"];
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return resultDic;
}

- (BOOL)configScanStatus:(BOOL)isOn {
    __block BOOL success = NO;
    [MKTrackerInterface configScanStatus:isOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configScanWindowType:(mk_scannWindowType)type {
    __block BOOL success = NO;
    [MKTrackerInterface configScannWindow:type sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - 设置扫描状态
/*
- (void)setScanStatusEnable:(BOOL)isOn{
    NSString *msg = (isOn ? @"If you turn on Beacon Scanner function, the Beacon will start scanning." : @"If you turn off Beacon Scanner function, the Beacon will stop scanning.");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MKSwitchStatusCellModel *model = weakSelf.section1List[0];
        model.isOn = !isOn;
        [weakSelf.tableView reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setScanStatusToDevice:isOn];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)setScanStatusToDevice:(BOOL)isOn{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [MKTrackerInterface configScanStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Success!"];
        MKSwitchStatusCellModel *model = weakSelf.section1List[0];
        model.isOn = isOn;
        [weakSelf.tableView reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKSwitchStatusCellModel *model = weakSelf.section1List[0];
        model.isOn = !isOn;
        [weakSelf.tableView reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}
 */

#pragma mark - 设置可连接状态
- (void)setConnectEnable:(BOOL)connect{
    NSString *msg = (connect ? @"Are you sure to make the device connectable?" : @"Are you sure to make the device Unconnectable?");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MKSwitchStatusCellModel *model = weakSelf.section1List[0];
        model.isOn = !connect;
        [weakSelf.tableView reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setConnectStatusToDevice:connect];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)setConnectStatusToDevice:(BOOL)connect{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [MKTrackerInterface configConnectableStatus:connect sucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKSwitchStatusCellModel *model = weakSelf.section1List[0];
        model.isOn = !connect;
        [weakSelf.tableView reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 设置按键开关状态
- (void)setButtonPowerStatusEnable:(BOOL)isOn{
    NSString *msg = (isOn ? @"If you turn on the Button Power function, you can turn off the beacon power with the button." : @"If you turn off the Button Power function, you cannot turn off the beacon power with the button.");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MKSwitchStatusCellModel *model = weakSelf.section1List[1];
        model.isOn = !isOn;
        [weakSelf.tableView reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setButtonPowerStatusToDevice:isOn];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)setButtonPowerStatusToDevice:(BOOL)isOn{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [MKTrackerInterface configButtonPowerStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKSwitchStatusCellModel *model = weakSelf.section1List[1];
        model.isOn = !isOn;
        [weakSelf.tableView reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 开关机
- (void)powerOff{
    NSString *msg = @"Are you sure to turn off the device? Please make sure the device has a button to turn on!";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MKSwitchStatusCellModel *model = weakSelf.section1List[2];
        model.isOn = NO;
        [weakSelf.tableView reloadRow:2 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf commandPowerOff];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)commandPowerOff{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [MKTrackerInterface powerOffDeviceWithSucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKSwitchStatusCellModel *model = weakSelf.section1List[2];
        model.isOn = YES;
        [weakSelf.tableView reloadRow:2 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 恢复出厂设置

- (void)factoryReset{
    NSString *msg = @"Please enter the password to reset the device.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Factory Reset"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        weakSelf.passwordField = nil;
        weakSelf.passwordField = textField;
        weakSelf.passwordField.placeholder = @"Enter the password.";
        [textField addTarget:self action:@selector(passwordInput) forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf sendResetCommandToDevice];
    }];
    [alertController addAction:moreAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)passwordInput {
    NSString *tempInputString = self.passwordField.text;
    if (!ValidStr(tempInputString)) {
        self.passwordField.text = @"";
        return;
    }
    self.passwordField.text = (tempInputString.length > 8 ? [tempInputString substringToIndex:8] : tempInputString);
}

- (void)sendResetCommandToDevice{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [MKTrackerInterface factoryDataResetWithPassword:self.passwordField.text sucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Factory reset successfully!Please reconnect the device"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 设置密码
- (void)setPassword{
    WS(weakSelf);
    NSString *msg = @"Note:The password should be 8 characters.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Change Password"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        weakSelf.passwordTextField = nil;
        weakSelf.passwordTextField = textField;
        [weakSelf.passwordTextField setPlaceholder:@"Enter new password"];
        [weakSelf.passwordTextField addTarget:self
                                       action:@selector(passwordTextFieldValueChanged:)
                             forControlEvents:UIControlEventEditingChanged];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        weakSelf.confirmTextField = nil;
        weakSelf.confirmTextField = textField;
        [weakSelf.confirmTextField setPlaceholder:@"Enter new password again"];
        [weakSelf.confirmTextField addTarget:self
                                      action:@selector(passwordTextFieldValueChanged:)
                            forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setPasswordToDevice];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)passwordTextFieldValueChanged:(UITextField *)textField{
    NSString *tempInputString = textField.text;
    if (!ValidStr(tempInputString)) {
        textField.text = @"";
        return;
    }
    textField.text = (tempInputString.length > 8 ? [tempInputString substringToIndex:8] : tempInputString);
}

- (void)setPasswordToDevice{
    NSString *password = self.passwordTextField.text;
    NSString *confirmpassword = self.confirmTextField.text;
    if (!ValidStr(password) || !ValidStr(confirmpassword) || password.length != 8 || confirmpassword.length != 8) {
        [self.view showCentralToast:@"The password should be 8 characters.Please try again."];
        return;
    }
    if (![password isEqualToString:confirmpassword]) {
        [self.view showCentralToast:@"Password do not match! Please try again."];
        return;
    }
    WS(weakSelf);
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKTrackerInterface configPassword:password sucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 设置灵敏度
- (void)triggerSensitivityMethod {
    [[MKHudManager share] showHUDWithTitle:@"Reading..."
                                    inView:self.view
                             isPenetration:NO];
    [MKTrackerInterface readMovementSensitivityWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        NSInteger triggerSen = [returnData[@"result"][@"sensitivity"] integerValue];
        [self showViewWithTriggerSensitivityValue:triggerSen];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)showViewWithTriggerSensitivityValue:(NSInteger)value {
    WS(weakSelf);
    MKTriggerSensitivityView *view = [[MKTriggerSensitivityView alloc] init];
    [view showViewWithValue:value completeBlock:^(NSInteger resultValue) {
        __strong typeof(self) sself = weakSelf;
        [sself configTriggerSensitivity:resultValue];
    }];
}

- (void)configTriggerSensitivity:(NSInteger)sensitivity {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKTrackerInterface configMovementSensitivity:sensitivity sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 设置scan window
- (void)scanWindowMethod {
    [[MKHudManager share] showHUDWithTitle:@"Reading..."
                                    inView:self.view
                             isPenetration:NO];
    dispatch_async(self.configQueue, ^{
        NSDictionary *scanStatusDic = [self readScanStatus];
        if (![scanStatusDic[@"success"] boolValue]) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Read scan status error!"];
            });
            return ;
        }
        BOOL isOn = [scanStatusDic[@"isOn"] boolValue];
        if (!isOn) {
            //关闭状态
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self showViewWithScanWindowValue:mk_scannWindowTypeClose];
            });
            return;
        }
        NSDictionary *scanWindowDic = [self readScanWindow];
        if (![scanWindowDic[@"success"] boolValue]) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Read scan window error!"];
            });
            return ;
        }
        moko_dispatch_main_safe(^{
            [[MKHudManager share] hide];
            [self showViewWithScanWindowValue:[scanWindowDic[@"type"] integerValue]];
        });
    });
    
}

- (void)showViewWithScanWindowValue:(mk_scannWindowType)value {
    WS(weakSelf);
    MKScannWindowConfigView *view = [[MKScannWindowConfigView alloc] init];
    [view showViewWithValue:value completeBlock:^(mk_scannWindowType resultType) {
        __strong typeof(self) sself = weakSelf;
        [sself configScanWindowStatus:resultType];
    }];
}

- (void)configScanWindowStatus:(mk_scannWindowType)scanType {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                    inView:self.view
                             isPenetration:NO];
    dispatch_async(self.configQueue, ^{
        BOOL isOn = (scanType != mk_scannWindowTypeClose);
        if (![self configScanStatus:isOn]) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Config scan stauts error"];
            });
            return ;
        }
        if (!isOn) {
            //关闭状态不需要再设置scan window
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Success"];
            });
            return;
        }
        if (![self configScanWindowType:scanType]) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Config scan window type error"];
            });
            return ;
        }
        moko_dispatch_main_safe(^{
            [[MKHudManager share] hide];
            [self.view showCentralToast:@"Success"];
        });
    });
}

#pragma mark -
- (void)loadTableDatas {
    MKContactTrackerTextCellModel *passwrodModel = [[MKContactTrackerTextCellModel alloc] init];
    passwrodModel.leftMsg = @"Change Password";
    passwrodModel.showRightIcon = YES;
    [self.section0List addObject:passwrodModel];
    
    MKContactTrackerTextCellModel *resetModel = [[MKContactTrackerTextCellModel alloc] init];
    resetModel.leftMsg = @"Factory Reset";
    resetModel.showRightIcon = YES;
    [self.section0List addObject:resetModel];
    
    MKContactTrackerTextCellModel *dufModel = [[MKContactTrackerTextCellModel alloc] init];
    dufModel.leftMsg = @"Update Firmware (DFU)";
    dufModel.showRightIcon = YES;
    [self.section0List addObject:dufModel];
    
    if (self.supportAdvTrigger) {
        MKContactTrackerTextCellModel *triggerModel = [[MKContactTrackerTextCellModel alloc] init];
        triggerModel.leftMsg = @"Trigger Sensitivity";
        triggerModel.showRightIcon = YES;
        [self.section0List addObject:triggerModel];
    }
    
    MKContactTrackerTextCellModel *scanWindowModel = [[MKContactTrackerTextCellModel alloc] init];
    scanWindowModel.leftMsg = @"Scan Window";
    scanWindowModel.showRightIcon = YES;
    [self.section0List addObject:scanWindowModel];
    
//    MKSwitchStatusCellModel *scannerModel = [[MKSwitchStatusCellModel alloc] init];
//    scannerModel.msg = @"Beacon Scanner";
//    scannerModel.index = 0;
//    [self.section1List addObject:scannerModel];
    
    MKSwitchStatusCellModel *connectModel = [[MKSwitchStatusCellModel alloc] init];
    connectModel.msg = @"Connectable";
    connectModel.index = 0;
    [self.section1List addObject:connectModel];
    
    MKSwitchStatusCellModel *buttonPowerModel = [[MKSwitchStatusCellModel alloc] init];
    buttonPowerModel.msg = @"Button Power";
    buttonPowerModel.index = 1;
    [self.section1List addObject:buttonPowerModel];
    
    MKSwitchStatusCellModel *powerOffModel = [[MKSwitchStatusCellModel alloc] init];
    powerOffModel.msg = @"Power Off";
    powerOffModel.index = 2;
    [self.section1List addObject:powerOffModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.custom_naviBarColor = UIColorFromRGB(0x2F84D0);
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.defaultTitle = @"SETTINGS";
    self.view.backgroundColor = COLOR_WHITE_MACROS;
    [self.rightButton setHidden:YES];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)configQueue {
    if (!_configQueue) {
        _configQueue = dispatch_queue_create("filterParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _configQueue;
}

@end
