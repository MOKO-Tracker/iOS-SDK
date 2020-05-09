//
//  MKDeviceInfoController.m
//  MKContactTracker
//
//  Created by aa on 2020/4/22.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKDeviceInfoController.h"

#import "MKDeviceInfoModel.h"

#import "MKContactTrackerTextCell.h"

@interface MKDeviceInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKDeviceInfoModel *infoModel;

@property (nonatomic, assign)BOOL onlyVoltage;

@end

@implementation MKDeviceInfoController

- (void)dealloc {
    NSLog(@"MKDeviceInfoController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startReadDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadTableDatas];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKPopToRootViewControllerNotification" object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MKContactTrackerTextCell *cell = [MKContactTrackerTextCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - 读取数据
- (void)startReadDatas {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.infoModel startLoadSystemInformation:self.onlyVoltage sucBlock:^{
        [[MKHudManager share] hide];
        if (!weakSelf.onlyVoltage) {
            weakSelf.onlyVoltage = YES;
        }
        [weakSelf loadDatasFromDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)loadDatasFromDevice {
    if (ValidStr(self.infoModel.batteryVoltage)) {
        MKContactTrackerTextCellModel *soc = self.dataList[0];
        soc.rightMsg = [self.infoModel.batteryVoltage stringByAppendingString:@"mV"];
    }
    if (ValidStr(self.infoModel.macAddress)) {
        MKContactTrackerTextCellModel *mac = self.dataList[1];
        mac.rightMsg = self.infoModel.macAddress;
    }
    if (ValidStr(self.infoModel.deviceModel)) {
        MKContactTrackerTextCellModel *produceModel = self.dataList[2];
        produceModel.rightMsg = self.infoModel.deviceModel;
    }
    if (ValidStr(self.infoModel.software)) {
        MKContactTrackerTextCellModel *softwareModel = self.dataList[3];
        softwareModel.rightMsg = self.infoModel.software;
    }
    if (ValidStr(self.infoModel.firmware)) {
        MKContactTrackerTextCellModel *firmwareModel = self.dataList[4];
        firmwareModel.rightMsg = self.infoModel.firmware;
    }
    if (ValidStr(self.infoModel.hardware)) {
        MKContactTrackerTextCellModel *hardware = self.dataList[5];
        hardware.rightMsg = self.infoModel.hardware;
    }
    if (ValidStr(self.infoModel.manuDate)) {
        MKContactTrackerTextCellModel *manuDateModel = self.dataList[6];
        manuDateModel.rightMsg = self.infoModel.manuDate;
    }
    if (ValidStr(self.infoModel.manu)) {
        MKContactTrackerTextCellModel *manuModel = self.dataList[7];
        manuModel.rightMsg = self.infoModel.manu;
    }
    [self.tableView reloadData];
}

#pragma mark -
- (void)loadTableDatas {
    MKContactTrackerTextCellModel *socModel = [[MKContactTrackerTextCellModel alloc] init];
    socModel.leftMsg = @"Battery Voltage";
    socModel.rightMsg = @"0mV";
    [self.dataList addObject:socModel];
    
    MKContactTrackerTextCellModel *macModel = [[MKContactTrackerTextCellModel alloc] init];
    macModel.leftMsg = @"Mac Address";
    macModel.rightMsg = @"CE:12:A4:32:1B:2E";
    [self.dataList addObject:macModel];
    
    MKContactTrackerTextCellModel *produceModel = [[MKContactTrackerTextCellModel alloc] init];
    produceModel.leftMsg = @"Product Model";
    produceModel.rightMsg = @"HHHH";
    [self.dataList addObject:produceModel];
    
    MKContactTrackerTextCellModel *softwareModel = [[MKContactTrackerTextCellModel alloc] init];
    softwareModel.leftMsg = @"Software Version";
    softwareModel.rightMsg = @"V1.0.0";
    [self.dataList addObject:softwareModel];
    
    MKContactTrackerTextCellModel *firmwareModel = [[MKContactTrackerTextCellModel alloc] init];
    firmwareModel.leftMsg = @"Firmware Version";
    firmwareModel.rightMsg = @"V1.0.0";
    [self.dataList addObject:firmwareModel];
    
    MKContactTrackerTextCellModel *hardwareModel = [[MKContactTrackerTextCellModel alloc] init];
    hardwareModel.leftMsg = @"Hardware Version";
    hardwareModel.rightMsg = @"V1.0.0";
    [self.dataList addObject:hardwareModel];
    
    MKContactTrackerTextCellModel *manuDateModel = [[MKContactTrackerTextCellModel alloc] init];
    manuDateModel.leftMsg = @"Manufacture Date";
    manuDateModel.rightMsg = @"1d2h3m15s";
    [self.dataList addObject:manuDateModel];
    
    MKContactTrackerTextCellModel *manuModel = [[MKContactTrackerTextCellModel alloc] init];
    manuModel.leftMsg = @"Manufacture";
    manuModel.rightMsg = @"LTD";
    [self.dataList addObject:manuModel];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.custom_naviBarColor = UIColorFromRGB(0x2F84D0);
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.defaultTitle = @"DEVICE";
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

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKDeviceInfoModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [[MKDeviceInfoModel alloc] init];
    }
    return _infoModel;
}

@end
