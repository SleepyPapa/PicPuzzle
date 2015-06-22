//
//  GJLTileButton.h
//  PicPuzzle
//
//  Created by Gregory Lavery on 02/12/2013.
//  Copyright (c) 2013 Gregory Lavery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJLTileButton : UIButton
@property	CGPoint tilePosition;
@property   NSString *tileName;
@property   NSMutableString *tileGridLocation;

+ (id) button;

@end
