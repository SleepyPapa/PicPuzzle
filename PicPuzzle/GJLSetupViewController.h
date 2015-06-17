//
//  GJLSetupViewController.h
//  PicPuzzle
//
//  Created by Gregory Lavery on 12/12/2013.
//  Copyright (c) 2013 Gregory Lavery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJLViewController.h"

@interface GJLSetupViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *removeDataFile;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleTypeOfPuzzle;
@property BOOL isPlainPuzzle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTile;
//@property (weak, nonatomic) IBOutlet UIImageView *imageViewPicture;
- (IBAction)choosePhoto:(id)sender;

@end
