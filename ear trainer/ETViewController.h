//
//  ETViewController.h
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 15/10/2013.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ETManager.h"


@interface ETViewController : UIViewController <MPMediaPickerControllerDelegate, UITextFieldDelegate, ETManagerDelegate>
{
    ETManager *etManager;
}

@property (strong, nonatomic) IBOutlet UIImageView *waveform;
@property (strong, nonatomic) IBOutlet UITextField *gainTextField;
@property (strong, nonatomic) IBOutlet UILabel *filterNumber;
@property (strong, nonatomic) IBOutlet UIImageView *inOutImageView;

- (IBAction)showMediaPicker:(id)sender;
- (IBAction)pauseAudio:(id)sender;
- (IBAction)Play:(id)sender;
- (IBAction)freq:(UISlider *)sender;
- (IBAction)tap:(UITapGestureRecognizer *)sender;
- (IBAction)filterState:(UISwitch *)sender;
- (IBAction)activateFilter:(UIButton *)sender;
- (IBAction)cut:(UIButton *)sender;
- (IBAction)boost:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;


@end
