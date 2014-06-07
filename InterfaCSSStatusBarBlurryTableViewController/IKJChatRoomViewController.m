//
//  IKJChatRoomViewController.m
//  InterfaCSSStatusBarBlurryTableViewController
//
//  Created by Amine Bellakrid on 07/06/14.
//  Copyright (c) 2014 PodRoulette. All rights reserved.
//

#import "IKJChatRoomViewController.h"

@interface IKJChatRoomViewController ()

@end

@implementation IKJChatRoomViewController

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
    
    [self configureBannerWithImage:[UIImage imageNamed:@"tiger"] height:200 blurRadius:12 blurTintColor:[UIColor colorWithWhite:0 alpha:0.5] saturationFactor:1];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
