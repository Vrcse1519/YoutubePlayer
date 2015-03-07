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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *colors = @[FlatGreenDark, FlatGreen, FlatMintDark, FlatMint];

    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom
                                                      withFrame:self.view.frame
                                                      andColors:colors];
    
    // loading playlist to video player
    [self.player loadPlayerWithPlaylistId:@"PLEE58C6029A8A6ADE"];
    
    // adding to subview
    [self.view addSubview:self.player];
    
    UIImage *startImage = [UIImage imageNamed:@"start"];
    UIImage *image1 = [UIImage imageNamed:@"rewind"];
    UIImage *image2 = [UIImage imageNamed:@"player"];
    UIImage *image3 = [UIImage imageNamed:@"forward"];
    NSArray *images = @[image1, image2, image3];
    
    SphereMenu *sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120) startImage:startImage submenuImages:images];
    
    sphereMenu.delegate = self;
    [self.view addSubview:sphereMenu];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:nil];
    NSError *sessionError = nil;
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    if (!success){
        NSLog(@"setCategory error %@", sessionError);
    }
    success = [audioSession setActive:YES error:&sessionError];
    if (!success){
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Turn on remote control event delivery
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // Set itself as the first responder
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    // Turn off remote control event delivery
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    // Resign as first responder
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if(self.counter == 0) {
                    [self.player playVideo];
                    self.counter = 1;
                }
                else {
                    [self.player pauseVideo];
                    self.counter = 0;
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

-(YTPlayerView*)player
{
    if(!_player)
    {
        _player = [[YTPlayerView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 220)];
        _player.delegate = self;
        _player.autoplay = NO;
        _player.modestbranding = YES;
        _player.allowLandscapeMode = YES;
        _player.forceBackToPortraitMode = YES;
        _player.allowAutoResizingPlayerFrame = YES;
        _player.playsinline = NO;
        _player.fullscreen = YES;
        _player.playsinline = YES;
    }
    
    return _player;
}


#pragma mark -
#pragma mark Player delegates

- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality
{
    [_player setPlaybackQuality:kYTPlaybackQualityHD720];
}

//- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error
//{
//    [self.player nextVideo];
//}


#pragma mark -
#pragma mark Helper Functions

- (void)sphereDidSelected:(int)index
{
//    NSLog(@"sphere %d selected", index);
    if(index == 1) {
        if(self.counter == 0) {
            [self.player playVideo];
            self.counter = 1;
        }
        else {
            [self.player pauseVideo];
            self.counter = 0;
        }
    }
    else if(index == 0) {
        [self.player previousVideo];
    }
    else {
        [self.player nextVideo];    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark -
#pragma mark Notifications

-(void)appIsInBakcground:(NSNotification*)notification{
    [self.player playVideo];
}

-(void)appWillBeInBakcground:(NSNotification*)notification{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(keepPlaying) userInfo:nil repeats:YES];
//    self.isInBackgroundMode = YES;
//    [self.player playVideo];
}

-(void)keepPlaying{
    if(self.isInBackgroundMode){
        [self.player playVideo];
        self.isInBackgroundMode = NO;
    }
    else{
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end
