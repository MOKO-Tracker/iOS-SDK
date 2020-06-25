//
//  MKBLEOperationDataAdopter.m
//  MKBLEBaseModule_Example
//
//  Created by aa on 2019/11/19.
//  Copyright © 2019 aadyx2007@163.com. All rights reserved.
//

#import "MKBLEOperationDataAdopter.h"
#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"
#import "MKContactTrackerSDKDefines.h"

#import "MKBLEOperationID.h"

NSString *const mk_communicationDataNum = @"mk_communicationDataNum";

@implementation MKBLEOperationDataAdopter

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSData *readData = characteristic.value;
    NSLog(@"+++++%@-----%@",characteristic.UUID.UUIDString,readData);
    if ([characteristic.UUID isEqual:MKUUID(@"2A19")]) {
        //电池电量
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *battery = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        return [self dataParserGetDataSuccess:@{@"batteryPower":battery} operationID:mk_taskReadBatteryPowerOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"2A24")]) {
        //产品型号
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"modeID":tempString} operationID:mk_taskReadDeviceModelOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"2A25")]) {
        //生产日期
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"productionDate":tempString} operationID:mk_taskReadProductionDateOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"2A26")]) {
        //firmware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"firmware":tempString} operationID:mk_taskReadFirmwareOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"2A27")]) {
        //hardware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"hardware":tempString} operationID:mk_taskReadHardwareOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"2A28")]) {
        //soft ware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"software":tempString} operationID:mk_taskReadSoftwareOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"2A29")]) {
        //manufacturerKey
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"manufacturer":tempString} operationID:mk_taskReadManufacturerOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF08")]) {
        //当前设备状态，解锁或者修改密码或者锁定状态
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        return [self dataParserGetDataSuccess:@{@"state":content} operationID:mk_taskConfigPasswordOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF0A")]) {
        //设备扫描状态
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        BOOL isOn = [content isEqualToString:@"01"];
        return [self dataParserGetDataSuccess:@{@"isOn":@(isOn)} operationID:mk_taskReadScanStatusOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF0B")]) {
        //设备扫描状态
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        BOOL isOn = [content isEqualToString:@"01"];
        return [self dataParserGetDataSuccess:@{@"isOn":@(isOn)} operationID:mk_taskReadConnectableStatusOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF00")]) {
        //设备类型
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        return [self dataParserGetDataSuccess:@{@"deviceType":content} operationID:mk_taskReadDeviceTypeOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF01")]) {
        //uuid
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:[content substringWithRange:NSMakeRange(0, 8)],
                                 [content substringWithRange:NSMakeRange(8, 4)],
                                 [content substringWithRange:NSMakeRange(12, 4)],
                                 [content substringWithRange:NSMakeRange(16,4)],
                                 [content substringWithRange:NSMakeRange(20, 12)], nil];
        [array insertObject:@"-" atIndex:1];
        [array insertObject:@"-" atIndex:3];
        [array insertObject:@"-" atIndex:5];
        [array insertObject:@"-" atIndex:7];
        NSString *uuid = @"";
        for (NSString *string in array) {
            uuid = [uuid stringByAppendingString:string];
        }
        uuid = [uuid uppercaseString];
        return [self dataParserGetDataSuccess:@{@"uuid":uuid} operationID:mk_taskReadProximityUUIDOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF02")]) {
        //major
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *major = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        return [self dataParserGetDataSuccess:@{@"major":major} operationID:mk_taskReadMajorOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF03")]) {
        //minor
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *minor = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        return [self dataParserGetDataSuccess:@{@"minor":minor} operationID:mk_taskReadMinorOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF04")]) {
        //RSSI@1M
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *measuredPower = [NSString stringWithFormat:@"%ld",(long)[[MKBLEBaseSDKAdopter signedHexTurnString:content] integerValue]];
        return [self dataParserGetDataSuccess:@{@"measuredPower":measuredPower} operationID:mk_taskReadMeasuredPowerOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF05")]) {
        //txPower
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        return [self dataParserGetDataSuccess:@{@"txPower":[self fetchTxPower:content]} operationID:mk_taskReadTxPowerOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF06")]) {
        //adv interval
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *interval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        return [self dataParserGetDataSuccess:@{@"interval":interval} operationID:mk_taskReadBroadcastIntervalOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF07")]) {
        //设备名称
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"deviceName":tempString} operationID:mk_taskReadDeviceNameOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF09")]) {
        //电池电压
        return [self batteryData:readData];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF0C")]) {
        //存储提醒
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        return [self dataParserGetDataSuccess:@{@"reminder":content} operationID:mk_taskReadStorageReminderOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF10")]) {
        //自定义协议部分
        return [self parseFF10Data:readData];
    }
    return @{};
}

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    mk_taskOperationID operationID = mk_defaultTaskOperationID;
    if ([characteristic.UUID isEqual:MKUUID(@"FF01")]) {
        //UUID
        operationID = mk_taskConfigProximityUUIDOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF02")]) {
        //Major
        operationID = mk_taskConfigMajorOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF03")]) {
        operationID = mk_taskConfigMinorOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF04")]) {
        operationID = mk_taskConfigMeasuredPowerOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF05")]) {
        operationID = mk_taskConfigTxPowerOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF06")]) {
        operationID = mk_taskConfigAdvIntervalOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF07")]) {
        operationID = mk_taskConfigDeviceNameOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF0A")]) {
        operationID = mk_taskConfigScanStatusOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF0B")]) {
        operationID = mk_taskConfigConnectableStatusOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF0C")]) {
        operationID = mk_taskConfigStorageReminderOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF0F")]) {
        operationID = mk_taskConfigFactoryDataResetOperation;
    }
    return [self dataParserGetDataSuccess:@{@"success":@(YES)} operationID:operationID];
}

#pragma mark -
+ (NSDictionary *)parseFF10Data:(NSData *)characteristicData {
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristicData];
    if (content.length < 8) {
        return @{};
    }
    NSString *header = [content substringWithRange:NSMakeRange(0, 2)];
    if (![header isEqualToString:@"eb"]) {
        return @{};
    }
    NSInteger len = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(6, 2)];
    if (content.length != 2 * len + 8) {
        return @{};
    }
    NSString *function = [content substringWithRange:NSMakeRange(2, 2)];
    NSDictionary *returnDic = @{};
    mk_taskOperationID operationID = mk_defaultTaskOperationID;
    if ([function isEqualToString:@"20"]) {
        //读取mac address
        NSString *tempMac = [[content substringWithRange:NSMakeRange(8, 12)] uppercaseString];
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[tempMac substringWithRange:NSMakeRange(0, 2)],[tempMac substringWithRange:NSMakeRange(2, 2)],[tempMac substringWithRange:NSMakeRange(4, 2)],[tempMac substringWithRange:NSMakeRange(6, 2)],[tempMac substringWithRange:NSMakeRange(8, 2)],[tempMac substringWithRange:NSMakeRange(10, 2)]];
        operationID = mk_taskReadMacAddressOperation;
        returnDic = @{@"macAddress":macAddress};
    }else if ([function isEqualToString:@"21"]) {
        //移动触发条件
        BOOL isOn = NO;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (content.length == 12) {
            NSString *time = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 4)];
            [dic setValue:time forKey:@"time"];
            isOn = YES;
        }
        [dic setValue:@(isOn) forKey:@"isOn"];
        returnDic = @{
            @"conditions":dic
        };
        operationID = mk_taskReadADVTriggerConditionsOperation;
    }else if ([function isEqualToString:@"22"]) {
        BOOL isOn = NO;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (content.length == 12) {
            NSString *time = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 4)];
            [dic setValue:time forKey:@"time"];
            isOn = YES;
        }
        [dic setValue:@(isOn) forKey:@"isOn"];
        returnDic = @{
            @"conditions":dic
        };
        operationID = mk_taskReadScanningTriggerConditionsOperation;
    }else if ([function isEqualToString:@"23"] && content.length == 10) {
        //读取存储RSSI条件
        NSString *rssi = [NSString stringWithFormat:@"%ld",(long)[[MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(8, 2)]] integerValue]];
        returnDic = @{
                       @"rssi":rssi,
                       };
        operationID = mk_taskReadStorageRssiOperation;
    }else if ([function isEqualToString:@"24"] && content.length == 10) {
        //读取存储间隔
        returnDic = @{
                       @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 2)],
                       };
        operationID = mk_taskReadStorageIntervalOperation;
    }else if ([function isEqualToString:@"26"] && content.length == 8) {
        //关机
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigPowerOffOperation;
    }else if ([function isEqualToString:@"28"] && content.length == 10) {
        //读取按键开关机状态
        BOOL isOn = [[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"];
        returnDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_taskReadButtonPowerStatusOperation;
    }else if ([function isEqualToString:@"29"] && content.length == 8) {
        //情况缓存
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskClearAllDatasOperation;
    }else if ([function isEqualToString:@"31"] && content.length == 8) {
        //配置扫描条件
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigAdvTriggerConditionsOperation;
    }else if ([function isEqualToString:@"32"] && content.length == 8) {
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigScanningTriggerConditionsOperation;
    }else if ([function isEqualToString:@"33"] && content.length == 8) {
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigStorageRssiOperation;
    }else if ([function isEqualToString:@"34"] && content.length == 8) {
        //配置存储间隔
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigStorageIntervalOperation;
    }else if ([function isEqualToString:@"35"] && content.length == 8) {
        //配置设备时间
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigDateOperation;
    }else if ([function isEqualToString:@"38"] && content.length == 8) {
        //配置按键开关机状态
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigButtonPowerStatusOperation;
    }else if ([function isEqualToString:@"40"] && content.length == 10) {
        //读取设备移动灵敏度
        NSString *sensitivity = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 2)];
        returnDic = @{
                       @"sensitivity":sensitivity,
                       };
        operationID = mk_taskReadMovementSensitivityOperation;
    }else if ([function isEqualToString:@"41"]) {
        //读取mac过滤条件
        BOOL isOn = [[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"];
        NSString *mac = @"";
        if (isOn && content.length > 12) {
            mac = [content substringWithRange:NSMakeRange(10, len * 2 - 2)];
        }
        returnDic = @{
                       @"isOn":@(isOn),
                       @"filterMac":mac
                       };
        operationID = mk_taskReadMacFilterStatusOperation;
    }else if ([function isEqualToString:@"42"]) {
        //读取advName过滤条件
        BOOL isOn = [[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"];
        NSString *advName = @"";
        if (isOn && content.length > 12) {
            advName = [[NSString alloc] initWithData:[characteristicData subdataWithRange:NSMakeRange(5, len - 1)] encoding:NSUTF8StringEncoding];
        }
        returnDic = @{
                       @"isOn":@(isOn),
                       @"advName":advName
                       };
        operationID = mk_taskReadAdvNameFilterStatusOperation;
    }else if ([function isEqualToString:@"43"]) {
        //读取raw adv data过滤条件
        BOOL isOn = [[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"];
        NSString *rawAdvData = @"";
        if (isOn && content.length >= 12) {
            rawAdvData = [content substringWithRange:NSMakeRange(10, 2 * (len - 1))];
        }
        returnDic = @{
                       @"isOn":@(isOn),
                       @"rawAdvData":rawAdvData
                       };
        operationID = mk_taskReadRawAdvDataFilterStatusOperation;
    }else if ([function isEqualToString:@"46"] && content.length == 10) {
        //读取advData过滤条件状态
        NSString *status = [content substringWithRange:NSMakeRange(8, 2)];
        returnDic = @{
                       @"isOn":@([status isEqualToString:@"00"])
                       };
        operationID = mk_taskReadAdvDataFilterStatusOperation;
    }else if ([function isEqualToString:@"47"]) {
        //读取uuid过滤条件状态
        BOOL isOn = (content.length == 40);
        NSString *uuid = @"";
        if (isOn) {
            NSString *tempUUID = [content substringWithRange:NSMakeRange(8, 32)];
            NSMutableArray *array = [NSMutableArray arrayWithObjects:[tempUUID substringWithRange:NSMakeRange(0, 8)],
                                     [tempUUID substringWithRange:NSMakeRange(8, 4)],
                                     [tempUUID substringWithRange:NSMakeRange(12, 4)],
                                     [tempUUID substringWithRange:NSMakeRange(16,4)],
                                     [tempUUID substringWithRange:NSMakeRange(20, 12)], nil];
            [array insertObject:@"-" atIndex:1];
            [array insertObject:@"-" atIndex:3];
            [array insertObject:@"-" atIndex:5];
            [array insertObject:@"-" atIndex:7];
            for (NSString *string in array) {
                uuid = [uuid stringByAppendingString:string];
            }
            uuid = [uuid uppercaseString];
        }
        
        returnDic = @{
                       @"isOn":@(isOn),
                       @"uuid":uuid,
                       };
        operationID = mk_taskReadProximityUUIDFilterStatusOperation;
    }else if ([function isEqualToString:@"48"]) {
        //读取major过滤条件状态
        BOOL isOn = (content.length == 12);
        NSString *major = @"";
        if (isOn) {
            major = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 4)];
        }
        returnDic = @{
                       @"isOn":@(isOn),
                       @"major":major
                       };
        operationID = mk_taskReadMajorFilterStatusOperation;
    }else if ([function isEqualToString:@"49"]) {
        //读取minor过滤条件状态
        BOOL isOn = (content.length == 12);
        NSString *minor = @"";
        if (isOn) {
            minor = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 4)];
        }
        returnDic = @{
                       @"isOn":@(isOn),
                       @"minor":minor
                       };
        operationID = mk_taskReadMinorFilterStatusOperation;
    }else if ([function isEqualToString:@"50"] && content.length == 8) {
        //配置当前设备移动灵敏度
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigMovementSensitivityOperation;
    }else if ([function isEqualToString:@"51"] && content.length == 8) {
        //配置当前mac地址过滤条件
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigMacFilterStatusOperation;
    }else if ([function isEqualToString:@"52"] && content.length == 8) {
        //配置当前advName地址过滤条件
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigAdvNameFilterStatusOperation;
    }else if ([function isEqualToString:@"53"] && content.length == 8) {
        //配置当前raw adv dat地址过滤条件
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigRawAdvDataFilterStatusOperation;
    }else if ([function isEqualToString:@"56"] && content.length == 8) {
        //配置advData过滤条件状态
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigAdvDataFilterStatusOperation;
    }else if ([function isEqualToString:@"57"] && content.length == 8) {
        //配置proximity uuid过滤条件状态
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigProximityUUIDFilterStatusOperation;
    }else if ([function isEqualToString:@"58"] && content.length == 8) {
        //配置major过滤条件状态
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigMajorFilterStatusOperation;
    }else if ([function isEqualToString:@"59"] && content.length == 8) {
        //配置minor过滤条件状态
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigMinorFilterStatusOperation;
    }else if ([function isEqualToString:@"60"] && content.length == 10) {
        //读取scan window
        NSString *value = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 2)];
        returnDic = @{
                       @"value":value,
                       };
        operationID = mk_taskReadScanWindowDataOperation;
    }else if ([function isEqualToString:@"70"] && content.length == 8) {
        //配置scan window
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskConfigScannWindowOperation;
    }else if ([function isEqualToString:@"f1"] && content.length == 8) {
        //震动
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_taskSendVibrationCommandsOperation;
    }
    return [self dataParserGetDataSuccess:returnDic operationID:operationID];
}

+ (NSDictionary *)batteryData:(NSData *)data{
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:data];
    if (!content || content.length != 4) {
        return @{};
    }
    NSString *battery = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
    return [self dataParserGetDataSuccess:@{@"batteryVoltage":battery} operationID:mk_taskReadBatteryVoltageOperation];
}

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_taskOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

+ (NSString *)fetchTxPower:(NSString *)content {
    if ([content isEqualToString:@"04"]) {
        return @"4dBm";
    }
    if ([content isEqualToString:@"03"]) {
        return @"3dBm";
    }
    if ([content isEqualToString:@"00"]) {
        return @"0dBm";
    }
    if ([content isEqualToString:@"fc"]) {
        return @"-4dBm";
    }
    if ([content isEqualToString:@"f8"]) {
        return @"-8dBm";
    }
    if ([content isEqualToString:@"f4"]) {
        return @"-12dBm";
    }
    if ([content isEqualToString:@"f0"]) {
        return @"-16dBm";
    }
    if ([content isEqualToString:@"ec"]) {
        return @"-20dBm";
    }
    if ([content isEqualToString:@"d8"]) {
        return @"-40dBm";
    }
    return @"-4dBm";
}

@end
