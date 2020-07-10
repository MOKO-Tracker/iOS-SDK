//
//  MKNumberOfVibCell.h
//  MKContactTracker
//
//  Created by aa on 2020/7/1.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKBaseCell.h"
#import "MKScannerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKNumberOfVibCell : MKBaseCell

@property (nonatomic, assign)NSInteger number;

@property (nonatomic, weak)id <MKScannerDelegate>delegate;

+ (MKNumberOfVibCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
