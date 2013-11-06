//
//  ETFilterScreenViewController.h
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 10/28/13.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ETFilterScreenDelegate <NSObject>
@optional


@end

@interface ETFilterScreenViewController : UIViewController

- (IBAction)activeFilterStateChanged:(UISwitch *)sender;

@end
