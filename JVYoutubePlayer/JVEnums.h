//
//  JVEnums.h
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2015-05-21.
//  Copyright (c) 2015 com.jorgedeveloper. All rights reserved.
//

#ifndef YoutubePlayerDemo_JVEnums_h
#define YoutubePlayerDemo_JVEnums_h

/** These enums represent the state of the current video in the player. */
typedef enum {
    kJVPlayerStateUnstarted,
    kJVPlayerStateEnded,
    kJVPlayerStatePlaying,
    kJVPlayerStatePaused,
    kJVPlayerStateBuffering,
    kJVPlayerStateQueued,
    kJVPlayerStateUnknown
} JVPlayerState;

/** These enums represent the resolution of the currently loaded video. */
typedef enum {
    kJVPlaybackQualitySmall,
    kJVPlaybackQualityMedium,
    kJVPlaybackQualityLarge,
    kJVPlaybackQualityHD720,
    kJVPlaybackQualityHD1080,
    kJVPlaybackQualityHighRes,
    kJVPlaybackQualityUnknown /** This should never be returned. It is here for future proofing. */
} JVPlaybackQuality;

/** These enums represent error codes thrown by the player. */
typedef enum {
    kJVPlayerErrorInvalidParam,
    kJVPlayerErrorHTML5Error,
    kJVPlayerErrorVideoNotFound, // Functionally equivalent error codes 100 and
    // 105 have been collapsed into |kYTPlayerErrorVideoNotFound|.
    kJVPlayerErrorNotEmbeddable,
    kJVPlayerErrorUnknown
} JVPlayerError;


#endif