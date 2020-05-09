//
//  MKConfigDateModel.m
//  MKContactTracker
//
//  Created by aa on 2020/4/27.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKConfigDateModel.h"

@implementation MKConfigDateModel

+ (MKConfigDateModel *)fetchTimeModelWithTimeStamp:(NSString *)timeStamp{
    if (!ValidStr(timeStamp)) {
        return nil;
    }
    NSArray *list = [timeStamp componentsSeparatedByString:@"-"];
    if (!ValidArray(list) || list.count != 6) {
        return nil;
    }
    MKConfigDateModel *timeModel = [[MKConfigDateModel alloc] init];
    timeModel.year = [list[0] integerValue];
    timeModel.month = [list[1] integerValue];
    timeModel.day = [list[2] integerValue];
    timeModel.hour = [list[3] integerValue];
    timeModel.minutes = [list[4] integerValue];
    timeModel.second = [list[5] integerValue];
    return timeModel;
}

+ (MKConfigDateModel *)fetchCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return [self fetchTimeModelWithTimeStamp:dateString];
}

@end
