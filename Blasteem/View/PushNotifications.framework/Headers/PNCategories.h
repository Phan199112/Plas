//
//  PNCategories.h
//  PushNotifications
//
//  Created by Marco Rocca on 04/05/15.
//  Copyright (c) 2015 Delite Studio S.r.l. All rights reserved.
//

#import "PNObject.h"

@interface PNCategories : PNObject

// Mandatory
@property (nonatomic, readonly) NSArray *categories; // array of PNCategory objects
@property (nonatomic, readonly) NSDate *timestamp;

+ (id)categoriesWithJson:(NSData *)json error:(NSError **)error;

@end
