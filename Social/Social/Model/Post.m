//
//  Post.m
//  Social
//
//  Created by feng jiang on 10/1/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import "Post.h"
#import <MapKit/MapKit.h>

@implementation Post

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.username = dict[@"user"];
        self.message = dict[@"message"];
        CLLocationDegrees latitute = [dict[@"lat"] doubleValue];
        CLLocationDegrees longtitude = [dict[@"lon"] doubleValue];
        self.location = [[CLLocation alloc] initWithLatitude:latitute longitude:longtitude];
        return self;
    }
    return nil;
}
@end
