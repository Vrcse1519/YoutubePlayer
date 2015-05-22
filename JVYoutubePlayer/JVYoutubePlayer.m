//
//  JVYoutubePlayer.m
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2015-05-21.
//  Copyright (c) 2015 com.jorgedeveloper. All rights reserved.
//

#import "JVYoutubePlayer.h"
#import "AppDelegate.h"


#pragma mark - Player Interface
@interface JVYoutubePlayer()

// for screen sizes
@property (nonatomic) CGSize screenRect;
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;

@property (nonatomic) CGRect prevFrame;
@property (nonatomic) BOOL playerContainsCustomParams;

@property (nonatomic) BOOL playerWithTimer;
@property (nonatomic) CGFloat stopTimer;

@property (nonatomic, strong) NSArray *loadPlayerDic;
@property (nonatomic, assign) BOOL isPlayerLoaded;

@property (nonatomic, strong) NSMutableDictionary *dicParameters;

@end


#pragma mark - Player Implementation

@implementation JVYoutubePlayer

#pragma mark - Player Initializers

- (BOOL)loadPlayerWithVideoURL:(NSString *)videoURL
{
    return [self loadWithVideoId:[self findVideoIdFromURL:videoURL] playerVars:nil];
}

- (BOOL)loadPlayerWithVideosURL:(NSArray *)videosURL
{
    if(videosURL.count > 0)
    {
        NSMutableArray *videosId = [[NSMutableArray alloc] initWithCapacity:videosURL.count];
        
        for(int x = 0; x < videosURL.count; x++)
        {
            videosId[x] = [[self findVideoIdFromURL:videosURL[x]] mutableCopy];
        }
        
        self.loadPlayerDic = @[@"loadPlayerWithVideosId", videosId];
        return [self loadPlayerWithVideoId:videosId[0]];
    }
    
    return nil;
}

- (BOOL)loadPlayerWithVideoId:(NSString *)videoId
{
    return [self loadWithVideoId:videoId playerVars:nil];
}

- (BOOL)loadPlayerWithVideosId:(NSArray *)videosId
{
    if(videosId.count > 0)
    {
        self.loadPlayerDic = @[@"loadPlayerWithVideosId", videosId];
        return [self loadPlayerWithVideoId:videosId[0]];
    }
    
    return nil;
}

- (BOOL)loadPlayerWithPlaylistId:(NSString *)playlistId
{
    return [self loadWithPlaylistId:playlistId playerVars:nil];
}

- (BOOL)loadWithVideoId:(NSString *)videoId playerVars:(NSDictionary *)playerVars
{
    if(self.playerContainsCustomParams)
    {
        return [self loadWithPlayerParams:playerVars];
    }
    
    if (!playerVars)
    {
        playerVars = @{};
    }
    
    if(self.dicParameters || self.dicParameters.count > 0)
    {
        NSDictionary *playerParams = @{ @"videoId" : videoId, @"playerVars" : self.dicParameters };
        return [self loadWithPlayerParams:playerParams];
    }
    
    NSDictionary *playerParams = @{ @"videoId" : videoId, @"playerVars" : playerVars };

    return [self loadWithPlayerParams:playerParams];
}

- (BOOL)loadWithPlaylistId:(NSString *)playlistId playerVars:(NSDictionary *)playerVars
{
    // Mutable copy because we may have been passed an immutable config dictionary.
    NSMutableDictionary *tempPlayerVars = [[NSMutableDictionary alloc] init];
    [tempPlayerVars setValue:@"playlist" forKey:@"listType"];
    [tempPlayerVars setValue:playlistId forKey:@"list"];
    [tempPlayerVars addEntriesFromDictionary:playerVars];  // No-op if playerVars is null
    [tempPlayerVars addEntriesFromDictionary:self.dicParameters];
    
    if(self.dicParameters || self.dicParameters.count > 0)
    {
        NSDictionary *playerParams = @{ @"playerVars" : tempPlayerVars };
        return [self loadWithPlayerParams:playerParams];
    }

    NSDictionary *playerParams = @{ @"playerVars" : tempPlayerVars };
    
    return [self loadWithPlayerParams:playerParams];
}

/**
 * Removes customs notifications
 * @name dealloc
 *
 * @param ...
 * @return void...
 */
