//
//  PNPosts.h
//  PushNotifications
//
//  Created by Marco Rocca on 04/05/15.
//  Copyright (c) 2015 Delite Studio S.r.l. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNObject.h"

@interface PNPosts : PNObject

// Mandatory
@property (nonatomic, readonly) NSArray *posts; // array of PNPost objects
@property (nonatomic, readonly) NSDate *timestamp;

// Optional
@property (nonatomic, readonly) NSUInteger unread;

+ (id)postsWithJson:(NSData *)json error:(NSError **)error;

@end
