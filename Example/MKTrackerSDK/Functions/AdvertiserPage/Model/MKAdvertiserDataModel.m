//
//  MKAdvertiserDataModel.m
//  MKContactTracker
//
//  Created by aa on 2020/4/28.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKAdvertiserDataModel.h"

@interface MKAdvertiserDataModel ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKAdvertiserDataModel

- (void)updateValueWithModel:(MKAdvertiserDataModel *)model {
    if (!model) {
        return;
    }
    self.deviceName = model.deviceName;
    self.proximityUUID = model.proximityUUID;
    self.major = model.major;
    self.minor = model.minor;
    self.interval = model.interval;
    self.measurePower = model.measurePower;
    self.txPower = model.txPower;
    self.advTriggerConditions = [NSDictionary dictionaryWithDictionary:model.advTriggerConditions];
}

- (void)startReadDatasWithSucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    dispatch_async(self.configQueue, ^{
        if (![self readDeviceName]) {
            [self operationFailedBlockWithMsg:@"Read device name error" block:failedBlock];
            return ;
        }
        if (![self readUUID]) {
            [self operationFailedBlockWithMsg:@"Read proximity uuid error" block:failedBlock];
            return ;
        }
        if (![self readMajor]) {
            [self operationFailedBlockWithMsg:@"Read major error" block:failedBlock];
            return ;
        }
        if (![self readMinor]) {
            [self operationFailedBlockWithMsg:@"Read minor error" block:failedBlock];
            return ;
        }
        if (![self readInterval]) {
            [self operationFailedBlockWithMsg:@"Read interval error" block:failedBlock];
            return ;
        }
        if (![self readMeasurePower]) {
            [self operationFailedBlockWithMsg:@"Read measure power error" block:failedBlock];
            return ;
        }
        if (![self readTxPower]) {
            [self operationFailedBlockWithMsg:@"Read txPower error" block:failedBlock];
            return ;
        }
        if (![self readADVTriggerConditions]) {
            [self operationFailedBlockWithMsg:@"Read conditions error" block:failedBlock];
            return ;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

- (void)startConfigDatas:(MKAdvertiserDataModel *)dataModel
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    dispatch_async(self.configQueue, ^{
        if (![self configDeviceName:dataModel.deviceName]) {
            [self operationFailedBlockWithMsg:@"Config device name error" block:failedBlock];
            return ;
        }
        if (![self configUUID:dataModel.proximityUUID]) {
            [self operationFailedBlockWithMsg:@"Config proximityUUID error" block:failedBlock];
            return ;
        }
        if (![self configMajor:[dataModel.major integerValue]]) {
            [self operationFailedBlockWithMsg:@"Config major error" block:failedBlock];
            return ;
        }
        if (![self configMinor:[dataModel.minor integerValue]]) {
            [self operationFailedBlockWithMsg:@"Config minor error" block:failedBlock];
            return ;
        }
        if (![self configInterval:[dataModel.interval integerValue]]) {
            [self operationFailedBlockWithMsg:@"Config interval error" block:failedBlock];
            return ;
        }
        if (![self configMeasurePower:[dataModel.measurePower integerValue]]) {
            [self operationFailedBlockWithMsg:@"Config measurePower error" block:failedBlock];
            return ;
        }
        if (![self configTxPower:dataModel.txPower]) {
            [self operationFailedBlockWithMsg:@"Config Tx Power error" block:failedBlock];
            return ;
        }
        if (![dataModel.advTriggerConditions[@"isOn"] boolValue]) {
            //关闭
            if (![self closeTriggerConditions]) {
                [self operationFailedBlockWithMsg:@"Config trigger conditions error" block:failedBlock];
                return ;
            }
        }else {
            //打开
            if (![self configTriggerConditions:[dataModel.advTriggerConditions[@"time"] integerValue]]) {
                [self operationFailedBlockWithMsg:@"Config trigger conditions error" block:failedBlock];
                return ;
            }
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readDeviceName {
    __block BOOL success = NO;
    [MKTrackerInterface readAdvNameWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.deviceName = returnData[@"result"][@"deviceName"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDeviceName:(NSString *)deviceName {
    __block BOOL success = NO;
    [MKTrackerInterface configDeviceName:deviceName sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readUUID {
    __block BOOL success = NO;
    [MKTrackerInterface readProximityUUIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.proximityUUID = returnData[@"result"][@"uuid"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configUUID:(NSString *)uuid {
    __block BOOL success = NO;
    [MKTrackerInterface configProximityUUID:uuid sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMajor {
    __block BOOL success = NO;
    [MKTrackerInterface readMajorWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.major = returnData[@"result"][@"major"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMajor:(NSInteger)major {
    __block BOOL success = NO;
    [MKTrackerInterface configMajor:major sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMinor {
    __block BOOL success = NO;
    [MKTrackerInterface readMinorWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.minor = returnData[@"result"][@"minor"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMinor:(NSInteger)minor {
    __block BOOL success = NO;
    [MKTrackerInterface configMinor:minor sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readInterval {
    __block BOOL success = NO;
    [MKTrackerInterface readAdvIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.interval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configInterval:(NSInteger)interval {
    __block BOOL success = NO;
    [MKTrackerInterface configAdvInterval:interval sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMeasurePower {
    __block BOOL success = NO;
    [MKTrackerInterface readMeasurePowerWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.measurePower = returnData[@"result"][@"measuredPower"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMeasurePower:(NSInteger)measurePower {
    __block BOOL success = NO;
    [MKTrackerInterface configMeasuredPower:measurePower sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTxPower {
    __block BOOL success = NO;
    [MKTrackerInterface readTxPowerWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.txPower = returnData[@"result"][@"txPower"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTxPower:(NSString *)txPower {
    __block BOOL success = NO;
    [MKTrackerInterface configTxPower:[self fetchTxPowerValue:txPower] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readADVTriggerConditions {
    __block BOOL success = NO;
    [MKTrackerInterface readADVTriggerConditionsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advTriggerConditions = returnData[@"result"][@"conditions"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)closeTriggerConditions {
    __block BOOL success = NO;
    [MKTrackerInterface closeAdvTriggerConditionsWithSucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTriggerConditions:(NSInteger)time {
    __block BOOL success = NO;
    [MKTrackerInterface configAdvTrigger:time sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"advertisingParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":SafeStr(msg)}];
        block(error);
    })
}

- (mk_trackerTxPower)fetchTxPowerValue:(NSString *)txPower {
    if ([txPower isEqualToString:@"-40dBm"]) {
        return mk_trackerTxPowerNeg40dBm;
    }else if ([txPower isEqualToString:@"-20dBm"]){
        return mk_trackerTxPowerNeg20dBm;
    }else if ([txPower isEqualToString:@"-16dBm"]){
        return mk_trackerTxPowerNeg16dBm;
    }else if ([txPower isEqualToString:@"-12dBm"]){
        return mk_trackerTxPowerNeg12dBm;
    }else if ([txPower isEqualToString:@"-8dBm"]){
        return mk_trackerTxPowerNeg8dBm;
    }else if ([txPower isEqualToString:@"-4dBm"]){
        return mk_trackerTxPowerNeg4dBm;
    }else if ([txPower isEqualToString:@"0dBm"]){
        return mk_trackerTxPower0dBm;
    }else if ([txPower isEqualToString:@"3dBm"]){
        return mk_trackerTxPower3dBm;
    }else if ([txPower isEqualToString:@"4dBm"]){
        return mk_trackerTxPower4dBm;
    }
    return mk_trackerTxPower0dBm;
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
