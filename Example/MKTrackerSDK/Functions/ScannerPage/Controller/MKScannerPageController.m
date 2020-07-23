//
//  MKScannerPageController.m
//  MKContactTracker
//
//  Created by aa on 2020/4/22.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKScannerPageController.h"

#import "MKContactTrackerTextCell.h"
#import "MKScannerSliderCell.h"
#import "MKTrackingNotifiCell.h"
#import "MKScannerTriggerCell.h"
#import "MKNumberOfVibCell.h"

#import "MKFliterOptionsController.h"
#import "MKTrackedDataController.h"

#import "MKScannerDataModel.h"
#import "MKScannerProtocol.h"

@interface MKScannerPageController ()<UITableViewDelegate, UITableViewDataSource, MKScannerDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)MKScannerDataModel *dataModel;

@property (nonatomic, strong)NSMutableArray *cellList;

@end

@implementation MKScannerPageController

- (void)dealloc {
    NSLog(@"MKScannerPageController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    [self readDatasFromDevice];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    MKScannerDataModel *model = [[MKScannerDataModel alloc] init];
    [model updateWithDataModel:self.dataModel];
    WS(weakSelf);
    [self.dataModel startConfigDatas:model sucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKPopToRootViewControllerNotification" object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 90.f;
    }
    if ([MKDeviceTypeManager shared].supportAdvTrigger) {
        NSInteger reloadRow = 3;
        if ([MKDeviceTypeManager shared].supportNewCommand && (self.dataModel.trackingNote == 2 || self.dataModel.trackingNote == 3)) {
            reloadRow = 4;
        }
        if (indexPath.row == reloadRow) {
            return ([self.dataModel.conditions[@"isOn"] boolValue] ? 120.f : 60.f);
        }
    }
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MKFliterOptionsController *vc = [[MKFliterOptionsController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        return;
    }
    if (indexPath.row == (self.cellList.count - 1)) {
        MKTrackedDataController *vc = [[MKTrackedDataController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        return;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellList[indexPath.row];
}

#pragma mark - MKScannerDelegate
- (void)advertiserParamsChanged:(id)newValue index:(NSInteger)index {
    if (index == 0) {
        //interval
        self.dataModel.interval = (NSString *)newValue;
        return;
    }
    if (index == 1) {
        //tracking note
        self.dataModel.trackingNote = [newValue integerValue];
        [self updateCellListDatas];
        return;
    }
    if (index == 2) {
        //conditions
        BOOL needReload = NO;
        if ([self.dataModel.conditions[@"isOn"] boolValue] != [newValue[@"isOn"] boolValue]) {
            //关闭状态不一样需要刷新cell的高度
            needReload = YES;
        }
        self.dataModel.conditions = (NSDictionary *)newValue;
        if (needReload) {
            NSInteger reloadRow = 3;
            if ([MKDeviceTypeManager shared].supportNewCommand && (self.dataModel.trackingNote == 2 || self.dataModel.trackingNote == 3)) {
                reloadRow = 4;
            }
            [self.tableView reloadRow:reloadRow inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }
        return;
    }
    if (index == 3) {
        //马达震动次数
        self.dataModel.vibNubmer = [newValue integerValue];
        return;
    }
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel startReadDatasWithSucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf updateCellListDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method

- (void)updateCellListDatas {
    [self.cellList removeAllObjects];
    
    MKContactTrackerTextCell *optionsCell = [MKContactTrackerTextCell initCellWithTableView:self.tableView];
    MKContactTrackerTextCellModel *optionsDataModel = [[MKContactTrackerTextCellModel alloc] init];
    optionsDataModel.leftMsg = @"Filter Options";
    optionsDataModel.showRightIcon = YES;
    optionsCell.dataModel = optionsDataModel;
    [self.cellList addObject:optionsCell];
    
    MKScannerSliderCell *sliderCell = [MKScannerSliderCell initCellWithTableView:self.tableView];
    sliderCell.interval = self.dataModel.interval;
    sliderCell.delegate = self;
    [self.cellList addObject:sliderCell];
    
    MKTrackingNotifiCell *noteCell = [MKTrackingNotifiCell initCellWithTableView:self.tableView];
    noteCell.trackingNote = self.dataModel.trackingNote;
    noteCell.delegate = self;
    [self.cellList addObject:noteCell];
    
    if ([MKDeviceTypeManager shared].supportNewCommand) {
        if (self.dataModel.trackingNote == 2 || self.dataModel.trackingNote == 3) {
            MKNumberOfVibCell *vibCell = [MKNumberOfVibCell initCellWithTableView:self.tableView];
            vibCell.number = self.dataModel.vibNubmer;
            vibCell.delegate = self;
            [self.cellList addObject:vibCell];
        }
    }
    
    if ([MKDeviceTypeManager shared].supportAdvTrigger) {
        MKScannerTriggerCell *scannerCell = [MKScannerTriggerCell initCellWithTableView:self.tableView];
        scannerCell.conditions = self.dataModel.conditions;
        scannerCell.delegate = self;
        [self.cellList addObject:scannerCell];
    }
    
    MKContactTrackerTextCell *trackerCell = [MKContactTrackerTextCell initCellWithTableView:self.tableView];
    MKContactTrackerTextCellModel *trackerDataModel = [[MKContactTrackerTextCellModel alloc] init];
    trackerDataModel.leftMsg = @"Tracked Data";
    trackerDataModel.showRightIcon = YES;
    trackerCell.dataModel = trackerDataModel;
    [self.cellList addObject:trackerCell];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.custom_naviBarColor = UIColorFromRGB(0x2F84D0);
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.defaultTitle = @"SCANNER";
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
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (MKScannerDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKScannerDataModel alloc] init];
    }
    return _dataModel;
}

- (NSMutableArray *)cellList {
    if (!_cellList) {
        _cellList = [NSMutableArray array];
    }
    return _cellList;
}

@end
