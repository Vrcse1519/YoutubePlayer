//
//  JVAppHelper.h
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2015-05-22.
//  Copyright (c) 2015 com.jorgedeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVEnums.h"
#import "JVConstants.h"

@interface JVAppHelper : NSObject

/**
 * Private helper method for converting an NSArray of video IDs into its JavaScript equivalent.
 *
 * @param videoIds An array of video ID strings to convert into JavaScript format.
 * @return A JavaScript array in String format containing video IDs.
 */
- (NSString *)stringFromVideoIdArray:(NSArray *)videoIds;


/**
 * Convert a quality value from NSString to the typed enum value.
 *
 * @param qualityString A string representing playback quality. Ex: "small", "medium", "hd1080".
 * @return An enum value representing the playback quality.
 */
- (JVPlaybackQuality)playbackQualityForString:(NSString *)qualityString;


/**
 * Convert a |JVPlaybackQuality| value from the typed value to NSString.
 *
 * @param quality A |JVPlaybackQuality| parameter.
 * @return An |NSString| value to be used in the JavaScript bridge.
 */
- (NSString *)stringForPlaybackQuality:(JVPlaybackQuality)quality;


/**
 * Convert a state value from NSString to the typed enum value.
 *
 * @param stateString A string representing player state. Ex: "-1", "0", "1".
 * @return An enum value representing the player state.
 */
- (JVPlayerState)playerStateForString:(NSString *)stateString;


/**
 * Convert a state value from the typed value to NSString.
 *
 * @param quality A |JVPlayerState| parameter.
 * @return A string value to be used in the JavaScript bridge.
 */
- (NSString *)stringForPlayerState:(JVPlayerState)state;


@end