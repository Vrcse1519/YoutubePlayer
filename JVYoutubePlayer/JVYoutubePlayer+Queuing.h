//
//  JVYoutubePlayer+Queuing.h
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2015-05-22.
//  Copyright (c) 2015 com.jorgedeveloper. All rights reserved.
//

#import "JVYoutubePlayer.h"

@interface JVYoutubePlayer (Queuing)

#pragma mark - Queuing videos

// Queueing functions for videos. These methods correspond to their JavaScript
// equivalents as documented here:
//   https://developers.google.com/youtube/js_api_reference#Queueing_Functions

/**
 * Cues a given video by its video ID for playback starting at the given time and with the
 * suggested quality. Cueing loads a video, but does not start video playback. This method
 * corresponds with its JavaScript API equivalent as documented here:
 *    https://developers.google.com/youtube/iframe_api_reference#cueVideoById
 *
 * @param videoId A video ID to cue.
 * @param startSeconds Time in seconds to start the video when YTPlayerView::playVideo is called.
 * @param suggestedQuality YTPlaybackQuality value suggesting a playback quality.
 */
- (void)cueVideoById:(NSString *)videoId
        startSeconds:(float)startSeconds
    suggestedQuality:(JVPlaybackQuality)suggestedQuality;

/**
 * Cues a given video by its video ID for playback starting and ending at the given times
 * with the suggested quality. Cueing loads a video, but does not start video playback. This
 * method corresponds with its JavaScript API equivalent as documented here:
 *    https://developers.google.com/youtube/iframe_api_reference#cueVideoById
 *
 * @param videoId A video ID to cue.
 * @param startSeconds Time in seconds to start the video when playVideo() is called.
 * @param endSeconds Time in seconds to end the video after it begins playing.
 * @param suggestedQuality YTPlaybackQuality value suggesting a playback quality.
 */
- (void)cueVideoById:(NSString *)videoId
        startSeconds:(float)startSeconds
          endSeconds:(float)endSeconds
    suggestedQuality:(JVPlaybackQuality)suggestedQuality;

/**
 * Loads a given video by its video ID for playback starting at the given time and with the
 * suggested quality. Loading a video both loads it and begins playback. This method
 * corresponds with its JavaScript API equivalent as documented here:
 *    https://developers.google.com/youtube/iframe_api_reference#loadVideoById
 *
 * @param videoId A video ID to load and begin playing.
 * @param startSeconds Time in seconds to start the video when it has loaded.
 * @param suggestedQuality YTPlaybackQuality value suggesting a playback quality.
 */
- (void)loadVideoById:(NSString *)videoId
         startSeconds:(float)startSeconds
     suggestedQuality:(JVPlaybackQuality)suggestedQuality;

/**
 * Loads a given video by its video ID for playback starting and ending at the given times
 * with the suggested quality. Loading a video both loads it and begins playback. This method
 * corresponds with its JavaScript API equivalent as documented here:
 *    https://developers.google.com/youtube/iframe_api_reference#loadVideoById
 *
 * @param videoId A video ID to load and begin playing.
 * @param startSeconds Time in seconds to start the video when it has loaded.
 * @param endSeconds Time in seconds to end the video after it begins playing.
 * @param suggestedQuality YTPlaybackQuality value suggesting a playback quality.
 */
- (void)loadVideoById:(NSString *)videoId
         startSeconds:(CGFloat)startSeconds
           endSeconds:(CGFloat)endSeconds
     suggestedQuality:(JVPlaybackQuality)suggestedQuality;

/**
 * Cues a given video by its URL on YouTube.com for playback starting at the given time
 * and with the suggested quality. Cueing loads a video, but does not start video playback.
 * This method corresponds with its JavaScript API equivalent as documented here:
 *    https://developers.google.com/youtube/iframe_api_reference#cueVideoByUrl
 *
 * @param videoURL URL of a YouTube video to cue for playback.
 * @param startSeconds Time in seconds to start the video when YTPlayerView::playVideo is called.
 * @param suggestedQuality YTPlaybackQuality value suggesting a playback quality.
 */
- (void)cueVideoByURL:(NSString *)videoURL
         startSeconds:(float)startSeconds
     suggestedQuality:(JVPlaybackQuality)suggestedQuality;

/**
 * Cues a given video by its URL on YouTube.com for playback starting at the given time
 * and with the suggested quality. Cueing loads a video, but does not start video playback.
 * This method corresponds with its JavaScript API equivalent as documented here:
 *    https://developers.google.com/youtube/iframe_api_reference#cueVideoByUrl
 *
 * @param videoURL URL of a YouTube video to cue for playback.
 * @param startSeconds Time in seconds to start the video when YTPlayerView::playVideo is called.
 * @param endSeconds Time in seconds to end the video after it begins playing.
 * @param suggestedQuality YTPlaybackQuality value suggesting a playback quality.
 */
- (void)cueVideoByURL:(NSString *)videoURL
         startSeconds:(float)startSeconds
           endSeconds:(float)endSeconds
     suggestedQuality:(JVPlaybackQuality)suggestedQuality;

