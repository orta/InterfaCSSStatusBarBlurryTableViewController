//
//  IKJBlurrerManager.h
//  InterfaCSSStatusBarBlurryTableViewController
//
//  Created by Hermes Pique on 6/7/14.
//  Copyright (c) 2014 PodRoulette. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IKJBlurrer, MCPeerID;

@interface IKJBlurrerManager : NSObject

+ (instancetype)sharedManager;

- (void)addBlurrer:(IKJBlurrer*)blurrer;
- (void)removeBlurrer:(IKJBlurrer*)blurrer;

- (NSArray*)allBlurrers;

- (IKJBlurrer*)blurrerForName:(NSString *)name;
- (IKJBlurrer*)blurrerForPeerID:(MCPeerID *)name;

- (IKJBlurrer*)user;

- (void)saveUser:(IKJBlurrer*)blurrer;

@end
