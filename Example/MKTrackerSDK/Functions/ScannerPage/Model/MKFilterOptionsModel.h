//
//  MKFilterOptionsModel.h
//  MKContactTracker
//
//  Created by aa on 2020/4/24.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterOptionsModel : NSObject

@property (nonatomic, assign)NSInteger rssiValue;

@property (nonatomic, assign)BOOL advDataFilterIson;

@property (nonatomic, assign)BOOL macIson;

@property (nonatomic, copy)NSString *macValue;

@property (nonatomic, assign)BOOL advNameIson;

@property (nonatomic, copy)NSString *advNameValue;

@property (nonatomic, assign)BOOL uuidIson;

@property (nonatomic, copy)NSString *uuidValue;

@property (nonatomic, assign)BOOL majorIson;

@property (nonatomic, copy)NSString *majorValue;

@property (nonatomic, assign)BOOL minorIson;

@property (nonatomic, copy)NSString *minorValue;

@property (nonatomic, assign)BOOL rawDataIson;

@property (nonatomic, copy)NSString *rawDataValue;

- (void)startReadDataWithSucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

- (void)startConfigDataWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
