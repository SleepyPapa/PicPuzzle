//
//  GJLViewController.m
//  PicPuzzle
//
//  Created by Gregory Lavery on 26/11/2013.
//  Copyright (c) 2013 Gregory Lavery. All rights reserved.
//

#import "GJLViewController.h"
#import "GJLTileButton.h"

@interface GJLViewController ()


@end

@implementation GJLViewController


- (void) pushed: (GJLTileButton *) aButton
{

    // search through tiles to file blank tile
    
    //check to see if the tile is next to current tile
    
    //check to see if tile can be moved in this location
    
    //move tile
    int tagOfButton = aButton.tag;
    NSValue *tempValue = [_storedLocations objectAtIndex:(15)];
    CGPoint currentBlankPosition = [tempValue CGPointValue];

//    CGPoint currentBlankPosition = CGPointMake(*(_blankTileLocationX), *(_blankTileLocationY));
    CGPoint updatedBlankPosition = aButton.center;
    
    
    NSLog(@"blank x %f, y %f\n", currentBlankPosition.x, currentBlankPosition.y);
    NSLog(@"updated x %f, y %f\n", updatedBlankPosition.x, updatedBlankPosition.y);
    
    _storedLocations[tagOfButton-1]= [NSValue valueWithCGPoint:currentBlankPosition];
    _storedLocations[15]= [NSValue valueWithCGPoint:updatedBlankPosition];
    
    aButton.center=currentBlankPosition;
    
    
    //need to move blank tile to new position
    
    UIView *tempButton = [self.view viewWithTag:16];
    tempButton.center=updatedBlankPosition;
//    _blankTileLocationX = &thePoint.x;
//    _blankTileLocationY = &thePoint.y;
    
    //else do nothing
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSInteger numberInGrid = 4;
    NSInteger numberOfTiles = numberInGrid*numberInGrid; // number of tiles to add

    CGSize insetSize = CGRectInset(self.view.frame, 30, 80).size;
    CGFloat xUnits = (insetSize.width/numberInGrid);
    CGFloat yUnits = (insetSize.height/numberInGrid);

    NSArray* tileArray = @[@"tile1",
                           @"tile2",
                           @"tile3",
                           @"tile4",
                           @"tile5",
                           @"tile6",
                           @"tile7",
                           @"tile8",
                           @"tile9",
                           @"tile10",
                           @"tile11",
                           @"tile12",
                           @"tile13",
                           @"tile14",
                           @"tile15",
                           @"tile_blank"];
    
    NSArray* locationArray = @[@"location1",
                           @"location2",
                           @"location3",
                           @"location4",
                           @"location5",
                           @"location6",
                           @"location7",
                           @"location8",
                           @"location9",
                           @"location10",
                           @"location11",
                           @"location12",
                           @"location13",
                           @"location14",
                           @"location15",
                           @"location16"];
    


    CGFloat positionX = 0.0f;
    CGFloat positionY = 0.0f;
    int rowNumber=0;
    
    
    
    _storedLocations = [[NSMutableArray alloc] init];

	for (int i = 0; i < (numberOfTiles); i++)
	{
		NSString *whichTile = [tileArray objectAtIndex:(i)];
        NSString *fileName = [whichTile stringByAppendingString:@".png"];
        UIImage *toLoad = [UIImage imageNamed:fileName];
        int result = i%numberInGrid;
        if (result==0)
            rowNumber++;
        positionX = (xUnits*(result))+xUnits;
        positionY = yUnits*rowNumber;
//        NSLog(@"result: %d i: %d xPosition: %f yPosition: %f \n",result, i,positionX, positionY);

        
        GJLTileButton *individualTile = [GJLTileButton button];
        [individualTile setBackgroundImage:toLoad forState:UIControlStateNormal];
        individualTile.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [individualTile setTitle: whichTile forState:UIControlStateNormal];
        individualTile.center = CGPointMake(positionX,positionY);
        individualTile.tileName=whichTile;
        individualTile.tileGridLocation = [locationArray objectAtIndex:(i)];
        individualTile.tag = i+1;
        [_storedLocations addObject:[NSValue valueWithCGPoint:individualTile.center]];
        _blankTileLocationX = &positionX; //works because it is the last in teh loop
        _blankTileLocationY = &positionY; //works because it is the last in teh loop
		[self.view addSubview:individualTile];
        [individualTile addTarget:self action:@selector(pushed:) forControlEvents: UIControlEventTouchUpInside];

    }
}



- (void) viewDidAppear:(BOOL)animated
{
    CGPoint viewCenter = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    self.view.center = viewCenter;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
