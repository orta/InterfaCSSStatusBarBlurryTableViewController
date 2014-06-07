//
//  IKJChat.m
//  InterfaCSSStatusBarBlurryTableViewController
//
//  Created by Orta on 07/06/2014.
//  Copyright (c) 2014 PodRoulette. All rights reserved.
//

#import "IKJChat.h"

@implementation IKJChat


- (void)encodeWithCoder:(NSCoder *)encoder
{
    if (self.owner)
    {
        [encoder encodeObject:self.owner forKey:@"owner"];
    }
    if (self.message)
    {
        [encoder encodeObject:self.message forKey:@"message"];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init]))
    {
        _message = [[decoder decodeObjectForKey:@"message"] copy];
        _owner = [decoder decodeObjectForKey:@"owner"];
    }
    return self;
}


@end
