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


@interface ETViewController : UIViewController <MPMediaPickerControllerDelegate>
{
    ETManager *etManager;
}

@property (strong, nonatomic) IBOutlet UIImageView *waveform;


- (IBAction)showMediaPicker:(id)sender;
- (IBAction)pauseAudio:(id)sender;
- (IBAction)Play:(id)sender;
- (IBAction)freq:(UISlider *)sender;

@end
