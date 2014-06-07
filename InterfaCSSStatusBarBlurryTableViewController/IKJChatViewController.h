//
//  IKJChatViewController.h
//  InterfaCSSStatusBarBlurryTableViewController
//
//  Created by Amine Bellakrid on 07/06/14.
//  Copyright (c) 2014 PodRoulette. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessages.h>

@class JSQDemoViewController;


@protocol JSQDemoViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(JSQDemoViewController *)vc;

@end


@interface IKJChatViewController : JSQMessagesViewController

@property (weak, nonatomic) id<JSQDemoViewControllerDelegate> delegateModal;

@property (strong, nonatomic) NSMutableArray *messages;
@property (copy, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) UIImageView *outgoingBubbleImageView;
@property (strong, nonatomic) UIImageView *incomingBubbleImageView;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;

- (void)setupTestModel;

@end
