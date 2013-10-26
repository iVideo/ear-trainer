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
}
@end

@implementation ETViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!etManager) {
        etManager = [ETManager sharedInstance];
        [etManager setUpAudio];
        [etManager createFilters];
        [etManager setDelegate:self];
        [self setInAndOutImageView:NO];
        
       self.tap.enabled = NO;
        [self.gainTextField setDelegate:self];
        negative = NO;
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Audio stuff
- (IBAction)pauseAudio:(id)sender {
    
    [etManager pauseAudio];
}

- (IBAction)Play:(id)sender {
    [etManager playAudio];
}



-(UIImageView *)getWaveform
{
   return [etManager getWaveform];
}

#pragma mark - TextField stuff

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.tap.enabled = YES;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tap.enabled = NO;

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    float number;
    
    if (negative) {
        
        number = [[numberFormatter numberFromString:textField.text] floatValue];
        
        number *= -1;
    }
    
    if (!negative) {
        
        number = [[numberFormatter numberFromString:textField.text] floatValue];
    }
    
    NSNumber *gainValue = [NSNumber numberWithFloat:number];
    
    [etManager setGainValue:gainValue];
}


#pragma mark - Media Picker Methods
-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    NSURL *url = [[[mediaItemCollection items] objectAtIndex:0] valueForProperty:MPMediaItemPropertyAssetURL];

    [etManager readAudioFileWithURL:url];
   // self.waveform = [etManager getWaveform];
    
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

- (IBAction)freq:(UISlider *)sender{
    
    [etManager setFreqFromSliderValue:sender.value withTag:sender.tag];
}


- (IBAction)filterState:(UISwitch *)sender {
    
    [etManager filterStateForFilter:sender.tag withState:sender.on];
}

- (IBAction)activateFilter:(UIButton *)sender {
    
    if(etManager.fileReader.playing){
        self.filterNumber.text = [NSString stringWithFormat:@"%i", [etManager selectRandomFilter]];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:etManager selector:@selector(turnFilterOn) userInfo:nil repeats:NO];

    }
}

- (IBAction)cut:(UIButton *)sender {
    
    negative = YES;
    etManager setGainValue:self.gainTextField
}

- (IBAction)boost:(UIButton *)sender {
    
    negative = NO;
}

#pragma mark - Tap Gesture Recognizer
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    
    [self.gainTextField resignFirstResponder];
   // [self textFieldDidEndEditing:self.gainTextField];
}

-(void)setInAndOutImageView:(BOOL)filterOn
{
    
    if (filterOn) {
        
        [self.inOutImageView setImage:[UIImage imageNamed:@"in button.png"]];
    }
    
    if (!filterOn) {
        [self.inOutImageView setImage:[UIImage imageNamed:@"out button.png"]];
    }
    
    
}





@end
