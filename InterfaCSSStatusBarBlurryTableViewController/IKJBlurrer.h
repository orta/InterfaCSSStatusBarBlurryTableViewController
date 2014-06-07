//
//  IKJBlurrer.h
//  InterfaCSSStatusBarBlurryTableViewController
//
//  Created by Hermes Pique on 6/7/14.
//  Copyright (c) 2014 PodRoulette. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MPCMultipeerClient/MPCMultipeerClient.h>

@interface IKJBlurrer : NSObject<NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *colorName;
@property (nonatomic, readonly) UIColor *color;
@property (nonatomic, assign) BOOL unblurred;
@property (nonatomic, strong) MCPeerID *peerID;

@end