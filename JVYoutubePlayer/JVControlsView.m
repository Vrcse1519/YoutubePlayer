//
//  JVControlsView.m
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2015-05-22.
//  Copyright (c) 2015 com.jorgedeveloper. All rights reserved.
//

#import "JVControlsView.h"

@interface JVControlsView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

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


#pragma mark - GestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


#pragma mark - Helper functions

- (void)showPlayerControlsOnTap:(UITapGestureRecognizer *)tap
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
}

@end