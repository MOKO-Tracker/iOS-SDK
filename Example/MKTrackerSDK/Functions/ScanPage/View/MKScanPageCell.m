//
//  MKScanPageCell.m
//  MKContactTracker
//
//  Created by aa on 2020/4/22.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKScanPageCell.h"

#import "MKContactTrackerModel+MKScanAdd.h"

static CGFloat const offset_X = 15.f;
static CGFloat const rssiIconWidth = 22.f;
static CGFloat const rssiIconHeight = 11.f;
static CGFloat const connectButtonWidth = 80.f;
static CGFloat const connectButtonHeight = 30.f;
static CGFloat const batteryIconWidth = 25.f;
static CGFloat const batteryIconHeight = 25.f;

#pragma mark - cell顶部视图

@interface MKScanPageCellTopView : UIView

@property (nonatomic, strong)UIImageView *rssiIcon;

@property (nonatomic, strong)UILabel *rssiLabel;

@property (nonatomic, strong)UILabel *deviceNameLabel;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UIButton *connectButton;

@end

@implementation MKScanPageCellTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:COLOR_WHITE_MACROS];
        [self addSubview:self.rssiIcon];
        [self addSubview:self.rssiLabel];
        [self addSubview:self.deviceNameLabel];
        [self addSubview:self.macLabel];
        [self addSubview:self.connectButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.rssiIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(15.f);
        make.width.mas_equalTo(rssiIconWidth);
        make.height.mas_equalTo(rssiIconHeight);
    }];
    [self.rssiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rssiIcon.mas_centerX);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(self.rssiIcon.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.connectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(connectButtonWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(connectButtonHeight);
    }];
    CGFloat nameWidth = (kScreenWidth - 2 * offset_X - rssiIconWidth - 10.f - 8.f - connectButtonWidth);
    CGSize nameSize = [NSString sizeWithText:self.deviceNameLabel.text
                                     andFont:self.deviceNameLabel.font
                                  andMaxSize:CGSizeMake(nameWidth, MAXFLOAT)];
    [self.deviceNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiIcon.mas_right).mas_offset(15.f);
        make.centerY.mas_equalTo(self.rssiIcon.mas_centerY);
        make.right.mas_equalTo(self.connectButton.mas_left).mas_offset(-8.f);
        make.height.mas_equalTo(nameSize.height);
    }];
    [self.macLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deviceNameLabel.mas_left);
        make.right.mas_equalTo(self.connectButton.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.rssiLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - getter
- (UIImageView *)rssiIcon {
    if (!_rssiIcon) {
        _rssiIcon = [[UIImageView alloc] init];
        _rssiIcon.image = LOADIMAGE(@"signalIcon", @"png");
    }
    return _rssiIcon;
}

- (UILabel *)rssiLabel {
    if (!_rssiLabel) {
        _rssiLabel = [[UILabel alloc] init];
        _rssiLabel.textColor = DEFAULT_TEXT_COLOR;
        _rssiLabel.textAlignment = NSTextAlignmentCenter;
        _rssiLabel.font = MKFont(10.f);
    }
    return _rssiLabel;
}

- (UILabel *)deviceNameLabel {
    if (!_deviceNameLabel) {
        _deviceNameLabel = [[UILabel alloc] init];
        _deviceNameLabel.textAlignment = NSTextAlignmentLeft;
        _deviceNameLabel.font = MKFont(15.f);
        _deviceNameLabel.textColor = DEFAULT_TEXT_COLOR;
    }
    return _deviceNameLabel;
}

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [[UILabel alloc] init];
        _macLabel.textColor = DEFAULT_TEXT_COLOR;
        _macLabel.font = MKFont(12.f);
        _macLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _macLabel;
}

- (UIButton *)connectButton{
    if (!_connectButton) {
        _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_connectButton setBackgroundColor:UIColorFromRGB(0x2F84D0)];
        [_connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
        [_connectButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_connectButton.titleLabel setFont:MKFont(15.f)];
        [_connectButton.layer setMasksToBounds:YES];
        [_connectButton.layer setCornerRadius:10.f];
    }
    return _connectButton;
}

@end

#pragma mark - cell底部视图

@interface MKScanPageCellBottomView : UIView

