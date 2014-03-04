//
//  ETViewController.m
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 15/10/2013.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

#import "ETViewController.h"

@interface ETViewController ()
{
    BOOL negative;
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UIView *nowPlayingView;
@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;

- (IBAction)repeatFilter:(id)sender;

@end

@implementation ETViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    // Set slider thumb image
    //[self.nowPlayingSlider setThumbImage:[UIImage imageNamed:@"sliderthumb.png"] forState:UIControlStateNormal];
    
    //Set play/pause button image
    if (etManager.fileReader.playing)
    {
        [self.playAndPauseButton setBackgroundImage:[UIImage imageNamed:@"pausebuttonwhite"] forState:UIControlStateNormal];
    }
    else if (!etManager.fileReader.playing)
    {
    [self.playAndPauseButton setBackgroundImage:[UIImage imageNamed:@"playbuttonwhite"] forState:UIControlStateNormal];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!etManager) {
        etManager = [ETManager sharedInstance];
        [etManager setUpAudio];
        [etManager createFilters];
        [etManager setDelegate:self];
        [self setInAndOutImageView:NO];         // Set the filter in/out image to 'OUT'
        
        [self.gainTextField setDelegate:self];
        negative = NO;                          // Cut or boost, set to boost initially
        
        //self.controlsView.hidden = 1;
        
        etManager.controlsViewHidden = 0;

        
    }
    
    CGRect frame = CGRectMake(0, 500, 320, self.view.frame.size.height - self.nowPlayingView.frame.size.height - self.bottomBar.frame.size.height);
    self.collectionView.frame = frame;

    [self showOrHideControlsViewOnLoad:etManager.controlsViewHidden];
    
    [self.nowPlayingView.layer setBorderWidth:0.5f];
    self.nowPlayingView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    //    UIBarButtonItem *musicLib = [[UIBarButtonItem alloc] init];
//    musicLib.image = [UIImage imageNamed:@"note"];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showOrHideControlsViewOnLoad:(BOOL)controlsViewHidden;
{
    if (controlsViewHidden) {
        
        CGRect frame = CGRectMake(0, 0, 320, 500);
        self.controlsView.frame = frame;
      
    }
    
    else if (!controlsViewHidden)
    {
        
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.nowPlayingView.frame), 320, self.controlsView.frame.size.height);
            self.controlsView.frame = frame;

        
    }
    
}
- (IBAction)toggleControlsView:(BOOL)controlsViewHidden;
{
    controlsViewHidden = etManager.controlsViewHidden;
    
    if (controlsViewHidden) {
      
        CGRect frame = CGRectMake(0, 0, 320, 50);
        frame.origin.y = CGRectGetMaxY(self.nowPlayingView.frame) - frame.size.height;
        self.controlsView.frame = frame;
        
        
        [self.nowPlayingView.superview insertSubview:self.controlsView belowSubview:self.nowPlayingView];
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = _controlsView.frame;
            frame.origin.y = CGRectGetMaxY(self.nowPlayingView.frame);
            self.controlsView.frame = frame;
            
            CGRect cViewFrame = self.collectionView.frame;
            cViewFrame.origin.y = cViewFrame.origin.y - self.controlsView.frame
            .size.height;
            cViewFrame.size.height = cViewFrame.size.height + self.controlsView.frame.size.height;
            self.collectionView.frame = cViewFrame;
            }];
        
        controlsViewHidden = 0;
        etManager.controlsViewHidden = controlsViewHidden;
    }
    
    else if (!controlsViewHidden)
    {
        
        NSLog(@"HIDE");
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = _controlsView.frame;
            frame.origin.y = CGRectGetMaxY(self.nowPlayingView.frame) - frame.size.height;
            self.controlsView.frame = frame;
            
            CGRect cViewFrame = self.collectionView.frame;
            cViewFrame.origin.y = cViewFrame.origin.y - self.controlsView.frame
            .size.height;
            cViewFrame.size.height = cViewFrame.size.height + self.controlsView.frame.size.height;
            self.collectionView.frame = cViewFrame;

    }];
        
        controlsViewHidden = 1;
        etManager.controlsViewHidden = controlsViewHidden;

    }
    
}

