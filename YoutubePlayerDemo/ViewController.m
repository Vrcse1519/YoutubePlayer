//
//  ViewController.m
//  YoutubePlayer
//
//  Created by Jorge Valbuena on 2014-10-24.
//  Copyright (c) 2014 com.jorgedeveloper. All rights reserved.
//

#import "ViewController.h"
#import "SphereMenu.h"
#import "Chameleon.h"

@interface ViewController () <SphereMenuDelegate>
@property (nonatomic) int counter;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) BOOL isInBackgroundMode;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *colors = [[NSArray alloc] initWithObjects:FlatGreen, FlatMint, nil];
    
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.view.frame andColors:colors];

    // loading playlist to video player
    [self.player loadWithPlaylistId:@"PLEE58C6029A8A6ADE"];
    
    [self.player setPlaybackQuality:kYTPlaybackQualityHD720];

    // adding to subview
    [self.view addSubview:self.player];
    
    UIImage *startImage = [self imageWithImage:[UIImage imageNamed:@"start"] scaledToSize:CGSizeMake(60., 60.)];
    UIImage *image1 = [self imageWithImage:[UIImage imageNamed:@"rewind"] scaledToSize:CGSizeMake(60., 60.)];
    UIImage *image2 = [self imageWithImage:[UIImage imageNamed:@"player"] scaledToSize:CGSizeMake(60., 60.)];
    UIImage *image3 = [self imageWithImage:[UIImage imageNamed:@"forward"] scaledToSize:CGSizeMake(60., 60.)];
    NSArray *images = @[image1, image2, image3];
    SphereMenu *sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*.8)
                                                         startImage:startImage
                                                      submenuImages:images];
    sphereMenu.delegate = self;
    [self.view addSubview:sphereMenu];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appIsInBakcground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBeInBakcground:) name:UIApplicationWillResignActiveNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}


#pragma mark -
#pragma mark Getters and Setters

-(YTPlayerView*)player
{
    if(!_player)
    {
        _player = [[YTPlayerView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 240)];
        _player.delegate = self;
        _player.autoplay = NO;
        _player.hd720 = YES;
        _player.modestbranding = YES;
        _player.allowLandscapeMode = YES;
        _player.forceBackToPortraitMode = YES;
        _player.allowAutoResizingPlayerFrame = YES;
        _player.playsinline = YES;
        _player.fullscreen = YES;
        _player.hd = YES;
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
    NSLog(@"sphere %d selected", index);
    
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

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
