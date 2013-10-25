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
    float QFactor;
    float initialGain;
    float userGain;
    int currentFilter;
    
    ETFilterStateHandler *filterStateHandler;
    NVPeakingEQFilter *PEQ[29];
    
    
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
    filterOn = 0;
    
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
    
    filterStateHandler = [[ETFilterStateHandler alloc] init];
}

-(Novocaine *)getAudioManager
{
    return audioManager;
}

-(void)readAudioFileWithURL:(NSURL *)url
{
    if (self.fileReader.playing) {
        [audioManager pause];
        [self.fileReader pause];
    }
    
    
    _fileReader = [[AudioFileReader alloc] initWithAudioFileURL:url samplingRate:audioManager.samplingRate numChannels:audioManager.numOutputChannels];

  //  self.waveformView = [[ETWaveformImageView alloc] initWithUrl:url];
    
    
    _fileReader.currentTime = 0.0;
    
    [audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         [self.fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
         
         
         //NSLog(@"Time: %f", fileReader.currentTime);
         
         if (filterOn){
             [PEQ[currentFilter] filterData:data numFrames:numFrames numChannels:numChannels];
         }
         
         
     }];
    
    

}

-(void)pauseAudio
{
    [self.fileReader pause];
    [audioManager pause];
}

-(void)playAudio;
{
    [_fileReader play];

    [audioManager play];
}

-(UIImageView *)getWaveform
{
    return self.waveformView;
}

#pragma mark - Filter stuff
-(void)setFreqFromSliderValue:(float)sliderValue withTag:(int)sliderTag
{
  PEQ[sliderTag].centerFrequency = sliderValue;
}

-(void)setGainValue:(float)value
{
    userGain = value;
    
    for (int i = 0; i < 23; i++) {
        PEQ[i].G = userGain;
//        NSLog(@"%f", PEQ[i].G);
    }
}

-(void)turnFilterOn
{
    filterOn = 1;
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(turnFilterOff) userInfo:nil repeats:NO];
    
}

-(void)turnFilterOff
{
    filterOn = 0;
}

-(void)filterStateForFilter:(int)filterNumber withState:(BOOL)state;
{
    [filterStateHandler updateFilter:filterNumber withState:state];
}

-(int)selectRandomFilter
{
    
  currentFilter = [filterStateHandler selectRandomFilter];
    
    return currentFilter;

}

#pragma mark - Singleton Instance
+(ETManager *)sharedInstance
{
    static ETManager *_sharedInstance = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{_sharedInstance = [[ETManager alloc] init];});

    return _sharedInstance;
}
@end
