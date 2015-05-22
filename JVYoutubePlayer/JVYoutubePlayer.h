//
//  JVYoutubePlayer.h
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2015-05-21.
//  Copyright (c) 2015 com.jorgedeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVEnums.h"
#import "JVConstants.h"
#import "JVAppHelper.h"


@class JVYoutubePlayer;

#pragma mark - Player Protocol
/**
 * A delegate for ViewControllers to respond to YouTube player events outside
 * of the view, such as changes to video playback state or playback errors.
 * The callback functions correlate to the events fired by the JavaScript
 * API. For the full documentation, see the JavaScript documentation here:
 *     https://developers.google.com/youtube/js_api_reference#Events
 */
@protocol JVYoutubePlayerDelegate <NSObject>

@optional
/**
 * Invoked when the player view is ready to receive API calls.
 *
 * @param playerView The YTPlayerView instance that has become ready.
 */
- (void)playerViewDidBecomeReady:(JVYoutubePlayer *)playerView;

/**
 * Callback invoked when player state has changed, e.g. stopped or started playback.
 *
 * @param playerView The YTPlayerView instance where playback state has changed.
 * @param state YTPlayerState designating the new playback state.
 */
- (void)playerView:(JVYoutubePlayer *)playerView didChangeToState:(JVPlayerState)state;

/**
 * Callback invoked when playback quality has changed.
 *
 * @param playerView The YTPlayerView instance where playback quality has changed.
 * @param quality YTPlaybackQuality designating the new playback quality.
 */
- (void)playerView:(JVYoutubePlayer *)playerView didChangeToQuality:(JVPlaybackQuality)quality;

/**
 * Callback invoked when an error has occured.
 *
 * @param playerView The YTPlayerView instance where the error has occurred.
 * @param error YTPlayerError containing the error state.
 */
- (void)playerView:(JVYoutubePlayer *)playerView receivedError:(JVPlayerError)error;

@end


#pragma mark - Player Interface
/**
 * YTPlayerView is a custom UIView that client developers will use to include YouTube
 * videos in their iOS applications. It can be instantiated programmatically, or via
 * Interface Builder. Use the methods YTPlayerView::loadWithVideoId:,
 * YTPlayerView::loadWithPlaylistId: or their variants to set the video or playlist
 * to populate the view with.
 */
@interface JVYoutubePlayer : UIView <NSObject, UIWebViewDelegate>
{
    BOOL playerWithTimer;
    CGFloat stopTimer;
    JVAppHelper *appHelper;
}

@property (nonatomic) BOOL playerWithTimer;
@property (nonatomic) CGFloat stopTimer;
@property (nonatomic, strong) JVAppHelper *appHelper;

// for more information visit https://developers.google.com/youtube/player_parameters
@property (nonatomic) BOOL allowLandscapeMode;

@property (nonatomic) BOOL forceBackToPortraitMode;

@property (nonatomic) BOOL allowAutoResizingPlayerFrame;

@property (nonatomic) BOOL autohide; // default is 2.. available values 0,1,2 (1 and 2 literraly the same) so if(YES then = 1)

@property (nonatomic) BOOL autoplay; // default is 0

@property (nonatomic) BOOL cc_load_policy; // default is based on user preferences

@property (nonatomic) BOOL color; // default is red color.. available red or white (if YES then = white)

@property (nonatomic) BOOL controls; // default is 1.. available 0,1,2 (1 and 2 is literally the same) so (if YES then = 0)

@property (nonatomic) BOOL disablekb; // default is 0.. available 0 and 1

@property (nonatomic) BOOL enablejsapi; // default is 0

@property (nonatomic) int end; // spicifies the time as a positive intiger

@property (nonatomic) BOOL fullscreen; // default is 1

//@property BOOL hl; // wont be implemented for now, is for interface language

@property (nonatomic) BOOL iv_load_policy; // default is 1.. available values 1 or 3.

@property (strong, nonatomic) NSString *list; // if listType == search then is (value specifies the search query)
// if listType == user_uploads then is (value identifies the YouTube channel whose uploaded videos will be loaded)
// if listType == user_uploads then is (value specifies a YouTube playlist ID. In the parameter value, you need to prepend the playlist ID with the letters PL as shown in the example below)
// http://www.youtube.com/embed?listType=playlist&list=PLC77007E23FF423C6 == PLC77007E23FF423C6

