//
//  JVYoutubePlayer+PlayerControls.m
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2015-05-22.
//  Copyright (c) 2015 com.jorgedeveloper. All rights reserved.
//

#import "JVYoutubePlayer+PlayerControls.h"

@implementation JVYoutubePlayer (PlayerControls)

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
    return [self.appHelper playerStateForString:returnValue];
}

- (float)currentTime
{
    return [[self stringFromEvaluatingJavaScript:@"player.getCurrentTime();"] floatValue];
}

// Playback quality
- (JVPlaybackQuality)playbackQuality
{
    NSString *qualityValue = [self stringFromEvaluatingJavaScript:@"player.getPlaybackQuality();"];
    return [self.appHelper playbackQualityForString:qualityValue];
}

- (void)setPlaybackQuality:(JVPlaybackQuality)suggestedQuality
{
    NSString *qualityValue = [self.appHelper stringForPlaybackQuality:suggestedQuality];
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
        JVPlaybackQuality quality = [self.appHelper playbackQualityForString:rawQualityValue];
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

@end