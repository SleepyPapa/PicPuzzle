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
    NSInteger rowWidth = _numberOfTiles;
    // find index of blank tile
    NSInteger indexOfBlank = [_whereInGrid indexOfObject:@"blank"]; //finds where in _whereInGrid the blank tile is
//    int tagOfButton = aButton.tag;

    NSString *tempString = aButton.tileName;
//    _whereInGrid[tagOfButton-1];
    NSInteger indexToMoveTo = [_whereInGrid indexOfObject:tempString];
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
    if ((indexOfBlank%(rowWidth))==(indexToMoveTo%rowWidth))
        sameColumn = true;
    if ((indexOfBlank+rowWidth==indexToMoveTo) || (indexToMoveTo+rowWidth==indexOfBlank))
        fourDifferent = true; //this is a valid move up or down

    if((fourDifferent)&(sameColumn))
        canMove=true;
    
/*    if ((indexToMoveTo==indexOfBlank+1) || (indexToMoveTo+1==indexOfBlank))
        adjacentNumbers = true;
*/
    if ((indexOfBlank%rowWidth)==1)
        leftEdge=true;
    if ((indexOfBlank%rowWidth)==0)
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
    _storedLocations[indexToMoveTo]= [NSValue valueWithCGPoint:updatedBlankPosition];
    _storedLocations[indexOfBlank]= [NSValue valueWithCGPoint:currentBlankPosition];
    //need to move blank tile to new position
    UIView *blankTile = [self.view viewWithTag:(rowWidth*rowWidth)];
    blankTile.center=updatedBlankPosition;
    
    //move the current tile to blank location
    aButton.center=currentBlankPosition;
//    NSLog(@"aButton layer: %f, blankTile layer: %f",aButton.layer.zPosition, blankTile.layer.zPosition);
    [aButton setContentMode:UIViewContentModeRedraw];
    
    [aButton setNeedsDisplay];
    [blankTile setNeedsDisplay];
    
    //swap around tileGridLocation names
    
    _whereInGrid[indexToMoveTo] = @"blank";
    _whereInGrid[indexOfBlank] = tempString;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _numberOfTiles=5;
    [self setUpAllTheLocations];
    
}

-(void) setUpAllTheLocations
{
	// Do any additional setup after loading the view, typically from a nib.
    NSInteger numberInGrid = _numberOfTiles;

    NSInteger totalNumberOfTiles = numberInGrid*numberInGrid; // number of tiles to add

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
                           @"tile6",
                           @"tile7",
                           @"tile8",
                           @"tile9",
                           @"tile10",
                           @"tile11",
                           @"tile12",
                           @"tile13",
                           @"tile14",
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
                               @"location16",
                               @"location17",
                               @"location18",
                               @"location19",
                               @"location20",
                               @"location21",
                               @"location22",
                               @"location23",
                               @"location24",
                           @"blank"];
    


    CGFloat positionX = 0.0f;
    CGFloat positionY = 0.0f;
    int rowNumber=0;
    
    
    _whereInGrid = [[NSMutableArray alloc] init];
    _storedLocations = [[NSMutableArray alloc] init];
//    [self setNumberOfTiles:numberInGrid];

	for (NSInteger i = 0; i < (totalNumberOfTiles); i++)
	{
		NSString *whichTile = [tileArray objectAtIndex:(i)];
        NSString *fileName = [whichTile stringByAppendingString:@".png"];
        UIImage *toLoad;
        if (i!=(totalNumberOfTiles-1))
            toLoad = [UIImage imageNamed:fileName];
        else {
            toLoad = [UIImage imageNamed:@"tile_blank.png"];
        }
        int result = i%numberInGrid;
        if (result==0)
            rowNumber++;
        positionX = (xUnits*(result))+xUnits;
        positionY = yUnits*rowNumber;
        
        GJLTileButton *individualTile = [GJLTileButton button];

        [individualTile setBackgroundImage:toLoad forState:UIControlStateNormal];
//        [individualTile setImage:toLoad forState:UIControlStateHighlighted];
        individualTile.adjustsImageWhenHighlighted=YES; //hack2

        individualTile.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        NSString *tileUIName =[NSString stringWithFormat:@"%d",(i+1)];
        [individualTile setTitle:tileUIName forState:UIControlStateNormal];
//        CGPoint positionOfFrame = CGPointMake(positionX,positionY);
        individualTile.center = CGPointMake(positionX,positionY);
        individualTile.tileName=[locationArray objectAtIndex:(i)];
        [_whereInGrid addObject:[locationArray objectAtIndex:(i)]];
        individualTile.tag = i+1;
        [_storedLocations addObject:[NSValue valueWithCGPoint:individualTile.center]];
        individualTile.contentMode = UIViewContentModeScaleAspectFit;
//        individualTile.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
//        [imageView setCenter:positionOfFrame];
        
//        imageView.userInteractionEnabled=YES;
        individualTile.userInteractionEnabled=YES;
        if (i==(totalNumberOfTiles-1)){
            individualTile.tileName=@"tile_blank";
            [_whereInGrid replaceObjectAtIndex:(i) withObject:@"blank"];
            [individualTile setTitle:@"" forState:UIControlStateNormal];
        }
        
        
        [individualTile addTarget:self action:@selector(pushed:) forControlEvents: UIControlEventTouchUpInside];
        [self.view addSubview:individualTile];
        self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        ;
    }
    [self.view.superview setAutoresizesSubviews:YES];
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
