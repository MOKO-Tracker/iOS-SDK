//
//  MKFilterMajorMinorCellModel.h
//  MKContactTracker
//
//  Created by aa on 2020/7/1.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterMajorMinorCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *minValue;

@property (nonatomic, copy)NSString *maxValue;

/// 0:Major,1:Minor
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, assign)BOOL isOn;

@end

NS_ASSUME_NONNULL_END
