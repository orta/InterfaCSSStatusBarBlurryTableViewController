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
#import <InterfaCSS/UIView+InterfaCSS.h>

@interface IKJSettingsViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

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
    self.imageView.styleClassISS = @"circle";
    
    IKJBlurrerManager *manager = [IKJBlurrerManager sharedManager];
    IKJBlurrer *user = manager.user;
    self.nameTextField.text = user.name;
    self.imageView.image = user.image;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveUser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)saveAction:(id)sender
{
    [self saveUser];
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

- (IBAction)startAction:(id)sender {
    if ([self saveUser])
    {
        [self performSegueWithIdentifier:@"start" sender:self];
    }
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

- (BOOL)saveUser
{
    NSString *name = self.nameTextField.text;
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!name || name.length == 0) {
        // TODO
        return NO;
    }
    IKJBlurrerManager *manager = [IKJBlurrerManager sharedManager];
    IKJBlurrer *user = manager.user;
    user.name = name;
    user.image = self.imageView.image;
    
    [manager saveUser:user];
    return YES;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.contentView.styleClassISS = @"green";
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
