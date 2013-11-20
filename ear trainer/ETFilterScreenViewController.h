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
-(void)textFieldDidBeginEditing:(UITextField *)textField;
-(void)textFieldDidEndEditing:(UITextField *)textField;

@optional


@end

@interface ETFilterScreenViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak) id <ETFilterScreenViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *gainTextField;


- (IBAction)done:(id)sender;
- (IBAction)octavesButton:(id)sender;
- (IBAction)oneThirdOctavesButton:(id)sender;

@end
