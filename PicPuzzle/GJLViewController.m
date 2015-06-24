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
        
        //To avoid division by zero...
        if (firstRandomValue==0)
            firstRandomValue=_numberOfTilesWidth*_numberOfTilesHeight;
        if (secondRandomValue==0)
            secondRandomValue=_numberOfTilesWidth*_numberOfTilesHeight;
        
        //swap around tileGridLocation names
        
        NSString *tempStringOne = _whereInGrid[firstRandomValue];
        NSString *tempStringTwo = _whereInGrid[secondRandomValue];
        
        _whereInGrid[secondRandomValue] = tempStringOne;
        _whereInGrid[firstRandomValue] = tempStringTwo;
        
    }
    _numberOfMoves=0; //reset the counter
    [self updateCounter];
    [self saveTheTiles];
    [self redrawOfTiles];
}
- (IBAction)resetTheData:(id)sender {
    
    NSInteger fullArray = _numberOfTilesWidth*_numberOfTilesHeight;
    [_whereInGrid removeAllObjects];
    _whereInGrid[0] = [NSString stringWithFormat:@"ignore"];
    
    for (NSInteger i=1;i<(fullArray+1) ;i++){
        NSString *locationName = [NSString stringWithFormat:@"%ld",(long)(i)];
        
        _whereInGrid[i]=locationName;
    }
    
    [_whereInGrid replaceObjectAtIndex:(fullArray) withObject:@"blank"];
    _numberOfMoves=0; //reset the counter
    [self updateCounter];
    [self saveTheTiles];
    [self redrawOfTiles];
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
    
    UIView *blankTile = [self.view viewWithTag:(_numberOfTilesWidth*_numberOfTilesHeight)]; //Blank is always last
    
    NSValue *tempLocationOne=[_storedLocations objectAtIndex:(indexOfBlank)];
    NSValue *tempLocationTwo=[_storedLocations objectAtIndex:(indexToMoveTo)];
    //Animate blank and button with button having a higher zPosition so always animated in front
    [UIView animateWithDuration:0.3 animations:^{
        blankTile.center=[tempLocationTwo CGPointValue];
        aButton.layer.zPosition = MAXFLOAT;
        aButton.center=[tempLocationOne CGPointValue];
    }];
    
    //move the current tile to blank location
    _whereInGrid[indexToMoveTo] = @"blank";
    _whereInGrid[indexOfBlank] = tempString;
    _numberOfMoves++;
    [self updateCounter];
    [self checkForWinningMove];
}

-(void)updateCounter
{
    UIView *numberOfMovesView = [self.view viewWithTag:(2000)];
    
    if ([numberOfMovesView isKindOfClass:[UILabel class]]) {
        CGFloat centreX = numberOfMovesView.center.x;
        CGFloat centreY = numberOfMovesView.center.y;
        [numberOfMovesView removeFromSuperview];
        NSString* newNumberOfMovesLabel = [NSString stringWithFormat:@"Number of Moves: %ld",(long)_numberOfMoves ];
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,228,21)];
        newLabel.tag=2000;
        newLabel.text = newNumberOfMovesLabel;
        newLabel.center=CGPointMake(centreX,centreY);
        [self.view addSubview:newLabel];
    }
}

