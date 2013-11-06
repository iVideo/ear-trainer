//
//  ETFilterScreenViewController.h
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 10/28/13.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ETFilterScreenViewControllerDelegate <NSObject>

@required
-(void)done;
-(void)activeFilterStateChanged:(UISwitch *)sender;
-(void)setSwitchStates;

@optional


@end

@interface ETFilterScreenViewController : UIViewController


@property (weak) id <ETFilterScreenViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;

@end
