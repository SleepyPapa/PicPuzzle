//
//  GJLSetupViewController.m
//  PicPuzzle
//
//  Created by Gregory Lavery on 12/12/2013.
//  Copyright (c) 2013 Gregory Lavery. All rights reserved.
//

#import "GJLSetupViewController.h"

@interface GJLSetupViewController ()

@end

@implementation GJLSetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GJLViewController *vc = [segue destinationViewController];
    
    if ([segue.identifier isEqualToString:@"simple"]) {
         [vc setNumberOfTilesWidth:3];
         [vc setNumberOfTilesHeight:3];
    }
    if ([segue.identifier isEqualToString:@"medium"]) {
        [vc setNumberOfTilesWidth:4];
        [vc setNumberOfTilesHeight:4];
    }
    if ([segue.identifier isEqualToString:@"hard"]) {
        [vc setNumberOfTilesWidth:5];
        [vc setNumberOfTilesHeight:6];
    }
    if ([segue.identifier isEqualToString:@"crazy"]) {
        [vc setNumberOfTilesWidth:6];
        [vc setNumberOfTilesHeight:10];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
