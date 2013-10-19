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
#import "NVHighpassFilter.h"
#import "NVPeakingEQFilter.h"
#import "ETWaveformImageView.h"

@interface ETManager : NSObject
{
    RingBuffer *ringBuffer;
    Novocaine *audioManager;
    AudioFileReader *fileReader;
    AudioFileWriter *fileWriter;
}
@property float Myvalue;

@property NVHighpassFilter *notchFilter;
@property ETWaveformImageView *waveformView;

+(ETManager *)sharedInstance;

-(void)createFilters;
-(void)setUpAudio;
-(Novocaine *)getAudioManager;
-(void)readAudioFileWithURL:(NSURL *)url;
-(void)pauseAudio;
-(void)playAudio;
-(UIImageView *)getWaveform;
-(void)setFreqFromSliderValue:(float)sliderValue;
@end
