//
//  MKTriggerSensitivityView.m
//  MKContactTracker
//
//  Created by aa on 2020/5/5.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKTriggerSensitivityView.h"
#import "MKTriggerSenSlider.h"

static NSString *const titleMsg = @"Trigger Sensitivity";
static NSString *const alertMsg = @"The larger the value,the more sensitive Beacon judges the movement.";

static CGFloat const sliderHeight = 20.f;
static CGFloat const buttonHeight = 55.f;
static CGFloat const offset_Y = 15.f;
static CGFloat const offset_X = 15.f;
static CGFloat const maxLabelHeight = 15.f;

@interface MKTriggerSensitivityView ()

@property (nonatomic, strong)UIView *alertView;

@property (nonatomic, strong)UILabel *titleMsgLabel;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *maxLabel;

@property (nonatomic, strong)UILabel *minLabel;

@property (nonatomic, strong)MKTriggerSenSlider *slider;

@property (nonatomic, strong)UILabel *valueLabel;

@property (nonatomic, strong)UIButton *cancelButton;

@property (nonatomic, strong)UIButton *confirmButton;

@property (nonatomic, strong)UIView *lineView1;

@property (nonatomic, strong)UIView *lineView2;

@property (nonatomic, copy)void (^valueConfirmBlock)(NSInteger resultValue);

@end

@implementation MKTriggerSensitivityView

- (void)dealloc {
    NSLog(@"MKTriggerSensitivityView销毁");
}

- (instancetype)init {
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.titleMsgLabel];
        [self.alertView addSubview:self.msgLabel];
        [self.alertView addSubview:self.maxLabel];
        [self.alertView addSubview:self.minLabel];
        [self.alertView addSubview:self.slider];
        [self.alertView addSubview:self.valueLabel];
        [self.alertView addSubview:self.lineView1];
        [self.alertView addSubview:self.lineView2];
        [self.alertView addSubview:self.cancelButton];
        [self.alertView addSubview:self.confirmButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize titleSize = [NSString sizeWithText:self.titleMsgLabel.text
                                      andFont:self.titleMsgLabel.font
                                   andMaxSize:CGSizeMake(kScreenWidth - 4 * offset_X, MAXFLOAT)];
    CGSize msgSize = [NSString sizeWithText:self.msgLabel.text
                                    andFont:self.msgLabel.font
                                 andMaxSize:CGSizeMake(kScreenWidth - 4 * offset_X, MAXFLOAT)];
    CGFloat alertHeight = 4 * offset_Y + titleSize.height + msgSize.height + maxLabelHeight + sliderHeight + CUTTING_LINE_HEIGHT + buttonHeight;
    [self.alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(alertHeight);
    }];
    [self.titleMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(offset_Y);
        make.height.mas_equalTo(titleSize.height);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(self.titleMsgLabel.mas_bottom).mas_offset(offset_Y);
        make.height.mas_equalTo(msgSize.height);
    }];
    [self.maxLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(80.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(offset_Y);
        make.height.mas_equalTo(maxLabelHeight);
    }];
    [self.minLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.valueLabel.mas_left).mas_offset(-offset_X);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.maxLabel.mas_centerY);
        make.height.mas_equalTo(maxLabelHeight);
    }];
    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(self.valueLabel.mas_left).mas_offset(-offset_X);
        make.top.mas_equalTo(self.maxLabel.mas_bottom);
        make.height.mas_equalTo(sliderHeight);
    }];
    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.slider.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.lineView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.slider.mas_bottom).mas_offset(offset_Y);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.lineView2.mas_left);
        make.top.mas_equalTo(self.lineView1.mas_bottom);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(self.lineView2.mas_right);
        make.top.mas_equalTo(self.lineView1.mas_bottom);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.lineView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
        make.width.mas_equalTo(CUTTING_LINE_HEIGHT);
        make.top.mas_equalTo(self.lineView1.mas_bottom);
        make.height.mas_equalTo(buttonHeight);
    }];
}