- (void)dealloc
{
    // removing notification center
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


#pragma mark - Player methods

- (void)playVideo
{
    if(self.playerWithTimer)
        [self schedulePauseVideo];
    
    [self stringFromEvaluatingJavaScript:@"player.playVideo();"];
}

- (void)pauseVideo
{
    [self stringFromEvaluatingJavaScript:@"player.pauseVideo();"];
}

- (void)stopVideo
{
    [self stringFromEvaluatingJavaScript:@"player.stopVideo();"];
}

- (void)seekToSeconds:(float)seekToSeconds allowSeekAhead:(BOOL)allowSeekAhead
{
    NSNumber *secondsValue = [NSNumber numberWithFloat:seekToSeconds];
    NSString *allowSeekAheadValue = [self stringForJSBoolean:allowSeekAhead];
    NSString *command = [NSString stringWithFormat:@"player.seekTo(%@, %@);", secondsValue, allowSeekAheadValue];
    [self stringFromEvaluatingJavaScript:command];
}

- (void)clearVideo
{
    [self stringFromEvaluatingJavaScript:@"player.clearVideo();"];
}


#pragma mark - Playing a video in a playlist

- (void)nextVideo {
    [self stringFromEvaluatingJavaScript:@"player.nextVideo();"];
}

- (void)previousVideo
{
    [self stringFromEvaluatingJavaScript:@"player.previousVideo();"];
}

- (void)playVideoAt:(int)index
{
    NSString *command = [NSString stringWithFormat:@"player.playVideoAt(%@);", [NSNumber numberWithInt:index]];
    [self stringFromEvaluatingJavaScript:command];
}


#pragma mark - Cueing methods

- (void)cueVideoById:(NSString *)videoId startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSString *qualityValue = [self stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.cueVideoById('%@', %@, '%@');", videoId, startSecondsValue, qualityValue];
    [self stringFromEvaluatingJavaScript:command];
}

- (void)cueVideoById:(NSString *)videoId startSeconds:(float)startSeconds endSeconds:(float)endSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    self.playerWithTimer = YES;
    self.stopTimer = endSeconds+1;
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSNumber *endSecondsValue = [NSNumber numberWithFloat:endSeconds];
    NSString *qualityValue = [self stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.cueVideoById('%@', %@, %@, '%@');", videoId, startSecondsValue, endSecondsValue, qualityValue];
    [self stringFromEvaluatingJavaScript:command];
}

- (void)loadVideoById:(NSString *)videoId startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSString *qualityValue = [self stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.loadVideoById('%@', %@, '%@');", videoId, startSecondsValue, qualityValue];
    [self stringFromEvaluatingJavaScript:command];
}

- (void)loadVideoById:(NSString *)videoId startSeconds:(CGFloat)startSeconds endSeconds:(CGFloat)endSeconds suggestedQuality:( JVPlaybackQuality)suggestedQuality
{
    self.playerWithTimer = YES;
    self.stopTimer = endSeconds+1;
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSNumber *endSecondsValue = [NSNumber numberWithFloat:endSeconds];
    NSString *qualityValue = [self stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.loadVideoById('%@', %@, %@, '%@');", videoId, startSecondsValue, endSecondsValue, qualityValue];
    [self stringFromEvaluatingJavaScript:command];
}

- (void)cueVideoByURL:(NSString *)videoURL startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSString *qualityValue = [self stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.cueVideoByUrl('%@', %@, '%@');", videoURL, startSecondsValue, qualityValue];
    [self stringFromEvaluatingJavaScript:command];
}

- (void)cueVideoByURL:(NSString *)videoURL startSeconds:(float)startSeconds endSeconds:(float)endSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    self.playerWithTimer = YES;
    self.stopTimer = endSeconds+1;
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSNumber *endSecondsValue = [NSNumber numberWithFloat:endSeconds];
    NSString *qualityValue = [self stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.cueVideoByUrl('%@', %@, %@, '%@');", videoURL, startSecondsValue, endSecondsValue, qualityValue];
    [self stringFromEvaluatingJavaScript:command];
}

- (void)loadVideoByURL:(NSString *)videoURL startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSString *qualityValue = [self stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.loadVideoByUrl('%@', %@, '%@');", videoURL, startSecondsValue, qualityValue];
    [self stringFromEvaluatingJavaScript:command];
}

- (void)loadVideoByURL:(NSString *)videoURL startSeconds:(float)startSeconds endSeconds:(float)endSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    self.playerWithTimer = YES;
    self.stopTimer = endSeconds+1;
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSNumber *endSecondsValue = [NSNumber numberWithFloat:endSeconds];
    NSString *qualityValue = [self stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.loadVideoByUrl('%@', %@, %@, '%@');", videoURL, startSecondsValue, endSecondsValue, qualityValue];
    [self stringFromEvaluatingJavaScript:command];
}


#pragma mark - Cueing methods for lists

- (void)cuePlaylistByPlaylistId:(NSString *)playlistId index:(int)index startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSString *playlistIdString = [NSString stringWithFormat:@"'%@'", playlistId];
    [self cuePlaylist:playlistIdString index:index startSeconds:startSeconds suggestedQuality:suggestedQuality];
}

- (void)cuePlaylistByVideos:(NSArray *)videoIds index:(int)index startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    [self cuePlaylist:[self stringFromVideoIdArray:videoIds] index:index startSeconds:startSeconds suggestedQuality:suggestedQuality];
}

