//
//  GJLViewController.h
//  PicPuzzle
//
//  Created by Gregory Lavery on 26/11/2013.
//  Copyright (c) 2013 Gregory Lavery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GJLViewController : UIViewController

@property NSMutableArray *storedLocations;
@property NSMutableArray *whereInGrid;
@property NSMutableArray *allDataToBeStored;
@property NSInteger numberOfTilesWidth;
@property NSInteger numberOfTilesHeight;
@property NSInteger numberOfMoves;
@property BOOL isPlain;
@property (weak, nonatomic) IBOutlet UIButton *resetTheData;


-(void) setUpAllTheLocations;
-(BOOL) loadTheTiles;
-(void) saveTheTiles;
-(void) redrawOfTiles;
-(void) updateCounter;


@end
