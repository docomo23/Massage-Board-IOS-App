//
//  Post.h
//  Social
//
//  Created by feng jiang on 10/1/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;
@interface Post : NSObject
@property(nonatomic) NSString *message;
@property(nonatomic) NSString *username;
@property (nonatomic) CLLocation *location;
- (instancetype) initWithDictionary:(NSDictionary *)dict;
@end
