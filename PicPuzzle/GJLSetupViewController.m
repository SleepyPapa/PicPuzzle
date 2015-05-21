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
    if ([segue.identifier isEqualToString:@"simple"]) {
        [segue.destinationViewController setNumberOfTiles:3];
    }
    if ([segue.identifier isEqualToString:@"medium"]) {
        [segue.destinationViewController setNumberOfTiles:4];
    }
    if ([segue.identifier isEqualToString:@"hard"]) {
        [segue.destinationViewController setNumberOfTiles:5];
    }
    if ([segue.identifier isEqualToString:@"crazy"]) {
        [segue.destinationViewController setNumberOfTiles:6];
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
