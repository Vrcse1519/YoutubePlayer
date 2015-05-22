//
//  JVConstants.h
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2015-05-21.
//  Copyright (c) 2015 com.jorgedeveloper. All rights reserved.
//

#ifndef YoutubePlayerDemo_Constants_h
#define YoutubePlayerDemo_Constants_h


// helper defines for detecting current version
#define IS_OS_6_OR_LATER  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_8_OR_LATER  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


// A full list of response error codes can be found here:  https://developers.google.com/youtube/iframe_api_reference

// Constants representing player state
FOUNDATION_EXTERN NSString *const kJVPlayerStateUnstartedCode;
FOUNDATION_EXTERN NSString *const kJVPlayerStateEndedCode;
FOUNDATION_EXTERN NSString *const kJVPlayerStatePlayingCode;
FOUNDATION_EXTERN NSString *const kJVPlayerStatePausedCode;
FOUNDATION_EXTERN NSString *const kJVPlayerStateBufferingCode;
FOUNDATION_EXTERN NSString *const kJVPlayerStateCuedCode;
FOUNDATION_EXTERN NSString *const kJVPlayerStateUnknownCode;

// Constants representing playback quality.
FOUNDATION_EXTERN NSString *const kJVPlaybackQualitySmallQuality;
FOUNDATION_EXTERN NSString *const kJVPlaybackQualityMediumQuality;
FOUNDATION_EXTERN NSString *const kJVPlaybackQualityLargeQuality;
FOUNDATION_EXTERN NSString *const kJVPlaybackQualityHD720Quality;
FOUNDATION_EXTERN NSString *const kJVPlaybackQualityHD1080Quality;
FOUNDATION_EXTERN NSString *const kJVPlaybackQualityHighResQuality;
FOUNDATION_EXTERN NSString *const kJVPlaybackQualityUnknownQuality;

// Constants representing YouTube player errors.
FOUNDATION_EXTERN NSString *const kJVPlayerErrorInvalidParamErrorCode;
FOUNDATION_EXTERN NSString *const kJVPlayerErrorHTML5ErrorCode;
FOUNDATION_EXTERN NSString *const kJVPlayerErrorVideoNotFoundErrorCode;
FOUNDATION_EXTERN NSString *const kJVPlayerErrorNotEmbeddableErrorCode;
FOUNDATION_EXTERN NSString *const kJVPlayerErrorCannotFindVideoErrorCode;

// Constants representing player callbacks.
FOUNDATION_EXTERN NSString *const kJVPlayerCallbackOnReady;
FOUNDATION_EXTERN NSString *const kJVPlayerCallbackOnStateChange;
FOUNDATION_EXTERN NSString *const kJVPlayerCallbackOnPlaybackQualityChange;
FOUNDATION_EXTERN NSString *const kJVPlayerCallbackOnError;
FOUNDATION_EXTERN NSString *const kJVPlayerCallbackOnYouTubeIframeAPIReady;

// Contant for regular expresion
FOUNDATION_EXTERN NSString *const kJVPlayerEmbedUrlRegexPattern;

#endif