- (BOOL)loadTheTiles
{
    
    [_whereInGrid removeAllObjects];
    [_whereInGrid addObject:@"ignore"]; //Puts in ignore, used to initialise array
    
    BOOL loadedFromDataFile;
    //check for existing files already
    NSString *myFile = @"whereStored.plist";
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [filePaths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:myFile];
    NSMutableArray *tempGrid = [NSMutableArray arrayWithContentsOfFile:path];
    
    if (tempGrid==nil){
        //Load of file has failed, create default data
        NSLog(@"recreating data file");
        [_allDataToBeStored removeAllObjects];
        [_allDataToBeStored addObject:@"ignore"]; //Puts in ignore
        
        for (int loop = 1;loop<9;loop++)
        {
            [_allDataToBeStored addObject:[NSString stringWithFormat:@"%d",(loop)]];
            _whereInGrid[loop]=_allDataToBeStored[loop];
        }
        
        [_whereInGrid addObject:@"blank"]; //defaults to 3x3 game
        [_allDataToBeStored addObject:@"blank"]; //defaults to 3x3 game
        
        for (int loop = 1;loop<16;loop++)
        {
            [_allDataToBeStored addObject:[NSString stringWithFormat:@"%d",(loop)]];
        }
        [_allDataToBeStored addObject:@"blank"]; //need blank
        for (int loop = 1;loop<25;loop++)
        {
            [_allDataToBeStored addObject:[NSString stringWithFormat:@"%d",(loop)]];
        }
        [_allDataToBeStored addObject:@"blank"]; //need blank
        for (int loop = 1;loop<60;loop++)
        {
            [_allDataToBeStored addObject:[NSString stringWithFormat:@"%d",(loop)]];
        }
        [_allDataToBeStored addObject:@"blank"]; //need blank
        loadedFromDataFile= FALSE; //blank data file and game set up
    }
    else {
        loadedFromDataFile=TRUE;
        NSInteger totalInTempGrid = tempGrid.count;
        for (int i=0;i<(totalInTempGrid);i++){
            _allDataToBeStored[i]=tempGrid[i];
        }
    }
    //copy from _allDataToBeStored  to  _whereInGrid
    
    NSInteger totalTiles = _numberOfTilesHeight*_numberOfTilesWidth;
    NSInteger offset = 0;
    if (totalTiles==9)
        offset=0;
    else if (totalTiles==16)
        offset=9;
    else if (totalTiles==25)
        offset=25;
    else
        offset=50;
    
    for (int i=1;i<((_numberOfTilesWidth*_numberOfTilesHeight)+1);i++){
        _whereInGrid[i]=_allDataToBeStored[i+offset];
    }
    return loadedFromDataFile;  //Game data loaded from storage if TRUE, generated if FALSE
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
        NSLog(@"Error deleting in saveTheTiles!%@", error);
        //TODO: Handle/Log error
    }
    
    //copy from _whereInGrid to _allDataToBeStored
    
    NSInteger totalTiles = _numberOfTilesHeight*_numberOfTilesWidth;
    NSInteger offset = 0;
    if (totalTiles==9)
        offset=0;
    else if (totalTiles==16)
        offset=9;
    else if (totalTiles==25)
        offset=25;
    else
        offset=50;
    
    for (int i=1;i<(totalTiles+1);i++){
        _allDataToBeStored[i+offset]=_whereInGrid[i];
    }
    
    [_allDataToBeStored writeToFile:path atomically:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpAllTheLocations];
    
}

- (void) redrawOfTiles {
    for (int t=1;t<=(_numberOfTilesWidth*_numberOfTilesHeight);t++)
    {
        NSString *actualLocationInGrid = _whereInGrid[t];
        NSInteger valueToUse = [actualLocationInGrid intValue];
        if (!valueToUse)
            valueToUse=(_numberOfTilesWidth*_numberOfTilesHeight);
        
        //Update buttons and animate to new locations
        UIView *tileOne = [self.view viewWithTag:(valueToUse)];
        NSValue *tempLocationValue=[_storedLocations objectAtIndex:(t)];
        [UIView animateWithDuration:0.3 animations:^{
            tileOne.center=[tempLocationValue CGPointValue];
        }
         ];
    }
}
- (void) viewDidDisappear:(BOOL)animated{
    [self saveTheTiles];
    
}



