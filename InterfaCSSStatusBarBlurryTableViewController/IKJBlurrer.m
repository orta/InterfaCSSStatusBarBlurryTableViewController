//
//  IKJBlurrer.m
//  InterfaCSSStatusBarBlurryTableViewController
//
//  Created by Hermes Pique on 6/7/14.
//  Copyright (c) 2014 PodRoulette. All rights reserved.
//

#import "IKJBlurrer.h"
#import <ColorUtils/ColorUtils.h>

@implementation IKJBlurrer

- (UIColor*)color
{
    return [UIColor colorWithString:self.name];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    if (self.name)
    {
        [encoder encodeObject:self.name forKey:@"name"];
    }
    if (self.colorName)
    {
        [encoder encodeObject:self.colorName forKey:@"colorName"];
    }
    if (self.image)
    {
        NSData *imageData = UIImagePNGRepresentation(self.image);
        [encoder encodeObject:imageData forKey:@"imageData"];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init]))
    {
        _name = [[decoder decodeObjectForKey:@"name"] copy];
        _colorName = [decoder decodeObjectForKey:@"colorName"];
        NSData *imageData = [decoder decodeObjectForKey:@"imageData"];
        if (imageData)
        {
            UIImage *image = [UIImage imageWithData:imageData];
            self.image = image;
        }
    }
    return self;
}

@end
