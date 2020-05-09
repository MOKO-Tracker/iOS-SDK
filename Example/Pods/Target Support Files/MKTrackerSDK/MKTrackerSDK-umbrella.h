#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MKContactTrackerSDK.h"
#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseDataProtocol.h"
#import "MKBLEBaseSDK.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"
#import "CBPeripheral+MKContactTracker.h"
#import "MKBLEOperation.h"
#import "MKBLEOperationDataAdopter.h"
#import "MKBLEOperationID.h"
#import "MKContackTrackerPeripheral.h"
#import "MKContactTrackerCentralManager.h"
#import "MKContactTrackerModel.h"
#import "MKContactTrackerSDKDefines.h"
#import "MKTrackerAdopter.h"
#import "MKTrackerInterface+MKConfig.h"
#import "MKTrackerInterface.h"

FOUNDATION_EXPORT double MKTrackerSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char MKTrackerSDKVersionString[];