#pragma mark - Now Playing methods
-(NSString *)timeFormat:(float)value
{
    
    int seconds = ceilf(value);
    
    //NSLog(@"value is: %f", value);
    int mins = floor(lroundf(value)/60);
    int secs = seconds % 60;
    
    //NSLog(@"current time is: %i", seconds);
    
//    int imins = roundf(mins);
//    int isecs = floorf(secs);
    
    NSString *time = [[NSString alloc] initWithFormat:@"%d:%02d", mins, secs];
    
    return time;
}

-(void)setupNowPlayingWithDuration:(int)duration
{
    
    self.elapsedTime.text = @"0:00";
    self.remainingTime.text = [NSString stringWithFormat:@"- %@", [self timeFormat:etManager.fileReader.duration]];
    self.nowPlayingSlider.maximumValue = duration;
    self.nowPlayingSlider.value = 0.0f;
    
}

-(void)updateNowPlaying
{
    float duration = etManager.fileReader.duration;
    float currentTime = etManager.fileReader.currentTime;
    
    self.elapsedTime.text = [NSString stringWithFormat:@"%@", [self timeFormat:currentTime]];
    self.remainingTime.text = [NSString stringWithFormat:@"-%@", [self timeFormat:(duration - currentTime)]];
   // NSLog(@"current time is: %@", [self timeFormat:currentTime]);

    self.nowPlayingSlider.value = (int)currentTime;
    
    if (duration - currentTime < 1) {
        self.elapsedTime.text = [NSString stringWithFormat:@"--:--"];
        self.remainingTime.text = [NSString stringWithFormat:@"--:--"];
        [etManager.fileReader pause];
        [[etManager getAudioManager] pause];
        
        [self.playAndPauseButton setBackgroundImage:[UIImage imageNamed:@"playbuttonwhite"] forState:UIControlStateNormal];
        
        etManager.fileReader.currentTime = 0.0f;
        self.nowPlayingSlider.value = 0.0f;
        
    }
    
}



#pragma mark - Audio stuff

- (IBAction)Play:(id)sender {
    
    if (etManager.fileReader.audioFileURL != 0)
    {
        if(![etManager getAudioManager].playing)
        {
            [etManager playAudio];
            [self.playAndPauseButton setBackgroundImage:[UIImage imageNamed:@"pausebuttonwhite"] forState:UIControlStateNormal];
        }
        else if ([etManager getAudioManager].playing)
        {
        
            [etManager pauseAudio];
            [self.playAndPauseButton setBackgroundImage:[UIImage imageNamed:@"playbuttonwhite"] forState:UIControlStateNormal];

        }
        
    }
}



-(UIImageView *)getWaveform
{
   return [etManager getWaveform];
}

-(void)updateGainValue:(float)number
{
    [etManager setGainValue:number negative:negative];
}


#pragma mark - Media Picker Methods
-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    NSURL *url = [[[mediaItemCollection items] objectAtIndex:0] valueForProperty:MPMediaItemPropertyAssetURL];
    NSString *title = [[[mediaItemCollection items] objectAtIndex:0] valueForProperty:MPMediaItemPropertyTitle];
    NSString *artist = [[[mediaItemCollection items] objectAtIndex:0] valueForProperty:MPMediaItemPropertyArtist];
    
    
    self.songLabel.text = [NSString stringWithFormat:@"%@ - %@", artist, title];


    [etManager readAudioFileWithURL:url];
   // self.waveform = [etManager getWaveform];
    int songDuration = [[[[mediaItemCollection items ]objectAtIndex:0]valueForProperty:MPMediaItemPropertyPlaybackDuration] integerValue];
    
    [self setupNowPlayingWithDuration:songDuration];
    
    [[[mediaItemCollection items ]objectAtIndex:0]valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showMediaPicker:(id)sender
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.prompt = @"Select songs to play";
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

#pragma mark - Filter stuff

- (IBAction)activateFilter:(UIButton *)sender {
    
    if(etManager.fileReader.playing){
        self.filterNumber.text = [NSString stringWithFormat:@"%i", [etManager selectRandomFilter] + 10];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:etManager selector:@selector(turnFilterOn) userInfo:nil repeats:NO];

    }
}


