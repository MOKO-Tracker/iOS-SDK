//
//  MKConfigDateModel.h
//  MKContactTracker
//
//  Created by aa on 2020/4/27.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKConfigDateModel : NSObject<MKDeviceTimeProtocol>

/**
 大于2000
 */
@property (nonatomic, assign)NSInteger year;

@property (nonatomic, assign)NSInteger month;

@property (nonatomic, assign)NSInteger day;

@property (nonatomic, assign)NSInteger hour;

@property (nonatomic, assign)NSInteger minutes;

@property (nonatomic, assign)NSInteger second;

/// yyyy-MM-dd-HH-mm-ss
/// @param timeStamp yyyy-MM-dd-HH-mm-ss
+ (MKConfigDateModel *)fetchTimeModelWithTimeStamp:(NSString *)timeStamp;

+ (MKConfigDateModel *)fetchCurrentTime;

@end

NS_ASSUME_NONNULL_END
