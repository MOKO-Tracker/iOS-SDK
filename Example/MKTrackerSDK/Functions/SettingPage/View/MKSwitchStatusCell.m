//
//  MKSwitchStatusCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/24.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSwitchStatusCell.h"
#import "MKSwitchStatusCellModel.h"

static NSString *const MKSwitchStatusCellIdenty = @"MKSwitchStatusCellIdenty";

@interface MKSwitchStatusCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UISwitch *switchView;

@end

@implementation MKSwitchStatusCell

+ (MKSwitchStatusCell *)initCellWithTableView:(UITableView *)tableView{
    MKSwitchStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:MKSwitchStatusCellIdenty];
    if (!cell) {
        cell = [[MKSwitchStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MKSwitchStatusCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.switchView];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-1.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - Private method
- (void)switchViewValueChanged{
    if ([self.delegate respondsToSelector:@selector(needChangedCellSwitchStatus:row:)]) {
        [self.delegate needChangedCellSwitchStatus:self.switchView.isOn row:self.dataModel.index];
    }
}

#pragma mark - Public method
- (void)setDataModel:(MKSwitchStatusCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    [self.switchView setOn:_dataModel.isOn];
}

#pragma mark - setter & getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (UISwitch *)switchView{
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        _switchView.backgroundColor = COLOR_WHITE_MACROS;
        [_switchView addTarget:self
                        action:@selector(switchViewValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

@end
