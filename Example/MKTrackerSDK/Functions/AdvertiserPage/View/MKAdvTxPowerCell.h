//
//  MKAdvTxPowerCell.h
//  MKContactTracker
//
//  Created by aa on 2020/4/23.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKBaseCell.h"
#import "MKAdvertiserCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKAdvTxPowerCell : MKBaseCell

@property (nonatomic, strong)NSDictionary *dataDic;

@property (nonatomic, weak)id <MKAdvertiserCellDelegate>delegate;

+ (MKAdvTxPowerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
