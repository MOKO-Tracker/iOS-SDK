//
//  MKTrackerInterface.h
//  MKContactTracker
//
//  Created by aa on 2020/4/27.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTrackerInterface : NSObject

#pragma mark - Device Service Information

/// Read the battery level of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readBatteryPowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                         failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read device manufacturer information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readManufacturerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                         failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read product model
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readDeviceModelWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the production date of the product
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readProductionDateWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read device hardware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readHardwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                     failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read device software information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readSoftwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                     failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read device firmware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readFirmwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                     failedBlock:(nonnull void (^)(NSError *error))failedBlock;

#pragma mark -

/// Read the battery voltage of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readBatteryVoltageWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock;

#pragma mark -

/// Reading device type.
/// The device without 3-axis sensor is 0x04, the device with 3-axis sensor is 0x05
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readTrackerDeviceTypeWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading mac address
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readMacaddressWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                       failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading the broadcast name of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readAdvNameWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                    failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading the proximity UUID of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readProximityUUIDWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                          failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading the major of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readMajorWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                  failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading the minor of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readMinorWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                  failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading the broadcast interval of the device
/// units:100ms
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readAdvIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// RSSI@1M
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readMeasurePowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                         failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading Advertised Tx Power(RSSI@0m)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readTxPowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                    failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading device broadcast mobile trigger condition
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readADVTriggerConditionsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                 failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading device data storage interval
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readStorageIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                            failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Tracking Notification,Turn on LED reminder: 0x01; turn on motor reminder: 0x02; turn on LED and motor reminder: 0x03; store reminder off: 0x00
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readTrackingNotificationWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                 failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading Scanning Trigger condition
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readScanningTriggerConditionsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                      failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading the current stored RSSI condition, and store it once when the master scans to the slave signal strength is greater than or equal to this value.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readStorageRssiWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Turn off this option, the Beacon will store all types of BLE ADV data.Turn on this option, the Beacon will store the corresponding ADV data according to the filtering rules.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readAdvDataFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Whether the filtering of the mac address of the device is turned on.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readMacAddressFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                   failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Whether the filtering of the adversting name of the device is turned on.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readAdvNameFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Whether the filtering of the proximity UUID of the device is turned on.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readProximityUUIDFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                      failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Whether the filtering of the major of the device is turned on.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readMajorFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Whether the filtering of the minor of the device is turned on.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readMinorFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Whether the filtering of the raw advertising data of the device is turned on.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readRawAdvDataFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                   failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the scan status of the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readScanStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                       failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the connectable status of the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readConnectableWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read if the device can be turned off by key
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readButtonPowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading device movement sensitivity.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readMovementSensitivityWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// The scan duration of every 1000ms.If you set the duration to 0ms,the Beacon will stop scanning,
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)readScanWindowDataWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
