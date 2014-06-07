//
//  IKJBlurrerManager.m
//  InterfaCSSStatusBarBlurryTableViewController
//
//  Created by Hermes Pique on 6/7/14.
//  Copyright (c) 2014 PodRoulette. All rights reserved.
//

#import "IKJBlurrerManager.h"
#import "IKJBlurrer.h"
#import <MPCMultipeerClient/MPCMultipeerClient.h>

static NSString *const IKJUserDefaultsKeyUser = @"IKJUser";

@implementation IKJBlurrerManager {
    NSMutableArray *_blurrers;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _blurrers = [NSMutableArray new];
    }
    return self;
}

+ (instancetype)sharedManager
{
    static IKJBlurrerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [IKJBlurrerManager new];
    });
    return instance;
}

- (void)addBlurrer:(IKJBlurrer *)blurrer
{
    IKJBlurrer *existingBlurrer = [self blurrerForPeerID:blurrer.peerID];
    if (existingBlurrer == nil) {
        [_blurrers addObject:blurrer];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updated_blurrers" object:nil];
    }
}

- (void)removeBlurrer:(IKJBlurrer *)blurrer
{
    [_blurrers removeObject:blurrer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updated_blurrers" object:nil];
}

- (NSArray*)allBlurrers
{
    return [_blurrers copy];
}

- (IKJBlurrer*)blurrerForName:(NSString*)name
{
    for (IKJBlurrer *blurrer in _blurrers)
    {
        if ([blurrer.name isEqualToString:name])
        {
            return blurrer;
        }
    }
    return nil;
}

- (IKJBlurrer *)blurrerForPeerID:(MCPeerID *)peerID
{
    for (IKJBlurrer *blurrer in _blurrers)
    {
        if ([blurrer.peerID isEqual:peerID])
        {
            return blurrer;
        }
    }
    return nil;
}


- (IKJBlurrer *)user
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *userData = [defaults objectForKey:IKJUserDefaultsKeyUser];
    if (userData)
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
    else
    {
        return nil;
    }
}

- (void)saveUser:(IKJBlurrer *)user
{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userData forKey:IKJUserDefaultsKeyUser];
    [defaults synchronize];
}

@end
