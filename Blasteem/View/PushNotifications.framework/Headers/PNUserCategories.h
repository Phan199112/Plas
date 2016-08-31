//
//  PNUserCategories.h
//  PushNotifications
//
//  Created by Marco Rocca on 24/08/15.
//  Copyright (c) 2015 Delite Studio S.r.l. All rights reserved.
//

#import "PNObject.h"

@interface PNUserCategories : PNObject

// Mandatory
@property (nonatomic, readonly) NSArray *categories; // array of PNUserCategory objects
@property (nonatomic, readonly) NSDate *timestamp;

+ (id)categoriesWithJson:(NSData *)json error:(NSError **)error;

@end
