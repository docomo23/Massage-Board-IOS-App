//
//  PostManager.h
//  Social
//
//  Created by feng jiang on 10/9/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Post;
@class CLLocation;

@interface PostManager : NSObject

/*
 * Create posts with message
 */
+ (void)createPostWithMessage:(NSString *)message andCompletion:(void(^)(NSError *error))completionBlock;

/*
 * load all posts within a givin location and range
 */
+ (void)getPostsWithLocation:(CLLocation *)location range:(NSInteger)range andCompletion:(void(^)(NSArray <Post *>* posts, NSError *error))completionBlock;

@end
