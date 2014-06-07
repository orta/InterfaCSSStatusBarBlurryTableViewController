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
#import <InterfaCSS/InterfaCSS.h>
#import <ColorUtils/ColorUtils.h>

static NSArray *Colors = nil;

@interface IKJSettingsViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation IKJSettingsViewController {
    NSIndexPath *_selectedIndexPath;
}

+ (void)initialize
{
    Colors = @[@"green", @"red", @"blue", @"orange"];
}

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
    self.view.styleClassISS = @"profile";
    self.imageView.styleClassISS = @"circle";
    
    IKJBlurrerManager *manager = [IKJBlurrerManager sharedManager];
    IKJBlurrer *user = manager.user;
    self.nameTextField.text = user.name;
    self.imageView.image = user.image;
    if (user.colorName)
    {
        [self.collectionView reloadData];
        NSString *normalizedColorName = user.colorName.lowercaseString;
        [Colors enumerateObjectsUsingBlock:^(NSString *colorName, NSUInteger idx, BOOL *stop) {
            NSString *colorValue = [[InterfaCSS interfaCSS] valueOfStyleSheetVariableWithName:colorName];
            if ([colorValue.lowercaseString isEqualToString:normalizedColorName])
            {
                _selectedIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                *stop = YES;
            }
        }];
    }
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
    
    if (_selectedIndexPath)
    {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_selectedIndexPath];
        user.colorName = [cell.contentView.backgroundColor stringValue];
    }
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
    [cell.contentView addStyleClassISS:@"selectableColor"];
    NSString *colorName = Colors[indexPath.row];
    [cell.contentView addStyleClassISS:colorName];
    if (_selectedIndexPath && [_selectedIndexPath compare:indexPath] == NSOrderedSame)
    {
        [cell.contentView addStyleClassISS:@"selectedColor" animated:YES];
    }
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    for (UICollectionViewCell *cell in collectionView.visibleCells)
    {
        [cell.contentView removeStyleClassISS:@"selectedColor" animated:YES];
        cell.contentView.layer.borderWidth = 0;
    }
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell.contentView addStyleClassISS:@"selectedColor" animated:YES];
    
    NSString *colorName = Colors[indexPath.row];
    NSString *colorValue = [[InterfaCSS interfaCSS] valueOfStyleSheetVariableWithName:colorName];
 
    UIColor *color = [UIColor colorWithString:colorValue];
    self.view.window.tintColor = color;
}

@end
