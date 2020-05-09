//
//  MKFliterOptionsController.m
//  MKContactTracker
//
//  Created by aa on 2020/4/24.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKFliterOptionsController.h"

#import "MKAdvDataFliterCell.h"
#import "MKFliterRssiValueCell.h"
#import "MKFilterAdvSwitchCell.h"

#import "MKAdvDataFliterCellModel.h"
#import "MKFilterOptionsModel.h"

static NSInteger const statusOnHeight = 85.f;
static NSInteger const statusOffHeight = 44.f;

@interface MKFliterOptionsController ()<UITableViewDelegate, UITableViewDataSource, MKAdvDataFliterCellDelegate, MKFilterAdvSwitchCellDelegate, MKFliterRssiValueCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKFilterOptionsModel *optionsModel;

@end

@implementation MKFliterOptionsController

- (void)dealloc {
    NSLog(@"MKFliterOptionsController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self startReadDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.optionsModel startConfigDataWithSucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self loadCellHeightWithIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    return (self.optionsModel.advDataFilterIson ? self.dataList.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self loadCellWithIndexPath:indexPath];
}

#pragma mark - MKFilterAdvSwitchCellDelegate
- (void)filterAdvSwitchStatusChanged:(BOOL)isOn {
    self.optionsModel.advDataFilterIson = isOn;
    [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - MKAdvDataFliterCellDelegate
- (void)advDataFliterCellSwitchStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //mac address
        self.optionsModel.macIson = isOn;
    }else if (index == 1) {
        //adv name
        self.optionsModel.advNameIson = isOn;
    }else if (index == 2) {
        //uuid
        self.optionsModel.uuidIson = isOn;
    }else if (index == 3) {
        //major
        self.optionsModel.majorIson = isOn;
    }else if (index == 4) {
        //minor
        self.optionsModel.minorIson = isOn;
    }else if (index == 5) {
        //raw adv data
        self.optionsModel.rawDataIson = isOn;
    }
    MKAdvDataFliterCellModel *dataModel = self.dataList[index];
    dataModel.isOn = isOn;
    [self.tableView reloadRow:index inSection:2 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)advertiserFilterContent:(NSString *)newValue index:(NSInteger)index {
    if (index == 0) {
        //mac address
        self.optionsModel.macValue = newValue;
    }else if (index == 1) {
        //adv name
        self.optionsModel.advNameValue = newValue;
    }else if (index == 2) {
        //uuid
        self.optionsModel.uuidValue = newValue;
    }else if (index == 3) {
        //major
        self.optionsModel.majorValue = newValue;
    }else if (index == 4) {
        //minor
        self.optionsModel.minorValue = newValue;
    }else if (index == 5) {
        //raw adv data
        self.optionsModel.rawDataValue = newValue;
    }
    MKAdvDataFliterCellModel *dataModel = self.dataList[index];
    dataModel.textFieldValue = newValue;
}

#pragma mark - MKFliterRssiValueCellDelegate
- (void)mk_fliterRssiValueChanged:(NSInteger)rssi {
    self.optionsModel.rssiValue = rssi;
}

#pragma mark - private method
- (CGFloat)loadCellHeightWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80.f;
    }
    if (indexPath.section == 1) {
        return 90.f;
    }
    if (!self.optionsModel.advDataFilterIson) {
        return 44.f;
    }
    if (indexPath.row == 0) {
        return (self.optionsModel.macIson ? statusOnHeight : statusOffHeight);
    }
    if (indexPath.row == 1) {
        return (self.optionsModel.advNameIson ? statusOnHeight : statusOffHeight);
    }
    if (indexPath.row == 2) {
        return (self.optionsModel.uuidIson ? statusOnHeight : statusOffHeight);
    }
    if (indexPath.row == 3) {
        return (self.optionsModel.majorIson ? statusOnHeight : statusOffHeight);
    }
    if (indexPath.row == 4) {
        return (self.optionsModel.minorIson ? statusOnHeight : statusOffHeight);
    }
    return (self.optionsModel.rawDataIson ? statusOnHeight : statusOffHeight);
}

