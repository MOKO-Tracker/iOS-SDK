//
//  MKContactTrackerTextCell.m
//  MKContactTracker
//
//  Created by aa on 2020/4/23.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKContactTrackerTextCell.h"

@implementation MKContactTrackerTextCellModel

@end

@interface MKContactTrackerTextCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *detailMsgLabel;

@property (nonatomic, strong)UIImageView *rightIcon;

@end

@implementation MKContactTrackerTextCell

+ (MKContactTrackerTextCell *)initCellWithTableView:(UITableView *)tableView {
    MKContactTrackerTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKContactTrackerTextCellIdenty"];
    if (!cell) {
        cell = [[MKContactTrackerTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKContactTrackerTextCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.detailMsgLabel];
        [self.contentView addSubview:self.rightIcon];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-1.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(8.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(14.f);
    }];
    [self.detailMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(1.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKContactTrackerTextCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.leftMsg);
    self.detailMsgLabel.text = SafeStr(_dataModel.rightMsg);
    self.detailMsgLabel.hidden = _dataModel.showRightIcon;
    self.rightIcon.hidden = !_dataModel.showRightIcon;
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = LOADIMAGE(@"goto_next_button", @"png");
    }
    return _rightIcon;
}

- (UILabel *)detailMsgLabel {
    if (!_detailMsgLabel) {
        _detailMsgLabel = [[UILabel alloc] init];
        _detailMsgLabel.textColor = DEFAULT_TEXT_COLOR;
        _detailMsgLabel.textAlignment = NSTextAlignmentRight;
        _detailMsgLabel.font = MKFont(13.f);
    }
    return _detailMsgLabel;
}

@end
