//
//  MKTrackerInterface+MKConfig.h
//  MKContactTracker
//
//  Created by aa on 2020/4/27.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKTrackerInterface.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKDeviceTimeProtocol <NSObject>

@property (nonatomic, assign)NSInteger year;

@property (nonatomic, assign)NSInteger month;

@property (nonatomic, assign)NSInteger day;

@property (nonatomic, assign)NSInteger hour;

@property (nonatomic, assign)NSInteger minutes;

@property (nonatomic, assign)NSInteger second;

@end

typedef NS_ENUM(NSInteger, mk_trackerTxPower) {
    mk_trackerTxPower4dBm,       //RadioTxPower:4dBm
    mk_trackerTxPower3dBm,       //3dBm
    mk_trackerTxPower0dBm,       //0dBm
    mk_trackerTxPowerNeg4dBm,    //-4dBm
    mk_trackerTxPowerNeg8dBm,    //-8dBm
    mk_trackerTxPowerNeg12dBm,   //-12dBm
    mk_trackerTxPowerNeg16dBm,   //-16dBm
    mk_trackerTxPowerNeg20dBm,   //-20dBm
    mk_trackerTxPowerNeg40dBm,   //-40dBm
};

typedef NS_ENUM(NSInteger, mk_trackingNotification) {
    mk_closeTrackingNotification,
    mk_ledTrackingNotification,
    mk_motorTrackingNotification,
    mk_ledMotorTrackingNotification,
};

@interface MKTrackerInterface (MKConfig)

/// Configure device time
/// @param protocol protocol
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configDeviceTime:(id <MKDeviceTimeProtocol>)protocol
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the broadcast name of the device
/// @param deviceName 1 ~ 10 length ASCII code characters
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configDeviceName:(NSString *)deviceName
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure iBeacon UUID
/// @param uuid uuid
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configProximityUUID:(NSString *)uuid
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure iBeacon Major
/// @param major 0~65535
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configMajor:(NSInteger)major
           sucBlock:(void (^)(void))sucBlock
        failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure iBeacon Minor
/// @param minor 0~65535
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configMinor:(NSInteger)minor
           sucBlock:(void (^)(void))sucBlock
        failedBlock:(void (^)(NSError *error))failedBlock;

/// Advertising interval
/// @param interval Advertising interval, unit: 100ms, range: 1~100
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configAdvInterval:(NSInteger)interval
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Measured Power
/// @param measuredPower (RSSI@1M),-127~0
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configMeasuredPower:(NSInteger)measuredPower
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Tx Power
/// @param txPower Tx Power
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configTxPower:(mk_trackerTxPower)txPower
             sucBlock:(void (^)(void))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock;

/// Close the current broadcast trigger state
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)closeAdvTriggerConditionsWithSucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Set how long Beacon will stop broadcasting after stopping, and start broadcasting when Beacon moves again.
/// @param time 0 ~ 65535 ,units:S
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configAdvTrigger:(NSInteger)time
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure device data storage interval
/// @param interval 0 mins ~ 255 mins
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configStorageInterval:(NSInteger)interval
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Tracking Notification
/// @param note Tracking Notification
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configTrackingNotification:(mk_trackingNotification)note
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Close the current scanning trigger state
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)closeScanningTriggerConditionsWithSucBlock:(void (^)(void))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Set how long Beacon will stop scanning after stopping, and start scanning when Beacon moves again.
/// @param time 0 ~ 65535 ,units:S
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configScanningTrigger:(NSInteger)time
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the current stored RSSI condition, and store it once when the master scans to the slave signal strength is greater than or equal to this value.
/// @param rssi -127 ~ 0
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configStorageRssi:(NSInteger)rssi
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Turn off this option, the Beacon will store all types of BLE ADV data.Turn on this option, the Beacon will store the corresponding ADV data according to the filtering rules.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configAdvDataFilterStatus:(BOOL)isOn
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Set the current MAC address filtering conditions
/// @param isOn Whether to enable mac address filtering
/// @param mac The mac address to be filtered. If isOn = NO, the item can be omitted. If isOn = YES, the mac address with a maximum length of 12 characters must be filled in.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configMacFilterStatus:(BOOL)isOn
                          mac:(NSString *)mac
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Set the current advertising name filtering conditions
/// @param isOn Whether to enable advertising name filtering
/// @param advName The advertising name to be filtered. If isOn = NO, the item can be omitted. If isOn = YES, the advertising name with a maximum length of 10 characters must be filled in.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configAdvNameFilterStatus:(BOOL)isOn
                              advName:(NSString *)advName
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Set the current proximity UUID filtering conditions
/// @param isOn Whether to enable proximity UUID filtering
/// @param uuid The proximity UUID to be filtered. If isOn = NO, the item can be omitted. 
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configProximityUUIDFilterStatus:(BOOL)isOn
                                   uuid:(NSString *)uuid
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Set the current major filtering conditions
/// @param isOn Whether to enable major filtering
/// @param major The major to be filtered. This value is invalid when isOn = NO.0~65535
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configMajorFilterStatus:(BOOL)isOn
                           major:(NSInteger)major
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Set the current minor filtering conditions.
/// @param isOn Whether to enable minor filtering
/// @param minor The minor to be filtered. This value is invalid when isOn = NO.0~65535
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configMinorFilterStatus:(BOOL)isOn
                          minor:(NSInteger)minor
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Set the current raw advertising data filtering conditions.
/// @param isOn Whether to enable raw advertising data filtering
/// @param rawAdvData The raw advertising data to be filtered. If isOn = NO, the item can be omitted. If isOn = YES, the raw advertising data with a maximum length of 31 bytes must be filled in.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configRawAdvDataFilterStatus:(BOOL)isOn
                          rawAdvData:(NSString *)rawAdvData
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the scan status of the device.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configScanStatus:(BOOL)isOn
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the connectable status of the device.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configConnectableStatus:(BOOL)isOn
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the current key switch status.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configButtonPowerStatus:(BOOL)isOn
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// power off.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)powerOffDeviceWithSucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the device to determine the mobile sensitivity.The larger the value, the more sensitive Beacon judges the movement.
/// @param sensitivity 7~255
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configMovementSensitivity:(NSInteger)sensitivity
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Resetting to factory state (RESET).NOTE:When resetting the device, the connection password will not be restored which shall remain set to its current value.
/// @param password 8-character ascii code characters
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)factoryDataResetWithPassword:(NSString *)password
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the device's connection password.
/// @param password 8-character ascii code characters
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)configPassword:(NSString *)password
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

/// Clear historical data stored on the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)clearAllDatasWithSucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
