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
#import "ETFilterScreenViewController.h"
#import "ETCell.h"
#import "ETHeaderView.h"

@interface ETViewController : UIViewController <MPMediaPickerControllerDelegate, UITextFieldDelegate, ETManagerDelegate, ETFilterScreenViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    ETManager *etManager;
}

@property (weak, nonatomic) IBOutlet UIImageView *waveform;
@property (weak, nonatomic) IBOutlet UITextField *gainTextField;
@property (weak, nonatomic) IBOutlet UILabel *filterNumber;
@property (weak, nonatomic) IBOutlet UIImageView *inOutImageView;
@property (weak, nonatomic) IBOutlet UISlider *playbackSlider;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)showMediaPicker:(id)sender;
- (IBAction)Play:(id)sender;
- (IBAction)activateFilter:(UIButton *)sender;
- (IBAction)nowPlayingSlider:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UILabel *elapsedTime;
@property (weak, nonatomic) IBOutlet UILabel *remainingTime;
@property (weak, nonatomic) IBOutlet UISlider *nowPlayingSlider;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;



@property (weak, nonatomic) IBOutlet UIButton *playAndPauseButton;

- (IBAction)filterScreen:(id)sender;

@end
