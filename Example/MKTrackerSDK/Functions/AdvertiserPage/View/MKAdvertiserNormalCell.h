//
//  MKAdvertiserNormalCell.h
//  MKContactTracker
//
//  Created by aa on 2020/4/22.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKBaseCell.h"
#import "MKAdvertiserCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class MKAdvertiserNormalCellModel;
@interface MKAdvertiserNormalCell : MKBaseCell

@property (nonatomic, strong)MKAdvertiserNormalCellModel *dataModel;

@property (nonatomic, weak)id <MKAdvertiserCellDelegate>delegate;

+ (MKAdvertiserNormalCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
