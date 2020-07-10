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
#import "MKFilterMajorMinorCell.h"

#import "MKFilterMajorMinorCellModel.h"
#import "MKAdvDataFliterCellModel.h"
#import "MKFilterOptionsModel.h"

static NSInteger const statusOnHeight = 85.f;
static NSInteger const statusOffHeight = 44.f;

@interface MKFliterOptionsController ()<UITableViewDelegate, UITableViewDataSource, MKAdvDataFliterCellDelegate, MKFilterAdvSwitchCellDelegate, MKFliterRssiValueCellDelegate, MKFilterMajorMinorCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    if (section == 2) {
        return (self.optionsModel.advDataFilterIson ? self.section2List.count : 0);
    }
    return (self.optionsModel.advDataFilterIson ? self.section3List.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self loadCellWithIndexPath:indexPath];
}

#pragma mark - MKFilterAdvSwitchCellDelegate
- (void)filterAdvSwitchStatusChanged:(BOOL)isOn {
    self.optionsModel.advDataFilterIson = isOn;
    [self.tableView reloadData];
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
        //raw adv data
        self.optionsModel.rawDataIson = isOn;
    }else if (index == 3) {
        //uuid
        self.optionsModel.uuidIson = isOn;
    }else if (index == 4) {
        //major
        self.optionsModel.majorIson = isOn;
    }else if (index == 5) {
        //minor
        self.optionsModel.minorIson = isOn;
    }
    if (index < 4) {
        MKAdvDataFliterCellModel *dataModel = self.section2List[index];
        dataModel.isOn = isOn;
        [self.tableView reloadRow:index inSection:2 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    MKAdvDataFliterCellModel *dataModel = self.section3List[index - 4];
    dataModel.isOn = isOn;
    [self.tableView reloadRow:(index - 4) inSection:3 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)advertiserFilterContent:(NSString *)newValue index:(NSInteger)index {
    if (index == 0) {
        //mac address
        self.optionsModel.macValue = newValue;
    }else if (index == 1) {
        //adv name
        self.optionsModel.advNameValue = newValue;
    }else if (index == 2) {
        //raw adv data
        self.optionsModel.rawDataValue = newValue;
    }else if (index == 3) {
        //uuid
        self.optionsModel.uuidValue = newValue;
    }else if (index == 4) {
        //major
        self.optionsModel.majorValue = newValue;
    }else if (index == 5) {
        //minor
        self.optionsModel.minorValue = newValue;
    }
    if (index < 4) {
        MKAdvDataFliterCellModel *dataModel = self.section2List[index];
        dataModel.textFieldValue = newValue;
    }else {
        MKAdvDataFliterCellModel *dataModel = self.section3List[index - 4];
        dataModel.textFieldValue = newValue;
    }
}

#pragma mark - MKFliterRssiValueCellDelegate
- (void)mk_fliterRssiValueChanged:(NSInteger)rssi {
    self.optionsModel.rssiValue = rssi;
}

#pragma mark - MKFilterMajorMinorCellDelegate
- (void)majorMinorFliterSwitchStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Major
        self.optionsModel.majorIson = isOn;
    }else if (index == 1) {
        //Minor
        self.optionsModel.minorIson = isOn;
    }
    MKFilterMajorMinorCellModel *dataModel = self.section3List[index];
    dataModel.isOn = isOn;
    [self.tableView reloadRow:index inSection:3 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)filterMaxValueContentChanged:(NSString *)newValue index:(NSInteger)index {
    if (index == 0) {
        self.optionsModel.majorMaxValue = newValue;
    }else if (index == 1) {
        self.optionsModel.minorMaxValue = newValue;
    }
    MKFilterMajorMinorCellModel * dataModel = self.section3List[index];
    dataModel.maxValue = newValue;
}

- (void)filterMinValueContentChanged:(NSString *)newValue index:(NSInteger)index {
    if (index == 0) {
        self.optionsModel.majorMinValue = newValue;
    }else if (index == 1) {
        self.optionsModel.minorMinValue = newValue;
    }
    MKFilterMajorMinorCellModel * dataModel = self.section3List[index];
    dataModel.minValue = newValue;
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
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return (self.optionsModel.macIson ? statusOnHeight : statusOffHeight);
        }
        if (indexPath.row == 1) {
            return (self.optionsModel.advNameIson ? statusOnHeight : statusOffHeight);
        }
        if (indexPath.row == 2) {
            return (self.optionsModel.rawDataIson ? statusOnHeight : statusOffHeight);
        }
        return (self.optionsModel.uuidIson ? statusOnHeight : statusOffHeight);
    }
    if (indexPath.row == 0) {
        return (self.optionsModel.majorIson ? statusOnHeight : statusOffHeight);
    }
    if (indexPath.row == 1) {
        return (self.optionsModel.minorIson ? statusOnHeight : statusOffHeight);
    }
    return 0.f;
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
    if (indexPath.section == 2) {
        MKAdvDataFliterCell *cell = [MKAdvDataFliterCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (![MKDeviceTypeManager shared].supportNewCommand) {
        MKAdvDataFliterCell *cell = [MKAdvDataFliterCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    //支持新协议的(V3.1.0以上)可以过滤Major和Minor的范围
    MKFilterMajorMinorCell *cell = [MKFilterMajorMinorCell initCellWithTableView:self.tableView];
    cell.dataModel = self.section3List[indexPath.row];
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
    [self.section2List addObject:macModel];
    
    MKAdvDataFliterCellModel *advNameModel = [[MKAdvDataFliterCellModel alloc] init];
    advNameModel.msg = @"Filter by ADV Name";
    advNameModel.textPlaceholder = @"1 ~ 10 Characters";
    advNameModel.textFieldType = normalInput;
    advNameModel.maxLength = 10;
    advNameModel.index = 1;
    advNameModel.textFieldValue = self.optionsModel.advNameValue;
    advNameModel.isOn = self.optionsModel.advNameIson;
    [self.section2List addObject:advNameModel];
    
    MKAdvDataFliterCellModel *rawDataModel = [[MKAdvDataFliterCellModel alloc] init];
    rawDataModel.msg = @"Filter by Raw Adv Data";
    rawDataModel.textPlaceholder = @"1 ~ 31 Bytes";
    rawDataModel.textFieldType = hexCharOnly;
    rawDataModel.maxLength = 62;
    rawDataModel.index = 2;
    rawDataModel.textFieldValue = self.optionsModel.rawDataValue;
    rawDataModel.isOn = self.optionsModel.rawDataIson;
    [self.section2List addObject:rawDataModel];
    
    MKAdvDataFliterCellModel *uuidModel = [[MKAdvDataFliterCellModel alloc] init];
    uuidModel.msg = @"Filter by iBeacon Proximity UUID";
    uuidModel.textPlaceholder = @"16 Bytes";
    uuidModel.textFieldType = uuidMode;
    uuidModel.maxLength = 36;
    uuidModel.index = 3;
    uuidModel.textFieldValue = self.optionsModel.uuidValue;
    uuidModel.isOn = self.optionsModel.uuidIson;
    [self.section2List addObject:uuidModel];
    
    if (![MKDeviceTypeManager shared].supportNewCommand) {
        MKAdvDataFliterCellModel *majorModel = [[MKAdvDataFliterCellModel alloc] init];
        majorModel.msg = @"Filter by iBeacon Major";
        majorModel.textPlaceholder = @"0 ~ 65535";
        majorModel.textFieldType = realNumberOnly;
        majorModel.maxLength = 5;
        majorModel.index = 4;
        majorModel.textFieldValue = self.optionsModel.majorValue;
        majorModel.isOn = self.optionsModel.majorIson;
        [self.section3List addObject:majorModel];
        
        MKAdvDataFliterCellModel *minorModel = [[MKAdvDataFliterCellModel alloc] init];
        minorModel.msg = @"Filter by iBeacon Minor";
        minorModel.textPlaceholder = @"0 ~ 65535";
        minorModel.textFieldType = realNumberOnly;
        minorModel.maxLength = 5;
        minorModel.index = 5;
        minorModel.textFieldValue = self.optionsModel.minorValue;
        minorModel.isOn = self.optionsModel.minorIson;
        [self.section3List addObject:minorModel];
    }else {
        MKFilterMajorMinorCellModel *majorModel = [[MKFilterMajorMinorCellModel alloc] init];
        majorModel.msg = @"Filter by iBeacon Major";
        majorModel.minValue = self.optionsModel.majorMinValue;
        majorModel.maxValue = self.optionsModel.majorMaxValue;
        majorModel.index = 0;
        majorModel.isOn = self.optionsModel.majorIson;
        [self.section3List addObject:majorModel];
        
        MKFilterMajorMinorCellModel *minorModel = [[MKFilterMajorMinorCellModel alloc] init];
        minorModel.msg = @"Filter by iBeacon Minor";
        minorModel.minValue = self.optionsModel.minorMinValue;
        minorModel.maxValue = self.optionsModel.minorMaxValue;
        minorModel.index = 1;
        minorModel.isOn = self.optionsModel.minorIson;
        [self.section3List addObject:minorModel];
    }
    
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

- (MKFilterOptionsModel *)optionsModel {
    if (!_optionsModel) {
        _optionsModel = [[MKFilterOptionsModel alloc] init];
    }
    return _optionsModel;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

@end