- (void)loadPlaylistByPlaylistId:(NSString *)playlistId index:(int)index startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSString *playlistIdString = [NSString stringWithFormat:@"'%@'", playlistId];
    [self loadPlaylist:playlistIdString index:index startSeconds:startSeconds suggestedQuality:suggestedQuality];
}

- (void)loadPlaylistByVideos:(NSArray *)videoIds index:(int)index startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    [self loadPlaylist:[self stringFromVideoIdArray:videoIds] index:index startSeconds:startSeconds suggestedQuality:suggestedQuality];
}


#pragma mark - Cueing & loading playlist

/**
 * Private method for cueing both cases of playlist ID and array of video IDs. Cueing
 * a playlist does not start playback.
 *
 * @param cueingString A JavaScript string representing an array, playlist ID or list of
 *                     video IDs to play with the playlist player.
 * @param index 0-index position of video to start playback on.
 * @param startSeconds Seconds after start of video to begin playback.
 * @param suggestedQuality Suggested JVPlaybackQuality to play the videos.
 * @return The result of cueing the playlist.
 */
- (void)cuePlaylist:(NSString *)cueingString index:(int)index startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSNumber *indexValue = [NSNumber numberWithInt:index];
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSString *qualityValue = [self stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.cuePlaylist(%@, %@, %@, '%@');", cueingString, indexValue, startSecondsValue, qualityValue];
    [self stringFromEvaluatingJavaScript:command];
}


#pragma mark - Setting the playback rate

- (float)playbackRate
{
    NSString *returnValue = [self stringFromEvaluatingJavaScript:@"player.getPlaybackRate();"];
    return [returnValue floatValue];
}

- (void)setPlaybackRate:(float)suggestedRate
{
    NSString *command = [NSString stringWithFormat:@"player.setPlaybackRate(%f);", suggestedRate];
    [self stringFromEvaluatingJavaScript:command];
}

