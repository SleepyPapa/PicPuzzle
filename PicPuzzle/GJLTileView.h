//
//  GJLTileView.h
//  PicPuzzle
//
//  Created by Gregory Lavery on 26/11/2013.
//  Copyright (c) 2013 Gregory Lavery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJLViewController.h"

@interface GJLTileView : UIImageView
{
}
@property	CGPoint tilePosition;
@property   NSString *tileName;
@property   NSMutableString *tileGridLocation;

@end
