//
//  ETFilterScreenViewController.m
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 10/28/13.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

#import "ETFilterScreenViewController.h"

@interface ETFilterScreenViewController ()

@property (weak, nonatomic) IBOutlet UIButton *boostOnOff;
@property (weak, nonatomic) IBOutlet UIButton *cutOnOff;

@property (strong, nonatomic) UIView *inputAccessoryView;
@end

@implementation ETFilterScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupDisplay];
    
    // Register for keyboard notifications
    [self registerForKeyboardNotifications];
 
    self.tap.enabled = NO;                   // Tap recognizer for when keyboard is up (default = disabled)
    [self.gainTextField setDelegate:self];
    
    self.gainTextField.text = [NSString stringWithFormat:@"%.1f", [self.delegate getUserGain]];
    
    BOOL negative = [self.delegate getNegative];
    if(negative == NO)
    {
        
        [self.cutOnOff setBackgroundImage:[UIImage imageNamed:@"offswitch"] forState:UIControlStateNormal];
        [self.boostOnOff setBackgroundImage:[UIImage imageNamed:@"onswitch"] forState:UIControlStateNormal];
    }
    else if (negative == YES)
    {
        [self.cutOnOff setBackgroundImage:[UIImage imageNamed:@"onswitch"] forState:UIControlStateNormal];
        [self.boostOnOff setBackgroundImage:[UIImage imageNamed:@"offswitch"] forState:UIControlStateNormal];
        
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 40, 0.0);
    self.scrollView.contentInset = contentInsets;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)activeFilterStateChanged:(UISwitch *)sender {
    
    [self.delegate activeFilterStateChanged:sender];
}
- (IBAction)done:(id)sender {
    
    [self.delegate done];
}

- (IBAction)octavesButton:(id)sender {
    
    [self.delegate setOctaves];
}

- (IBAction)oneThirdOctavesButton:(id)sender {
    
    [self.delegate setOneThirdOctaves];
    
}

- (IBAction)clearFiltersButton:(id)sender {
    [self.delegate removeAllFilters];
}
#pragma mark - Tap Gesture Recognizer

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self dismissingKeyboard];
}

- (IBAction)turnBoostOn:(UIButton *)sender {
    
    BOOL negative = [self.delegate getNegative];
    
    if(negative != NO)
    {
        [self.delegate setNegative:NO];
    
        float gain = [self.delegate getUserGain];
        
        gain *= -1;
    
        
        self.gainTextField.text = [NSString stringWithFormat:@"%.1f", gain];
        
        [self.delegate updateGainValue:gain];
        
        [self.cutOnOff setBackgroundImage:[UIImage imageNamed:@"offswitch"] forState:UIControlStateNormal];
        [self.boostOnOff setBackgroundImage:[UIImage imageNamed:@"onswitch"] forState:UIControlStateNormal];
    }
}

- (IBAction)turnCutOn:(UIButton *)sender {
    
   BOOL negative = [self.delegate getNegative];
    if(negative != YES)
   {
      [self.delegate setNegative:YES];
    
    
        float gain = [self.delegate getUserGain];
    
        gain *= -1;
        
        
        self.gainTextField.text = [NSString stringWithFormat:@"%.1f", gain];
        [self.delegate updateGainValue:gain];
        
        
        

        [self.cutOnOff setBackgroundImage:[UIImage imageNamed:@"onswitch"] forState:UIControlStateNormal];
        [self.boostOnOff setBackgroundImage:[UIImage imageNamed:@"offswitch"] forState:UIControlStateNormal];
    }
}

-(UIView *)inputAccessoryView

{
    
    if (!_inputAccessoryView) {
        CGRect accessFrame = CGRectMake(0.0, 0.0, 320, 40);
        _inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
        _inputAccessoryView.backgroundColor = [UIColor whiteColor];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        doneButton.frame = CGRectMake(250, 10, 50, 20);
        doneButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(dismissingKeyboard) forControlEvents:UIControlEventTouchUpInside];
        
        [_inputAccessoryView addSubview:doneButton];
        
    }
    
    return _inputAccessoryView;
}
#pragma mark - TextField stuff

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.tap.enabled = YES;             // Enable tap recognizer to be able to dismiss keyboard
    self.gainTextField.inputAccessoryView = self.inputAccessoryView;
    
}

-(void)dismissingKeyboard
{
    self.tap.enabled = NO;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    float number = [[numberFormatter numberFromString:self.gainTextField.text] floatValue];
    
    if ([self.delegate getNegative])
    {
        number *= -1;
        self.gainTextField.text = [NSString stringWithFormat:@"%.1f", number];
    }
    
    if (number == 0) {
        
        float tempGain = [self.delegate getUserGain];
        
        self.gainTextField.text = [NSString stringWithFormat:@"%.1f", tempGain];
        
        number = tempGain;
    }
    [self.delegate updateGainValue:number];
    
    
    [self.gainTextField resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [self dismissingKeyboard];
    
}


-(void)setupDisplay
{
    [self.delegate setSwitchStates];
    
}

#pragma mark - Keyboard notifications
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //[self captureBlur:kbSize];
    
    

    float inputAccessoryViewHeight = self.inputAccessoryView.frame.size.height;
    NSLog(@"%f, %f", inputAccessoryViewHeight, kbSize.height);
    
    
    [UIView animateWithDuration:0.2 animations:^{
       // [self.controlsView setTransform:CGAffineTransformMakeTranslation(0, -300)];
        self.controlsView.frame = CGRectMake(self.controlsView.frame.origin.x, self.view.frame.size.height - kbSize.height - inputAccessoryViewHeight - self.controlsView.frame.size.height, self.controlsView.frame.size.width, self.controlsView.frame.size.height);
        
        
        self.scrollView.alpha = 0.3;
        
    }
     
     
     
        
     completion:^(BOOL finished){
       NSLog(@"Done!");
    }
     
    ];
    
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    self.view.alpha = 1;
    
    float inputAccessoryViewHeight = self.inputAccessoryView.frame.size.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.controlsView.frame = CGRectMake(self.controlsView.frame.origin.x, self.controlsView.frame.origin.y + kbSize.height + inputAccessoryViewHeight, self.controlsView.frame.size.width, self.controlsView.frame.size.height);
        
        self.scrollView.alpha = 1;

    } completion:nil];
    
}

-(void) captureBlur:(CGSize)kbSize
{
    //Get a UIImage from the UIView
    NSLog(@"blur capture");
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Blur the UIImage
    CIImage *imageToBlur = [CIImage imageWithCGImage:viewImage.CGImage];
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:imageToBlur forKey: @"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat: 5] forKey: @"inputRadius"]; //change number to increase/decrease blur
    CIImage *resultImage = [gaussianBlurFilter valueForKey: @"outputImage"];
    
    UIView *transparentView = [[UIView alloc]init];
    transparentView.alpha = 0.7;
    transparentView.bounds = self.view.bounds;
    
    UIView *blurredView = [[UIView alloc] init];
    blurredView.bounds = self.view.bounds;
    
    
    UIImage *blurredImage = [[UIImage alloc] initWithCIImage:resultImage];
    
    UIImageView *blurredImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    blurredImageView.image = blurredImage;
    
    [blurredView addSubview:blurredImageView];

    
    [self.view insertSubview:blurredView belowSubview:self.controlsView];

    [self.view insertSubview:transparentView belowSubview:self.controlsView];
    
}
@end