/**
 * Loads a given video by its video ID for playback starting at the given time
 * with the suggested quality. Loading a video both loads it and begins playback. This method
 * corresponds with its JavaScript API equivalent as documented here:
 *    https://developers.google.com/youtube/iframe_api_reference#loadVideoByUrl
 *
 * @param videoURL URL of a YouTube video to load and play.
 * @param startSeconds Time in seconds to start the video when it has loaded.
 * @param suggestedQuality YTPlaybackQuality value suggesting a playback quality.
 */
- (void)loadVideoByURL:(NSString *)videoURL
          startSeconds:(float)startSeconds
      suggestedQuality:(JVPlaybackQuality)suggestedQuality;

/**
 * Loads a given video by its video ID for playback starting and ending at the given times
 * with the suggested quality. Loading a video both loads it and begins playback. This method
 * corresponds with its JavaScript API equivalent as documented here:
 *    https://developers.google.com/youtube/iframe_api_reference#loadVideoByUrl
 *
 * @param videoURL URL of a YouTube video to load and play.
 * @param startSeconds Time in seconds to start the video when it has loaded.
 * @param endSeconds Time in seconds to end the video after it begins playing.
 * @param suggestedQuality YTPlaybackQuality value suggesting a playback quality.
 */
- (void)loadVideoByURL:(NSString *)videoURL
          startSeconds:(float)startSeconds
            endSeconds:(float)endSeconds
      suggestedQuality:(JVPlaybackQuality)suggestedQuality;

#pragma mark - Queuing functions for playlists

// Queueing functions for playlists. These methods correspond to
// the JavaScript methods defined here:
//    https://developers.google.com/youtube/js_api_reference#Playlist_Queueing_Functions

/**
 * Cues a given playlist with the given ID. The |index| parameter specifies the 0-indexed
 * position of the first video to play, starting at the given time and with the
 * suggested quality. Cueing loads a playlist, but does not start video playback. This method
 * corresponds with its JavaScript API equivalent as documented here:
 *    https://developers.google.com/youtube/iframe_api_reference#cuePlaylist
 *
 * @param playlistId Playlist ID of a YouTube playlist to cue.
 * @param index A 0-indexed position specifying the first video to play.
 * @param startSeconds Time in seconds to start the video when YTPlayerView::playVideo is called.
 * @param suggestedQuality YTPlaybackQuality value suggesting a playback quality.
 */
- (void)cuePlaylistByPlaylistId:(NSString *)playlistId
                          index:(int)index
                   startSeconds:(float)startSeconds
               suggestedQuality:(JVPlaybackQuality)suggestedQuality;

/**
 * Cues a playlist of videos with the given video IDs. The |index| parameter specifies the
 * 0-indexed position of the first video to play, starting at the given time and with the
 * suggested quality. Cueing loads a playlist, but does not start video playback. This method
 * corresponds with its JavaScript API equivalent as documented here:
 *    https://developers.google.com/youtube/iframe_api_reference#cuePlaylist
 *
 * @param videoIds An NSArray of video IDs to compose the playlist of.
 * @param index A 0-indexed position specifying the first video to play.
 * @param startSeconds Time in seconds to start the video when YTPlayerView::playVideo is called.
 * @param suggestedQuality YTPlaybackQuality value suggesting a playback quality.
 */
- (void)cuePlaylistByVideos:(NSArray *)videoIds
                      index:(int)index
               startSeconds:(float)startSeconds
           suggestedQuality:(JVPlaybackQuality)suggestedQuality;

/**
 * Loads a given playlist with the given ID. The |index| parameter specifies the 0-indexed
 * position of the first video to play, starting at the given time and with the
 * suggested quality. Loading a playlist starts video playback. This method
 * corresponds with its JavaScript API equivalent as documented here:
 *    https://developers.google.com/youtube/iframe_api_reference#loadPlaylist
 *
 * @param playlistId Playlist ID of a YouTube playlist to cue.
 * @param index A 0-indexed position specifying the first video to play.
 * @param startSeconds Time in seconds to start the video when YTPlayerView::playVideo is called.
 * @param suggestedQuality YTPlaybackQuality value suggesting a playback quality.
 */
- (void)loadPlaylistByPlaylistId:(NSString *)playlistId
                           index:(int)index
                    startSeconds:(float)startSeconds
                suggestedQuality:(JVPlaybackQuality)suggestedQuality;

/**
 * Loads a playlist of videos with the given video IDs. The |index| parameter specifies the
 * 0-indexed position of the first video to play, starting at the given time and with the
 * suggested quality. Loading a playlist starts video playback. This method
 * corresponds with its JavaScript API equivalent as documented here:
 *    https://developers.google.com/youtube/iframe_api_reference#loadPlaylist
 *
 * @param videoIds An NSArray of video IDs to compose the playlist of.
 * @param index A 0-indexed position specifying the first video to play.
 * @param startSeconds Time in seconds to start the video when YTPlayerView::playVideo is called.
 * @param suggestedQuality YTPlaybackQuality value suggesting a playback quality.
 */
- (void)loadPlaylistByVideos:(NSArray *)videoIds
                       index:(int)index
                startSeconds:(float)startSeconds
            suggestedQuality:(JVPlaybackQuality)suggestedQuality;

@end