//
//  ETManager.h
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 15/10/2013.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Novocaine.h"
#import "RingBuffer.h"
#import "AudioFileReader.h"
#import "AudioFileWriter.h"
#import "NVDSP.h"
#import "NVNotchFilter.h"

@interface ETManager : NSObject
{
    RingBuffer *ringBuffer;
    Novocaine *audioManager;
    AudioFileReader *fileReader;
    AudioFileWriter *fileWriter;
    NVNotchFilter *HPF;
}


-(void)createFilters;


@end
