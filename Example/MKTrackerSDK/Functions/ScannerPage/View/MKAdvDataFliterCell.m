//
//  MKAdvDataFliterCell.m
//  MKContactTracker
//
//  Created by aa on 2020/4/24.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKAdvDataFliterCell.h"
#import "MKAdvDataFliterCellModel.h"

@interface MKAdvDataFliterCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UISwitch *switchView;

@property (nonatomic, strong)UIView *textView;

@property (nonatomic, strong)UITextField *textField;

@end

@implementation MKAdvDataFliterCell

+ (MKAdvDataFliterCell *)initCellWithTableView:(UITableView *)tableView {
    MKAdvDataFliterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKAdvDataFliterCellIdenty"];
    if (!cell) {
        cell = [[MKAdvDataFliterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKAdvDataFliterCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.switchView];
        [self.contentView addSubview:self.textView];
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
}

#pragma mark - event method
- (void)switchViewValueChanged {
    self.textView.hidden = !self.switchView.isOn;
    if ([self.delegate respondsToSelector:@selector(advDataFliterCellSwitchStatusChanged:index:)]) {
        [self.delegate advDataFliterCellSwitchStatusChanged:self.switchView.isOn index:self.dataModel.index];
    }
}

- (void)textFieldValueChanged {
    if (self.dataModel.maxLength > 0 && self.textField.text.length > self.dataModel.maxLength) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(advertiserFilterContent:index:)]) {
        [self.delegate advertiserFilterContent:self.textField.text index:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKAdvDataFliterCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.msgLabel.text = _dataModel.msg;
    if (self.textField.superview) {
        [self.textField removeFromSuperview];
    }
    self.textField = nil;
    self.textField = [self textFieldWithPlaceholder:_dataModel.textPlaceholder
                                              value:_dataModel.textFieldValue
                                          maxLength:_dataModel.maxLength
                                               type:_dataModel.textFieldType];
    [self.textView addSubview:self.textField];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(2.f);
        make.bottom.mas_equalTo(0);
    }];
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

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder
                                    value:(NSString *)value
                                maxLength:(NSInteger)maxLength
                                     type:(mk_CustomTextFieldType)type {
    UITextField *textField = [[UITextField alloc] initWithTextFieldType:type];
    textField.maxLength = maxLength;
    textField.placeholder = placeholder;
    textField.text = value;
    textField.font = MKFont(13.f);
    textField.textColor = DEFAULT_TEXT_COLOR;
    textField.textAlignment = NSTextAlignmentLeft;
    [textField addTarget:self
                  action:@selector(textFieldValueChanged)
        forControlEvents:UIControlEventEditingChanged];
    return textField;
}

@end