//- (IBAction)showNowPlaying:(id)sender {
//    
//        if (!self.nowPlayingView.hidden)
//        {
//            [self.nowPlayingView setHidden:YES];
//            [UIView animateWithDuration:0.5 animations:^{
//                CGRect screenRect = [[UIScreen mainScreen] bounds];
//
//                self.collectionView.frame = CGRectMake(0, 20, screenRect.size.width, screenRect.size.height - 92);
//                
//            } completion:^(BOOL finished) {
//                NSLog(@"Done!");
//            }];
//        }
//    else if (self.nowPlayingView.hidden)
//    {
//        
//        [UIView animateWithDuration:0.0 animations:^{
//            
//            CGRect screenRect = [[UIScreen mainScreen] bounds];
//            
//            self.collectionView.frame = CGRectMake(0, 64, screenRect.size.width, screenRect.size.height - 158);
//            
//        } completion:^(BOOL finished) {
//            NSLog(@"Done!");
//        }];
//        [self.nowPlayingView setHidden:NO];
//    }
//}

- (IBAction)repeatFilter:(id)sender {
    
    if([etManager getCurrentFilter] != 5000)
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:etManager selector:@selector(turnFilterOn) userInfo:nil repeats:NO];
}
- (IBAction)nowPlayingSlider:(UISlider *)sender {
    
    [etManager.fileReader setCurrentTime:sender.value];

}

-(BOOL)getNegative
{
    return negative;
}
-(void)setNegative:(BOOL)booleanValue;
{
    negative = booleanValue;
    
}

#pragma mark - ETManager delegate
-(void)setInAndOutImageView:(BOOL)filterOn
{
    
    if (filterOn) {
        
        [self.inOutImageView setImage:[UIImage imageNamed:@"in button.png"]];
    }
    
    if (!filterOn) {
        [self.inOutImageView setImage:[UIImage imageNamed:@"out button2.png"]];
    }
    
    
}



-(void)startNowPlayingTimer
{
    if (_timer == nil)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateNowPlaying) userInfo:nil repeats:YES];
    }
    
}

-(void)stopNowPlayingTimer
{
    if (_timer != nil)
    {
        [_timer invalidate];
        _timer = nil;
    }
}



#pragma mark - ETFilterStateHandler delegate methods

- (void)activeFilterStateChanged:(UISwitch *)sender;
{
    
    [etManager filterStateForFilter:sender.tag withState:sender.on];
}

-(void)done
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [self.collectionView reloadData];
}

-(void)setSwitchStates
{
    NSMutableArray *filters = etManager.filterStateHandler.activeFilters;
    
    for (int j = 10; j < 39; j++) {
        UISwitch *uiswitch = (UISwitch *)[self.presentedViewController.view viewWithTag:j];
        
        //        NSLog(@" %i", [[filters objectAtIndex:i] integerValue]);
        [uiswitch setOn:NO animated:NO];
        [uiswitch setOffImage:[UIImage imageNamed:@"onswitch"]];
    }
    
    for (int i = 0; i < [filters count]; i++) {
        UISwitch *uiswitch = (UISwitch *)[self.presentedViewController.view viewWithTag:[[filters objectAtIndex:i] integerValue]];
        
//        NSLog(@" %i", [[filters objectAtIndex:i] integerValue]);
        [uiswitch setOn:YES animated:NO];
        
    }
    
    [filters enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"this is inside the array%@", obj);
    }];
}

