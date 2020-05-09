//
//  MKFilterOptionsModel.m
//  MKContactTracker
//
//  Created by aa on 2020/4/24.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKFilterOptionsModel.h"

@interface MKFilterOptionsModel ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKFilterOptionsModel

- (void)startReadDataWithSucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.configQueue, ^{
        if (![self readStorageRssi]) {
            [self operationFailedBlockWithMsg:@"Read rssi error" block:failedBlock];
            return ;
        }
        if (![self readAdvDataFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Read adv Data filter error" block:failedBlock];
            return ;
        }
        if (![self readMacAddressFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Read mac filter error" block:failedBlock];
            return ;
        }
        if (![self readAdvNameFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Read adv name filter error" block:failedBlock];
            return ;
        }
        if (![self readProximityUUIDStatus]) {
            [self operationFailedBlockWithMsg:@"Read proximity uuid filter error" block:failedBlock];
            return ;
        }
        if (![self readMajorStatus]) {
            [self operationFailedBlockWithMsg:@"Read major filter error" block:failedBlock];
            return ;
        }
        if (![self readMinorStatus]) {
            [self operationFailedBlockWithMsg:@"Read minor filter error" block:failedBlock];
            return ;
        }
        if (![self readRawAdvDataStatus]) {
            [self operationFailedBlockWithMsg:@"Read raw adv data filter error" block:failedBlock];
            return ;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

- (void)startConfigDataWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.configQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return ;
        }
        if (![self configStorageRssi]) {
            [self operationFailedBlockWithMsg:@"Config storage rssi error" block:failedBlock];
            return;
        }
        if (![self configAdvDataFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Config adv data filter error" block:failedBlock];
            return;
        }
        if (!self.advDataFilterIson) {
            //关闭了筛选条件
            moko_dispatch_main_safe(^{
                sucBlock();
            });
            return;
        }
        if (![self configMacFilter]) {
            [self operationFailedBlockWithMsg:@"Config mac filter error" block:failedBlock];
            return;
        }
        if (![self configAdvNameFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Config adv name filter error" block:failedBlock];
            return;
        }
        if (![self configProximityUUIDStatus]) {
            [self operationFailedBlockWithMsg:@"Config proximity UUID filter error" block:failedBlock];
            return;
        }
        if (![self configMajorStatus]) {
            [self operationFailedBlockWithMsg:@"Config major filter error" block:failedBlock];
            return;
        }
        if (![self configMinorStatus]) {
            [self operationFailedBlockWithMsg:@"Config minor filter error" block:failedBlock];
            return;
        }
        if (![self configRawAdvDataStatus]) {
            [self operationFailedBlockWithMsg:@"Config raw adv data filter error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readStorageRssi {
    __block BOOL success = NO;
    [MKTrackerInterface readStorageRssiWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.rssiValue = [returnData[@"result"][@"rssi"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configStorageRssi {
    __block BOOL success = NO;
    [MKTrackerInterface configStorageRssi:self.rssiValue sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAdvDataFilterStatus {
    __block BOOL success = NO;
    [MKTrackerInterface readAdvDataFilterStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advDataFilterIson = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAdvDataFilterStatus {
    __block BOOL success = NO;
    [MKTrackerInterface configAdvDataFilterStatus:self.advDataFilterIson sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMacAddressFilterStatus {
    __block BOOL success = NO;
    [MKTrackerInterface readMacAddressFilterStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.macIson = [returnData[@"result"][@"isOn"] boolValue];
        self.macValue = returnData[@"result"][@"filterMac"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMacFilter {
    __block BOOL success = NO;
    [MKTrackerInterface configMacFilterStatus:self.macIson mac:self.macValue sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAdvNameFilterStatus {
    __block BOOL success = NO;
    [MKTrackerInterface readAdvNameFilterStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advNameIson = [returnData[@"result"][@"isOn"] boolValue];
        self.advNameValue = returnData[@"result"][@"advName"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAdvNameFilterStatus {
    __block BOOL success = NO;
    [MKTrackerInterface configAdvNameFilterStatus:self.advNameIson advName:self.advNameValue sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readProximityUUIDStatus {
    __block BOOL success = NO;
    [MKTrackerInterface readProximityUUIDFilterStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.uuidIson = [returnData[@"result"][@"isOn"] boolValue];
        self.uuidValue = returnData[@"result"][@"uuid"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configProximityUUIDStatus {
    __block BOOL success = NO;
    [MKTrackerInterface configProximityUUIDFilterStatus:self.uuidIson uuid:self.uuidValue sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMajorStatus {
    __block BOOL success = NO;
    [MKTrackerInterface readMajorFilterStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.majorIson = [returnData[@"result"][@"isOn"] boolValue];
        self.majorValue = returnData[@"result"][@"major"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMajorStatus {
    __block BOOL success = NO;
    [MKTrackerInterface configMajorFilterStatus:self.majorIson major:[self.majorValue integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMinorStatus {
    __block BOOL success = NO;
    [MKTrackerInterface readMinorFilterStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.minorIson = [returnData[@"result"][@"isOn"] boolValue];
        self.minorValue = returnData[@"result"][@"minor"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMinorStatus {
    __block BOOL success = NO;
    [MKTrackerInterface configMinorFilterStatus:self.minorIson minor:[self.minorValue integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readRawAdvDataStatus {
    __block BOOL success = NO;
    [MKTrackerInterface readRawAdvDataFilterStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.rawDataIson = [returnData[@"result"][@"isOn"] boolValue];
        self.rawDataValue = returnData[@"result"][@"rawAdvData"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configRawAdvDataStatus {
    __block BOOL success = NO;
    [MKTrackerInterface configRawAdvDataFilterStatus:self.rawDataIson rawAdvData:self.rawDataValue sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - params valid
- (BOOL)validParams {
    if (!self.advDataFilterIson) {
        return YES;
    }
    if (self.macIson) {
        if (self.macValue.length % 2 != 0 || self.macValue.length == 0 || self.macValue.length > 12) {
            return NO;
        }
    }
    if (self.advNameIson) {
        if (!ValidStr(self.advNameValue) || self.advNameValue.length > 10) {
            return NO;
        }
    }
    if (self.uuidIson) {
        if (![MKTrackerAdopter isUUIDString:self.uuidValue]) {
            return NO;
        }
    }
    if (self.majorIson) {
        if (!ValidStr(self.majorValue) || [self.majorValue integerValue] < 0 || [self.majorValue integerValue] > 65535) {
            return NO;
        }
    }
    if (self.minorIson) {
        if (!ValidStr(self.minorValue) || [self.minorValue integerValue] < 0 || [self.minorValue integerValue] > 65535) {
            return NO;
        }
    }
    if (self.rawDataIson) {
        if (!ValidStr(self.rawDataValue) || self.rawDataValue.length > 31) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"advFilterParams"
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
        _configQueue = dispatch_queue_create("filterParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _configQueue;
}

@end
