//
//  ViewController.m
//  YoutubePlayer
//
//  Created by Jorge Valbuena on 2014-10-24.
//  Copyright (c) 2014 com.jorgedeveloper. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SphereMenu.h"
#import "Chameleon.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


static NSString const *api_key =@"AIzaSyAnNzksYIn-iEWWIvy8slUZM44jH6WjtP8"; // public youtube api key

@interface ViewController () <SphereMenuDelegate>

@property (nonatomic) int counter;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) BOOL isInBackgroundMode;
@property (nonatomic, strong) SphereMenu *sphereMenu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *colors = @[FlatGreenDark, FlatGreen, FlatMintDark, FlatMint];

    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom
                                                      withFrame:self.view.frame
                                                      andColors:colors];

    // loading a video by URL
    // [self.player loadPlayerWithVideoURL:@"https://www.youtube.com/watch?v=mIAgmyoAmmc"];
    
    // loading multiple videos from url
    // NSArray *videosUrl = @[@"https://www.youtube.com/watch?v=Zv1QV6lrc_Y", @"https://www.youtube.com/watch?v=NVGEMZ_1ETs"];
    // [self.player loadPlayerWithVideosURL:videosUrl];

    // loading videoId
    // [self.player loadPlayerWithVideoId:@"O8TiugM6Jg"];

    // loading playlist to video player
     [self.player loadPlayerWithPlaylistId:@"PLEE58C6029A8A6ADE"];
    
    // loading a set of videos to the player
    // NSArray *videoList = @[@"O8TiugM6Jg", @"NVGEMZ_1ETs"];
    // [self.player loadPlayerWithVideosId:videoList];
    
    // adding to subview
    [self.view addSubview:self.player];

    // adding controls menu to view
    [self.view addSubview:self.sphereMenu];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:nil];
    
    NSError *sessionError = nil;
    
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    
    if (!success)
    {
        NSLog(@"setCategory error %@", sessionError);
    }
    
    success = [audioSession setActive:YES error:&sessionError];
    
    if (!success)
    {
        NSLog(@"setActive error %@", sessionError);
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appIsInBakcground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillBeInBakcground:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Turn on remote control event delivery
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // Set itself as the first responder
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Turn off remote control event delivery
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    // Resign as first responder
    [self resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl)
    {
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if(self.player.playerState == kJVPlayerStatePaused || self.player.playerState == kJVPlayerStateEnded || self.player.playerState == kJVPlayerStateUnstarted || self.player.playerState == kJVPlayerStateUnknown || self.player.playerState == kJVPlayerStateQueued || self.player.playerState == kJVPlayerStateBuffering)
                {
                    [self.player playVideo];
                }
                else {
                    [self.player pauseVideo];
                }
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self.player previousVideo];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self.player nextVideo];
                break;
                
            default:
                break;
        }
    }
}


#pragma mark -
#pragma mark Getters and Setters

- (JVYoutubePlayer *)player
{
    if(!_player)
    {
        _player = [[JVYoutubePlayer alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 234)];
        _player.delegate = self;
        _player.autoplay = NO;
        _player.modestbranding = YES;
        _player.allowLandscapeMode = YES;
        _player.forceBackToPortraitMode = NO;
        _player.allowAutoResizingPlayerFrame = YES;
        _player.playsinline = NO;
        _player.fullscreen = YES;
        _player.playsinline = YES;
        _player.showinfo = NO;
        _player.controls = YES;
    }
    
    return _player;
}

- (SphereMenu *)sphereMenu
{
    if(!_sphereMenu)
    {
        UIImage *startImage = [UIImage imageNamed:@"start"];
        UIImage *image1 = [UIImage imageNamed:@"rewind"];
        UIImage *image2 = [UIImage imageNamed:@"player"];
        UIImage *image3 = [UIImage imageNamed:@"forward"];
        NSArray *images = @[image1, image2, image3];
    
        _sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120) startImage:startImage submenuImages:images];
        _sphereMenu.delegate = self;
    }
    
    return _sphereMenu;
}


#pragma mark -
#pragma mark Player delegates

- (void)playerView:(JVYoutubePlayer *)playerView didChangeToQuality:(JVPlaybackQuality)quality
{
    [_player setPlaybackQuality:kJVPlaybackQualityHD720];
}

//- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error
//{
//    [self.player nextVideo];
//}


#pragma mark -
#pragma mark Helper Functions

- (void)sphereDidSelected:(int)index
{
    if(index == 1)
    {
        if(self.player.playerState == kJVPlayerStatePaused || self.player.playerState == kJVPlayerStateEnded || self.player.playerState == kJVPlayerStateUnstarted || self.player.playerState == kJVPlayerStateUnknown || self.player.playerState == kJVPlayerStateQueued || self.player.playerState == kJVPlayerStateBuffering)
        {
            [self.player playVideo];
        }
        else
        {
            [self.player pauseVideo];
            self.counter = 0;
        }
    }
    else if(index == 0)
    {
        [self.player previousVideo];
    }
    else
    {
        [self.player nextVideo];
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)playerViewDidBecomeReady:(JVYoutubePlayer *)playerView
{
    // loading a set of videos to the player after the player has finished loading
    // NSArray *videoList = @[@"m2d0ID-V9So", @"c7lNU4IPYlk"];
    // [self.player loadPlaylistByVideos:videoList index:0 startSeconds:0.0 suggestedQuality:kYTPlaybackQualityHD720];
}

#pragma mark -
#pragma mark Notifications

- (void)appIsInBakcground:(NSNotification *)notification
{
    [self.player playVideo];
}

- (void)appWillBeInBakcground:(NSNotification *)notification
{
    // self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(keepPlaying) userInfo:nil repeats:YES];
    // self.isInBackgroundMode = YES;
    // [self.player playVideo];
}

- (void)keepPlaying
{
    if(self.isInBackgroundMode)
    {
        [self.player playVideo];
        self.isInBackgroundMode = NO;
    }
    else
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end