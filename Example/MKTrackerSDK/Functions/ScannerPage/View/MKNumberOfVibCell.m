//
//  MKNumberOfVibCell.m
//  MKContactTracker
//
//  Created by aa on 2020/7/1.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKNumberOfVibCell.h"
#import "MKSlotConfigPickView.h"

@interface MKNumberOfVibCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *typeLabel;

@end

@implementation MKNumberOfVibCell

+ (MKNumberOfVibCell *)initCellWithTableView:(UITableView *)tableView {
    MKNumberOfVibCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKNumberOfVibCellIdenty"];
    if (!cell) {
        cell = [[MKNumberOfVibCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKNumberOfVibCellIdenty"];
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
    NSArray *dataList = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    MKSlotConfigPickView *pickView = [[MKSlotConfigPickView alloc] init];
    pickView.dataList = dataList;
    [pickView showPickViewWithIndex:([self.typeLabel.text integerValue] - 1) block:^(NSInteger currentRow) {
        self.typeLabel.text = dataList[currentRow];
        if ([self.delegate respondsToSelector:@selector(advertiserParamsChanged:index:)]) {
            [self.delegate advertiserParamsChanged:@(currentRow) index:3];
        }
    }];
}

#pragma mark - setter
- (void)setNumber:(NSInteger)number {
    _number = number;
    self.typeLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
}

#pragma mark - private method

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Number of Vibrations";
    }
    return _msgLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = UIColorFromRGB(0x2F84D0);
        _typeLabel.font = MKFont(13.f);
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.text = @"1";
        [_typeLabel addTapAction:self selector:@selector(typeLabelPressed)];
    }
    return _typeLabel;
}

@end
