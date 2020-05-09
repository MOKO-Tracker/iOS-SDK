//
//  MKFilterAdvSwitchCell.m
//  MKContactTracker
//
//  Created by aa on 2020/4/24.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKFilterAdvSwitchCell.h"

static NSString *const noteMsg = @"*Turn off this option, the Beacon will store all types of BLE ADV data.Turn on this option, the Beacon will store the corresponding ADV data according to the filtering rules.";

@interface MKFilterAdvSwitchCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *noteLabel;

@property (nonatomic, strong)UISwitch *switchView;

@end

@implementation MKFilterAdvSwitchCell

+ (MKFilterAdvSwitchCell *)initCellWithTableView:(UITableView *)tableView {
    MKFilterAdvSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKFilterAdvSwitchCellIdenty"];
    if (!cell) {
        cell = [[MKFilterAdvSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKFilterAdvSwitchCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.switchView];
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(150.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.width.mas_equalTo(45.f);
        make.height.mas_equalTo(30.f);
    }];
    CGSize size = [NSString sizeWithText:noteMsg
                                 andFont:MKFont(12.f)
                              andMaxSize:CGSizeMake(kScreenWidth - 2 * 15.f, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(-5.f);
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark - event method
- (void)switchViewValueChanged {
    if ([self.delegate respondsToSelector:@selector(filterAdvSwitchStatusChanged:)]) {
        [self.delegate filterAdvSwitchStatusChanged:self.switchView.isOn];
    }
}

#pragma mark - setter
- (void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    [self.switchView setOn:isOn];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"ADV Data Filter";
    }
    return _msgLabel;
}

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self
                        action:@selector(switchViewValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.textColor = RGBCOLOR(193, 88, 38);
        _noteLabel.text = noteMsg;
        _noteLabel.numberOfLines = 0;
        _noteLabel.font = MKFont(12.f);
    }
    return _noteLabel;
}

@end
