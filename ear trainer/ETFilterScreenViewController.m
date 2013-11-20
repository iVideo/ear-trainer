//
//  ETFilterScreenViewController.m
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 10/28/13.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

#import "ETFilterScreenViewController.h"

@interface ETFilterScreenViewController ()

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
    self.scrollView.frame = CGRectMake(0, 0, 320, 300);

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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegate textFieldDidBeginEditing:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self.delegate textFieldDidEndEditing:textField];
}

-(void)setupDisplay
{
    [self.delegate setSwitchStates];
    
}
@end
