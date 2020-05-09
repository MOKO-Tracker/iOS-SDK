//
//  MKAdvertiserNormalCellModel.h
//  MKContactTracker
//
//  Created by aa on 2020/4/22.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAdvertiserNormalCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *textPlaceholder;

@property (nonatomic, assign)NSInteger maxLength;

@property (nonatomic, assign)mk_CustomTextFieldType textFieldType;

@property (nonatomic, copy)NSString *textFieldValue;

@end

NS_ASSUME_NONNULL_END
