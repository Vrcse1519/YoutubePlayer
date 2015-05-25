//
//  JVControlsView.h
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2015-05-22.
//  Copyright (c) 2015 com.jorgedeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JVControlsView;

@protocol JVControlsViewDelegate <NSObject>

@required

- (void)playButtonWasPressed:(JVControlsView *)jvControlsView;

- (void)pauseButtonWasPressed:(JVControlsView *)jvControlsView;

- (void)previousButtonWasPressed:(JVControlsView *)jvControlsView;

- (void)nextButtonWasPressed:(JVControlsView *)jvControlsView;

@end


@interface JVControlsView : UIView

@property (nonatomic, weak) id<JVControlsViewDelegate> delegate;

// Initializers
- (instancetype)initWithFrame:(CGRect)frame;

@end