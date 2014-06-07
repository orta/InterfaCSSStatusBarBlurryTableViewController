//
//  IKJSettingsViewController.m
//  InterfaCSSStatusBarBlurryTableViewController
//
//  Created by Hermes Pique on 6/7/14.
//  Copyright (c) 2014 PodRoulette. All rights reserved.
//

#import "IKJSettingsViewController.h"
#import "IKJBlurrerManager.h"
#import "IKJBlurrer.h"

@interface IKJSettingsViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation IKJSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.layer.cornerRadius = 50;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)saveAction:(id)sender
{
    NSString *name = self.nameTextField.text;
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!name || name.length > 0) {
        // TODO
        return;
    }
    IKJBlurrerManager *manager = [IKJBlurrerManager sharedManager];
    IKJBlurrer *user = manager.user;
    user.name = name;
    user.image = self.imageView.image;
    
    [manager saveUser:user];
}

- (IBAction)tapImageAction:(id)sender
{
    UIImagePickerController *controller = [UIImagePickerController new];
    controller.delegate = self;
#if (TARGET_IPHONE_SIMULATOR)
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    [self presentViewController:controller animated:YES completion:^{}];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