@property (strong, nonatomic) NSString *listType; // only allows the values -> playlist, search and user_uploads.

@property (nonatomic) BOOL loops; // default is 0

@property (nonatomic) BOOL modestbranding; // default is 0

//BOOL origin; // wont be implement for now.

@property (strong, nonatomic) NSString *playerapiid; // Value can be any alphanumeric string

@property (strong, nonatomic) NSString *playList; // Value is a comma-separated list of video IDs to play

@property (nonatomic) BOOL playsinline; // default is 0

@property (nonatomic) BOOL rel; // default is 1

@property (nonatomic) BOOL showinfo; // default is 1

@property (nonatomic) int start; // Values: A positive integer. This parameter causes the player to begin playing the
// video at the given number of seconds from the start of the video

@property (nonatomic) BOOL theme; // default is dark, available dark and light (if YES == light)

@property (nonatomic) BOOL hd;

@property (nonatomic) BOOL hd720;

@property (nonatomic) BOOL hd1080;

@property(nonatomic, strong) UIWebView *webView;

/** A delegate to be notified on playback events. */
@property(nonatomic, weak) id<JVYoutubePlayerDelegate> delegate;

#pragma mark - Player Initializers
/**
 * This method loads the player with the given video url.
 * This is a convenience method for calling YTPlayerView::loadPlayerWithVideoId:withPlayerVars:
 * without player variables.
 *
 * This method reloads the entire contents of the UIWebView and regenerates its HTML contents.
 * To change the currently loaded video without reloading the entire UIWebView, use the
 * YTPlayerView::cueVideoById:startSeconds:suggestedQuality: family of methods.
 *
 * @param videoURL The YouTube video url of the video to load in the player view.
 * @return YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadPlayerWithVideoURL:(NSString *)videoURL;

/**
 * This method loads the player with the given videos urls.
 * This is a convenience method for calling YTPlayerView::loadPlayerWithVideoId:withPlayerVars:
 * without player variables.
 *
 * This method reloads the entire contents of the UIWebView and regenerates its HTML contents.
 * To change the currently loaded video without reloading the entire UIWebView, use the
 * YTPlayerView::cueVideoById:startSeconds:suggestedQuality: family of methods.
 *
 * @param videosURL The YouTube videos urls of the videos to load in the player view.
 * @return YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadPlayerWithVideosURL:(NSArray *)videosURL;

/**
 * This method loads the player with the given video ID.
 * This is a convenience method for calling YTPlayerView::loadPlayerWithVideoId:withPlayerVars:
 * without player variables.
 *
 * This method reloads the entire contents of the UIWebView and regenerates its HTML contents.
 * To change the currently loaded video without reloading the entire UIWebView, use the
 * YTPlayerView::cueVideoById:startSeconds:suggestedQuality: family of methods.
 *
 * @param videoId The YouTube video ID of the video to load in the player view.
 * @return YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadPlayerWithVideoId:(NSString *)videoId;

/**
 * This method loads the player with the given videos IDs.
 * This is a convenience method for calling YTPlayerView::loadPlayerWithVideoId:withPlayerVars:
 * without player variables.
 *
 * This method reloads the entire contents of the UIWebView and regenerates its HTML contents.
 * To change the currently loaded video without reloading the entire UIWebView, use the
 * YTPlayerView::cueVideoById:startSeconds:suggestedQuality: family of methods.
 *
 * @param videosId The YouTube videos IDs of the videos to load in the player view.
 * @return YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadPlayerWithVideosId:(NSArray *)videosId;

/**
 * This method loads the player with the given playlist ID.
 * This is a convenience method for calling YTPlayerView::loadWithPlaylistId:withPlayerVars:
 * without player variables.
 *
 * This method reloads the entire contents of the UIWebView and regenerates its HTML contents.
 * To change the currently loaded video without reloading the entire UIWebView, use the
 * YTPlayerView::cuePlaylistByPlaylistId:index:startSeconds:suggestedQuality:
 * family of methods.
 *
 * @param playlistId The YouTube playlist ID of the playlist to load in the player view.
 * @return YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadPlayerWithPlaylistId:(NSString *)playlistId;

/**
 * This method loads the player with the given video ID and player variables. Player variables
 * specify optional parameters for video playback. For instance, to play a YouTube
 * video inline, the following playerVars dictionary would be used:
 *
 * @code
 * @{ @"playsinline" : @1 };
 * @endcode
 *
 * Note that when the documentation specifies a valid value as a number (typically 0, 1 or 2),
 * both strings and integers are valid values. The full list of parameters is defined at:
 *   https://developers.google.com/youtube/player_parameters?playerVersion=HTML5.
 *
 * This method reloads the entire contents of the UIWebView and regenerates its HTML contents.
 * To change the currently loaded video without reloading the entire UIWebView, use the
 * YTPlayerView::cueVideoById:startSeconds:suggestedQuality: family of methods.
 *
 * @param videoId The YouTube video ID of the video to load in the player view.
 * @param playerVars An NSDictionary of player parameters.
 * @return YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadWithVideoId:(NSString *)videoId playerVars:(NSDictionary *)playerVars;

/**
 * This method loads the player with the given playlist ID and player variables. Player variables
 * specify optional parameters for video playback. For instance, to play a YouTube
 * video inline, the following playerVars dictionary would be used:
 *
 * @code
 * @{ @"playsinline" : @1 };
 * @endcode
 *
 * Note that when the documentation specifies a valid value as a number (typically 0, 1 or 2),
 * both strings and integers are valid values. The full list of parameters is defined at:
 *   https://developers.google.com/youtube/player_parameters?playerVersion=HTML5.
 *
 * This method reloads the entire contents of the UIWebView and regenerates its HTML contents.
 * To change the currently loaded video without reloading the entire UIWebView, use the
 * YTPlayerView::cuePlaylistByPlaylistId:index:startSeconds:suggestedQuality:
 * family of methods.
 *
 * @param playlistId The YouTube playlist ID of the playlist to load in the player view.
 * @param playerVars An NSDictionary of player parameters.
 * @return YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadWithPlaylistId:(NSString *)playlistId playerVars:(NSDictionary *)playerVars;


//#pragma mark - Notifications

// Adding notifications to allow rotation when app is restricted to portrait mode only
// and to resize the webview in landscape for fullscreen youtube player, more info here:
//   https://developers.google.com/youtube/iframe_api_reference#getPlaylistIndex

/**
 * This method allows landscape mode when the app is retristed for portrait mode,
 * but requires extra settings on the AppDelegate.m please find an example here:
 *   https://developers.google.com/youtube/iframe_api_reference#getPlaylistIndex
 *
 */
