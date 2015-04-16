//
//  RecordController.h
//  RecordAudio
//
//  Created by mani on 14-2-19.
//  Copyright (c) 2014年 pamakids. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "FlashRuntimeExtensions.h"
#include "lame.h"

@interface RecordController : NSObject

{
    AVAudioRecorder*                _recorder;
    AVAudioPlayer*                  _player;
    AVAudioPlayer*                  _mp3Player;
    
    BOOL                            _hasCAFFile;
    BOOL                            _recording;
    BOOL                            _pause;
    BOOL                            _hasMp3File;
    BOOL                            _playingMp3;
    
    NSURL*                          _recordedFile;
    CGFloat                         _sampleRate;
    AVAudioQuality                  _quality;
    NSInteger                       _formatIndex;
    NSTimer*                        _timer;
    NSDate*                         _startDate;
    NSString*                       _saveName;
    NSString*                       _pureName;
}

@property ( nonatomic, assign ) FREContext      *freContext;

-(void) startRecord:(NSString*)saveName index:(NSString*)index sampleRate:(NSString *)sampleRate;
-(void) stopRecord;
-(void) pauseRecord;
-(void) resumeRecord;
-(void) toMp3;
-(void) toAmr;

@end
