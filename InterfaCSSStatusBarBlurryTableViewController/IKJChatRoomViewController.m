//
//  IKJChatRoomViewController.m
//  InterfaCSSStatusBarBlurryTableViewController
//
//  Created by Amine Bellakrid on 07/06/14.
//  Copyright (c) 2014 PodRoulette. All rights reserved.
//

#import "IKJChatRoomViewController.h"
#import "IKJChatRoomTableViewCell.h"
#import "IKJBlurrerManager.h"
#import "IKJBlurrer.h"
#import "IKJChatViewController.h"

@interface IKJChatRoomViewController ()

@property (nonatomic) BOOL shouldShowChat;
@property (nonatomic) BOOL isScrolling;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.shouldShowChat = YES;
    
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"updated_blurrers" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updated_blurrers" object:nil];
}

- (void)reload
{
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    if (self.shouldShowChat) {
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge < scrollView.contentSize.height) {
            self.shouldShowChat = NO;
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //[super scrollViewWillBeginDragging:scrollView];   // pull to refresh
    
    self.isScrolling = YES;
    NSLog(@"+scrollViewWillBeginDragging");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];    // pull to refresh
    
    if(!decelerate) {
        self.isScrolling = NO;
    }
    NSLog(@"%@scrollViewDidEndDragging", self.isScrolling ? @"" : @"-");
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isScrolling = NO;
    if (!self.shouldShowChat) {
        IKJChatViewController *vc = [[IKJChatViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

    NSLog(@"-scrollViewDidEndDecelerating");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IKJChatRoomTableViewCell *cell = (IKJChatRoomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSArray *images = @[@"balloons",@"tiger",@"whaou"];
    NSString *imageName = [images objectAtIndex:indexPath.row];
    [self configureBannerWithImage:[UIImage imageNamed:imageName] height:200 blurRadius:12 blurTintColor:[UIColor colorWithWhite:0 alpha:0.5] saturationFactor:1];
    [cell setSelected:YES animated:YES];
}


#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[IKJBlurrerManager sharedManager] allBlurrers] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IKJChatRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IKJChatRoomTableViewCell" forIndexPath:indexPath];

    IKJBlurrer *blurrer = [[IKJBlurrerManager sharedManager] allBlurrers][indexPath.row];
    cell.textLabel.text = blurrer.peerID.displayName;

    return cell;
}

- (UIImage*) blur:(UIImage*)theImage
{
    // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)
    // theImage = [self reOrientIfNeeded:theImage];
    
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
    
    // *************** if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}



@end
