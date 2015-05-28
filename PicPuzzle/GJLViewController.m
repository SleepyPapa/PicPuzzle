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
    
    for (int i=0; i<(_numberOfTilesWidth*_numberOfTilesHeight);i++){
        NSInteger firstRandomValue = arc4random()%(_numberOfTilesWidth*_numberOfTilesHeight);
        NSInteger secondRandomValue = arc4random()%(_numberOfTilesWidth*_numberOfTilesHeight);
        //        NSLog(@"first %d  second %d  \n",firstRandomValue,secondRandomValue);
        if (firstRandomValue==0)
            firstRandomValue++;
        if (secondRandomValue==0)
            secondRandomValue++;
            
            //swap around tileGridLocation names
        
        NSString *tempStringOne = _whereInGrid[firstRandomValue];
        NSString *tempStringTwo = _whereInGrid[secondRandomValue];
        
        _whereInGrid[secondRandomValue] = tempStringOne;
        _whereInGrid[firstRandomValue] = tempStringTwo;
        
    }
    
    for (int t=1;t<=(_numberOfTilesWidth*_numberOfTilesHeight);t++)
    {
        NSString *actualLocationInGrid = _whereInGrid[t];
        NSInteger valueToUse = [actualLocationInGrid intValue];
        if (!valueToUse)
            valueToUse=(_numberOfTilesWidth*_numberOfTilesHeight);
        
        //Update buttons - hopefully will animate them too
        UIView *tileOne = [self.view viewWithTag:(valueToUse)];
        NSValue *tempLocationValue=[_storedLocations objectAtIndex:(t)];
        [UIView animateWithDuration:0.3 animations:^{
            tileOne.center=[tempLocationValue CGPointValue];
        }
         ];
    }

    [self saveTheTiles];
}
- (IBAction)resetTheData:(id)sender {
    
    [_whereInGrid removeAllObjects];
    
    NSInteger fullArray = _numberOfTilesWidth*_numberOfTilesHeight;

    _whereInGrid[0] = @"ignore";

    for (NSInteger i=1;i<(fullArray+1) ;i++){
        NSString *locationName = [NSString stringWithFormat:@"%ld",(i)];
        
            _whereInGrid[i]=locationName;
        }

    _whereInGrid[fullArray] = @"blank";

    
    [self saveTheTiles];
}

- (void) pushed: (GJLTileButton *) aButton
{
    NSInteger rowWidth = _numberOfTilesWidth;
    // find index of blank tile
    NSInteger indexOfBlank = [_whereInGrid indexOfObject:@"blank"]; //finds where in _whereInGrid the blank tile is
    

    NSString *tempString =[@(aButton.tag) stringValue];
    
    NSInteger indexToMoveTo = [_whereInGrid indexOfObject:tempString];

    if (indexOfBlank == indexToMoveTo)
        return; //clicked on blank tile

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
    
    
    //move tile
    //need to swap blank with clicked tile
    NSLog((@"swapping %ld with %ld"), (long)indexOfBlank, (long)indexToMoveTo);
    
    UIView *blankTile = [self.view viewWithTag:(_numberOfTilesWidth*_numberOfTilesHeight)]; //Blank is always last

    
    
    NSValue *tempLocationOne=[_storedLocations objectAtIndex:(indexOfBlank)];
    NSValue *tempLocationTwo=[_storedLocations objectAtIndex:(indexToMoveTo)];
    //Animate blank so it is in background
    [UIView animateWithDuration:0.3 animations:^{
        blankTile.center=[tempLocationTwo CGPointValue];
        aButton.layer.zPosition = MAXFLOAT;
        aButton.center=[tempLocationOne CGPointValue];
    }];

    //move the current tile to blank location
    _whereInGrid[indexToMoveTo] = @"blank";
    _whereInGrid[indexOfBlank] = tempString;
    
    [self checkForWinningMove];
}

