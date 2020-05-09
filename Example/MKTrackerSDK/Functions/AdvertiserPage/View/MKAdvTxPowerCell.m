//
//  MKAdvTxPowerCell.m
//  MKContactTracker
//
//  Created by aa on 2020/4/23.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKAdvTxPowerCell.h"
#import "MKSlider.h"

@interface MKAdvTxPowerCell ()

@property (nonatomic, strong)UILabel *rssiMsgLabel;

@property (nonatomic, strong)MKSlider *rssiSlider;

@property (nonatomic, strong)UILabel *rssiValueLabel;

@property (nonatomic, strong)UILabel *txPowerMsgLabel;

@property (nonatomic, strong)MKSlider *txPowerSlider;

@property (nonatomic, strong)UILabel *txPowerValueLabel;

@property (nonatomic, strong)UIView *lineView1;

@property (nonatomic, strong)UIView *lineView2;

@end

@implementation MKAdvTxPowerCell

+ (MKAdvTxPowerCell *)initCellWithTableView:(UITableView *)tableView {
    MKAdvTxPowerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKAdvTxPowerCellIdenty"];
    if (!cell) {
        cell = [[MKAdvTxPowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKAdvTxPowerCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.rssiMsgLabel];
        [self.contentView addSubview:self.rssiSlider];
        [self.contentView addSubview:self.rssiValueLabel];
        [self.contentView addSubview:self.txPowerMsgLabel];
        [self.contentView addSubview:self.txPowerSlider];
        [self.contentView addSubview:self.txPowerValueLabel];
        [self.contentView addSubview:self.lineView1];
        [self.contentView addSubview:self.lineView2];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.rssiMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(10.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.rssiSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.rssiValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.rssiMsgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.rssiValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.rssiSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.rssiSlider.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
    [self.txPowerMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(self.lineView1.mas_bottom).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.txPowerSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.txPowerValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.txPowerMsgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.txPowerValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.txPowerSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
}

#pragma mark - event method
- (void)rssiSliderValueChanged {
    NSString *value = [NSString stringWithFormat:@"%.fdBm",self.rssiSlider.value];
    if ([value isEqualToString:@"-0dBm"]) {
        value = @"0dBm";
    }
    self.rssiValueLabel.text = value;
    if ([self.delegate respondsToSelector:@selector(advertiserParamsChanged:indexPath:)]) {
        [self.delegate advertiserParamsChanged:@{
            @"measurePower":[NSString stringWithFormat:@"%.f",self.rssiSlider.value],
            @"txPower":[self getTxPowerUnitWithValue:self.txPowerSlider.value],
        } indexPath:self.indexPath];
    }
}

- (void)txPowerSliderValueChanged {
    self.txPowerValueLabel.text = [self getTxPowerUnitWithValue:self.txPowerSlider.value];
    if ([self.delegate respondsToSelector:@selector(advertiserParamsChanged:indexPath:)]) {
        [self.delegate advertiserParamsChanged:@{
            @"measurePower":[NSString stringWithFormat:@"%.f",self.rssiSlider.value],
            @"txPower":[self getTxPowerUnitWithValue:self.txPowerSlider.value],
        } indexPath:self.indexPath];
    }
}

#pragma mark - setter
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = nil;
    _dataDic = dataDic;
    if (!_dataDic) {
        return;
    }
    self.rssiSlider.value = [dataDic[@"measurePower"] floatValue];
    self.txPowerSlider.value = [self getTxPowerSliderValue:dataDic[@"txPower"]];
    [self rssiSliderValueChanged];
    [self txPowerSliderValueChanged];
}

#pragma mark - private method
- (NSString *)getTxPowerUnitWithValue:(float)value{
    if (value >=0 && value < 1) {
        return @"-40dBm";
    }else if (value >= 1 && value < 2){
        return @"-20dBm";
    }else if (value >= 2 && value < 3){
        return @"-16dBm";
    }else if (value >= 3 && value < 4){
        return @"-12dBm";
    }else if (value >= 4 && value < 5){
        return @"-8dBm";
    }else if (value >= 5 && value < 6){
        return @"-4dBm";
    }else if (value >= 6 && value < 7){
        return @"0dBm";
    }else if (value >= 7 && value < 8) {
        return @"3dBm";
    }else {
        return @"4dBm";
    }
}

- (float)getTxPowerSliderValue:(NSString *)txPower{
    if (!ValidStr(txPower)) {
        return 0.f;
    }
    if ([txPower isEqualToString:@"-40dBm"]) {
        return 0;
    }else if ([txPower isEqualToString:@"-20dBm"]){
        return 1;
    }else if ([txPower isEqualToString:@"-16dBm"]){
        return 2;
    }else if ([txPower isEqualToString:@"-12dBm"]){
        return 3;
    }else if ([txPower isEqualToString:@"-8dBm"]){
        return 4;
    }else if ([txPower isEqualToString:@"-4dBm"]){
        return 5;
    }else if ([txPower isEqualToString:@"0dBm"]){
        return 6;
    }else if ([txPower isEqualToString:@"3dBm"]){
        return 7;
    }else if ([txPower isEqualToString:@"4dBm"]){
        return 8;
    }
    return 0.f;
}

#pragma mark - getter
- (UILabel *)rssiMsgLabel {
    if (!_rssiMsgLabel) {
        _rssiMsgLabel = [[UILabel alloc] init];
        _rssiMsgLabel.textAlignment = NSTextAlignmentLeft;
        _rssiMsgLabel.attributedText = [MKAttributedString getAttributedString:@[@"RSSI@1m",@"   (-127dBm ~ 0dBm)"] fonts:@[MKFont(15.f),MKFont(13.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _rssiMsgLabel;
}

- (MKSlider *)rssiSlider {
    if (!_rssiSlider) {
        _rssiSlider = [[MKSlider alloc] init];
        _rssiSlider.maximumValue = 0;
        _rssiSlider.minimumValue = -127;
        _rssiSlider.value = -40;
        [_rssiSlider addTarget:self
                        action:@selector(rssiSliderValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _rssiSlider;
}

- (UILabel *)rssiValueLabel {
    if (!_rssiValueLabel) {
        _rssiValueLabel = [[UILabel alloc] init];
        _rssiValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _rssiValueLabel.textAlignment = NSTextAlignmentLeft;
        _rssiValueLabel.font = MKFont(11.f);
        _rssiValueLabel.text = @"-40dBm";
    }
    return _rssiValueLabel;
}

- (UILabel *)txPowerMsgLabel {
    if (!_txPowerMsgLabel) {
        _txPowerMsgLabel = [[UILabel alloc] init];
        _txPowerMsgLabel.textAlignment = NSTextAlignmentLeft;
        _txPowerMsgLabel.attributedText = [MKAttributedString getAttributedString:@[@"Tx Power",@"   (-40,-20,-16,-12,-8,-4,0,+3,+4)"] fonts:@[MKFont(15.f),MKFont(13.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _txPowerMsgLabel;
}

- (MKSlider *)txPowerSlider {
    if (!_txPowerSlider) {
        _txPowerSlider = [[MKSlider alloc] init];
        _txPowerSlider.maximumValue = 9.f;
        _txPowerSlider.minimumValue = 0.f;
        _txPowerSlider.value = 0.f;
        [_txPowerSlider addTarget:self
                           action:@selector(txPowerSliderValueChanged)
                 forControlEvents:UIControlEventValueChanged];
    }
    return _txPowerSlider;
}

- (UILabel *)txPowerValueLabel {
    if (!_txPowerValueLabel) {
        _txPowerValueLabel = [[UILabel alloc] init];
        _txPowerValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _txPowerValueLabel.textAlignment = NSTextAlignmentLeft;
        _txPowerValueLabel.font = MKFont(11.f);
        _txPowerValueLabel.text = @"-12dBm";
    }
    return _txPowerValueLabel;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _lineView1;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _lineView2;
}

@end
