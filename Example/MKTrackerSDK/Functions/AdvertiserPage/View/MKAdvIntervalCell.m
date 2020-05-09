//
//  MKAdvIntervalCell.m
//  MKContactTracker
//
//  Created by aa on 2020/4/23.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKAdvIntervalCell.h"

@interface MKAdvIntervalCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIView *textView;

@property (nonatomic, strong)UITextField *textField;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation MKAdvIntervalCell

+ (MKAdvIntervalCell *)initCellWithTableView:(UITableView *)tableView {
    MKAdvIntervalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKAdvIntervalCellIdenty"];
    if (!cell) {
        cell = [[MKAdvIntervalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKAdvIntervalCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.textView];
        [self.textView addSubview:self.textField];
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(40.f);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(2.f);
        make.bottom.mas_equalTo(0);
    }];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textView.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.textView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)textFieldValueChanged {
    if ([self.delegate respondsToSelector:@selector(advertiserParamsChanged:indexPath:)]) {
        [self.delegate advertiserParamsChanged:SafeStr(self.textField.text) indexPath:self.indexPath];
    }
}

#pragma mark - setter
- (void)setInterval:(NSString *)interval {
    _interval = nil;
    _interval = interval;
    if (!_interval) {
        return;
    }
    self.textField.text = interval;
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"ADV Interval";
    }
    return _msgLabel;
}

- (UIView *)textView {
    if (!_textView) {
        _textView = [[UIView alloc] init];
        _textView.backgroundColor = COLOR_WHITE_MACROS;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _textView.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = CUTTING_LINE_COLOR;
        [_textView addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(2.f);
        }];
    }
    return _textView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithTextFieldType:realNumberOnly];
        _textField.maxLength = 3;
        _textField.placeholder = @"1~100";
        _textField.font = MKFont(13.f);
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.textAlignment = NSTextAlignmentLeft;
        [_textField addTarget:self
                       action:@selector(textFieldValueChanged)
             forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.textColor = DEFAULT_TEXT_COLOR;
        _noteLabel.font = MKFont(13.f);
        _noteLabel.text = @"x 100ms";
    }
    return _noteLabel;
}

@end
