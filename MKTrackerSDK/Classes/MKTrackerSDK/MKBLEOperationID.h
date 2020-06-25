
typedef NS_ENUM(NSInteger, mk_taskOperationID) {
    mk_defaultTaskOperationID,
    
#pragma mark - Read
    mk_taskReadBatteryPowerOperation,       //电池电量
    mk_taskReadManufacturerOperation,       //读取厂商信息
    mk_taskReadDeviceModelOperation,        //读取产品型号
    mk_taskReadProductionDateOperation,     //读取生产日期
    mk_taskReadHardwareOperation,           //读取硬件类型
    mk_taskReadSoftwareOperation,           //读取软件版本
    mk_taskReadFirmwareOperation,           //读取固件版本
    mk_taskReadBatteryVoltageOperation,     //读取电池电压
    
    mk_taskReadDeviceTypeOperation,         //读取产品类型
    mk_taskReadMacAddressOperation,         //读取mac地址
    mk_taskReadDeviceNameOperation,         //读取设备广播名称
    mk_taskReadProximityUUIDOperation,      //Proximity UUID
    mk_taskReadMajorOperation,              //major
    mk_taskReadMinorOperation,              //minor
    mk_taskReadBroadcastIntervalOperation,  //广播间隔
    mk_taskReadMeasuredPowerOperation,      //RSSI@1m
    mk_taskReadTxPowerOperation,            //tx power
    mk_taskReadADVTriggerConditionsOperation,   //移动触发条件
    mk_taskReadStorageIntervalOperation,        //存储间隔
    mk_taskReadStorageReminderOperation,        //追踪提醒
    mk_taskReadScanningTriggerConditionsOperation,
    mk_taskReadStorageRssiOperation,
    mk_taskReadAdvDataFilterStatusOperation,
    mk_taskReadMacFilterStatusOperation,
    mk_taskReadAdvNameFilterStatusOperation,
    mk_taskReadProximityUUIDFilterStatusOperation,
    mk_taskReadMajorFilterStatusOperation,
    mk_taskReadMinorFilterStatusOperation,
    mk_taskReadRawAdvDataFilterStatusOperation,
    mk_taskReadScanStatusOperation,
    mk_taskReadConnectableStatusOperation,
    mk_taskReadButtonPowerStatusOperation,
    mk_taskReadMovementSensitivityOperation,
    mk_taskReadScanWindowDataOperation,
    
#pragma mark - Config
    mk_taskConfigDateOperation,             //设置时间
    mk_taskConfigDeviceNameOperation,       //设置广播名称
    mk_taskConfigProximityUUIDOperation,    //设置UUID
    mk_taskConfigMajorOperation,            //设置Major
    mk_taskConfigMinorOperation,            //设置Minor
    mk_taskConfigAdvIntervalOperation,      //设置广播间隔
    mk_taskConfigMeasuredPowerOperation,    //设置RSSI@1m
    mk_taskConfigTxPowerOperation,          //设置Tx Power
    mk_taskConfigAdvTriggerConditionsOperation, //移动触发条件
    mk_taskConfigStorageIntervalOperation,      //设置存储间隔
    mk_taskConfigStorageReminderOperation,      //设置追踪报警
    mk_taskConfigScanningTriggerConditionsOperation,
    mk_taskConfigStorageRssiOperation,
    mk_taskConfigAdvDataFilterStatusOperation,
    mk_taskConfigMacFilterStatusOperation,
    mk_taskConfigAdvNameFilterStatusOperation,
    mk_taskConfigProximityUUIDFilterStatusOperation,
    mk_taskConfigMajorFilterStatusOperation,
    mk_taskConfigMinorFilterStatusOperation,
    mk_taskConfigRawAdvDataFilterStatusOperation,
    mk_taskConfigScanStatusOperation,
    mk_taskConfigConnectableStatusOperation,
    mk_taskConfigButtonPowerStatusOperation,
    mk_taskConfigPowerOffOperation,
    mk_taskConfigMovementSensitivityOperation,//
    mk_taskConfigScannWindowOperation,
    mk_taskConfigFactoryDataResetOperation,
    mk_taskConfigPasswordOperation,               //密码
    mk_taskClearAllDatasOperation,
    mk_taskSendVibrationCommandsOperation,
};
