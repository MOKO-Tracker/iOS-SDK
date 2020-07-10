//
//  MKScannerDataModel.m
//  MKContactTracker
//
//  Created by aa on 2020/4/29.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKScannerDataModel.h"

@interface MKScannerDataModel ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKScannerDataModel

- (void)updateWithDataModel:(MKScannerDataModel *)model {
    self.interval = model.interval;
    self.trackingNote = model.trackingNote;
    self.conditions = model.conditions;
}

- (void)startReadDatasWithSucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    dispatch_async(self.configQueue, ^{
        if (![self readStorageInterval]) {
            [self operationFailedBlockWithMsg:@"Read interval error" block:failedBlock];
            return ;
        }
        if (![self readTrackingNote]) {
            [self operationFailedBlockWithMsg:@"Read tracking notification error" block:failedBlock];
            return;
        }
        if ([MKDeviceTypeManager shared].supportAdvTrigger) {
            if (![self readConditions]) {
                [self operationFailedBlockWithMsg:@"Read scanning trigger error" block:failedBlock];
                return;
            }
        }
        if ([MKDeviceTypeManager shared].supportNewCommand) {
            if (![self readNumbersOfVibration]) {
                [self operationFailedBlockWithMsg:@"Read number of vibrations error" block:failedBlock];
                return;
            }
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)startConfigDatas:(MKScannerDataModel *)dataModel
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    dispatch_async(self.configQueue, ^{
        if (![self configStorageInterval:[dataModel.interval integerValue]]) {
            [self operationFailedBlockWithMsg:@"Config interval error" block:failedBlock];
            return ;
        }
        if (![self configTrackingNote:dataModel.trackingNote]) {
            [self operationFailedBlockWithMsg:@"Config tracking note error" block:failedBlock];
            return ;
        }
        if ([MKDeviceTypeManager shared].supportAdvTrigger) {
            if (![dataModel.conditions[@"isOn"] boolValue]) {
                //关闭
                if (![self closeScanningConditions]) {
                    [self operationFailedBlockWithMsg:@"Config scanning conditions error" block:failedBlock];
                    return ;
                }
            }else {
                //打开
                if (![self configScanningTime:[dataModel.conditions[@"time"] integerValue]]) {
                    [self operationFailedBlockWithMsg:@"Config scanning conditions error" block:failedBlock];
                    return ;
                }
            }
        }
        if ([MKDeviceTypeManager shared].supportNewCommand) {
            if (![self configNumbersOfVibration]) {
                [self operationFailedBlockWithMsg:@"Config number of vibrations error" block:failedBlock];
                return ;
            }
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readStorageInterval {
    __block BOOL success = NO;
    [MKTrackerInterface readStorageIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.interval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configStorageInterval:(NSInteger)interval {
    __block BOOL success = NO;
    [MKTrackerInterface configStorageInterval:interval sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTrackingNote {
    __block BOOL success = NO;
    [MKTrackerInterface readTrackingNotificationWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.trackingNote = [returnData[@"result"][@"reminder"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTrackingNote:(mk_trackingNotification)note {
    __block BOOL success = NO;
    [MKTrackerInterface configTrackingNotification:note sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readConditions {
    __block BOOL success = NO;
    [MKTrackerInterface readScanningTriggerConditionsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.conditions = returnData[@"result"][@"conditions"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)closeScanningConditions {
    __block BOOL success = NO;
    [MKTrackerInterface closeScanningTriggerConditionsWithSucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configScanningTime:(NSInteger)time {
    __block BOOL success = NO;
    [MKTrackerInterface configScanningTrigger:time sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNumbersOfVibration {
    __block BOOL success = NO;
    [MKTrackerInterface readNumberOfVibrationsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.vibNubmer = [returnData[@"result"][@"number"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNumbersOfVibration {
    __block BOOL success = NO;
    [MKTrackerInterface configNumberOfVibrations:self.vibNubmer sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"scanningParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":SafeStr(msg)}];
        block(error);
    })
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)configQueue {
    if (!_configQueue) {
        _configQueue = dispatch_queue_create("deviceInfoReadParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _configQueue;
}

@end