- (BOOL)loadTheTiles
{
    
    [_whereInGrid removeAllObjects];
    //    BOOL fileExists = FALSE;
    //check for existing files already
    NSString *myFile = @"whereStored.plist";
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [filePaths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:myFile];
    //    NSMutableArray *checkWhere;
    BOOL didRead = (_whereInGrid = [NSMutableArray arrayWithContentsOfFile:path]);
    if (didRead)
        NSLog(@"It read");
    return didRead;
}
- (void)saveTheTiles
{
    NSString *myFile = @"whereStored.plist";
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [filePaths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:myFile];
    NSError *error;
    if(![[NSFileManager defaultManager] removeItemAtPath:path error:&error])
    {
        NSLog(@"Error deleting!");
        //TODO: Handle/Log error
    }
    BOOL didWrite = [_whereInGrid writeToFile:path atomically:YES];
    if (didWrite)
        NSLog(@"It saved");

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpAllTheLocations];
    
}

-(void) checkForWinningMove
{
    BOOL allInRightLocation = TRUE;
    for (int t=0;t<((_numberOfTilesWidth*_numberOfTilesHeight)-1);t++)
    {
        NSString *locationOfTile = _whereInGrid[t];
        if ([locationOfTile intValue] !=t+1)
        {
            allInRightLocation = FALSE;
        }
        
    }
    NSString *nameOfBlank = @"blank";
    if ((allInRightLocation) && (_whereInGrid[(_numberOfTilesWidth*_numberOfTilesHeight)] == nameOfBlank))
        NSLog(@"Check has worked and all in a line");
}


-(void) setUpAllTheLocations
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    NSInteger numberInGridWidth = _numberOfTilesWidth;
    NSInteger numberInGridHeight = _numberOfTilesHeight;
    
    NSInteger totalNumberOfTiles = numberInGridWidth*numberInGridHeight; // number of tiles to add
    
    CGSize insetSize = CGRectInset(self.view.bounds, 10, 80).size;
    CGFloat xUnits = (insetSize.width/numberInGridWidth);
    CGFloat yUnits = (insetSize.height/numberInGridHeight);
    
    CGFloat positionX = 0.0f;
    CGFloat positionY = 0.0f;
    int rowNumber=0;

    
    [_storedLocations removeAllObjects];

    [_whereInGrid removeAllObjects];
    
    
    _whereInGrid = [[NSMutableArray alloc] init];
    _storedLocations = [[NSMutableArray alloc] init];
    
    CGPoint firstPosition = CGPointMake(positionX,positionY);
    [_storedLocations addObject:[NSValue valueWithCGPoint:firstPosition]];
    
    for (NSInteger i = 0; i < (totalNumberOfTiles); i++)
    {
        NSInteger result = i%numberInGridWidth;
        if (result==0)
            rowNumber++;
        positionX = (xUnits*result)+(xUnits/2);
        positionY = (yUnits*rowNumber);
        CGPoint centrePosition = CGPointMake(positionX,positionY);
        [_storedLocations addObject:[NSValue valueWithCGPoint:centrePosition]];
        
    }
    
    //load in previous data if already there
    BOOL loadedFileCorrectly = FALSE;
    loadedFileCorrectly = [self loadTheTiles];
