//
//  IKJNetworkBlurrers.m
//  InterfaCSSStatusBarBlurryTableViewController
//
//  Created by Orta on 07/06/2014.
//  Copyright (c) 2014 PodRoulette. All rights reserved.
//

#import "IKJNetworkBlurrers.h"
#import <MPCMultipeerClient/MPCMultipeerClient.h>

#import "IKJChat.h"
#import "IKJBlurrer.h"
#import "IKJBlurrerManager.h"

#import <KGStatusBar/KGStatusBar.h>

@implementation IKJNetworkBlurrers

+ (void)start
{
    [MPCMultipeerClient browseWithServiceType:@"blurchat"];
    [MPCMultipeerClient advertiseWithServiceType:@"blurchat"];

    [MPCMultipeerClient onConnect:^(MCPeerID *peerID) {

        NSLog(@"connected");
        IKJBlurrer *blurrer = [[IKJBlurrer alloc] init];
        blurrer.name = @"OK";


        IKJChat *chat = [[IKJChat alloc] init];
        chat.owner = blurrer;
        chat.message = @"hello";

        IKJBlurrer *me = [[IKJBlurrerManager sharedManager] user];
        me.peerID = peerID;

        [MPCMultipeerClient sendEvent:@"chat" withObject:chat];
        [MPCMultipeerClient sendEvent:@"announcement" withObject:me];
    }];


    [MPCMultipeerClient onDisconnect:^(MCPeerID *peerID) {
        IKJBlurrer *blurrer = [[IKJBlurrerManager sharedManager] blurrerForPeerID:peerID];
        [[IKJBlurrerManager sharedManager] removeBlurrer:blurrer];

        NSLog(@"%@ BYE BYE", blurrer.name);
    }];

    [MPCMultipeerClient onEvent:@"announcement" runBlock:^(MCPeerID *peerID, IKJBlurrer *blurrer) {
        NSLog(@"%@ arrived", blurrer.name);
        [[IKJBlurrerManager sharedManager] addBlurrer:blurrer];
    }];

    [MPCMultipeerClient onEvent:@"chat" runBlock:^(MCPeerID *peerID, IKJChat *chat) {
        NSString *message = [NSString stringWithFormat:@"%@ said '%@'", chat.owner.name, chat.message];
        [KGStatusBar showWithStatus:message];
    }];

}

@end
