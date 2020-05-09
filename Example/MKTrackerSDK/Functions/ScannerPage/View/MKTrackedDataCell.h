//
//  MKTrackedDataCell.h
//  MKBLEGateway
//
//  Created by aa on 2019/9/19.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@class MKDeviceMainPageModel;
@interface MKTrackedDataCell : MKBaseCell

@property (nonatomic, strong)NSDictionary *dataModel;

+ (MKTrackedDataCell *)initCellWithTableView:(UITableView *)tableView;

+ (CGFloat)fetchCellHeight:(NSDictionary *)dataDic;

@end

NS_ASSUME_NONNULL_END