- (UITableViewCell *)loadCellWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKFliterRssiValueCell *cell = [MKFliterRssiValueCell initCellWithTableView:self.tableView];
        cell.delegate = self;
        cell.rssi = self.optionsModel.rssiValue;
        return cell;
    }
    if (indexPath.section == 1) {
        MKFilterAdvSwitchCell *cell = [MKFilterAdvSwitchCell initCellWithTableView:self.tableView];
        cell.delegate = self;
        cell.isOn = self.optionsModel.advDataFilterIson;
        return cell;
    }
    MKAdvDataFliterCell *cell = [MKAdvDataFliterCell initCellWithTableView:self.tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)startReadDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.optionsModel startReadDataWithSucBlock:^{
        [weakSelf loadFilterOptionDatas];
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)loadFilterOptionDatas {
    MKAdvDataFliterCellModel *macModel = [[MKAdvDataFliterCellModel alloc] init];
    macModel.msg = @"Filter by MAC Address";
    macModel.textPlaceholder = @"1 ~ 6 Bytes";
    macModel.textFieldType = hexCharOnly;
    macModel.maxLength = 12;
    macModel.index = 0;
    macModel.textFieldValue = self.optionsModel.macValue;
    macModel.isOn = self.optionsModel.macIson;
    [self.dataList addObject:macModel];
    
    MKAdvDataFliterCellModel *advNameModel = [[MKAdvDataFliterCellModel alloc] init];
    advNameModel.msg = @"Filter by ADV Name";
    advNameModel.textPlaceholder = @"1 ~ 10 Characters";
    advNameModel.textFieldType = normalInput;
    advNameModel.maxLength = 10;
    advNameModel.index = 1;
    advNameModel.textFieldValue = self.optionsModel.advNameValue;
    advNameModel.isOn = self.optionsModel.advNameIson;
    [self.dataList addObject:advNameModel];
    
    MKAdvDataFliterCellModel *uuidModel = [[MKAdvDataFliterCellModel alloc] init];
    uuidModel.msg = @"Filter by iBeacon Proximity UUID";
    uuidModel.textPlaceholder = @"16 Bytes";
    uuidModel.textFieldType = uuidMode;
    uuidModel.maxLength = 36;
    uuidModel.index = 2;
    uuidModel.textFieldValue = self.optionsModel.uuidValue;
    uuidModel.isOn = self.optionsModel.uuidIson;
    [self.dataList addObject:uuidModel];
    
    MKAdvDataFliterCellModel *majorModel = [[MKAdvDataFliterCellModel alloc] init];
    majorModel.msg = @"Filter by iBeacon Major";
    majorModel.textPlaceholder = @"0 ~ 65535";
    majorModel.textFieldType = realNumberOnly;
    majorModel.maxLength = 5;
    majorModel.index = 3;
    majorModel.textFieldValue = self.optionsModel.majorValue;
    majorModel.isOn = self.optionsModel.majorIson;
    [self.dataList addObject:majorModel];
    
    MKAdvDataFliterCellModel *minorModel = [[MKAdvDataFliterCellModel alloc] init];
    minorModel.msg = @"Filter by iBeacon Minor";
    minorModel.textPlaceholder = @"0 ~ 65535";
    minorModel.textFieldType = realNumberOnly;
    minorModel.maxLength = 5;
    minorModel.index = 4;
    minorModel.textFieldValue = self.optionsModel.minorValue;
    minorModel.isOn = self.optionsModel.minorIson;
    [self.dataList addObject:minorModel];
    
    MKAdvDataFliterCellModel *rawDataModel = [[MKAdvDataFliterCellModel alloc] init];
    rawDataModel.msg = @"Filter by Raw Adv Data";
    rawDataModel.textPlaceholder = @"1 ~ 31 Bytes";
    rawDataModel.textFieldType = hexCharOnly;
    rawDataModel.maxLength = 62;
    rawDataModel.index = 5;
    rawDataModel.textFieldValue = self.optionsModel.rawDataValue;
    rawDataModel.isOn = self.optionsModel.rawDataIson;
    [self.dataList addObject:rawDataModel];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.custom_naviBarColor = UIColorFromRGB(0x2F84D0);
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.defaultTitle = @"FILTER OPTIONS";
    self.view.backgroundColor = COLOR_WHITE_MACROS;
    [self.rightButton setImage:LOADIMAGE(@"slotSaveIcon", @"png") forState:UIControlStateNormal];
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

- (MKFilterOptionsModel *)optionsModel {
    if (!_optionsModel) {
        _optionsModel = [[MKFilterOptionsModel alloc] init];
    }
    return _optionsModel;
}

@end