-(void) checkForWinningMove
{
    BOOL allInRightLocation = TRUE;
    for (int t=1;t<((_numberOfTilesWidth*_numberOfTilesHeight));t++)
    {
        NSString *locationOfTile = _whereInGrid[t];
        if ([locationOfTile intValue] !=t)
        {
            allInRightLocation = FALSE;
        }
        
    }
    NSString *nameOfBlank = @"blank";
    if ((allInRightLocation) && (_whereInGrid[(_numberOfTilesWidth*_numberOfTilesHeight)] == nameOfBlank)){
        NSString *path  = [[NSBundle mainBundle] pathForResource:@"SMALL_CROWD_APPLAUSE-Yannick_Lemieux-1268806408" ofType:@"wav"];
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        
        SystemSoundID audioEffect;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
        // Using GCD, we can use a block to dispose of the audio effect without using a NSTimer or something else to figure out when it'll be finished playing.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AudioServicesDisposeSystemSoundID(audioEffect);
        });
        
        NSString *numberOfMoves = [NSString stringWithFormat:@"You won in %ld moves", (long)_numberOfMoves];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Winner!"
                                                                       message:numberOfMoves
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        _numberOfMoves=0; //Reset as you've won the game
        [self updateCounter];
        
    }
}


-(UIImage *) getTheTileImage :(NSInteger)tileNumber :(CGFloat)xUnits  :(CGFloat) yUnits
{
    UIImage *mainImage;
    mainImage=_imageToUse;

    CGFloat pointsToPixels;
    if (mainImage.size.width>mainImage.size.height)
    {
        //Landscape
        pointsToPixels = (mainImage.size.width/self.view.frame.size.width);
    }
    else{
        //Portrait
        pointsToPixels = (mainImage.size.height/self.view.frame.size.height);
    }
 
    NSValue *tempValue = [_storedLocations objectAtIndex:(tileNumber)]; //extracts location of centre of tile
    //find corresponding location in mainImage
    CGPoint cutOrigin = [tempValue CGPointValue];
    CGPoint cutExtent = cutOrigin;
    
    cutOrigin.x=((cutOrigin.x-xUnits/2)*pointsToPixels);
    cutOrigin.y=((cutOrigin.y-yUnits/2)*pointsToPixels);

    cutExtent.x = xUnits*pointsToPixels;
    cutExtent.y = yUnits*pointsToPixels;
    
    double (^rad)(double) = ^(double deg) {
        return deg / 180.0 * M_PI;
    };
    
    CGAffineTransform rectTransform;
    switch (mainImage.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -mainImage.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -mainImage.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -mainImage.size.width, -mainImage.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    rectTransform = CGAffineTransformScale(rectTransform, mainImage.scale, mainImage.scale);
    
    //get mainImage data resized
    CGImageRef temporaryImageReference = mainImage.CGImage;
    CGImageRef cutImageReference = CGImageCreateWithImageInRect(temporaryImageReference,CGRectApplyAffineTransform (CGRectMake(cutOrigin.x, cutOrigin.y, cutExtent.x, cutExtent.y),rectTransform));
    UIImage *cutImage = [UIImage imageWithCGImage:cutImageReference scale:mainImage.scale orientation:mainImage.imageOrientation];
    CGImageRelease(cutImageReference);
    return cutImage;
}

-(void) setUpAllTheLocations
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _whereInGrid = [[NSMutableArray alloc] init];
    _storedLocations = [[NSMutableArray alloc] init];
    _allDataToBeStored = [[NSMutableArray alloc] init];
    _numberOfMoves=0;
    NSInteger numberInGridWidth = _numberOfTilesWidth;
    NSInteger numberInGridHeight = _numberOfTilesHeight;
    
    NSInteger totalNumberOfTiles = numberInGridWidth*numberInGridHeight; // number of tiles to add
    
    [_whereInGrid addObject:[NSString stringWithFormat:@"ignore"]]; //fill up the zero location in array with blank data
    
    CGSize insetSize = CGRectInset(self.view.bounds, 10, 80).size;

    //adjust insetSize if necessary for dimension of picture being used
    if (!_isPlain && _imageToUse)
    {
        //Using picture and image data has been set
        if (_imageToUse.size.width>_imageToUse.size.height)
        {
            // adjust for Landscape
            insetSize.height=insetSize.height*(insetSize.width/_imageToUse.size.width);
        }

    }
    
    CGFloat xUnits = (insetSize.width/numberInGridWidth);
    CGFloat yUnits = (insetSize.height/numberInGridHeight);
    
    CGFloat positionX = 0.0f;
    CGFloat positionY = 0.0f;
    NSInteger rowNumber=0;
    
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
    if(!loadedFileCorrectly)
        NSLog(@"Problem with loading, using generated file");
    
    if (!_isPlain){
        for (NSInteger i = 1; i < (totalNumberOfTiles+1); i++)
        {
            //Build up grid using images as selected by user
            UIImage *cutImage = [self getTheTileImage:i :xUnits :yUnits];
            
            GJLTileButton *individualTile = [GJLTileButton button];
            
            if (i==totalNumberOfTiles){
                [individualTile setAlpha:0.1];
            }
            
            [individualTile setBackgroundImage:cutImage forState:UIControlStateNormal];
            
            individualTile.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            NSString *tileUIName =[NSString stringWithFormat:@"%ld",(long)(i)];
            [individualTile setTitle:tileUIName forState:UIControlStateNormal];
            NSValue *tempValue = [_storedLocations objectAtIndex:(i)]; //extracts location of centre of tile
            CGPoint centerOffset= [tempValue CGPointValue];
            if (_imageToUse.size.width>=_imageToUse.size.height)
            {
            //Portrait
                centerOffset.y=centerOffset.y+200;
//                centerOffset.y=centerOffset.y+((self.view.frame.size.height-(yUnits*_numberOfTilesHeight))/2);
            }
            individualTile.frame = CGRectMake(0,0, xUnits,yUnits);
            individualTile.center = centerOffset;
            NSString *locationName = [NSString stringWithFormat:@"%ld",(long)(i)];
            
            individualTile.tileName=locationName;
            [_whereInGrid addObject:locationName];
            individualTile.tag = i;
            individualTile.userInteractionEnabled=YES;
            if (i==(totalNumberOfTiles)){
                individualTile.tileName=@"blank";
                [individualTile setTitle:@"" forState:UIControlStateNormal];
            }
            [individualTile addTarget:self action:@selector(pushed:) forControlEvents: UIControlEventTouchUpInside];
            [self.view addSubview:individualTile];
        }
    }
    else {
        for (NSInteger i = 1; i < (totalNumberOfTiles+1); i++)
        {
            //Build up grid using plain tiles rather than images
            NSString *fileName;
            
            //Get value of tag as stored in array
            NSString *actualLocationInGrid = _whereInGrid[i];
            NSInteger valueToUse = [actualLocationInGrid intValue];
            if ([actualLocationInGrid isEqual:@"blank"])
            {
                valueToUse=totalNumberOfTiles; //This is the blank tile
            }
            if (valueToUse%2==0)
                fileName= @"redlarge.png";
            else
                fileName= @"blacklarge.png";
            UIImage *toLoad;
            if (valueToUse!=(totalNumberOfTiles))
                toLoad = [UIImage imageNamed:fileName];
            else {
                toLoad = [UIImage imageNamed:@"white.png"];
            }
            
            GJLTileButton *individualTile = [GJLTileButton button];
            [individualTile setBackgroundImage:toLoad forState:UIControlStateNormal];
            individualTile.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            NSString *tileUIName = actualLocationInGrid;
            [individualTile setTitle:tileUIName forState:UIControlStateNormal];
            NSValue *tempValue = [_storedLocations objectAtIndex:(valueToUse)];
            individualTile.center = [tempValue CGPointValue];
            individualTile.frame = CGRectMake(0,0,xUnits,yUnits);
            individualTile.tag = valueToUse;
            individualTile.userInteractionEnabled=YES;
            
            
            [individualTile addTarget:self action:@selector(pushed:) forControlEvents: UIControlEventTouchUpInside];
            [self.view addSubview:individualTile];
        }
    }
    [self redrawOfTiles];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
