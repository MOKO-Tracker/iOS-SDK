//
//  MKAdvertiserPageController.m
//  MKContactTracker
//
//  Created by aa on 2020/4/22.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKAdvertiserPageController.h"

#import "MKAdvertiserCellProtocol.h"
#import "MKAdvertiserNormalCell.h"
#import "MKAdvIntervalCell.h"
#import "MKAdvTxPowerCell.h"
#import "MKAdvTriggerCell.h"

#import "MKAdvertiserDataModel.h"
#import "MKAdvertiserNormalCellModel.h"

@interface MKAdvertiserPageController ()<UITableViewDelegate, UITableViewDataSource, MKAdvertiserCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKAdvertiserDataModel *dataModel;

@end

@implementation MKAdvertiserPageController

- (void)dealloc {
    NSLog(@"MKAdvertiserPageController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    [self readDataFromDevice];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSection0Datas];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKPopToRootViewControllerNotification" object:nil];
}

- (void)rightButtonMethod {
    if (![self validConfigParams]) {
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    MKAdvertiserDataModel *model = [[MKAdvertiserDataModel alloc] init];
    [model updateValueWithModel:self.dataModel];
    WS(weakSelf);
    [self.dataModel startConfigDatas:model sucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 60.f;
    }
    if (indexPath.section == 2) {
        return 120.f;
    }
    return 130.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataList.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self loadCellWithIndexPath:indexPath];
}

#pragma mark - MKAdvertiserCellDelegate
- (void)advertiserParamsChanged:(id)newValue indexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //
        if (indexPath.row == 0) {
            //deviceName
            self.dataModel.deviceName = (NSString *)newValue;
            MKAdvertiserNormalCellModel *advNameModel = self.dataList[0];
            advNameModel.textFieldValue = SafeStr(self.dataModel.deviceName);
            return;
        }
        if (indexPath.row == 1) {
            //uuid
            self.dataModel.proximityUUID = (NSString *)newValue;
            MKAdvertiserNormalCellModel *uuidModel = self.dataList[1];
            uuidModel.textFieldValue = self.dataModel.proximityUUID;
            return;
        }
        if (indexPath.row == 2) {
            //major
            self.dataModel.major = (NSString *)newValue;
            MKAdvertiserNormalCellModel *majorModel = self.dataList[2];
            majorModel.textFieldValue = self.dataModel.major;
            return;
        }
        if (indexPath.row == 3) {
            //minor
            self.dataModel.minor = (NSString *)newValue;
            MKAdvertiserNormalCellModel *minorModel = self.dataList[3];
            minorModel.textFieldValue = self.dataModel.minor;
            return;
        }
        return;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //interval
            self.dataModel.interval = (NSString *)newValue;
            return;
        }
        
        return;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //txPower
            NSDictionary *txPowerDic = (NSDictionary *)newValue;
            self.dataModel.measurePower = txPowerDic[@"measurePower"];
            self.dataModel.txPower = txPowerDic[@"txPower"];
            return;
        }
        return;
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            //trigger conditions
            self.dataModel.advTriggerConditions = (NSDictionary *)newValue;
            return;
        }
        return;
    }
}

#pragma mark - 读取数据
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel startReadDatasWithSucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf reloadTableDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)reloadTableDatas {
    MKAdvertiserNormalCellModel *advNameModel = self.dataList[0];
    advNameModel.textFieldValue = SafeStr(self.dataModel.deviceName);
    MKAdvertiserNormalCellModel *uuidModel = self.dataList[1];
    uuidModel.textFieldValue = self.dataModel.proximityUUID;
    MKAdvertiserNormalCellModel *majorModel = self.dataList[2];
    majorModel.textFieldValue = self.dataModel.major;
    MKAdvertiserNormalCellModel *minorModel = self.dataList[3];
    minorModel.textFieldValue = self.dataModel.minor;
            
    [self.tableView reloadData];
}

