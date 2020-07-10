//
//  MKTrackerInterface.m
//  MKContactTracker
//
//  Created by aa on 2020/4/27.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKTrackerInterface.h"
#import "MKContactTrackerCentralManager.h"

#import "MKBLEOperation.h"
#import "MKTrackerAdopter.h"
#import "CBPeripheral+MKContactTracker.h"
#import "MKBLEOperationID.h"

#define centralManager [MKContactTrackerCentralManager shared]

@implementation MKTrackerInterface

+ (void)readBatteryPowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                         failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadBatteryPowerOperation
                           characteristic:centralManager.peripheral.batteryPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readManufacturerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                         failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadManufacturerOperation
                           characteristic:centralManager.peripheral.manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readDeviceModelWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadDeviceModelOperation
                           characteristic:centralManager.peripheral.deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readProductionDateWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadProductionDateOperation
                           characteristic:centralManager.peripheral.productionDate
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readHardwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                     failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadHardwareOperation
                           characteristic:centralManager.peripheral.hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readSoftwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                     failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadSoftwareOperation
                           characteristic:centralManager.peripheral.sofeware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readFirmwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                     failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadFirmwareOperation
                           characteristic:centralManager.peripheral.firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readBatteryVoltageWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadBatteryVoltageOperation
                           characteristic:centralManager.peripheral.batteryVoltage
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readTrackerDeviceTypeWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadDeviceTypeOperation
                           characteristic:centralManager.peripheral.deviceType
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readMacaddressWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                       failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadMacAddressOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea200000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readAdvNameWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                    failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadDeviceNameOperation
                           characteristic:centralManager.peripheral.deviceName
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readProximityUUIDWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                          failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadProximityUUIDOperation
                           characteristic:centralManager.peripheral.uuid
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readMajorWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                  failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadMajorOperation
                           characteristic:centralManager.peripheral.major
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readMinorWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                  failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadMinorOperation
                           characteristic:centralManager.peripheral.minor
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readAdvIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadBroadcastIntervalOperation
                           characteristic:centralManager.peripheral.broadcastInterval
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readMeasurePowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                         failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadMeasuredPowerOperation
                           characteristic:centralManager.peripheral.measuredPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readTxPowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                    failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadTxPowerOperation
                           characteristic:centralManager.peripheral.txPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readADVTriggerConditionsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                 failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadADVTriggerConditionsOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea210000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readStorageIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                            failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadStorageIntervalOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea240000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readTrackingNotificationWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                 failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadStorageReminderOperation
                           characteristic:centralManager.peripheral.storageReminder
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readScanningTriggerConditionsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                      failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadScanningTriggerConditionsOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea220000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readStorageRssiWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadStorageRssiOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea230000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readAdvDataFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadAdvDataFilterStatusOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea460000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readMacAddressFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                   failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadMacFilterStatusOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea410000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readAdvNameFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadAdvNameFilterStatusOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea420000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readProximityUUIDFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                      failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadProximityUUIDFilterStatusOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea470000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readMajorFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadMajorFilterStatusOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea480000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readMinorFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadMinorFilterStatusOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea490000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readMajorFilterStateWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                             failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadMajorFilterStateOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea630000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readMinorFilterStateWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                             failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadMinorFilterStateOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea640000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readRawAdvDataFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                   failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadRawAdvDataFilterStatusOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea430000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readScanStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                       failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadScanStatusOperation
                           characteristic:centralManager.peripheral.scanStatus
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readConnectableWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_taskReadConnectableStatusOperation
                           characteristic:centralManager.peripheral.connectable
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readButtonPowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadButtonPowerStatusOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea280000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readMovementSensitivityWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadMovementSensitivityOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea400000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readScanWindowDataWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadScanWindowDataOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea600000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readNumberOfVibrationsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                               failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_taskReadNumberOfVibrationsOperation
                       characteristic:centralManager.peripheral.custom
                             resetNum:NO
                          commandData:@"ea620000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
