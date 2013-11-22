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
    
    self.scrollView.contentSize = CGSizeMake(320, 1000);
    //self.scrollView.frame = CGRectMake(0, 0, 320, 300);
    self.tap.enabled = NO;                   // Tap recognizer for when keyboard is up (default = disabled)
    [self.gainTextField setDelegate:self];

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
#pragma mark - Tap Gesture Recognizer

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self dismissingKeyboard];
}

- (IBAction)turnBoostOn:(UIButton *)sender {
    BOOL negative = [self.delegate getNegative];
    
    if(negative != NO)
    {
        [self.delegate setNegative:NO];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        float number = [[numberFormatter numberFromString:self.gainTextField.text] floatValue];
        [self.delegate updateGainValue:number];
        
        [self.cutOnOff setBackgroundImage:[UIImage imageNamed:@"offswitch"] forState:UIControlStateNormal];
        [self.boostOnOff setBackgroundImage:[UIImage imageNamed:@"onswitch"] forState:UIControlStateNormal];
    }
}

- (IBAction)turnCutOn:(UIButton *)sender {
    
    BOOL negative = [self.delegate getNegative];
    if(negative != YES)
    {
        [self.delegate setNegative:YES];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        float number = [[numberFormatter numberFromString:self.gainTextField.text] floatValue];
        [self.delegate updateGainValue:number];
        
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
    if (number == 0) {
        self.gainTextField.text = @"0,0";
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
@end
