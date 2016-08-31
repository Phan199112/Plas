//
//  DSRestClient.h
//  PushNotifications
//
//  Created by Marco Rocca on 04/05/15.
//  Copyright (c) 2015 Delite Studio S.r.l. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PNPosts;
@class PNPost;
@class PNCategories;
@class PNUserCategories;
@protocol DSRestClientDelegate;


@interface DSRestClient : NSObject

@property (nonatomic, weak) id<DSRestClientDelegate> delegate;
@property (nonatomic, readonly) NSString *deviceToken;
@property (nonatomic, strong) NSString *userAgent;

- (id)initWithKey:(NSString *)key andSecret:(NSString *)secret;

- (void)registerWithUrl:(NSString *)url;
- (void)registerWithUrl:(NSString *)url andToken:(NSData *)token;
- (void)unregisterWithUrl:(NSString *)url;

- (void)loadPostsWithUrl:(NSString *)url andTimestamp:(NSDate *)timestamp;
- (void)loadPostWithUrl:(NSString *)url andIdentifier:(NSUInteger)identifier;

- (void)loadCategoriesWithUrl:(NSString *)url andTimestamp:(NSDate *)timestamp;
- (void)updateCategoryWithUrl:(NSString *)url andIdentifier:(NSUInteger)identifier andExclude:(BOOL)exclude;

- (void)loadUserCategoriesWithUrl:(NSString *)url andTimestamp:(NSDate *)timestamp;
- (void)updateUserCategoryWithUrl:(NSString *)url andIdentifier:(NSUInteger)identifier;

- (void)linkWithUrl:(NSString *)url andEmail:(NSString *)email;
- (void)linkWithUrl:(NSString *)url andEmail:(NSString *)email andCustomParameters:(NSDictionary *)customParameters;
- (void)linkWithUrl:(NSString *)url andEmail:(NSString *)email andUserCategory:(NSUInteger)identifier;
- (void)linkWithUrl:(NSString *)url andEmail:(NSString *)email andUserCategory:(NSUInteger)identifier andCustomParameters:(NSDictionary *)customParameters;

- (void)cancelAllRequests;
- (NSUInteger)requestCount;

@end


@protocol DSRestClientDelegate <NSObject>

@optional

- (void)restClientRegistered:(DSRestClient *)client;
- (void)restClient:(DSRestClient *)client registerFailedWithError:(NSError *)error;

- (void)restClientUnregistered:(DSRestClient *)client;
- (void)restClient:(DSRestClient *)client unregisterFailedWithError:(NSError *)error;

- (void)restClient:(DSRestClient *)client loadedPosts:(PNPosts *)posts;
- (void)restClientPostsUnchanged:(DSRestClient *)client;
- (void)restClient:(DSRestClient *)client loadPostsFailedWithError:(NSError *)error;

- (void)restClient:(DSRestClient *)client loadedPost:(PNPost *)post;
- (void)restClientPostUnchanged:(DSRestClient *)client;
- (void)restClient:(DSRestClient *)client loadPostFailedWithError:(NSError *)error;

- (void)restClient:(DSRestClient *)client loadedCategories:(PNCategories *)categories;
- (void)restClientCategoriesUnchanged:(DSRestClient *)client;
- (void)restClient:(DSRestClient *)client loadCategoriesFailedWithError:(NSError *)error;

- (void)restClientCategoryUpdated:(DSRestClient *)client;
- (void)restClient:(DSRestClient *)client updateCategoryFailedWithError:(NSError *)error;

- (void)restClientLinked:(DSRestClient *)client withEmail:(NSString *)email andCustomParameters:(NSDictionary *)customParameters;
- (void)restClient:(DSRestClient *)client linkFailedWithError:(NSError *)error;

- (void)restClient:(DSRestClient *)client loadedUserCategories:(PNUserCategories *)categories;
- (void)restClientUserCategoriesUnchanged:(DSRestClient *)client;
- (void)restClient:(DSRestClient *)client loadUserCategoriesFailedWithError:(NSError *)error;

- (void)restClientUserCategoryUpdated:(DSRestClient *)client;
- (void)restClient:(DSRestClient *)client updateUserCategoryFailedWithError:(NSError *)error;

@end