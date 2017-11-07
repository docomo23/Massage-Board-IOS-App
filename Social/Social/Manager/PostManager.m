//
//  PostManager.m
//  Social
//
//  Created by feng jiang on 10/9/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//



#import "PostManager.h"
#import "Post.h"
#import "AFNetworking.h"
#import "User.h"
#import "LocationManager.h"
#import <MapKit/MapKit.h>

static NSString * const BaseURLString = @"http://127.0.0.1:8080/iOSServer";

@implementation PostManager

+ (void)createPostWithMessage:(NSString *)message andCompletion:(void(^)(NSError *error))completionBlock
{
    // POST url
    NSString *urlString = [BaseURLString stringByAppendingString:@"/post"];
    
    // create sesstion manager
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    // create POST body dictionary
    NSString *userName = [User defaultUserName];
    CLLocation *currentLocation = [[LocationManager sharedManager] getUserCurrentLocation];
    NSDictionary *body = @{@"user" : userName,
                           @"message" : message,
                           @"lat" : @(currentLocation.coordinate.latitude),
                           @"lon" : @(currentLocation.coordinate.longitude)
                                           };
    // generate JSON string from NSDictioanry
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // create and config URL request
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // API call with completion block
    [[sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionBlock) {
            completionBlock(error);
        }
    }] resume];
}

+ (void)getPostsWithLocation:(CLLocation *)location range:(NSInteger)range andCompletion:(void(^)(NSArray <Post *>* posts, NSError *error))completionBlock {
    // ignore edge case
    if ((location.coordinate.latitude <= 0.001) &&
        (location.coordinate.longitude <= 0.001)) {
        return;
    }
    // API call with completion success and failure block
    NSURL * const BaseURLString = [NSURL URLWithString:@"http://127.0.0.1:8080/iOSServer"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:BaseURLString];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *param =
  @{@"lat": @(location.coordinate.latitude),
     @"lon": @(location.coordinate.longitude),
       @"range":  @(fabs(range/1000.0)) };
    [manager GET:@"search" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *result = [NSMutableArray new];
        if (completionBlock && [responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in responseObject) {
                Post *post = [[Post alloc] initWithDictionary:dict];
                if (post.message) {
                    [result addObject:post];
                }
            }
            completionBlock(result.copy, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
}

@end