- (NSArray *)availablePlaybackRates
{
    NSString *returnValue = [self stringFromEvaluatingJavaScript:@"player.getAvailablePlaybackRates();"];
    
    NSData *playbackRateData = [returnValue dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonDeserializationError;
    NSArray *playbackRates = [NSJSONSerialization JSONObjectWithData:playbackRateData
                                                             options:kNilOptions
                                                               error:&jsonDeserializationError];
    
    if (jsonDeserializationError)
    {
        return nil;
    }
    
    return playbackRates;
}


#pragma mark - Setting playback behavior for playlists

- (void)setLoop:(BOOL)loop
{
    NSString *loopPlayListValue = [self stringForJSBoolean:loop];
    NSString *command = [NSString stringWithFormat:@"player.setLoop(%@);", loopPlayListValue];
    [self stringFromEvaluatingJavaScript:command];
}

- (void)setShuffle:(BOOL)shuffle
{
    NSString *shufflePlayListValue = [self stringForJSBoolean:shuffle];
    NSString *command = [NSString stringWithFormat:@"player.setShuffle(%@);", shufflePlayListValue];
    [self stringFromEvaluatingJavaScript:command];
}


#pragma mark - Playback status

- (float)videoLoadedFraction
{
    return [[self stringFromEvaluatingJavaScript:@"player.getVideoLoadedFraction();"] floatValue];
}

- (JVPlayerState)playerState
{
    NSString *returnValue = [self stringFromEvaluatingJavaScript:@"player.getPlayerState();"];
    return [self playerStateForString:returnValue];
}

- (float)currentTime
{
    return [[self stringFromEvaluatingJavaScript:@"player.getCurrentTime();"] floatValue];
}

// Playback quality
- (JVPlaybackQuality)playbackQuality
{
    NSString *qualityValue = [self stringFromEvaluatingJavaScript:@"player.getPlaybackQuality();"];
    return [self playbackQualityForString:qualityValue];
}

- (void)setPlaybackQuality:(JVPlaybackQuality)suggestedQuality
{
    NSString *qualityValue = [self stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.setPlaybackQuality('%@');", qualityValue];
    [self stringFromEvaluatingJavaScript:command];
}

- (NSArray *)availableQualityLevels
{
    NSString *returnValue = [self stringFromEvaluatingJavaScript:@"player.getAvailableQualityLevels();"];
    
    NSData *availableQualityLevelsData = [returnValue dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonDeserializationError;
    
    NSArray *rawQualityValues = [NSJSONSerialization JSONObjectWithData:availableQualityLevelsData
                                                                options:kNilOptions
                                                                  error:&jsonDeserializationError];
    
    if (jsonDeserializationError)
    {
        return nil;
    }
    
    NSMutableArray *levels = [[NSMutableArray alloc] init];
    for (NSString *rawQualityValue in rawQualityValues) {
        JVPlaybackQuality quality = [self playbackQualityForString:rawQualityValue];
        [levels addObject:[NSNumber numberWithInt:quality]];
    }
    
    return levels;
}


#pragma mark - Video information methods

- (int)duration
{
    return [[self stringFromEvaluatingJavaScript:@"player.getDuration();"] intValue];
}

- (NSURL *)videoUrl
{
    return [NSURL URLWithString:[self stringFromEvaluatingJavaScript:@"player.getVideoUrl();"]];
}

- (NSString *)videoEmbedCode
{
    return [self stringFromEvaluatingJavaScript:@"player.getVideoEmbedCode();"];
}


#pragma mark - Playlist methods

- (NSArray *)playlist
{
    NSString *returnValue = [self stringFromEvaluatingJavaScript:@"player.getPlaylist();"];
    
    NSData *playlistData = [returnValue dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonDeserializationError;
    NSArray *videoIds = [NSJSONSerialization JSONObjectWithData:playlistData
                                                        options:kNilOptions
                                                          error:&jsonDeserializationError];
    
    if (jsonDeserializationError) {
        return nil;
    }
    
    return videoIds;
}

- (int)playlistIndex
{
    NSString *returnValue = [self stringFromEvaluatingJavaScript:@"player.getPlaylistIndex();"];
    return [returnValue intValue];
}


#pragma mark - Helper methods

- (void)schedulePauseVideo
{
    [self performSelector:@selector(pauseVideo) withObject:self afterDelay:self.stopTimer];
}

- (NSString *)findVideoIdFromURL:(NSString *)videoURL
{
    NSString *videoId;
    NSString *searchedString = videoURL;
    NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
    NSString *pattern = @"(youtu(?:\\.be|be\\.com)\\/(?:.*v(?:\\/|=)|(?:.*\\/)?)([\\w'-]+))";
    NSError  *error = nil;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:searchedString options:0 range: searchedRange];
    
    // debugging plain youtube link
//    NSLog(@"group1: %@", [searchedString substringWithRange:[match rangeAtIndex:1]]);
    // debugging youtube video id
//    NSLog(@"group2: %@", [searchedString substringWithRange:[match rangeAtIndex:2]]);
    
    videoId = [searchedString substringWithRange:[match rangeAtIndex:2]];
    
    return videoId;
}


#pragma mark - WebView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // logging state of video
    NSLog(@"***** Checking Loading -> %@", request.URL.absoluteString);
    
    // adding timer to pause video at giving time
    if ([request.URL.absoluteString isEqualToString:@"ytplayer://onStateChange?data=1"])
    {
        if(self.playerWithTimer)
            [self schedulePauseVideo];
    }
    
    // forcing video to autoplay
    if ([request.URL.absoluteString isEqualToString:@"ytplayer://onReady?data=null"])
    {
        if(self.autoplay)
            [self playVideo];
    }
    
    if ([request.URL.absoluteString isEqualToString:@"ytplayer://onStateChange?data=1"])
    {
//        [self playVideo]; // play video if goes into background
    }
    
    // if found an error skip to next video
    if ([request.URL.absoluteString isEqualToString:@"ytplayer://onError?data=150"] || [request.URL.absoluteString isEqualToString:@"ytplayer://onStateChange?data=0"])
    {
        [self nextVideo]; // play next video if current can't be played
    }
    
    if (self.allowLandscapeMode) {
        // allows youtube player in landscape mode
        if ([request.URL.absoluteString isEqualToString:@"ytplayer://onStateChange?data=3"])
        {
            [self playerStarted];
            return NO;
        }
        else if ([request.URL.absoluteString isEqualToString:@"ytplayer://onStateChange?data=2"])
        {
            [self playerEnded];
            return NO;
        }
    }
    
    if ([request.URL.scheme isEqual:@"ytplayer"])
    {
        [self notifyDelegateOfYouTubeCallbackUrl:request.URL];
        return NO;
    }
//    else if ([request.URL.scheme isEqual: @"http"] || [request.URL.scheme isEqual:@"https"])
//    {
//        return [self handleHttpNavigationToUrl:request.URL];
//    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting to load info
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    [self setPlaybackQuality:kJVPlaybackQualityHD720];
    
    if(self.allowLandscapeMode)
    {
        // adding listener to webView
        [self.webView stringByEvaluatingJavaScriptFromString:@" for (var i = 0, videos = document.getElementsByTagName('video'); i < videos.length; i++) {"
         @"      videos[i].addEventListener('webkitbeginfullscreen', function(){ "
         @"           window.location = 'ytplayer://begin-fullscreen';"
         @"      }, false);"
         @""
         @"      videos[i].addEventListener('webkitendfullscreen', function(){ "
         @"           window.location = 'ytplayer://end-fullscreen';"
         @"      }, false);"
         @" }"
         ];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // we got an error
}

#pragma mark - Private methods

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
- (void)loadPlaylist:(NSString *)cueingString index:(int)index startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSNumber *indexValue = [NSNumber numberWithInt:index];
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSString *qualityValue = [self stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.loadPlaylist(%@, %@, %@, '%@');", cueingString, indexValue, startSecondsValue, qualityValue];
    [self stringFromEvaluatingJavaScript:command];
}

/**
 * Private method to handle "navigation" to a callback URL of the format
 * http://ytplayer/action?data=someData
 * This is how the UIWebView communicates with the containing Objective-C code.
 * Side effects of this method are that it calls methods on this class's delegate.
 *
 * @param url A URL of the format http://ytplayer/action.
 */
- (void)notifyDelegateOfYouTubeCallbackUrl: (NSURL *) url
{
    NSString *action = url.host;

    // We know the query can only be of the format http://ytplayer?data=SOMEVALUE,
    // so we parse out the value.
    NSString *query = url.query;
    NSString *data;
    if (query)
    {
        data = [query componentsSeparatedByString:@"="][1];
    }

    if ([action isEqual:kJVPlayerCallbackOnReady])
    {
        self.isPlayerLoaded = YES;
        
        if ([self.delegate respondsToSelector:@selector(playerViewDidBecomeReady:)])
        {
            [self.delegate playerViewDidBecomeReady:self];
        }
    }
    else if ([action isEqual:kJVPlayerCallbackOnStateChange])
    {
        if ([self.delegate respondsToSelector:@selector(playerView:didChangeToState:)])
        {
            JVPlayerState state = kJVPlayerStateUnknown;

            if ([data isEqual:kJVPlayerStateEndedCode])
            {
                state = kJVPlayerStateEnded;
            }
            else if ([data isEqual:kJVPlayerStatePlayingCode])
            {
                state = kJVPlayerStatePlaying;
            }
            else if ([data isEqual:kJVPlayerStatePausedCode])
            {
                state = kJVPlayerStatePaused;
            }
            else if ([data isEqual:kJVPlayerStateBufferingCode])
            {
                state = kJVPlayerStateBuffering;
            }
            else if ([data isEqual:kJVPlayerStateCuedCode])
            {
                state = kJVPlayerStateQueued;
            }
            else if ([data isEqual:kJVPlayerStateUnstartedCode])
            {
                state = kJVPlayerStateUnstarted;
            }

            [self.delegate playerView:self didChangeToState:state];
        }
    }
    else if ([action isEqual:kJVPlayerCallbackOnPlaybackQualityChange])
    {
        if ([self.delegate respondsToSelector:@selector(playerView:didChangeToQuality:)])
        {
            JVPlaybackQuality quality = [self playbackQualityForString:data];
            [self.delegate playerView:self didChangeToQuality:quality];
        }
    }
    else if ([action isEqual:kJVPlayerCallbackOnError])
    {
        if ([self.delegate respondsToSelector:@selector(playerView:receivedError:)])
        {
            JVPlayerError error = kJVPlayerErrorUnknown;

            if ([data isEqual:kJVPlayerErrorInvalidParamErrorCode])
            {
                error = kJVPlayerErrorInvalidParam;
            }
            else if ([data isEqual:kJVPlayerErrorHTML5ErrorCode])
            {
                error = kJVPlayerErrorHTML5Error;
            }
            else if ([data isEqual:kJVPlayerErrorNotEmbeddableErrorCode])
            {
                error = kJVPlayerErrorNotEmbeddable;
            }
            else if ([data isEqual:kJVPlayerErrorVideoNotFoundErrorCode] || [data isEqual:kJVPlayerErrorCannotFindVideoErrorCode])
            {
                error = kJVPlayerErrorVideoNotFound;
            }

            [self.delegate playerView:self receivedError:error];
        }
    }
}

- (BOOL)handleHttpNavigationToUrl:(NSURL *) url
{
    // Usually this means the user has clicked on the YouTube logo or an error message in the
    // player. Most URLs should open in the browser. The only http(s) URL that should open in this
    // UIWebView is the URL for the embed, which is of the format:
    //     http(s)://www.youtube.com/embed/[VIDEO ID]?[PARAMETERS]
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kJVPlayerEmbedUrlRegexPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:url.absoluteString
                                                    options:0
                                                      range:NSMakeRange(0, [url.absoluteString length])];
    if (match)
    {
        return YES;
    }
    else
    {
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
}


/**
 * Private helper method to load an iframe player with the given player parameters.
 *
 * @param additionalPlayerParams An NSDictionary of parameters in addition to required parameters
 *                               to instantiate the HTML5 player with. This differs depending on
 *                               whether a single video or playlist is being loaded.
 * @return YES if successful, NO if not.
 */
- (BOOL)loadWithPlayerParams:(NSDictionary *)additionalPlayerParams
{
    // creating webview for youtube player
    if(!_webView || !_webView.window)
        [self addSubview:self.webView];
    
    // preserving users frame
    self.prevFrame = self.frame;
    
    NSDictionary *playerCallbacks = @{
        @"onReady" : @"onReady",
        @"onStateChange" : @"onStateChange",
        @"onPlaybackQualityChange" : @"onPlaybackQualityChange",
        @"onError" : @"onPlayerError"
    };
    
    NSMutableDictionary *playerParams = [[NSMutableDictionary alloc] init];
    [playerParams addEntriesFromDictionary:additionalPlayerParams];
    [playerParams setValue:@"100%" forKey:@"height"];
    [playerParams setValue:@"100%" forKey:@"width"];
    [playerParams setValue:playerCallbacks forKey:@"events"];

    // This must not be empty so we can render a '{}' in the output JSON
    if (![playerParams objectForKey:@"playerVars"])
    {
        [playerParams setValue:[[NSDictionary alloc] init] forKey:@"playerVars"];
    }

    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JVYoutubePlayer-iFrame"
                                                     ofType:@"html"
                                                inDirectory:@""];

    NSString *embedHTMLTemplate = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];

    if (error)
    {
        NSLog(@"Received error rendering template: %@", error);
        return NO;
    }

    // Render the playerVars as a JSON dictionary.
    NSError *jsonRenderingError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerParams
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jsonRenderingError];
    
    if (jsonRenderingError)
    {
        NSLog(@"Attempted configuration of player with invalid playerVars: %@ \tError: %@", playerParams, jsonRenderingError);
        NSString *errMessage = [NSString stringWithFormat:@"\nAttempted configuration of player with invalid playerVars: %@ \nError: %@", playerParams, jsonRenderingError];
        @throw [NSException exceptionWithName:NSGenericException reason:errMessage userInfo:nil];
        return NO;
    }

    NSString *playerVarsJsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSString *embedHTML = [NSString stringWithFormat:embedHTMLTemplate, playerVarsJsonString];
    
    // for debugging html file
//    NSLog(@"%@", embedHTML);
    
    [self.webView loadHTMLString:embedHTML baseURL:[NSURL URLWithString:@"about:blank"]];

    return YES;
}

