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
-(void)setOctaves;
-(void)setOneThirdOctaves;

@optional


@end

@interface ETFilterScreenViewController : UIViewController


@property (weak) id <ETFilterScreenViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;
- (IBAction)octavesButton:(id)sender;
- (IBAction)oneThirdOctavesButton:(id)sender;

@end
