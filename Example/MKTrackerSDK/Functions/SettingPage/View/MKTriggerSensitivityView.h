//
//  MKTriggerSensitivityView.h
//  MKContactTracker
//
//  Created by aa on 2020/5/5.
//  Copyright © 2020 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTriggerSensitivityView : UIView

- (void)showViewWithValue:(NSInteger)value completeBlock:(void (^)(NSInteger resultValue))block;

@end

NS_ASSUME_NONNULL_END
