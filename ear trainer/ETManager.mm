//
//  ETManager.m
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 15/10/2013.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

#import "ETManager.h"

@interface ETManager()
{
    BOOL filterOn;
    // define center frequencies of the bands
    float centerFrequencies[10];
    NVPeakingEQFilter *PEQ[10];
    float QFactor;
    float initialGain;
}


@end

@implementation ETManager



-(void)setUpAudio
{
    ringBuffer = new RingBuffer(32768, 2);
    audioManager = [Novocaine audioManager];
    
}
-(void)createFilters;
{
    QFactor = 2.0f;
    initialGain = 0.0f;
    centerFrequencies[0] = 60.0f;
    centerFrequencies[1] = 170.0f;
    centerFrequencies[2] = 310.0f;
    centerFrequencies[3] = 600.0f;
    centerFrequencies[4] = 1000.0f;
    centerFrequencies[5] = 3000.0f;
    centerFrequencies[6] = 6000.0f;
    centerFrequencies[7] = 12000.0f;
    centerFrequencies[8] = 14000.0f;
    centerFrequencies[9] = 16000.0f;
    
    self.Myvalue = centerFrequencies[5];
    
    for (int i = 0; i < 10; i++) {
        PEQ[i] = [[NVPeakingEQFilter alloc] initWithSamplingRate:audioManager.samplingRate];
        PEQ[i].Q = QFactor;
        PEQ[i].centerFrequency = centerFrequencies[i];
        PEQ[i].G = initialGain;
        
        if (i==5) {
            PEQ[i].G = 12.0f;
        }
    }
    
    NSLog(@"k this works too");

    
}

-(Novocaine *)getAudioManager
{
    return audioManager;
}

-(void)readAudioFileWithURL:(NSURL *)url
{
  fileReader = [[AudioFileReader alloc] initWithAudioFileURL:url samplingRate:audioManager.samplingRate numChannels:audioManager.numOutputChannels];
    
  //  self.waveformView = [[ETWaveformImageView alloc] initWithUrl:url];
    
    
    [fileReader play];
    fileReader.currentTime = 0.0;

    NSLog(@"adfsdf");
    [audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         [fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
         
         PEQ[5].centerFrequency = self.Myvalue;

         //NSLog(@"Time: %f", fileReader.currentTime);
         for (int i = 0; i < 10; i++) {
             [PEQ[i] filterData:data numFrames:numFrames numChannels:numChannels];
         }
         
     }];

    [audioManager pause];
}

-(void)pauseAudio
{
    [audioManager pause];
}

-(void)playAudio;
{
    
    [audioManager play];
}

-(UIImageView *)getWaveform
{
    return self.waveformView;
}

-(void)setFreqFromSliderValue:(float)sliderValue
{

  self.Myvalue = float(sliderValue);

    
}

+(ETManager *)sharedInstance
{
    static ETManager *_sharedInstance = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{_sharedInstance = [[ETManager alloc] init];});

    return _sharedInstance;
}
@end
