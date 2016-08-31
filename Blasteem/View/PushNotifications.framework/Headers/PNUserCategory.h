//
//  PNUserCategory.h
//  PushNotifications
//
//  Created by Marco Rocca on 24/08/15.
//  Copyright (c) 2015 Delite Studio S.r.l. All rights reserved.
//

#import "PNObject.h"

@interface PNUserCategory : PNObject

// Mandatory
@property (nonatomic, readonly) NSUInteger identifier;
@property (nonatomic, readonly) NSString *name;

// Optional
@property (nonatomic, readonly) NSString *desc;

+ (id)categoryWithValues:(NSDictionary *)values error:(NSError **)error;

@end
