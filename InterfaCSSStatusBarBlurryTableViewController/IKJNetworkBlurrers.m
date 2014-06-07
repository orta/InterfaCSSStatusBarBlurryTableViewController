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

@implementation IKJNetworkBlurrers

+ (void)start
{
    [MPCMultipeerClient advertiseWithServiceType:@"blurchat"];
    [MPCMultipeerClient onConnect:^(MCPeerID *peerID) {
        NSLog(@"HI");
    }];
    [MPCMultipeerClient onDisconnect:^(MCPeerID *peerID) {
        NSLog(@"BYE");
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

    [MPCMultipeerClient sendEvent:@"chat" withObject:chat];

}

@end
