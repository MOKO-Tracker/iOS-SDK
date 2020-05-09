//
//  MKScannerProtocol.h
//  MKContactTracker
//
//  Created by aa on 2020/4/29.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKScannerDelegate <NSObject>

- (void)advertiserParamsChanged:(id)newValue index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
