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
- (IBAction)showMediaPicker:(id)sender;

@end
