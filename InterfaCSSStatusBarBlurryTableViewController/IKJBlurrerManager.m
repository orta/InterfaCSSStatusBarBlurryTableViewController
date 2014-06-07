//
//  IKJBlurrerManager.m
//  InterfaCSSStatusBarBlurryTableViewController
//
//  Created by Hermes Pique on 6/7/14.
//  Copyright (c) 2014 PodRoulette. All rights reserved.
//

#import "IKJBlurrerManager.h"
#import "IKJBlurrer.h"

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
    [_blurrers addObject:blurrer];
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

- (IKJBlurrer*)user
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *userData = [defaults objectForKey:IKJUserDefaultsKeyUser];
    IKJBlurrer *user = nil;
    if (!userData)
    {
        user = [IKJBlurrer new];
        userData = [NSKeyedArchiver archivedDataWithRootObject:user];
        [defaults setObject:userData forKey:IKJUserDefaultsKeyUser];
    }
    else
    {
        user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
    return user;
}

- (void)saveUser:(IKJBlurrer *)user
{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userData forKey:IKJUserDefaultsKeyUser];
}

@end