/**
 * Protected method for evaluating JavaScript in the WebView.
 *
 * @param jsToExecute The JavaScript code in string format that we want to execute.
 * @return JavaScript response from evaluating code.
 */
- (NSString *)stringFromEvaluatingJavaScript:(NSString *)jsToExecute
{
    return [self.webView stringByEvaluatingJavaScriptFromString:jsToExecute];
}

/**
 * Protected method to convert a Objective-C BOOL value to JS boolean value.
 *
 * @param boolValue Objective-C BOOL value.
 * @return JavaScript Boolean value, i.e. "true" or "false".
 */
- (NSString *)stringForJSBoolean:(BOOL)boolValue
{
    return boolValue ? @"true" : @"false";
}


#pragma mark - Helper Functions

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
 * Executes when player starts full screen of video player (good for changing app orientation)
 * @name playerStarted
 *
 * @param ...
 * @return void...
 */
- (void)playerStarted//:(NSNotification*)notification
{
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).videoIsInFullscreen = YES;
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
}


/**
 * Executes when player exits full screen of video player (good for changing app orientation)
 * @name playerEnded
 *
 * @param ...
 * @return void...
 */
- (void)playerEnded//:(NSNotification*)notification
{
    if(self.forceBackToPortraitMode == YES)
    {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).videoIsInFullscreen = NO;
        
        [self supportedInterfaceOrientations];
        
        [self shouldAutorotate:UIInterfaceOrientationPortrait];
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    }
}

