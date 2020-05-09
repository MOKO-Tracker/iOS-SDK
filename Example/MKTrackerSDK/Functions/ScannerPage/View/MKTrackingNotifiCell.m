//
//  MKTrackingNotifiCell.m
//  MKContactTracker
//
//  Created by aa on 2020/4/23.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKTrackingNotifiCell.h"

#import "MKSlotConfigPickView.h"

@interface MKTrackingNotifiCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *typeLabel;

@end

@implementation MKTrackingNotifiCell

+ (MKTrackingNotifiCell *)initCellWithTableView:(UITableView *)tableView {
    MKTrackingNotifiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKTrackingNotifiCellIdenty"];
    if (!cell) {
        cell = [[MKTrackingNotifiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKTrackingNotifiCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.typeLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.typeLabel.mas_left).mas_offset(-10.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(35.f);
    }];
}

#pragma mark - event method
- (void)typeLabelPressed {
    NSArray *dataList = @[@"Off",@"Light",@"Vibration",@"Light+Vibration"];
    MKSlotConfigPickView *pickView = [[MKSlotConfigPickView alloc] init];
    pickView.dataList = dataList;
    [pickView showPickViewWithIndex:[self fetchCurrentDataIndex] block:^(NSInteger currentRow) {
        self.typeLabel.text = dataList[currentRow];
        if ([self.delegate respondsToSelector:@selector(advertiserParamsChanged:index:)]) {
            [self.delegate advertiserParamsChanged:@(currentRow) index:1];
        }
    }];
}

#pragma mark - setter
- (void)setTrackingNote:(NSInteger)trackingNote {
    _trackingNote = trackingNote;
    NSArray *dataList = @[@"Off",@"Light",@"Vibration",@"Light+Vibration"];
    [self.typeLabel setText:dataList[_trackingNote]];
}

#pragma mark - private method
- (NSInteger)fetchCurrentDataIndex {
    if ([self.typeLabel.text isEqualToString:@"Off"]) {
        return 0;
    }
    if ([self.typeLabel.text isEqualToString:@"Light"]) {
        return 1;
    }
    if ([self.typeLabel.text isEqualToString:@"Vibration"]) {
        return 2;
    }
    if ([self.typeLabel.text isEqualToString:@"Light+Vibration"]) {
        return 3;
    }
    
    return 0;
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Tracking Notification";
    }
    return _msgLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = UIColorFromRGB(0x2F84D0);
        _typeLabel.font = MKFont(13.f);
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.text = @"Off";
        [_typeLabel addTapAction:self selector:@selector(typeLabelPressed)];
    }
    return _typeLabel;
}

@end
