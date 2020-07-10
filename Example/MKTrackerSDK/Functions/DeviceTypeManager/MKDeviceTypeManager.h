//
//  MKDeviceTypeManager.h
//  MKContactTracker
//
//  Created by aa on 2020/6/30.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKDeviceTypeManager : NSObject

/// 对于设备固件版本号V3.0.X走旧的流程(不支持震动，主值次值走过滤条件—iBeacon-Major类型（0x48/58）/过滤条件—iBeacon-Minor类型（0x49/59）)，其余的走新流程
@property (nonatomic, assign, readonly)BOOL supportNewCommand;

/// 设备类型,04:不带3轴和Flash,05:只带3轴,06:只带Flash,07:同时带3轴和Flash
@property (nonatomic, copy, readonly)NSString *deviceType;

/// deviceType为05和07的支持3轴传感器触发设置
@property (nonatomic, assign, readonly)BOOL supportAdvTrigger;

/// 当前连接密码
@property (nonatomic, copy, readonly)NSString *password;

+ (MKDeviceTypeManager *)shared;

- (void)connectTracker:(MKContactTrackerModel *)trackerModel
              password:(NSString *)password
         completeBlock:(void (^)(NSError *error,BOOL supportNewCommand))completeBlock;

@end

NS_ASSUME_NONNULL_END
