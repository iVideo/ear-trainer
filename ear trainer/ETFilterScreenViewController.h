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
-(void)removeAllFilters;
-(void)updateGainValue:(float)number;
-(BOOL)getNegative;
-(void)setNegative:(BOOL)booleanValue;
-(float)getUserGain;

@optional


@end

@interface ETFilterScreenViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *controlsView;

@property (weak) id <ETFilterScreenViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;

@property (weak, nonatomic) IBOutlet UITextField *gainTextField;


- (IBAction)done:(id)sender;
- (IBAction)octavesButton:(id)sender;
- (IBAction)oneThirdOctavesButton:(id)sender;
- (IBAction)clearFiltersButton:(id)sender;
- (IBAction)tap:(UITapGestureRecognizer *)sender;
- (IBAction)turnBoostOn:(UIButton *)sender;
- (IBAction)turnCutOn:(UIButton *)sender;

@end