- (NSInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/**
 * Updates player frame depending on orientation
 * @name orientationChanged
 *
 * @param screenHeight, screenWidth and JVYoutubePlayer
 * @return void but updates JVYoutubePlayer frame
 */
- (void)orientationChanged:(NSNotification*)notification
{
    UIDevice *device = [UIDevice currentDevice];
    
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight)
    {
        self.screenRect = [[UIScreen mainScreen] bounds].size;
        self.screenHeight = self.screenRect.height;
        self.screenWidth = self.screenRect.width;
        
        self.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
    }
    else if(device.orientation == UIDeviceOrientationPortrait)
    {
        self.frame = self.prevFrame;
    }
    else if (device.orientation == UIDeviceOrientationPortraitUpsideDown)
    {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).videoIsInFullscreen = NO;
        
        [self supportedInterfaceOrientations];
        
        [self shouldAutorotate:UIInterfaceOrientationPortrait];
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    }
}


#pragma mark - Custom getters

- (UIWebView *)webView
{
    if(!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:self.bounds];
        _webView.delegate = self;
        _webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.bounces = NO;
        _webView.allowsInlineMediaPlayback = YES;
        _webView.mediaPlaybackRequiresUserAction = NO;
        _webView.mediaPlaybackAllowsAirPlay = YES;
    }
    
    return _webView;
}

