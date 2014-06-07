//
//  IKJNetworkBlurrers.m
//  InterfaCSSStatusBarBlurryTableViewController
//
//  Created by Orta on 07/06/2014.
//  Copyright (c) 2014 PodRoulette. All rights reserved.
//

#import "IKJNetworkBlurrers.h"
#import <MPCMultipeerClient/MPCMultipeerClient.h>

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

    [MPCMultipeerClient onEvent:@"chat" runBlock:^(MCPeerID *peerID, id object) {
        NSLog(@"CHATTED");
    }];

}

@end
