//
//  IKJChat.h
//  InterfaCSSStatusBarBlurryTableViewController
//
//  Created by Orta on 07/06/2014.
//  Copyright (c) 2014 PodRoulette. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IKJBlurrer.h"

@interface IKJChat : NSObject <NSCoding>

@property (nonatomic, strong) IKJBlurrer *owner;
@property (nonatomic, copy) NSString *message;

@end
