//
//  MKAdvDataFliterCellModel.h
//  MKContactTracker
//
//  Created by aa on 2020/4/24.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAdvDataFliterCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, copy)NSString *textPlaceholder;

@property (nonatomic, assign)NSInteger maxLength;

@property (nonatomic, assign)mk_CustomTextFieldType textFieldType;

@property (nonatomic, copy)NSString *textFieldValue;

@property (nonatomic, assign)NSInteger index;

@end

NS_ASSUME_NONNULL_END