//- (void)allowLandscapeMode;

/**
 * This method allows to update the youtube webview frame to change to full screen
 * in landscape mode (Good for playlists).
 * for more information find an example here:
 *   https://developers.google.com/youtube/iframe_api_reference#getPlaylistIndex
 *
 */
//- (void)allowAutoResizingPlayerFrame;


#pragma mark - Protected methods

/**
 * Protected method for loading both cases of playlist ID and array of video IDs. Loading
 * a playlist automatically starts playback.
 *
 * @param cueingString A JavaScript string representing an array, playlist ID or list of
 *                     video IDs to play with the playlist player.
 * @param index 0-index position of video to start playback on.
 * @param startSeconds Seconds after start of video to begin playback.
 * @param suggestedQuality Suggested JVPlaybackQuality to play the videos.
 * @return The result of cueing the playlist.
 */
- (void)loadPlaylist:(NSString *)cueingString index:(int)index startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality;

/**
 * Protected method for evaluating JavaScript in the WebView.
 *
 * @param jsToExecute The JavaScript code in string format that we want to execute.
 * @return JavaScript response from evaluating code.
 */
- (NSString *)stringFromEvaluatingJavaScript:(NSString *)jsToExecute;

/**
 * Protected method to convert a Objective-C BOOL value to JS boolean value.
 *
 * @param boolValue Objective-C BOOL value.
 * @return JavaScript Boolean value, i.e. "true" or "false".
 */
- (NSString *)stringForJSBoolean:(BOOL)boolValue;

- (void)schedulePauseVideo;

@end

#import "JVYoutubePlayer+PlayerControls.h"