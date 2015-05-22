//
//  JVAppHelper.m
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2015-05-22.
//  Copyright (c) 2015 com.jorgedeveloper. All rights reserved.
//

#import "JVAppHelper.h"

@implementation JVAppHelper

/**
 * Private helper method for converting an NSArray of video IDs into its JavaScript equivalent.
 *
 * @param videoIds An array of video ID strings to convert into JavaScript format.
 * @return A JavaScript array in String format containing video IDs.
 */
- (NSString *)stringFromVideoIdArray:(NSArray *)videoIds
{
    NSMutableArray *formattedVideoIds = [[NSMutableArray alloc] init];
    
    for (id unformattedId in videoIds)
    {
        [formattedVideoIds addObject:[NSString stringWithFormat:@"'%@'", unformattedId]];
    }
    
    return [NSString stringWithFormat:@"[%@]", [formattedVideoIds componentsJoinedByString:@", "]];
}

/**
 * Convert a quality value from NSString to the typed enum value.
 *
 * @param qualityString A string representing playback quality. Ex: "small", "medium", "hd1080".
 * @return An enum value representing the playback quality.
 */
- (JVPlaybackQuality)playbackQualityForString:(NSString *)qualityString
{
    JVPlaybackQuality quality = kJVPlaybackQualityUnknown;
    
    if ([qualityString isEqualToString:kJVPlaybackQualitySmallQuality])
    {
        quality = kJVPlaybackQualitySmall;
    }
    else if ([qualityString isEqualToString:kJVPlaybackQualityMediumQuality])
    {
        quality = kJVPlaybackQualityMedium;
    }
    else if ([qualityString isEqualToString:kJVPlaybackQualityLargeQuality])
    {
        quality = kJVPlaybackQualityLarge;
    }
    else if ([qualityString isEqualToString:kJVPlaybackQualityHD720Quality])
    {
        quality = kJVPlaybackQualityHD720;
    }
    else if ([qualityString isEqualToString:kJVPlaybackQualityHD1080Quality])
    {
        quality = kJVPlaybackQualityHD1080;
    }
    else if ([qualityString isEqualToString:kJVPlaybackQualityHighResQuality])
    {
        quality = kJVPlaybackQualityHighRes;
    }
    
    return quality;
}

/**
 * Convert a |JVPlaybackQuality| value from the typed value to NSString.
 *
 * @param quality A |JVPlaybackQuality| parameter.
 * @return An |NSString| value to be used in the JavaScript bridge.
 */
- (NSString *)stringForPlaybackQuality:(JVPlaybackQuality)quality
{
    switch (quality) {
        case kJVPlaybackQualitySmall:
            return kJVPlaybackQualitySmallQuality;
        case kJVPlaybackQualityMedium:
            return kJVPlaybackQualityMediumQuality;
        case kJVPlaybackQualityLarge:
            return kJVPlaybackQualityLargeQuality;
        case kJVPlaybackQualityHD720:
            return kJVPlaybackQualityHD720Quality;
        case kJVPlaybackQualityHD1080:
            return kJVPlaybackQualityHD1080Quality;
        case kJVPlaybackQualityHighRes:
            return kJVPlaybackQualityHighResQuality;
        default:
            return kJVPlaybackQualityUnknownQuality;
    }
}

/**
 * Convert a state value from NSString to the typed enum value.
 *
 * @param stateString A string representing player state. Ex: "-1", "0", "1".
 * @return An enum value representing the player state.
 */
- (JVPlayerState)playerStateForString:(NSString *)stateString
{
    JVPlayerState state = kJVPlayerStateUnknown;
    
    if ([stateString isEqualToString:kJVPlayerStateUnstartedCode])
    {
        state = kJVPlayerStateUnstarted;
    }
    else if ([stateString isEqualToString:kJVPlayerStateEndedCode])
    {
        state = kJVPlayerStateEnded;
    }
    else if ([stateString isEqualToString:kJVPlayerStatePlayingCode])
    {
        state = kJVPlayerStatePlaying;
    }
    else if ([stateString isEqualToString:kJVPlayerStatePausedCode])
    {
        state = kJVPlayerStatePaused;
    }
    else if ([stateString isEqualToString:kJVPlayerStateBufferingCode])
    {
        state = kJVPlayerStateBuffering;
    }
    else if ([stateString isEqualToString:kJVPlayerStateCuedCode])
    {
        state = kJVPlayerStateQueued;
    }
    
    return state;
}

/**
 * Convert a state value from the typed value to NSString.
 *
 * @param quality A |JVPlayerState| parameter.
 * @return A string value to be used in the JavaScript bridge.
 */
- (NSString *)stringForPlayerState:(JVPlayerState)state
{
    switch (state) {
        case kJVPlayerStateUnstarted:
            return kJVPlayerStateUnstartedCode;
        case kJVPlayerStateEnded:
            return kJVPlayerStateEndedCode;
        case kJVPlayerStatePlaying:
            return kJVPlayerStatePlayingCode;
        case kJVPlayerStatePaused:
            return kJVPlayerStatePausedCode;
        case kJVPlayerStateBuffering:
            return kJVPlayerStateBufferingCode;
        case kJVPlayerStateQueued:
            return kJVPlayerStateCuedCode;
        default:
            return kJVPlayerStateUnknownCode;
    }
}


@end