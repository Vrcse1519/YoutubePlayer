//
//  JVControlsView.m
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2015-05-22.
//  Copyright (c) 2015 com.jorgedeveloper. All rights reserved.
//

#import "JVControlsView.h"

#define BUTTON_SIZE 80

@interface JVControlsView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *previousBtn;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, assign) BOOL controlsShowing;

@end


@implementation JVControlsView

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    if(!(self = [super initWithFrame:frame]))
        return nil;
    
    // setting up the view
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizer:self.tapRecognizer];
}


#pragma mark - Custom getters & setters

- (UITapGestureRecognizer *)tapRecognizer
{
    if(!_tapRecognizer)
    {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPlayerControlsOnTap:)];
        _tapRecognizer.numberOfTapsRequired = 1;
        _tapRecognizer.delegate = self;
    }
    
    return _tapRecognizer;
}

- (UIButton *)playBtn
{
    if(!_playBtn)
    {
        _playBtn  = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-BUTTON_SIZE/2, self.frame.size.height/2-BUTTON_SIZE/2, BUTTON_SIZE, BUTTON_SIZE)];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"jvplay"] forState:UIControlStateNormal];
        _playBtn.backgroundColor = [UIColor clearColor];
        [_playBtn addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.tag = 1;
    }
    
    return _playBtn;
}

- (UIButton *)previousBtn
{
    if(!_previousBtn)
    {
        _previousBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, self.frame.size.height/2-BUTTON_SIZE/2, BUTTON_SIZE, BUTTON_SIZE)];
        [_previousBtn setBackgroundImage:[UIImage imageNamed:@"jvprevious"] forState:UIControlStateNormal];
        _previousBtn.backgroundColor = [UIColor clearColor];
        [_previousBtn addTarget:self action:@selector(previousButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _previousBtn;
}

- (UIButton *)nextBtn
{
    if(!_nextBtn)
    {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-BUTTON_SIZE-40, self.frame.size.height/2-BUTTON_SIZE/2, BUTTON_SIZE, BUTTON_SIZE)];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"jvnext"] forState:UIControlStateNormal];
        _nextBtn.backgroundColor = [UIColor clearColor];
        [_nextBtn addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _nextBtn;
}

#pragma mark - GestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


#pragma mark - Helper functions

- (void)showPlayerControlsOnTap:(UITapGestureRecognizer *)tap
{
    if(!self.controlsShowing)
    {
        [self showViewAnimated];
    }
    else
    {
        [self hideViewAnimated];
    }
}

- (void)showViewAnimated
{
    // showing controls animations
    self.alpha = 0;
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    [self addSubview:self.playBtn];
    [self addSubview:self.previousBtn];
    [self addSubview:self.nextBtn];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                         self.alpha = 1.0;
                     }
                     completion:^(BOOL finished)
                     {
                         self.controlsShowing = YES;
                     }];
}


- (void)hideViewAnimated
{
    // hidding controls animations
    [UIView animateWithDuration:0.4
                     animations:^{
        
                         self.alpha = 0;
        
                     }
                     completion:^(BOOL finished)
                     {
                         self.backgroundColor = [UIColor clearColor];
                         [self.playBtn removeFromSuperview];
                         [self.previousBtn removeFromSuperview];
                         [self.nextBtn removeFromSuperview];
                         self.controlsShowing = NO;
                         self.alpha = 1.0;
                     }];
}


#pragma mark - Button actions

- (void)playButtonPressed:(UIButton *)btn
{
    if(self.playBtn.tag == 1)
    {
        // tell delegate play btn has been pressed
        if ([self.delegate respondsToSelector:@selector(playButtonWasPressed:)])
        {
            [self.delegate playButtonWasPressed:self];
        }

        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"jvpause"] forState:UIControlStateNormal];
        self.playBtn.tag = 2;
    }
    else
    {
        // tell delegate pause btn has been pressed
        if ([self.delegate respondsToSelector:@selector(pauseButtonWasPressed:)])
        {
            [self.delegate pauseButtonWasPressed:self];
        }

        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"jvplay"] forState:UIControlStateNormal];
        self.playBtn.tag = 1;
    }
    
    [self hideViewAnimated];
}

- (void)previousButtonPressed:(UIButton *)btn
{
    // tell delegate previous btn has been pressed
    if ([self.delegate respondsToSelector:@selector(previousButtonWasPressed:)])
    {
        [self.delegate previousButtonWasPressed:self];
    }
    
    [self hideViewAnimated];
}

- (void)nextButtonPressed:(UIButton *)btn
{
    // tell delegate next btn has been pressed
    if ([self.delegate respondsToSelector:@selector(nextButtonWasPressed:)])
    {
        [self.delegate nextButtonWasPressed:self];
    }
    
    [self hideViewAnimated];
}

@end