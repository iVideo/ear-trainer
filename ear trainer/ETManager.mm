//
//  ETManager.m
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 15/10/2013.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

#import "ETManager.h"



@implementation ETManager



-(void)setUpAudio
{
    ringBuffer = new RingBuffer(32768, 2);
    audioManager = [Novocaine audioManager];
    float samplingRate = audioManager.samplingRate;
    
    
    
}
-(void)createFilters;
{
   
}
@end
