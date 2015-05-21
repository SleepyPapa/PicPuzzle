//
//  GJLTileView.m
//  PicPuzzle
//
//  Created by Gregory Lavery on 26/11/2013.
//  Copyright (c) 2013 Gregory Lavery. All rights reserved.
//

#import "GJLTileView.h"

@implementation GJLTileView

- (id) initWithImage: (UIImage *) anImage
{
	if (self = [super initWithImage:anImage])
		self.userInteractionEnabled = YES;
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

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	// Calculate and store offset, and pop view into front if needed
	_tilePosition = [[touches anyObject] locationInView:self];
	[self.superview bringSubviewToFront:self];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"tileName %@",self.tileName);
    NSLog(@"tileGridLocation %@",self.tileGridLocation);

    //call selector on ViewController with button press details
    
    
    //check to see if tile can be moved
    
}

/*- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	// Calculate offset
	CGPoint pt = [[touches anyObject] locationInView:self];
	float dx = pt.x - _tileLocation.x;
	float dy = pt.y - _tileLocation.y;
	CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
	
	// Set new location
	self.center = newcenter;
}
*/


@end