- (NSMutableDictionary*)dicParameters
{
    if(!_dicParameters)
    {
        _dicParameters = [[NSMutableDictionary alloc] init];
    }
    
    return _dicParameters;
}


#pragma mark - Custom setters

// Custom setters and getters for youtube player parameters
// to be loaded when player loads video.
// These parameters can be set by the user, if they are not
// they won't be loaded to the player because, youtube api
// will use defaults parameters when player created.

- (void)setIsPlayerLoaded:(BOOL)isPlayerLoaded
{
    if(self.loadPlayerDic.count > 0)
    {
        if([self.loadPlayerDic[0] isEqualToString:@"loadPlayerWithVideosId"])
        {
            [self loadPlaylist:[self stringFromVideoIdArray:self.loadPlayerDic[1]] index:0 startSeconds:0.0 suggestedQuality:kJVPlaybackQualityHD720];
        }
    }
    
    _isPlayerLoaded = isPlayerLoaded;
}

-(void)setAllowLandscapeMode:(BOOL)allowLandscapeMode {
    _allowLandscapeMode = allowLandscapeMode;
}

-(void)setForceBackToPortraitMode:(BOOL)forceBackToPortraitMode {
    _forceBackToPortraitMode = forceBackToPortraitMode;
}

-(void)setAllowAutoResizingPlayerFrame:(BOOL)allowAutoResizingPlayerFrame {
    
    if(allowAutoResizingPlayerFrame == YES) {
        // current device
        UIDevice *device = [UIDevice currentDevice];
        
        //Tell it to start monitoring the accelerometer for orientation
        [device beginGeneratingDeviceOrientationNotifications];
        //Get the notification centre for the app
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:device];
    }
    _allowAutoResizingPlayerFrame = allowAutoResizingPlayerFrame;
}

-(void)setAutohide:(BOOL)autohide {

    if(autohide == YES) {
        [self.dicParameters setObject:@(1) forKey:@"autohide"];
    }
    _autohide = autohide;
}

-(void)setAutoplay:(BOOL)autoplay {
    
    if(autoplay == YES) {
        [self.dicParameters setObject:@(1) forKey:@"autoplay"];
    }
    _autoplay = autoplay;
}

