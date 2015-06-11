//
//  GJLTileButton.m
//  PicPuzzle
//
//  Created by Gregory Lavery on 02/12/2013.
//  Copyright (c) 2013 Gregory Lavery. All rights reserved.
//

#import "GJLTileButton.h"


@implementation GJLTileButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}


+ (id) button
{
    GJLTileButton *button = [GJLTileButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
    button.bounds = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);

    // Set up the button aligment properties
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	// Set the font and color
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    button.adjustsImageWhenHighlighted=NO;
    button.adjustsImageWhenDisabled=NO;

    
    // Set up the art
    button.userInteractionEnabled=YES;
    return button;
}
@end
