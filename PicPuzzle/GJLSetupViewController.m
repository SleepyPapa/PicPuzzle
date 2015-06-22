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
    //Any further initialization required
    }
    return self;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GJLViewController *vc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"Simple"]) {
        [vc setNumberOfTilesWidth:3];
        [vc setNumberOfTilesHeight:3];
        [vc setIsPlain:_isPlainPuzzle];
        [vc setImageToUse:_imageViewTile.image];
    }
    if ([segue.identifier isEqualToString:@"Medium"]) {
        [vc setNumberOfTilesWidth:4];
        [vc setNumberOfTilesHeight:4];
        [vc setIsPlain:_isPlainPuzzle];
        [vc setImageToUse:_imageViewTile.image];
    }
    if ([segue.identifier isEqualToString:@"Hard"]) {
        [vc setNumberOfTilesWidth:5];
        [vc setNumberOfTilesHeight:5];
        [vc setIsPlain:_isPlainPuzzle];
        [vc setImageToUse:_imageViewTile.image];
    }
    if ([segue.identifier isEqualToString:@"Crazy"]) {
        [vc setNumberOfTilesWidth:6];
        [vc setNumberOfTilesHeight:10];
        [vc setIsPlain:_isPlainPuzzle];
        [vc setImageToUse:_imageViewTile.image];
    }
}

- (IBAction)UnwindtoThisView:(UIStoryboardSegue *)segue
{
    //Placeholder for unwinding of segue, no need to do anything with it in this version
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isPlainPuzzle = TRUE;
    UIImage *standardImage;
    NSString *filename;
    filename= @"RYAN.JPG";
    standardImage = [UIImage imageNamed:filename];
    _imageViewTile.image=standardImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)toggleTypeOfPuzzle:(UISegmentedControl *)segmentedButton {
    if (segmentedButton.selectedSegmentIndex==0){
        UIView *chooseImageView = [self.view viewWithTag:(200)];
        
        if ([chooseImageView isKindOfClass:[UIButton class]]) {
            chooseImageView.hidden = YES;
            _isPlainPuzzle = TRUE;
            _imageViewTile.alpha=0.5;
        }
    }
    else
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIView *cameraButton = [self.view viewWithTag:(201)];
            
            if ([cameraButton isKindOfClass:[UIButton class]]) {
                cameraButton.hidden = YES;
            }
        }
        UIView *chooseImageView = [self.view viewWithTag:(200)];
        
        if ([chooseImageView isKindOfClass:[UIButton class]]) {
            chooseImageView.hidden = NO;
            _isPlainPuzzle = FALSE;
            _imageViewTile.alpha=1.0;
        }
    }
}


-(IBAction)removeDataFile:(id)sender{
    {
        NSString *myFile = @"whereStored.plist";
        NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory,  NSUserDomainMask, YES);
        NSString *documentsDirectory = [filePaths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:myFile];
        NSError *error;
        if(![[NSFileManager defaultManager] removeItemAtPath:path error:&error])
        {
            NSLog(@"Error deleting! %@", error );
            //TODO: Handle/Log error
        }
        UIImage *standardImage;
        NSString *filename;
        filename= @"RYAN.JPG";
        standardImage = [UIImage imageNamed:filename];
        _imageViewTile.image=standardImage;
    }
}
- (IBAction)choosePhoto:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageViewTile.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
