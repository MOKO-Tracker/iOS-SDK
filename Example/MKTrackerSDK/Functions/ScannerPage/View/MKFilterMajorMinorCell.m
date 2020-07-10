//
//  MKFilterMajorMinorCell.m
//  MKContactTracker
//
//  Created by aa on 2020/7/1.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKFilterMajorMinorCell.h"

#import "MKFilterMajorMinorCellModel.h"

static CGFloat const labelWidth = 40.f;

@interface MKFilterMajorMinorCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UISwitch *switchView;

@property (nonatomic, strong)UIView *textView;

@property (nonatomic, strong)UIView *minTextView;

@property (nonatomic, strong)UIView *maxTextView;

@property (nonatomic, strong)UITextField *minTextField;

@property (nonatomic, strong)UITextField *maxTextField;

@property (nonatomic, strong)UILabel *fromLabel;

@property (nonatomic, strong)UILabel *toLabel;

@end

@implementation MKFilterMajorMinorCell

+ (MKFilterMajorMinorCell *)initCellWithTableView:(UITableView *)tableView {
    MKFilterMajorMinorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKFilterMajorMinorCellIdenty"];
    if (!cell) {
        cell = [[MKFilterMajorMinorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKFilterMajorMinorCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.switchView];
        [self.contentView addSubview:self.textView];
        [self.textView addSubview:self.minTextView];
        [self.textView addSubview:self.maxTextView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.switchView.mas_left).mas_offset(-10.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.width.mas_equalTo(45.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.switchView.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(35.f);
    }];
    [self.minTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.textView.mas_centerX);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.maxTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textView.mas_centerX);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - event method
- (void)switchViewValueChanged {
    if ([self.delegate respondsToSelector:@selector(majorMinorFliterSwitchStatusChanged:index:)]) {
        [self.delegate majorMinorFliterSwitchStatusChanged:self.switchView.isOn index:self.dataModel.index];
    }
}

- (void)minValueChanged {
    if (self.minTextField.text.length > 5) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(filterMinValueContentChanged:index:)]) {
        [self.delegate filterMinValueContentChanged:self.minTextField.text index:self.dataModel.index];
    }
}

- (void)maxValueChanged {
    if (self.maxTextField.text.length > 5) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(filterMaxValueContentChanged:index:)]) {
        [self.delegate filterMaxValueContentChanged:self.maxTextField.text index:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKFilterMajorMinorCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.minTextField.text = SafeStr(_dataModel.minValue);
    self.maxTextField.text = SafeStr(_dataModel.maxValue);
    [self.switchView setOn:_dataModel.isOn];
    [self.textView setHidden:!_dataModel.isOn];
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

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self
                        action:@selector(switchViewValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UIView *)textView {
    if (!_textView) {
        _textView = [[UIView alloc] init];
    }
    return _textView;
}

- (UILabel *)fromLabel {
    if (!_fromLabel) {
        _fromLabel = [[UILabel alloc] init];
        _fromLabel.textColor = DEFAULT_TEXT_COLOR;
        _fromLabel.font = MKFont(13.f);
        _fromLabel.textAlignment = NSTextAlignmentLeft;
        _fromLabel.text = @"From";
    }
    return _fromLabel;
}

- (UILabel *)toLabel {
    if (!_toLabel) {
        _toLabel = [[UILabel alloc] init];
        _toLabel.textColor = DEFAULT_TEXT_COLOR;
        _toLabel.font = MKFont(13.f);
        _toLabel.textAlignment = NSTextAlignmentLeft;
        _toLabel.text = @"To";
    }
    return _toLabel;
}

- (UITextField *)minTextField {
    if (!_minTextField) {
        _minTextField = [[UITextField alloc] initWithTextFieldType:realNumberOnly];
        _minTextField.maxLength = 5;
        _minTextField.placeholder = @"0~65535";
        _minTextField.font = MKFont(13.f);
        _minTextField.textColor = DEFAULT_TEXT_COLOR;
        _minTextField.textAlignment = NSTextAlignmentLeft;
        [_minTextField addTarget:self
                          action:@selector(minValueChanged)
                forControlEvents:UIControlEventEditingChanged];
    }
    return _minTextField;
}

- (UITextField *)maxTextField {
    if (!_maxTextField) {
        _maxTextField = [[UITextField alloc] initWithTextFieldType:realNumberOnly];
        _maxTextField.maxLength = 5;
        _maxTextField.placeholder = @"0~65535";
        _maxTextField.font = MKFont(13.f);
        _maxTextField.textColor = DEFAULT_TEXT_COLOR;
        _maxTextField.textAlignment = NSTextAlignmentLeft;
        [_maxTextField addTarget:self
                          action:@selector(maxValueChanged)
                forControlEvents:UIControlEventEditingChanged];
    }
    return _maxTextField;
}

- (UIView *)minTextView {
    if (!_minTextView) {
        _minTextView = [[UIView alloc] init];
        [_minTextView addSubview:self.fromLabel];
        [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.f);
            make.width.mas_equalTo(labelWidth);
            make.centerY.mas_equalTo(_minTextView.mas_centerY);
            make.height.mas_equalTo(MKFont(13.f).lineHeight);
        }];
        UIView *minView = [self textFieldViewWithTextField:self.minTextField];
        [_minTextView addSubview:minView];
        [minView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fromLabel.mas_right).mas_equalTo(10.f);
            make.right.mas_equalTo(-5.f);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _minTextView;
}

- (UIView *)maxTextView {
    if (!_maxTextView) {
        _maxTextView = [[UIView alloc] init];
        [_maxTextView addSubview:self.toLabel];
        [self.toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.f);
            make.width.mas_equalTo(labelWidth);
            make.centerY.mas_equalTo(_maxTextView.mas_centerY);
            make.height.mas_equalTo(MKFont(13.f).lineHeight);
        }];
        UIView *maxView = [self textFieldViewWithTextField:self.maxTextField];
        [_maxTextView addSubview:maxView];
        [maxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.toLabel.mas_right).mas_equalTo(10.f);
            make.right.mas_equalTo(-5.f);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _maxTextView;
}

- (UIView *)textFieldViewWithTextField:(UITextField *)textField {
    UIView *textFieldView = [[UIView alloc] init];
    textFieldView = [[UIView alloc] init];
    textFieldView.backgroundColor = COLOR_WHITE_MACROS;
    textFieldView.layer.masksToBounds = YES;
    textFieldView.layer.borderWidth = CUTTING_LINE_HEIGHT;
    textFieldView.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = CUTTING_LINE_COLOR;
    [textFieldView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(2.f);
    }];
    
    [textFieldView addSubview:textField];
    [textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(topLine.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    
    return textFieldView;
}

@end
