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
    float centerFrequencies[29];
    NVPeakingEQFilter *PEQ[29];
    float QFactor;
    float initialGain;
    float userGain;
    
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
    centerFrequencies[0] = 31.0f;
    centerFrequencies[1] = 40.0f;
    centerFrequencies[2] = 50.0f;
    centerFrequencies[3] = 60.0f;
    centerFrequencies[4] = 80.0f;
    centerFrequencies[5] = 100.0f;
    centerFrequencies[6] = 125.0f;
    centerFrequencies[7] = 160.0f;
    centerFrequencies[8] = 200.0f;
    centerFrequencies[9] = 250.0f;
    centerFrequencies[10] = 315.0f;
    centerFrequencies[11] = 400.0f;
    centerFrequencies[12] = 500.0f;
    centerFrequencies[13] = 630.0f;
    centerFrequencies[14] = 800.0f;
    centerFrequencies[15] = 1000.0f;
    centerFrequencies[16] = 1250.0f;
    centerFrequencies[17] = 1600.0f;
    centerFrequencies[18] = 2000.0f;
    centerFrequencies[19] = 2500.0f;
    centerFrequencies[20] = 3150.0f;
    centerFrequencies[21] = 4000.0f;
    centerFrequencies[22] = 5000.0f;
    centerFrequencies[23] = 6300.0f;
    centerFrequencies[24] = 8000.0f;
    centerFrequencies[25] = 10000.0f;
    centerFrequencies[26] = 12500.0f;
    centerFrequencies[27] = 16000.0f;
    centerFrequencies[28] = 20000.0f;
    
    for (int i = 0; i < 23; i++) {
        PEQ[i] = [[NVPeakingEQFilter alloc] initWithSamplingRate:audioManager.samplingRate];
        PEQ[i].Q = QFactor;
        PEQ[i].centerFrequency = centerFrequencies[i];
        PEQ[i].G = initialGain;
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
         
         //PEQ[5].centerFrequency = self.Myvalue;

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

-(void)setFreqFromSliderValue:(float)sliderValue withTag:(int)sliderTag
{

  PEQ[sliderTag].centerFrequency = sliderValue;

    
}

+(ETManager *)sharedInstance
{
    static ETManager *_sharedInstance = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{_sharedInstance = [[ETManager alloc] init];});

    return _sharedInstance;
}
@end
