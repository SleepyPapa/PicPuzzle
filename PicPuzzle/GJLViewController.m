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

    // find index of blank tile
    NSUInteger indexOfBlank = [_whereInGrid indexOfObject:@"blank"]; //finds where in _whereInGrid the blank tile is
//    int tagOfButton = aButton.tag;

    NSString *tempString = aButton.tileName;
//    _whereInGrid[tagOfButton-1];
    NSUInteger indexToMoveTo = [_whereInGrid indexOfObject:tempString];
    if (indexOfBlank == indexToMoveTo)
        return; //clicked on blank tile
    
    //update to handle starting from one rather than zero
    indexOfBlank++;
    indexToMoveTo++;
    
    BOOL sameColumn = false;
//    BOOL adjacentNumbers= false;
    BOOL fourDifferent = false;
    BOOL leftEdge = false;
    BOOL rightEdge = false;
    
    BOOL canMove = false;
    
    //check to see if tile can be moved in this location
    if ((indexOfBlank%4)==(indexToMoveTo%4))
        sameColumn = true;
    if ((indexOfBlank+4==indexToMoveTo) || (indexToMoveTo+4==indexOfBlank))
        fourDifferent = true; //this is a valid move up or down

    if((fourDifferent)&(sameColumn))
        canMove=true;
    
/*    if ((indexToMoveTo==indexOfBlank+1) || (indexToMoveTo+1==indexOfBlank))
        adjacentNumbers = true;
*/
    if ((indexOfBlank%4)==1)
        leftEdge=true;
    if ((indexOfBlank%4)==0)
        rightEdge=true;
        
    if ((indexToMoveTo==indexOfBlank+1) && (!rightEdge))
        canMove=true;

    if ((indexToMoveTo==indexOfBlank-1) && (!leftEdge))
        canMove=true;
    
    if(!canMove)
        return;
    
    indexToMoveTo--;
    indexOfBlank--;
    
    
    //move tile
    NSValue *tempValue = [_storedLocations objectAtIndex:(indexOfBlank)];
    CGPoint currentBlankPosition = [tempValue CGPointValue];
    CGPoint updatedBlankPosition = aButton.center;
    
    
//    NSLog(@"blank x %f, y %f\n", currentBlankPosition.x, currentBlankPosition.y);
//    NSLog(@"updated x %f, y %f\n", updatedBlankPosition.x, updatedBlankPosition.y);
    
    
    //update positions with new values
    _storedLocations[indexToMoveTo]= [NSValue valueWithCGPoint:currentBlankPosition];
    _storedLocations[indexOfBlank]= [NSValue valueWithCGPoint:updatedBlankPosition];
    //need to move blank tile to new position
    UIView *tempButton = [self.view viewWithTag:16];

    tempButton.center=updatedBlankPosition;
    
    //move the current tile to blank location
    aButton.center=currentBlankPosition;
    [aButton setContentMode:UIViewContentModeRedraw];
    
    
    //swap around tileGridLocation names
    
    _whereInGrid[indexToMoveTo] = @"blank";
    _whereInGrid[indexOfBlank] = tempString;

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
                           @"blank"];
    


    CGFloat positionX = 0.0f;
    CGFloat positionY = 0.0f;
    int rowNumber=0;
    
    
    _whereInGrid = [[NSMutableArray alloc] init];
    _storedLocations = [[NSMutableArray alloc] init];

	for (NSInteger i = 0; i < (numberOfTiles); i++)
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

        UIImage *imageToUse = [UIImage imageNamed:fileName];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:imageToUse];
        
        GJLTileButton *individualTile = [GJLTileButton button];
        [individualTile setBackgroundImage:toLoad forState:UIControlStateNormal];
        [individualTile setImage:toLoad forState:UIControlStateHighlighted];
        individualTile.adjustsImageWhenHighlighted=YES; //hack2

        individualTile.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        CGPoint positionOfFrame = CGPointMake(positionX,positionY);
        individualTile.center = CGPointMake(positionX,positionY);
        individualTile.tileName=[locationArray objectAtIndex:(i)];
        [_whereInGrid addObject:[locationArray objectAtIndex:(i)]];
        individualTile.tag = i+1;
        [_storedLocations addObject:[NSValue valueWithCGPoint:individualTile.center]];
        individualTile.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
        [imageView setCenter:positionOfFrame];
        
        imageView.userInteractionEnabled=YES;
        [individualTile addTarget:self action:@selector(pushed:) forControlEvents: UIControlEventTouchUpInside];
        [self.view addSubview:individualTile];

    }
}


/*
- (void) viewDidAppear:(BOOL)animated
{
    CGPoint viewCenter = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    self.view.center = viewCenter;
}
*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
