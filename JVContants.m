//
//  JVContants.m
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2015-05-21.
//  Copyright (c) 2015 com.jorgedeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVConstants.h"

// A full list of response error codes can be found here:  https://developers.google.com/youtube/iframe_api_reference

// Constants representing player state
NSString *const kJVPlayerStateUnstartedCode = @"-1";
NSString *const kJVPlayerStateEndedCode = @"0";
NSString *const kJVPlayerStatePlayingCode = @"1";
NSString *const kJVPlayerStatePausedCode = @"2";
NSString *const kJVPlayerStateBufferingCode = @"3";
NSString *const kJVPlayerStateCuedCode = @"5";
NSString *const kJVPlayerStateUnknownCode = @"unknown";

// Constants representing playback quality.
NSString *const kJVPlaybackQualitySmallQuality = @"small";
NSString *const kJVPlaybackQualityMediumQuality = @"medium";
NSString *const kJVPlaybackQualityLargeQuality = @"large";
NSString *const kJVPlaybackQualityHD720Quality = @"hd720";
NSString *const kJVPlaybackQualityHD1080Quality = @"hd1080";
NSString *const kJVPlaybackQualityHighResQuality = @"highres";
NSString *const kJVPlaybackQualityUnknownQuality = @"unknown";

// Constants representing YouTube player errors.
NSString *const kJVPlayerErrorInvalidParamErrorCode = @"2";
NSString *const kJVPlayerErrorHTML5ErrorCode = @"5";
NSString *const kJVPlayerErrorVideoNotFoundErrorCode = @"100";
NSString *const kJVPlayerErrorNotEmbeddableErrorCode = @"101";
NSString *const kJVPlayerErrorCannotFindVideoErrorCode = @"105";

// Constants representing player callbacks.
NSString *const kJVPlayerCallbackOnReady = @"onReady";
NSString *const kJVPlayerCallbackOnStateChange = @"onStateChange";
NSString *const kJVPlayerCallbackOnPlaybackQualityChange = @"onPlaybackQualityChange";
NSString *const kJVPlayerCallbackOnError = @"onError";
NSString *const kJVPlayerCallbackOnYouTubeIframeAPIReady = @"onYouTubeIframeAPIReady";

// Contant for regular expresion
NSString *const kJVPlayerEmbedUrlRegexPattern = @"^http(s)://(www.)youtube.com/embed/(.*)$";