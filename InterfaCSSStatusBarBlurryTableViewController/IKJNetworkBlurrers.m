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

@implementation IKJNetworkBlurrers

+ (void)start
{
    [MPCMultipeerClient advertiseWithServiceType:@"blurchat"];

    [MPCMultipeerClient onDisconnect:^(MCPeerID *peerID) {
        IKJBlurrer *blurrer = [[IKJBlurrerManager sharedManager] blurrerForPeerID:peerID];
        NSLog(@"%@ BYE BYE", blurrer.name);

    }];

    [MPCMultipeerClient onEvent:@"announcement" runBlock:^(MCPeerID *peerID, IKJBlurrer *blurrer) {
        NSLog(@"%@ arrived", blurrer.name);
    }];


    [MPCMultipeerClient onEvent:@"chat" runBlock:^(MCPeerID *peerID, IKJChat *chat) {
        NSLog(@"%@ said '%@'", chat.owner.name, chat.message);
    }];

    [MPCMultipeerClient onEvent:@"chat" runBlock:^(MCPeerID *peerID, IKJChat *chat) {
        NSLog(@"%@ said '%@'", chat.owner.name, chat.message);
    }];


    [MPCMultipeerClient browseWithServiceType:@"blurchat"];


    IKJBlurrer *blurrer = [[IKJBlurrer alloc] init];
    blurrer.name = @"OK";

    IKJChat *chat = [[IKJChat alloc] init];
    chat.owner = blurrer;
    chat.message = @"OK";

    IKJBlurrer *me = [[IKJBlurrerManager sharedManager] user];

    [MPCMultipeerClient sendEvent:@"chat" withObject:chat];
    [MPCMultipeerClient sendEvent:@"announcement" withObject:me];

}

@end
