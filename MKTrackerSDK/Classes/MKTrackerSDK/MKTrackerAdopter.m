//
//  MKTrackerAdopter.m
//  MKContactTracker
//
//  Created by aa on 2020/4/27.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKTrackerAdopter.h"
#import "MKBLEBaseSDKAdopter.h"

@implementation MKTrackerAdopter

+ (BOOL)asciiString:(NSString *)content {
    NSInteger strlen = content.length;
    NSInteger datalen = [[content dataUsingEncoding:NSUTF8StringEncoding] length];
    if (strlen != datalen) {
        return NO;
    }
    return YES;
}

+ (BOOL)isUUIDString:(NSString *)uuid{
    NSString *uuidPatternString = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:uuidPatternString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSInteger numberOfMatches = [regex numberOfMatchesInString:uuid
                                                       options:kNilOptions
                                                         range:NSMakeRange(0, uuid.length)];
    return (numberOfMatches > 0);
}

+ (NSString *)getBinaryByhex:(NSString *)hex{
    if (!hex || ![hex isKindOfClass:NSString.class] || hex.length != 2 || ![MKBLEBaseSDKAdopter checkHexCharacter:hex]) {
        return @"";
    }
    NSDictionary *hexDic = @{
                             @"0":@"0000",@"1":@"0001",@"2":@"0010",
                             @"3":@"0011",@"4":@"0100",@"5":@"0101",
                             @"6":@"0110",@"7":@"0111",@"8":@"1000",
                             @"9":@"1001",@"A":@"1010",@"a":@"1010",
                             @"B":@"1011",@"b":@"1011",@"C":@"1100",
                             @"c":@"1100",@"D":@"1101",@"d":@"1101",
                             @"E":@"1110",@"e":@"1110",@"F":@"1111",
                             @"f":@"1111",
                             };
    NSString *binaryString = @"";
    for (int i=0; i<[hex length]; i++) {
        NSRange rage;
        rage.length = 1;
        rage.location = i;
        NSString *key = [hex substringWithRange:rage];
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,
                        [NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
        
    }
    
    return binaryString;
}

+ (NSDictionary *)parseDateString:(NSString *)date {
    NSString *year = [NSString stringWithFormat:@"%ld",(long)([MKBLEBaseSDKAdopter getDecimalWithHex:date range:NSMakeRange(0, 2)] + 2000)];
    NSString *month = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(2, 2)];
    if (month.length == 1) {
        month = [@"0" stringByAppendingString:month];
    }
    NSString *day = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(4, 2)];
    if (day.length == 1) {
        day = [@"0" stringByAppendingString:day];
    }
    NSString *hour = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(6, 2)];
    if (hour.length == 1) {
        hour = [@"0" stringByAppendingString:hour];
    }
    NSString *min = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(8, 2)];
    if (min.length == 1) {
        min = [@"0" stringByAppendingString:min];
    }
    NSString *second = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(10, 2)];
    if (second.length == 1) {
        second = [@"0" stringByAppendingString:second];
    }
    return @{
        @"year":year,
        @"month":month,
        @"day":day,
        @"hour":hour,
        @"minute":min,
        @"second":second,
    };
}

+ (NSDictionary *)parseScannerTrackedData:(NSString *)content {
    NSDictionary *dateDic = [self parseDateString:[content substringWithRange:NSMakeRange(0, 12)]];
    NSString *tempMac = [[content substringWithRange:NSMakeRange(12, 12)] uppercaseString];
    NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",
                            [tempMac substringWithRange:NSMakeRange(10, 2)],
                            [tempMac substringWithRange:NSMakeRange(8, 2)],
                            [tempMac substringWithRange:NSMakeRange(6, 2)],
                            [tempMac substringWithRange:NSMakeRange(4, 2)],
                            [tempMac substringWithRange:NSMakeRange(2, 2)],
                            [tempMac substringWithRange:NSMakeRange(0, 2)]];
    NSNumber *rssi = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(24, 2)]];
    NSString *rawData = [content substringFromIndex:26];
    
    return @{
        @"dateDic":dateDic,
        @"macAddress":macAddress,
        @"rssi":rssi,
        @"rawData":rawData,
    };
}

@end
