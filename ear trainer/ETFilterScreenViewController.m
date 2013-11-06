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

-(void)setupDisplay
{
    [self.delegate setSwitchStates];
    
}
@end
