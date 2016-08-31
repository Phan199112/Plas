//
//  PNCategory.h
//  PushNotifications
//
//  Created by Marco Rocca on 04/05/15.
//  Copyright (c) 2015 Delite Studio S.r.l. All rights reserved.
//

#import "PNObject.h"

@interface PNCategory : PNObject

// Mandatory
@property (nonatomic, readonly) NSUInteger identifier;
@property (nonatomic, readonly) NSString *name;

// Optional
@property (nonatomic, readonly) NSUInteger parent;
@property (nonatomic, readonly) NSString *desc;
@property (nonatomic, readonly) BOOL exclude;

+ (id)categoryWithValues:(NSDictionary *)values error:(NSError **)error;

@end
