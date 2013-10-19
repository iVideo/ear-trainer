//
//  ETWaveformImageView.h
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 18/10/2013.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

//.h file
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface ETWaveformImageView : UIImageView{
    
}
-(id)initWithUrl:(NSURL*)url;
- (NSData *) renderPNGAudioPictogramLogForAssett:(AVURLAsset *)songAsset;
@end