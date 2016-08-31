//
//  PNPost.h
//  PushNotifications
//
//  Created by Marco Rocca on 04/05/15.
//  Copyright (c) 2015 Delite Studio S.r.l. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNObject.h"


@interface PNPost : PNObject

// Mandatory
@property (nonatomic, readonly) NSUInteger identifier;
@property (nonatomic, readonly) NSString *title;

// Optional
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) NSString *thumbnail;
@property (nonatomic, readonly) NSString *image;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) NSString *author;
@property (nonatomic, readonly) NSArray *categories; // array of PNCategory objects
@property (nonatomic, assign) BOOL read;

+ (id)postWithWithValues:(NSDictionary *)values error:(NSError **)error;
+ (id)postWithJson:(NSData *)json error:(NSError **)error;

@end
