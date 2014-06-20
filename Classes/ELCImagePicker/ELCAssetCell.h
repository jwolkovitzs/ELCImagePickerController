//
//  AssetCell.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ELCAssetCell : UITableViewCell
@property (nonatomic) int maxInRow;
- (void)setAssets:(NSArray *)assets withMaxInRow:(int)maxCount;

@end
