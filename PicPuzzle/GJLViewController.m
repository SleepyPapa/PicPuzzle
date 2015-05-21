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

- (IBAction)shuffleTiles:(id)sender {
    
    for (int i=0; i<20;i++){
    NSInteger firstRandomValue = arc4random()%(_numberOfTiles*_numberOfTiles);
    NSInteger secondRandomValue = arc4random()%(_numberOfTiles*_numberOfTiles);
//        NSLog(@"first %d  second %d  \n",firstRandomValue,secondRandomValue);

    //swap around tileGridLocation names
    
    NSString *tempStringOne = _whereInGrid[firstRandomValue];
    NSString *tempStringTwo = _whereInGrid[secondRandomValue];
    
    _whereInGrid[secondRandomValue] = tempStringOne;
    _whereInGrid[firstRandomValue] = tempStringTwo;

    }
    
    for (int t=0;t<(_numberOfTiles*_numberOfTiles);t++)
    {
        NSString *actualLocationInGrid = _whereInGrid[t];
        NSInteger valueToUse = [actualLocationInGrid intValue];
        if (!valueToUse)
            valueToUse=(_numberOfTiles*_numberOfTiles);
        
        //Update buttons - hopefully will animate them too
    UIView *tileOne = [self.view viewWithTag:(valueToUse)];
    NSValue *tempLocationValue=[_storedLocations objectAtIndex:(t)];
    tileOne.center=[tempLocationValue CGPointValue];

    }
    
}

- (void) pushed: (GJLTileButton *) aButton
{
    NSInteger rowWidth = _numberOfTiles;
    // find index of blank tile
    NSInteger indexOfBlank = [_whereInGrid indexOfObject:@"blank"]; //finds where in _whereInGrid the blank tile is

//    NSInteger buttonTag =
    NSString *tempString =[@(aButton.tag) stringValue];

    NSInteger indexToMoveTo = [_whereInGrid indexOfObject:tempString];
    if (indexOfBlank == indexToMoveTo)
        return; //clicked on blank tile
    
    //update to handle starting from one rather than zero
    indexOfBlank++;
    indexToMoveTo++;
    
    BOOL sameColumn = false;
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
    NSValue *tempValueBlank = [_storedLocations objectAtIndex:(indexOfBlank)];
    CGPoint positionOfBlank = [tempValueBlank CGPointValue];
    NSValue *tempValueMoveTo = [_storedLocations objectAtIndex:(indexToMoveTo)];
    CGPoint positionToMoveTo = [tempValueMoveTo CGPointValue];

    //need to move blank tile to new position
    UIView *blankTile = [self.view viewWithTag:(rowWidth*rowWidth)];
    //Animate numbered tile first so it is foreground
    [UIView animateWithDuration:0.3 animations:^{
        aButton.layer.zPosition = MAXFLOAT;
        aButton.center=positionOfBlank;
    }];
    //Animate blank so it is in background
    [UIView animateWithDuration:0.3 animations:^{
        blankTile.center=positionToMoveTo;
    }];
    
    //move the current tile to blank location
//    NSLog(@"aButton layer: %f, blankTile layer: %f",aButton.layer.zPosition, blankTile.layer.zPosition);
    [aButton setContentMode:UIViewContentModeRedraw];
    
    [aButton setNeedsDisplay];
    [blankTile setNeedsDisplay];
    
    //swap around whereInGrid names
    
    _whereInGrid[indexToMoveTo] = @"blank";
    _whereInGrid[indexOfBlank] = tempString;

    [self checkForWinningMove];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _numberOfTiles=4;
    [self setUpAllTheLocations];
    
}

-(void) checkForWinningMove
{
    BOOL allInRightLocation = TRUE;
//    NSInteger checkingNumber;
    for (int t=0;t<((_numberOfTiles*_numberOfTiles)-2);t++)
    {
        NSString *locationOfTile = _whereInGrid[t];
        if ([locationOfTile intValue] !=t+1)
        {
            allInRightLocation = FALSE;
        }
        
    }
    NSString *nameOfBlank = @"blank";
    if ((allInRightLocation) && (_whereInGrid[(_numberOfTiles*_numberOfTiles)-1] == nameOfBlank))
        NSLog(@"Check has worked and all in a line");
}


-(void) setUpAllTheLocations
{
	// Do any additional setup after loading the view, typically from a nib.
    NSInteger numberInGrid = _numberOfTiles;

    NSInteger totalNumberOfTiles = numberInGrid*numberInGrid; // number of tiles to add

    CGSize insetSize = CGRectInset(self.view.frame, 30, 80).size;
    CGFloat xUnits = (insetSize.width/numberInGrid);
    CGFloat yUnits = (insetSize.height/numberInGrid);
    CGFloat positionX = 0.0f;
    CGFloat positionY = 0.0f;
    int rowNumber=0;
    
    
    _whereInGrid = [[NSMutableArray alloc] init];
    _storedLocations = [[NSMutableArray alloc] init];


	for (NSInteger i = 0; i < (totalNumberOfTiles); i++)
	{
        NSString *fileName;
        if (i%2==0)
             fileName= @"red.png";
        else
             fileName= @"black.png";
        UIImage *toLoad;
        if (i!=(totalNumberOfTiles-1))
            toLoad = [UIImage imageNamed:fileName];
        else {
            toLoad = [UIImage imageNamed:@"white.png"];
        }
        int result = i%numberInGrid;
        if (result==0)
            rowNumber++;
        positionX = (xUnits*(result))+xUnits;
        positionY = yUnits*rowNumber;
        
        GJLTileButton *individualTile = [GJLTileButton button];

        [individualTile setBackgroundImage:toLoad forState:UIControlStateNormal];

        individualTile.adjustsImageWhenHighlighted=YES;

        individualTile.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        NSString *tileUIName =[NSString stringWithFormat:@"%d",(i+1)];
        [individualTile setTitle:tileUIName forState:UIControlStateNormal];

        individualTile.center = CGPointMake(positionX,positionY);
        individualTile.bounds = CGRectMake(positionX, positionY, xUnits,yUnits);
        NSString *locationName = [NSString stringWithFormat:@"%d",(i+1)];

        individualTile.tileName=locationName;
        [_whereInGrid addObject:locationName];
        individualTile.tag = i+1;
        [_storedLocations addObject:[NSValue valueWithCGPoint:individualTile.center]];
        individualTile.contentMode = UIViewContentModeScaleAspectFit;

        individualTile.userInteractionEnabled=YES;
        if (i==(totalNumberOfTiles-1)){
            individualTile.tileName=@"blank";
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
