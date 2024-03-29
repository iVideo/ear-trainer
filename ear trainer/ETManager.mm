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
    float centerFrequencies[39];
    float QFactor;
    float initialGain;
    float userGain;
    int currentFilter;
    
    NVPeakingEQFilter *PEQ[29];
    
    
}



@end

@implementation ETManager

-(BOOL)getFilterOn
{
    return filterOn;
}

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
    currentFilter = 5000;
    userGain = 0;
    
    centerFrequencies[10] = 31.0f;
    centerFrequencies[11] = 40.0f;
    centerFrequencies[12] = 50.0f;
    centerFrequencies[13] = 63.0f;
    centerFrequencies[14] = 80.0f;
    centerFrequencies[15] = 100.0f;
    centerFrequencies[16] = 125.0f;
    centerFrequencies[17] = 160.0f;
    centerFrequencies[18] = 200.0f;
    centerFrequencies[19] = 250.0f;
    centerFrequencies[20] = 315.0f;
    centerFrequencies[21] = 400.0f;
    centerFrequencies[22] = 500.0f;
    centerFrequencies[23] = 630.0f;
    centerFrequencies[24] = 800.0f;
    centerFrequencies[25] = 1000.0f;
    centerFrequencies[26] = 1250.0f;
    centerFrequencies[27] = 1600.0f;
    centerFrequencies[28] = 2000.0f;
    centerFrequencies[29] = 2500.0f;
    centerFrequencies[30] = 3150.0f;
    centerFrequencies[31] = 4000.0f;
    centerFrequencies[32] = 5000.0f;
    centerFrequencies[33] = 6300.0f;
    centerFrequencies[34] = 8000.0f;
    centerFrequencies[35] = 10000.0f;
    centerFrequencies[36] = 12500.0f;
    centerFrequencies[37] = 16000.0f;
    centerFrequencies[38] = 20000.0f;
    
    for (int i = 0; i < 29; i++) {
        PEQ[i] = [[NVPeakingEQFilter alloc] initWithSamplingRate:audioManager.samplingRate];
        PEQ[i].Q = QFactor;
        PEQ[i].centerFrequency = centerFrequencies[i + 10];
        PEQ[i].G = initialGain;
    }
    
    self.filterStateHandler = [[ETFilterStateHandler alloc] init];
    
    for(int i = 10; i < 39; i += 3)
    {
        [self.filterStateHandler updateFilter:i withState:YES];
    }
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
    
    
    self.fileReader = [[AudioFileReader alloc] initWithAudioFileURL:url samplingRate:audioManager.samplingRate numChannels:audioManager.numOutputChannels];

  //  self.waveformView = [[ETWaveformImageView alloc] initWithUrl:url];
    
    
    [self.fileReader setCurrentTime:0.0f];
    
//    NSLog(@"%f", self.fileReader.currentTime);
//    NSLog(@" current time: %f, duration: %f", floorf(self.fileReader.currentTime), self.fileReader.duration);
    
    [audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         [self.fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
                  
         if (filterOn){
             [PEQ[currentFilter] filterData:data numFrames:numFrames numChannels:numChannels];
         }
         
         
     }];
    
    currentFilter = 5000;

}

-(void)pauseAudio
{
    [self.fileReader pause];
    [audioManager pause];
    
   [self.delegate stopNowPlayingTimer];
}

-(void)playAudio;
{
    [_fileReader play];

    [audioManager play];
    
   [self.delegate startNowPlayingTimer];
}

-(UIImageView *)getWaveform
{
    return self.waveformView;
}

#pragma mark - Timer stuff


#pragma mark - Filter stuff
-(void)setFreqFromSliderValue:(float)sliderValue withTag:(int)sliderTag
{
  PEQ[sliderTag].centerFrequency = sliderValue;
}

-(void)setGainValue:(float)value negative:(BOOL)negative
{
//    if (negative) {
//        
//        value *= -1;
//    }
    
    //NSNumber *gainValue = [NSNumber numberWithFloat:value];
    
    userGain = value;
    
    for (int i = 0; i < 23; i++) {
        PEQ[i].G = userGain;
        NSLog(@"%f", PEQ[i].G);
    }
}

-(void)turnFilterOn
{
    filterOn = 1;
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(turnFilterOff) userInfo:nil repeats:NO];
    [self.delegate setInAndOutImageView:filterOn];
}

-(void)turnFilterOff
{
    filterOn = 0;
    [self.delegate setInAndOutImageView:filterOn];
}

-(void)filterStateForFilter:(int)filterNumber withState:(BOOL)state;
{
    [self.filterStateHandler updateFilter:filterNumber withState:state];
}

-(int)selectRandomFilter
{
    // Sets current filter to randomly selected filter. 10 is minused so that the value derived from within 'activeFilters' corresponds to the correct filter inside PEQ[]
    if (!([self.filterStateHandler.activeFilters count] == 0))
  currentFilter = [self.filterStateHandler selectRandomFilter] - 10;
    
    return currentFilter;

}
-(int)getCurrentFilter
{
    
    return currentFilter;
}

-(float)getFrequencyOfActiveFilters:(NSNumber *)filterNumber
{
    int filterNo = [filterNumber integerValue];
    return PEQ[filterNo - 10].centerFrequency;
    
}
-(float)getUserGain
{
    return userGain;
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
