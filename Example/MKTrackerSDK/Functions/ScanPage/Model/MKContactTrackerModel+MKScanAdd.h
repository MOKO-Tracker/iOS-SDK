//
//  MKContactTrackerModel+MKScanAdd.h
//  MKContactTracker
//
//  Created by aa on 2020/4/25.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKContactTrackerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKContactTrackerModel (MKScanAdd)

/// cell上面显示的时间
@property (nonatomic, copy)NSString *scanTime;

/**
 上一次扫描到的时间
 */
@property (nonatomic, copy)NSString *lastScanDate;

/**
 当前model所在的row
 */
@property (nonatomic, assign)NSInteger index;

@end

NS_ASSUME_NONNULL_END