#pragma mark - event Method

/**
 取消选择
 */
- (void)cancelButtonPressed {
    [self dismiss];
}

/**
 确认选择
 */
- (void)confirmButtonPressed {
    if (self.valueConfirmBlock) {
        NSString *value = [NSString stringWithFormat:@"%.f",self.slider.value];
        self.valueConfirmBlock([value integerValue]);
    }
    [self dismiss];
}

- (void)dismiss {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)sliderValueChanged {
    [self updateSliderValue];
}

#pragma mark - public method
- (void)showViewWithValue:(NSInteger)value completeBlock:(void (^)(NSInteger resultValue))block {
    [kAppWindow addSubview:self];
    self.valueConfirmBlock = block;
    self.slider.value = value;
    [self updateSliderValue];
}

#pragma mark - private method
- (void)updateSliderValue {
    NSString *value = [NSString stringWithFormat:@"%.f",self.slider.value];
    NSInteger currentValue = 248 - [value integerValue];
    self.valueLabel.text = [NSString stringWithFormat:@"%ld",(long)currentValue];
}

#pragma mark - getter
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = RGBCOLOR(239, 239, 239);
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.borderColor = RGBCOLOR(167, 166, 167).CGColor;
        _alertView.layer.borderWidth = 0.5f;
        _alertView.layer.cornerRadius = 8.f;
    }
    return _alertView;
}

- (UILabel *)titleMsgLabel {
    if (!_titleMsgLabel) {
        _titleMsgLabel = [[UILabel alloc] init];
        _titleMsgLabel.textColor = DEFAULT_TEXT_COLOR;
        _titleMsgLabel.textAlignment = NSTextAlignmentCenter;
        _titleMsgLabel.font = MKFont(17.f);
        _titleMsgLabel.numberOfLines = 0;
        _titleMsgLabel.text = titleMsg;
    }
    return _titleMsgLabel;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = MKFont(14.f);
        _msgLabel.numberOfLines = 0;
        _msgLabel.text = alertMsg;
    }
    return _msgLabel;
}

- (UILabel *)maxLabel {
    if (!_maxLabel) {
        _maxLabel = [[UILabel alloc] init];
        _maxLabel.textColor = RGBCOLOR(171, 174, 181);
        _maxLabel.textAlignment = NSTextAlignmentLeft;
        _maxLabel.font = MKFont(13.f);
        _maxLabel.text = @"MAX";
    }
    return _maxLabel;
}

- (UILabel *)minLabel {
    if (!_minLabel) {
        _minLabel = [[UILabel alloc] init];
        _minLabel.textAlignment = NSTextAlignmentRight;
        _minLabel.textColor = RGBCOLOR(171, 174, 181);
        _minLabel.font = MKFont(13.f);
        _minLabel.text = @"MIN";
    }
    return _minLabel;
}

- (MKTriggerSenSlider *)slider {
    if (!_slider) {
        _slider = [[MKTriggerSenSlider alloc] init];
        _slider.maximumValue = 248;
        _slider.minimumValue = 0;
        _slider.value = 0.f;
        [_slider addTarget:self
                    action:@selector(sliderValueChanged)
          forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = DEFAULT_TEXT_COLOR;
        _valueLabel.textAlignment = NSTextAlignmentLeft;
        _valueLabel.font = MKFont(13.f);
    }
    return _valueLabel;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = RGBCOLOR(167, 166, 167);
    }
    return _lineView1;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = RGBCOLOR(167, 166, 167);
    }
    return _lineView2;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorFromRGB(0x2F84D0) forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:MKFont(15.f)];
        [_cancelButton addTapAction:self selector:@selector(cancelButtonPressed)];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"OK" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:UIColorFromRGB(0x2F84D0) forState:UIControlStateNormal];
        [_confirmButton.titleLabel setFont:MKFont(15.f)];
        [_confirmButton addTapAction:self selector:@selector(confirmButtonPressed)];
    }
    return _confirmButton;
}

@end