-(void)setCc_load_policy:(BOOL)cc_load_policy {
    
    if(cc_load_policy == YES) {
        [self.dicParameters setObject:@(1) forKey:@"cc_load_policy"];
    }
    _cc_load_policy = cc_load_policy;
}

-(void)setColor:(BOOL)color {
    
    if(color == YES) {
        [self.dicParameters setObject:@"white" forKey:@"color"];
    }
    _color = color;
}

-(void)setControls:(BOOL)controls {
    
    if(controls == YES) {
        [self.dicParameters setObject:@(0) forKey:@"controls"];
    }
    _controls = controls;
}

-(void)setDisablekb:(BOOL)disablekb {
    
    if(disablekb == YES) {
        [self.dicParameters setObject:@(1) forKey:@"disablekb"];
    }
    _disablekb = disablekb;
}

-(void)setEnablejsapi:(BOOL)enablejsapi {
    
    if(enablejsapi == YES) {
        [self.dicParameters setObject:@(1) forKey:@"enablejsapi"];
    }
    _enablejsapi = enablejsapi;
}

-(void)setEnd:(int)end {
    
    if(end > 0) {
        [self.dicParameters setObject:@(end) forKey:@"end"];
    }
    _end = end;
}

-(void)setFullscreen:(BOOL)fullscreen {
    
    if(fullscreen == YES) {
        [self.dicParameters setObject:@(0) forKey:@"fs"];
    }
    _fullscreen = fullscreen;
}

-(void)setIv_load_policy:(BOOL)iv_load_policy {
    
    if(iv_load_policy == YES) {
        [self.dicParameters setObject:@(3) forKey:@"iv_load_policy"];
    }
    _iv_load_policy = iv_load_policy;
}

-(void)setList:(NSString *)list {
    
    if(list.length > 0) {
        [self.dicParameters setObject:list forKey:@"list"];
    }
    _list = list;
}

-(void)setListType:(NSString *)listType {
    
    if(listType.length > 0) {
        [self.dicParameters setObject:listType forKey:@"listType"];
    }
    _listType = listType;
}

-(void)setLoops:(BOOL)loops {
    
    if(loops == YES) {
        [self.dicParameters setObject:@(1) forKey:@"loop"];
    }
    _loops = loops;
}

-(void)setModestbranding:(BOOL)modestbranding {
    
    if(modestbranding == YES) {
        [_dicParameters setObject:[NSNumber numberWithInt:1] forKey:@"modestbranding"];
    }
    _modestbranding = modestbranding;
}

-(void)setPlayerapiid:(NSString *)playerapiid {
    
    if(playerapiid.length > 0) {
        [self.dicParameters setObject:playerapiid forKey:@"playerapiid"];
    }
    _playerapiid = playerapiid;
}

-(void)setPlayList:(NSString*)playList {
    
    if(playList.length > 0) {
        [self.dicParameters setObject:playList forKey:@"playlist"];
    }
    _playList = playList;
}

-(void)setPlaysinline:(BOOL)playsinline {
    
    if(playsinline == YES) {
        [self.dicParameters setObject:@(1) forKey:@"playsinline"];
    }
    _playsinline = playsinline;
}

-(void)setRel:(BOOL)rel {
    
    if(rel == YES) {
        [self.dicParameters setObject:@(1) forKey:@"rel"];
    }
    _rel = rel;
}

-(void)setShowinfo:(BOOL)showinfo {
    
    if(showinfo == YES) {
        [self.dicParameters setObject:@(1) forKey:@"showinfo"];
    }
    else{
        [self.dicParameters setObject:@(0) forKey:@"showinfo"];
    }
    _showinfo = showinfo;
}

-(void)setStart:(int)start {
    
    if(start == YES) {
        [self.dicParameters setObject:@(start) forKey:@"start"];
    }
    _start = start;
}

-(void)setTheme:(BOOL)theme {
    
    if(theme == YES) {
        [self.dicParameters setObject:@"light" forKey:@"theme"];
    }
    _theme = theme;
}

-(void)setHd:(BOOL)hd {
    if(hd == YES) {
        [self.dicParameters setObject:@(1) forKey:@"hd"];
    }
    _hd = hd;
}

-(void)setHd720:(BOOL)hd720 {
    if(hd720 == YES) {
        [self.dicParameters setObject:@"hd720" forKey:@"vq"];
    }
    _hd720 = hd720;
}

-(void)setHd1080:(BOOL)hd1080 {
    if(hd1080 == YES) {
        [self.dicParameters setObject:@"hd1080" forKey:@"vq"];
    }
    _hd1080 = hd1080;
}

@end