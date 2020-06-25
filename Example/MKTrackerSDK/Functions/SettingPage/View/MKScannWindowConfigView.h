//
//  MKScannWindowConfigView.h
//  MKContactTracker
//
//  Created by aa on 2020/6/19.
//  Copyright © 2020 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKScannWindowConfigView : UIView

- (void)showViewWithValue:(mk_scannWindowType)type completeBlock:(void (^)(mk_scannWindowType resultType))block;

@end

NS_ASSUME_NONNULL_END
