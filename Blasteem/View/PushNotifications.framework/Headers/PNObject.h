//
//  PNObject.h
//  PushNotifications
//
//  Created by Marco Rocca on 04/05/15.
//  Copyright (c) 2015 Delite Studio S.r.l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNObject : NSObject

@property (nonatomic, readonly) NSDictionary *values;

+ (id)objectWithWithValues:(NSDictionary *)values error:(NSError **)error;
- (id)initWithValues:(NSDictionary *)values;
+ (NSDictionary *)mandatoryTypes;
+ (NSDictionary *)optionalTypes;
+ (BOOL)testObject:(NSObject *)object withType:(Class)class error:(NSError **)error;

@end