#pragma mark - config
- (BOOL)validConfigParams {
    if (!ValidStr(self.dataModel.deviceName) || self.dataModel.deviceName.length > 10) {
        [self showParamsErrorAlert];
        return NO;
    }
    if (![MKTrackerAdopter isUUIDString:self.dataModel.proximityUUID]) {
        [self showParamsErrorAlert];
        return NO;
    }
    if (!ValidStr(self.dataModel.major) || [self.dataModel.major integerValue] < 0 || [self.dataModel.major integerValue] > 65535) {
        [self showParamsErrorAlert];
        return NO;
    }
    if (!ValidStr(self.dataModel.minor) || [self.dataModel.minor integerValue] < 0 || [self.dataModel.minor integerValue] > 65535) {
        [self showParamsErrorAlert];
        return NO;
    }
    if (!ValidStr(self.dataModel.interval) || [self.dataModel.interval integerValue] < 1 || [self.dataModel.interval integerValue] > 100) {
        [self showParamsErrorAlert];
        return NO;
    }
    NSDictionary *conditions = self.dataModel.advTriggerConditions;
    if ([conditions[@"isOn"] boolValue] && (!ValidStr(conditions[@"time"]) || [conditions[@"time"] integerValue] < 1 || [conditions[@"time"] integerValue] > 65535)) {
        [self showParamsErrorAlert];
        return NO;
    }
    
    return YES;
}

- (void)showParamsErrorAlert {
    NSString *msg = @"Opps! Save failed. Please check the input characters and try again.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:moreAction];
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -

- (UITableViewCell *)loadCellWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKAdvertiserNormalCell *cell = [MKAdvertiserNormalCell initCellWithTableView:self.tableView];
        cell.dataModel = self.dataList[indexPath.row];
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKAdvIntervalCell *cell = [MKAdvIntervalCell initCellWithTableView:self.tableView];
        cell.interval = self.dataModel.interval;
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKAdvTxPowerCell *cell = [MKAdvTxPowerCell initCellWithTableView:self.tableView];
        cell.dataDic = @{
            @"measurePower":SafeStr(self.dataModel.measurePower),
                @"txPower":SafeStr(self.dataModel.txPower),
        };
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }
    MKAdvTriggerCell *cell = [MKAdvTriggerCell initCellWithTableView:self.tableView];
    cell.conditions = self.dataModel.advTriggerConditions;
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (void)loadSection0Datas {
    MKAdvertiserNormalCellModel *advNameModel = [[MKAdvertiserNormalCellModel alloc] init];
    advNameModel.msg = @"ADV Name";
    advNameModel.textPlaceholder = @"1~10 Characters";
    advNameModel.maxLength = 10;
    advNameModel.textFieldType = normalInput;
    [self.dataList addObject:advNameModel];
    
    MKAdvertiserNormalCellModel *uuidModel = [[MKAdvertiserNormalCellModel alloc] init];
    uuidModel.msg = @"Proximity UUID";
    uuidModel.textPlaceholder = @"16 Bytes";
    uuidModel.textFieldType = uuidMode;
    uuidModel.maxLength = 36;
    [self.dataList addObject:uuidModel];
    
    MKAdvertiserNormalCellModel *majorModel = [[MKAdvertiserNormalCellModel alloc] init];
    majorModel.msg = @"Major";
    majorModel.textPlaceholder = @"0~65535";
    majorModel.maxLength = 5;
    majorModel.textFieldType = realNumberOnly;
    [self.dataList addObject:majorModel];
    
    MKAdvertiserNormalCellModel *minorModel = [[MKAdvertiserNormalCellModel alloc] init];
    minorModel.msg = @"Minor";
    minorModel.textPlaceholder = @"0~65535";
    minorModel.maxLength = 5;
    minorModel.textFieldType = realNumberOnly;
    [self.dataList addObject:minorModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.custom_naviBarColor = UIColorFromRGB(0x2F84D0);
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.defaultTitle = @"ADVERTISER";
    self.view.backgroundColor = COLOR_WHITE_MACROS;
    [self.rightButton setImage:LOADIMAGE(@"slotSaveIcon", @"png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 49.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKAdvertiserDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKAdvertiserDataModel alloc] init];
    }
    return _dataModel;
}

@end
