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

- (IBAction)showMediaPicker:(id)sender
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.prompt = @"Select songs to play";
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    NSURL *url = [[[mediaItemCollection items] objectAtIndex:0] valueForProperty:MPMediaItemPropertyAssetURL];
    
    NSLog(@"%@", url);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
