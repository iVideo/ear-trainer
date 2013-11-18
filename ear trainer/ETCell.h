//
//  ETCell.h
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 17/11/2013.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *cellBackground;
@property (weak, nonatomic) IBOutlet UILabel *freqLabel;

@end
