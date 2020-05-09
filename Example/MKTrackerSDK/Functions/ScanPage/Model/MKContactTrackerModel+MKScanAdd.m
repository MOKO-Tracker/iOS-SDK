//
//  MKContactTrackerModel+MKScanAdd.m
//  MKContactTracker
//
//  Created by aa on 2020/4/25.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKContactTrackerModel+MKScanAdd.h"
#import <objc/runtime.h>

static const char *scanTimeKey = "scanTimeKey";
static const char *lastScanDateKey = "lastScanDateKey";
static const char *indexKey = "indexKey";


@implementation MKContactTrackerModel (MKScanAdd)

- (void)setScanTime:(NSString *)scanTime {
    objc_setAssociatedObject(self, &scanTimeKey, scanTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)scanTime {
    return objc_getAssociatedObject(self, &scanTimeKey);
}

- (void)setLastScanDate:(NSString *)lastScanDate {
    objc_setAssociatedObject(self, &lastScanDateKey, lastScanDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)lastScanDate {
    return objc_getAssociatedObject(self, &lastScanDateKey);
}

- (void)setIndex:(NSInteger)index {
    objc_setAssociatedObject(self, &indexKey, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)index {
    return [objc_getAssociatedObject(self, &indexKey) integerValue];
}

@end
