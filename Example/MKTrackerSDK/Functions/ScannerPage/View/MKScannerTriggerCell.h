//
//  MKScannerTriggerCell.h
//  MKContactTracker
//
//  Created by aa on 2020/4/23.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKBaseCell.h"
#import "MKScannerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKScannerTriggerCell : MKBaseCell

@property (nonatomic, strong)NSDictionary *conditions;

@property (nonatomic, weak)id <MKScannerDelegate>delegate;

+ (MKScannerTriggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