@property (nonatomic, strong)UIImageView *batteryIcon;

@property (nonatomic, strong)UILabel *batteryLabel;

@property (nonatomic, strong)UILabel *txPowerLabel;

@property (nonatomic, strong)UILabel *trackLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UILabel *majorLabel;

@property (nonatomic, strong)UILabel *majorValueLabel;

@property (nonatomic, strong)UILabel *minorLabel;

@property (nonatomic, strong)UILabel *minorValueLabel;

@property (nonatomic, strong)UILabel *rssi1mLabel;

@property (nonatomic, strong)UILabel *rssi1mValueLabel;

@property (nonatomic, strong)UILabel *proximityLabel;

@property (nonatomic, strong)UILabel *proximityValueLabel;

@end

@implementation MKScanPageCellBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:COLOR_WHITE_MACROS];
        [self addSubview:self.batteryIcon];
        [self addSubview:self.batteryLabel];
        [self addSubview:self.txPowerLabel];
        [self addSubview:self.trackLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.majorLabel];
        [self addSubview:self.majorValueLabel];
        [self addSubview:self.minorLabel];
        [self addSubview:self.minorValueLabel];
        [self addSubview:self.rssi1mLabel];
        [self addSubview:self.rssi1mValueLabel];
        [self addSubview:self.proximityLabel];
        [self addSubview:self.proximityValueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.batteryIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.width.mas_equalTo(batteryIconWidth);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(batteryIconHeight);
    }];
    [self.batteryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.batteryIcon.mas_centerX);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(self.batteryIcon.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.txPowerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.batteryLabel.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.batteryIcon.mas_centerY).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.trackLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.txPowerLabel.mas_right).mas_offset(8.f);
        make.width.mas_equalTo(70.f);
        make.centerY.mas_equalTo(self.txPowerLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.trackLabel.mas_right).mas_offset(3.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.txPowerLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.majorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.txPowerLabel.mas_left);
        make.width.mas_equalTo(90.f);
        make.top.mas_equalTo(self.txPowerLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.majorValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.majorLabel.mas_right).mas_offset(3.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.majorLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
    [self.minorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.txPowerLabel.mas_left);
        make.width.mas_equalTo(90.f);
        make.top.mas_equalTo(self.majorLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.minorValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minorLabel.mas_right).mas_offset(3.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.minorLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
    [self.rssi1mLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.txPowerLabel.mas_left);
        make.width.mas_equalTo(90.f);
        make.top.mas_equalTo(self.minorLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.rssi1mValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssi1mLabel.mas_right).mas_offset(3.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.rssi1mLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
    [self.proximityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.txPowerLabel.mas_left);
        make.width.mas_equalTo(90.f);
        make.top.mas_equalTo(self.rssi1mLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.proximityValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.proximityLabel.mas_right).mas_offset(3.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.proximityLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
}

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)batteryIcon {
    if (!_batteryIcon) {
        _batteryIcon = [[UIImageView alloc] init];
        _batteryIcon.image = LOADIMAGE(@"batteryHighest", @"png");
    }
    return _batteryIcon;
}

- (UILabel *)batteryLabel {
    if (!_batteryLabel) {
        _batteryLabel = [self createLabelWithFont:MKFont(10.f)];
        _batteryLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _batteryLabel;
}

- (UILabel *)txPowerLabel {
    if (!_txPowerLabel) {
        _txPowerLabel = [self createLabelWithFont:MKFont(12.f)];
    }
    return _txPowerLabel;
}

- (UILabel *)trackLabel {
    if (!_trackLabel) {
        _trackLabel = [self createLabelWithFont:MKFont(12.f)];
    }
    return _trackLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [self createLabelWithFont:MKFont(12.f)];
    }
    return _timeLabel;
}

- (UILabel *)majorLabel {
    if (!_majorLabel) {
        _majorLabel = [self createLabelWithFont:MKFont(13.f)];
        _majorLabel.text = @"Major:";
    }
    return _majorLabel;
}

- (UILabel *)majorValueLabel {
    if (!_majorValueLabel) {
        _majorValueLabel = [self createLabelWithFont:MKFont(11.f)];
    }
    return _majorValueLabel;
}

- (UILabel *)minorLabel {
    if (!_minorLabel) {
        _minorLabel = [self createLabelWithFont:MKFont(13.f)];
        _minorLabel.text = @"Minor:";
    }
    return _minorLabel;
}

- (UILabel *)minorValueLabel {
    if (!_minorValueLabel) {
        _minorValueLabel = [self createLabelWithFont:MKFont(11.f)];
    }
    return _minorValueLabel;
}

- (UILabel *)rssi1mLabel {
    if (!_rssi1mLabel) {
        _rssi1mLabel = [self createLabelWithFont:MKFont(13.f)];
        _rssi1mLabel.text = @"RSSI@1m:";
    }
    return _rssi1mLabel;
}

- (UILabel *)rssi1mValueLabel {
    if (!_rssi1mValueLabel) {
        _rssi1mValueLabel = [self createLabelWithFont:MKFont(11.f)];
    }
    return _rssi1mValueLabel;
}

- (UILabel *)proximityLabel {
    if (!_proximityLabel) {
        _proximityLabel = [self createLabelWithFont:MKFont(13.f)];
        _proximityLabel.text = @"Proximity:";
    }
    return _proximityLabel;
}

- (UILabel *)proximityValueLabel {
    if (!_proximityValueLabel) {
        _proximityValueLabel = [self createLabelWithFont:MKFont(11.f)];
    }
    return _proximityValueLabel;
}

- (UILabel *)createLabelWithFont:(UIFont *)font {
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.textColor = DEFAULT_TEXT_COLOR;
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.font = font;
    return msgLabel;
}

@end


@interface MKScanPageCell ()

@property (nonatomic, strong)MKScanPageCellTopView *topView;

@property (nonatomic, strong)MKScanPageCellBottomView *bottomView;

@end

@implementation MKScanPageCell

+ (MKScanPageCell *)initCellWithTableView:(UITableView *)tableView {
    MKScanPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKScanPageCellIdenty"];
    if (!cell) {
        cell = [[MKScanPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKScanPageCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.topView];
        [self.contentView addSubview:self.bottomView];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40.f);
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(80.f);
    }];
}

#pragma mark - event method
- (void)connectButtonPressed {
    if ([self.delegate respondsToSelector:@selector(scanCellConnectButtonPressed:)]) {
        [self.delegate scanCellConnectButtonPressed:self.dataModel.index];
    }
}

#pragma mark - setter

- (void)setDataModel:(MKContactTrackerModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    //顶部
    self.topView.rssiLabel.text = [NSString stringWithFormat:@"%lddBm",(long)dataModel.rssi];
    self.topView.deviceNameLabel.text = (ValidStr(dataModel.deviceName) ? dataModel.deviceName : @"N/A");
    self.topView.macLabel.text = [@"MAC: " stringByAppendingString:(ValidStr(dataModel.macAddress) ? dataModel.macAddress : @"N/A")];
    self.topView.connectButton.hidden = !dataModel.connectable;
    //底部
    self.bottomView.batteryLabel.text = [NSString stringWithFormat:@"%ldmV",(long)dataModel.batteryVoltage];
    self.bottomView.txPowerLabel.text = [NSString stringWithFormat:@"%@ %lddBm",@"Tx Power:",(long)dataModel.txPower];
    self.bottomView.trackLabel.text = (dataModel.track ? @"Track: ON" : @"Track: OFF");
    self.bottomView.timeLabel.text = dataModel.scanTime;
    self.bottomView.majorValueLabel.text = [NSString stringWithFormat:@"%ld",(long)dataModel.major];
    self.bottomView.minorValueLabel.text = [NSString stringWithFormat:@"%ld",(long)dataModel.minor];
    self.bottomView.rssi1mValueLabel.text = [NSString stringWithFormat:@"%lddBm",(long)dataModel.rssi1m];
    self.bottomView.proximityValueLabel.text = dataModel.proximity;
}

#pragma mark - getter
- (MKScanPageCellTopView *)topView {
    if (!_topView) {
        _topView = [[MKScanPageCellTopView alloc] init];
        [_topView.connectButton addTapAction:self selector:@selector(connectButtonPressed)];
    }
    return _topView;
}

- (MKScanPageCellBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[MKScanPageCellBottomView alloc] init];
    }
    return _bottomView;
}

@end
