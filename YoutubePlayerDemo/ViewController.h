//
//  ViewController.h
//  YoutubePlayer
//
//  Created by Jorge Valbuena on 2014-10-24.
//  Copyright (c) 2014 com.jorgedeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVYoutubePlayerView.h"

@interface ViewController : UIViewController <JVYoutubePlayerDelegate>

@property (nonatomic, strong) JVYoutubePlayerView *player;

@end

