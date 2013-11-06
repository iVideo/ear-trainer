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
        [self setInAndOutImageView:NO];         // Set the filter in/out image to 'OUT'
        
       self.tap.enabled = NO;                   // Tap recognizer for when keyboard is up (default = disabled)
        [self.gainTextField setDelegate:self];
        negative = NO;                          // Cut or boost, set to boost initially
    }
    
    // Set slider thumb image
    [self.playbackSlider setThumbImage:[UIImage imageNamed:@"sliderthumb.png"] forState:UIControlStateNormal];
    
    
    
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
    self.tap.enabled = YES;             // Enable tap recognizer to be able to dismiss keyboard
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tap.enabled = NO;


    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
   float number = [[numberFormatter numberFromString:textField.text] floatValue];       // Convert textField text to float
    
    [etManager setGainValue:number negative:negative];
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
    [self textFieldDidEndEditing:self.gainTextField];
}

- (IBAction)boost:(UIButton *)sender {
    
    negative = NO;
    [self textFieldDidEndEditing:self.gainTextField];

}

#pragma mark - Tap Gesture Recognizer
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    
    [self.gainTextField resignFirstResponder];
   // [self textFieldDidEndEditing:self.gainTextField];
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


#pragma mark - ETFilterStateHandler delegate methods

- (void)activeFilterStateChanged:(UISwitch *)sender;
{
    
    [etManager filterStateForFilter:sender.tag withState:sender.on];
}

-(void)done
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)setSwitchStates
{
    NSMutableArray *filters = etManager.filterStateHandler.activeFilters;
    
    for (int j = 10; j < 39; j++) {
        UISwitch *uiswitch = (UISwitch *)[self.presentedViewController.view viewWithTag:j];
        
        //        NSLog(@" %i", [[filters objectAtIndex:i] integerValue]);
        [uiswitch setOn:NO animated:NO];
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

#pragma mark - Filter screen
- (IBAction)filterScreen:(id)sender {
    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ETFilterScreenViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterScreen"];
    
    [vc setDelegate:self];
    
    
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

@end
