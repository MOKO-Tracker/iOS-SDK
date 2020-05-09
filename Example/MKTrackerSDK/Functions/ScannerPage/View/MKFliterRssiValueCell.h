//
//  MKFliterRssiValueCell.h
//  MKContactTracker
//
//  Created by aa on 2020/4/24.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKFliterRssiValueCellDelegate <NSObject>

- (void)mk_fliterRssiValueChanged:(NSInteger)rssi;

@end

@interface MKFliterRssiValueCell : MKBaseCell

@property (nonatomic, assign)NSInteger rssi;

@property (nonatomic, weak)id <MKFliterRssiValueCellDelegate>delegate;

+ (MKFliterRssiValueCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
