//
//  ETViewController.m
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 15/10/2013.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

#import "ETViewController.h"

@interface ETViewController ()
@end

@implementation ETViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!etManager) {
        etManager = [ETManager sharedInstance];
        [etManager setUpAudio];
        [etManager createFilters];
        
       self.tap.enabled = NO;
        [self.gainTextField setDelegate:self];
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
    [etManager setGainValue:[textField.text floatValue]];
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

//- (IBAction)randomFilter:(UIButton *)sender {
//    
//    
//}

- (IBAction)activateFilter:(UIButton *)sender {
    
    if(etManager.fileReader.playing){
        self.filterNumber.text = [NSString stringWithFormat:@"%i", [etManager selectRandomFilter]];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:etManager selector:@selector(turnFilterOn) userInfo:nil repeats:NO];
        
//        NSMethodSignature *sig =  [etManager methodSignatureForSelector:@selector(turnFilterOn)];
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
//        [invocation setSelector:@selector(turnFilterOn)];
//        [NSTimer timerWithTimeInterval:1.0 invocation:invocation repeats:NO];
        
       // [etManager turnFilterOn];
    }
}

#pragma mark - Tap Gesture Recognizer
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    
    [self.gainTextField resignFirstResponder];
   // [self textFieldDidEndEditing:self.gainTextField];
}





@end
