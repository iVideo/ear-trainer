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
@property (weak, nonatomic) IBOutlet UIButton *cutOnOff;
@property (weak, nonatomic) IBOutlet UIButton *boostOnOff;
@property (weak, nonatomic) IBOutlet UIImageView *boostFilter;
@property (weak, nonatomic) IBOutlet UIView *nowPlayingView;


- (IBAction)turnCutOn:(UIButton *)sender;
- (IBAction)turnBoostOn:(UIButton *)sender;
- (IBAction)displayFilterNumber:(id)sender;
- (IBAction)showNowPlaying:(id)sender;
- (IBAction)repeatFilter:(id)sender;

@end

@implementation ETViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    // Set slider thumb image
    [self.playbackSlider setThumbImage:[UIImage imageNamed:@"sliderthumb.png"] forState:UIControlStateNormal];
    if (etManager.fileReader.playing)
        [self.playAndPauseButton setBackgroundImage:[UIImage imageNamed:@"pausebuttonwhite"] forState:UIControlStateNormal];
    else if (!etManager.fileReader.playing)
    [self.playAndPauseButton setBackgroundImage:[UIImage imageNamed:@"playbuttonwhite"] forState:UIControlStateNormal];
    
    self.boostFilter.image = [UIImage imageNamed:@"boostfilter"];
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
    }
    
//    UIBarButtonItem *musicLib = [[UIBarButtonItem alloc] init];
//    musicLib.image = [UIImage imageNamed:@"note"];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    self.songDetailsLabel.text = [NSString stringWithFormat:@"%@ - %@", artist, title];

    [etManager readAudioFileWithURL:url];
   // self.waveform = [etManager getWaveform];
    int songDuration = [[[[mediaItemCollection items ]objectAtIndex:0]valueForProperty:MPMediaItemPropertyPlaybackDuration] integerValue];
    
    [self setupNowPlayingWithDuration:songDuration];
    
    [[[mediaItemCollection items ]objectAtIndex:0]valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    NSLog(@" %@", etManager.fileReader.audioFileURL);
    
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

- (IBAction)turnCutOn:(UIButton *)sender {
    
    if(negative != YES)
    {
        negative = YES;
        [self textFieldDidEndEditing:self.gainTextField];
       
        [self.cutOnOff setBackgroundImage:[UIImage imageNamed:@"onswitch"] forState:UIControlStateNormal];
        [self.boostOnOff setBackgroundImage:[UIImage imageNamed:@"offswitch"] forState:UIControlStateNormal];
    }
}

- (IBAction)turnBoostOn:(UIButton *)sender {
    
    if(negative != NO)
    {
        negative = NO;
        [self textFieldDidEndEditing:self.gainTextField];
        [self.cutOnOff setBackgroundImage:[UIImage imageNamed:@"offswitch"] forState:UIControlStateNormal];
        [self.boostOnOff setBackgroundImage:[UIImage imageNamed:@"onswitch"] forState:UIControlStateNormal];
    }
}

- (IBAction)displayFilterNumber:(id)sender {
    
    self.filterNumber.text = [NSString stringWithFormat:@"%i", [etManager getCurrentFilter]];
}

- (IBAction)showNowPlaying:(id)sender {
    
        if (!self.nowPlayingView.hidden)
        {
            [self.nowPlayingView setHidden:YES];
            [UIView animateWithDuration:0.5 animations:^{
                
                self.collectionView.frame = CGRectMake(0, 20, 320, 474);
                
            } completion:^(BOOL finished) {
                NSLog(@"Done!");
            }];
        }
    else if (self.nowPlayingView.hidden)
    {
        
        [UIView animateWithDuration:0.0 animations:^{
            
            self.collectionView.frame = CGRectMake(0, 64, 320, 410);
            
        } completion:^(BOOL finished) {
            NSLog(@"Done!");
        }];
        [self.nowPlayingView setHidden:NO];
    }
}

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
        [self.inOutImageView setImage:[UIImage imageNamed:@"out button.png"]];
    }
    
    
}



-(void)startNowPlayingTimer
{
    if (_timer == nil)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.01f target:self selector:@selector(updateNowPlaying) userInfo:nil repeats:YES];
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
#pragma mark - Filter screen
- (IBAction)filterScreen:(id)sender {
    
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
        
        if ([temp integerValue] == [etManager getCurrentFilter] + 10)
        {
        
            NSLog(@"you got it right!!#!#$!#$@#$");
            ETCell *cell = (ETCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [cell.cellBackground setImage:[UIImage imageNamed:@"plaincollectionviewright"]];
            
            [self activateFilter:nil];
        }
        else if ([temp integerValue] != [etManager getCurrentFilter] + 10)
        {
            NSLog(@"WRONG!");
            ETCell *cell = (ETCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [cell.cellBackground setImage:[UIImage imageNamed:@"plaincollectionviewwrong"]];
        
        }
        
    }
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
