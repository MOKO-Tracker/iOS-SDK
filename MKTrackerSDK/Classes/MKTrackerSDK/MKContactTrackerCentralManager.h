//
//  MKContactTrackerCentralManager.h
//  MKContactTracker
//
//  Created by aa on 2020/4/22.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBLEBaseDataProtocol.h"

#import "MKBLEOperationID.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_bleCentralConnectStatus) {
    mk_bleCentralConnectStatusUnknow,                                           //未知状态
    mk_bleCentralConnectStatusConnecting,                                       //正在连接
    mk_bleCentralConnectStatusConnected,                                        //连接成功
    mk_bleCentralConnectStatusConnectedFailed,                                  //连接失败
    mk_bleCentralConnectStatusDisconnect,
};

//Notification of device connection status changes.
extern NSString *const mk_peripheralConnectStateChangedNotification;

//Notification of changes in the status of the Bluetooth Center.
extern NSString *const mk_centralManagerStateChangedNotification;

//Notification of receive scanner tracked data.
extern NSString *const mk_receiveScannerTrackedDataNotification;

/*
 After connecting the device, if no password is entered within one minute, it returns 0x00. After successful password change, it returns 0x01, after restoring the factory settings, it returns 0x02, the device has no data communication for two consecutive minutes, it returns 0x03, and the shutdown protocol is sent to make the device shut down and return 0x04.
 note:This notification is available only when the device disconnect type feature monitoring is turned on.
 note:[[MKContactTrackerCentralManager share] notifyDisconnectType:YES];
 */
extern NSString *const mk_deviceDisconnectTypeNotification;

@class CBCentralManager,CBPeripheral;
@class MKContactTrackerModel;

@protocol MKContactTrackerCentralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param trackerModel device
- (void)mk_trackerReceiveDevice:(MKContactTrackerModel *)trackerModel;

@optional

/// Starts scanning equipment.
- (void)mk_trackerStartScan;

/// Stops scanning equipment.
- (void)mk_trackerStopScan;

@end

@interface MKContactTrackerCentralManager : NSObject<MKBLEBaseCentralManagerProtocol>

@property (nonatomic, weak)id <MKContactTrackerCentralManagerScanDelegate>delegate;

/// Current connection status
@property (nonatomic, assign, readonly)mk_bleCentralConnectStatus connectStatus;

+ (MKContactTrackerCentralManager *)shared;

/// Singleton destruction
+ (void)sharedDealloc;

- (nonnull CBCentralManager *)centralManager;

/// Currently connected devices
- (nullable CBPeripheral *)peripheral;

/// Current Bluetooth center status
- (MKCentralManagerState )centralStatus;

/// Bluetooth Center starts scanning
- (void)startScan;

/// Bluetooth center stops scanning
- (void)stopScan;

/// Connect device function
/// @param trackerModel Model
/// @param password Device connection password,8 characters long ascii code
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectDevice:(nonnull MKContactTrackerModel *)trackerModel
             password:(nonnull NSString *)password
             sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock;

- (void)disconnect;

/**
 Whether to monitor device scan data.

 @param notify BOOL
 @return result
 */
- (BOOL)notifyScannerTrackedData:(BOOL)notify;

/// Whether to monitor device disconnect type characteristics
/// @param notify BOOL
- (BOOL)notifyDisconnectType:(BOOL)notify;

/// Start a task for data communication with the device
/// @param operationID operation id
/// @param characteristic characteristic for communication
/// @param resetNum How many data will the communication device return
/// @param commandData Data to be sent to the device for this communication
/// @param successBlock Successful callback
/// @param failureBlock Failure callback
- (void)addTaskWithTaskID:(mk_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
                 resetNum:(BOOL)resetNum
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock;

/// Start a task to read device characteristic data
/// @param operationID operation id
/// @param characteristic characteristic for communication
/// @param successBlock Successful callback
/// @param failureBlock Failure callback
- (void)addReadTaskWithTaskID:(mk_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock;

@end

NS_ASSUME_NONNULL_END
