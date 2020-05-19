//
//  MKTrackerAdopter.h
//  MKContactTracker
//
//  Created by aa on 2020/4/27.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTrackerAdopter : NSObject

+ (BOOL)asciiString:(NSString *)content;
+ (BOOL)isUUIDString:(NSString *)uuid;
+ (NSString *)getBinaryByhex:(NSString *)hex;
+ (NSDictionary *)parseDateString:(NSString *)date;
+ (NSDictionary *)parseScannerTrackedData:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