//    loadedFileCorrectly=FALSE;
    if (!loadedFileCorrectly){
        [_whereInGrid addObject:@"ignore"]; //fill up the zero location in array
        for (NSInteger i = 1; i < (totalNumberOfTiles+1); i++)
        {
            NSString *fileName;
            if (i%2==0)
                fileName= @"red.png";
            else
                fileName= @"black.png";
            UIImage *toLoad;
            if (i!=(totalNumberOfTiles))
                toLoad = [UIImage imageNamed:fileName];
            else {
                toLoad = [UIImage imageNamed:@"white.png"];
            }
/*            NSInteger result = i%numberInGridWidth;
            if (result==0)
                rowNumber++;
            positionX = (xUnits*result)+(xUnits/2);
            positionY = (yUnits*rowNumber);
*/
            GJLTileButton *individualTile = [GJLTileButton button];
            
            [individualTile setBackgroundImage:toLoad forState:UIControlStateNormal];
            
            individualTile.adjustsImageWhenHighlighted=YES;
            
            individualTile.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            NSString *tileUIName =[NSString stringWithFormat:@"%ld",(i)];
            [individualTile setTitle:tileUIName forState:UIControlStateNormal];
            NSValue *tempValue = [_storedLocations objectAtIndex:(i)];
            individualTile.center = [tempValue CGPointValue];
            individualTile.bounds = CGRectMake(0,0, xUnits,yUnits);
            NSString *locationName = [NSString stringWithFormat:@"%ld",(i)];
            
            individualTile.tileName=locationName;
            [_whereInGrid addObject:locationName];
            individualTile.tag = i;
            NSLog(@"tag is %ld",i);
            individualTile.contentMode = UIViewContentModeScaleAspectFit;
            
            individualTile.userInteractionEnabled=YES;
            if (i==(totalNumberOfTiles)){
                individualTile.tileName=@"blank";
                [_whereInGrid replaceObjectAtIndex:(i) withObject:@"blank"];
                [individualTile setTitle:@"" forState:UIControlStateNormal];
            }
            
            
            [individualTile addTarget:self action:@selector(pushed:) forControlEvents: UIControlEventTouchUpInside];
            [self.view addSubview:individualTile];
            self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            ;
        }
    }
    else {
        for (NSInteger i = 1; i < (totalNumberOfTiles+1); i++)
        {
            NSString *fileName;
            
            //Get value of tag as stored in array
            NSString *actualLocationInGrid = _whereInGrid[i];
            NSInteger valueToUse = [actualLocationInGrid intValue];
            if ([actualLocationInGrid isEqual:@"blank"])
            {
                NSLog(@"found blank \n");
                valueToUse=totalNumberOfTiles; //This is the blank tile
            }
//            NSLog(@"valuetoUse %ld, string %@",(long)valueToUse, actualLocationInGrid);
            if (valueToUse%2==0)
                fileName= @"red.png";
            else
                fileName= @"black.png";
            UIImage *toLoad;
            if (valueToUse!=(totalNumberOfTiles))
                toLoad = [UIImage imageNamed:fileName];
            else {
                toLoad = [UIImage imageNamed:@"white.png"];
            }
            
            NSInteger columns = (numberInGridWidth%valueToUse);
            
            NSInteger rows = valueToUse/numberInGridHeight;

            positionX = (xUnits*(columns))+(xUnits/2);
            positionY = (yUnits*rows)+(yUnits/2);
            
            GJLTileButton *individualTile = [GJLTileButton button];
            
            [individualTile setBackgroundImage:toLoad forState:UIControlStateNormal];
            
            individualTile.adjustsImageWhenHighlighted=YES;
            
            individualTile.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            NSString *tileUIName = actualLocationInGrid;
            [individualTile setTitle:tileUIName forState:UIControlStateNormal];
            NSValue *tempValue = [_storedLocations objectAtIndex:(valueToUse)];
            individualTile.center = [tempValue CGPointValue];
            individualTile.bounds = CGRectMake(0,0, xUnits,yUnits);
            NSLog(@"valueToUse %ld columns %ld, rows %ld, CentreX %f, Centrey %f\n",(long)valueToUse,(long)columns, (long)rows, individualTile.center.x,individualTile.center.y);
            individualTile.tag = valueToUse;
            individualTile.contentMode = UIViewContentModeScaleAspectFit;
            
            individualTile.userInteractionEnabled=YES;

            
            [individualTile addTarget:self action:@selector(pushed:) forControlEvents: UIControlEventTouchUpInside];
            [self.view addSubview:individualTile];
            self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            ;
        }
    }
    [self saveTheTiles];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