-(void)setOctaves
{
    [etManager.filterStateHandler.activeFilters removeAllObjects];
    
    for(int i = 10; i < 38; i += 3)
    {
        [etManager.filterStateHandler updateFilter:i withState:YES];
    }
    
    [self setSwitchStates];
}

-(void)setOneThirdOctaves
{
    [etManager.filterStateHandler.activeFilters removeAllObjects];
    
    for(int i = 10; i < 39; i += 1)
    {
        [etManager.filterStateHandler updateFilter:i withState:YES];
    }
    
    [self setSwitchStates];
}
-(void)removeAllFilters
{
    [etManager.filterStateHandler.activeFilters removeAllObjects];
    [self setSwitchStates];
}

-(float)getUserGain
{
    return [etManager getUserGain];
}

#pragma mark - Filter screen
- (IBAction)filterScreen:(id)sender {
    
    [self dehighlightcollectionviewcell];
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ETFilterScreenViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterScreen"];
    
    [vc setDelegate:self];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - CollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [etManager.filterStateHandler.activeFilters count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"1st";
    
    ETCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (etManager) {
        NSNumber *number = [etManager.filterStateHandler.activeFilters objectAtIndex:indexPath.row];
        float freqVal = [etManager getFrequencyOfActiveFilters:number];
        NSString *freq = nil;
        
        
        if (freqVal >= 1000) {
            freqVal = freqVal / 1000;
        
            if(floor(freqVal) == freqVal)                                   // if freqVal is an integer after dividing, have it display no decimal places, else display with 3 S.F.s
                freq = [NSString stringWithFormat:@"%.0f kHz", freqVal];
                else
                freq = [NSString stringWithFormat:@"%.3g kHz", freqVal];
        }
        else
        freq = [NSString stringWithFormat:@"%.0f Hz", freqVal];     // If the value is smaller than 1000, just display with no decimal places.
        

        cell.freqLabel.text = freq;
        //cell.cellBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"collectionview"]];
    }
    return cell;
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([etManager getAudioManager].playing && [etManager getCurrentFilter] != 5000)
    {
        
        NSNumber *temp = [etManager.filterStateHandler.activeFilters objectAtIndex:indexPath.row];
        
        NSLog(@" %@", temp);
        
        
        // If user selects the correct frequency, paint cell green and go onto next filter
        if ([temp integerValue] == [etManager getCurrentFilter] + 10)
        {
        
            NSLog(@"you got it right!!#!#$!#$@#$");
            ETCell *cell = (ETCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [cell.cellBackground setImage:[UIImage imageNamed:@"plaincollectionviewright"]];
            
            [etManager selectRandomFilter];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:etManager selector:@selector(turnFilterOn) userInfo:nil repeats:NO];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dehighlightcollectionviewcell) userInfo:nil repeats:NO];

            
        }
        else if ([temp integerValue] != [etManager getCurrentFilter] + 10)
        {
            NSLog(@"WRONG!");
            ETCell *cell = (ETCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [cell.cellBackground setImage:[UIImage imageNamed:@"plaincollectionviewwrong"]];
        
        }
        
    }
}

-(void)dehighlightcollectionviewcell
{
    
    for (ETCell *cell in self.collectionView.visibleCells) {
        
        [cell.cellBackground setImage:[UIImage imageNamed:@"plaincollectionview"]];

    }
//    NSArray *cells = [_collectionView visibleCells];
//    
//    for (int i=0; i < [cells count]; i++) {
//        
//        [cells[i] setImage:[UIImage imageNamed:@"plaincollectionview"]];
//
//    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ETCell *cell = (ETCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.cellBackground setImage:[UIImage imageNamed:@"plaincollectionview"]];
    
}

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    
//    static NSString *headerViewIdentifier = @"collectionViewTitle";
//    
//    ETHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
//    
//    return headerView;
//    
//    
//    
//}




@end
