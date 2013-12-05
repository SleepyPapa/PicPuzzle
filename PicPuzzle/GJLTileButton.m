//
//  GJLTileButton.m
//  PicPuzzle
//
//  Created by Gregory Lavery on 02/12/2013.
//  Copyright (c) 2013 Gregory Lavery. All rights reserved.
//

#import "GJLTileButton.h"

#define CAPWIDTH    110.0f
#define INSETS      (UIEdgeInsets){0.0f, CAPWIDTH, 0.0f, CAPWIDTH}
#define BUTTONONE   [[UIImage imageNamed:@"tile1.png"] resizableImageWithCapInsets:INSETS]
#define BUTTONTWO   [[UIImage imageNamed:@"tile2.png"] resizableImageWithCapInsets:INSETS]

@implementation GJLTileButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



+ (id) button
{
    GJLTileButton *button = [GJLTileButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    
    // Set up the button aligment properties
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	// Set the font and color
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    
    // Set up the art
    [button setTitle:@"Click" forState:UIControlStateHighlighted];
    return button;
}
@end
