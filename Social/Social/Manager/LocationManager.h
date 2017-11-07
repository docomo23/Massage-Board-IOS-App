//
//  LocationManager.h
//  Social
//
//  Created by feng jiang on 10/9/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;

extern NSString * const LocationUpdateNotification;

@interface LocationManager : NSObject

+ (instancetype)sharedManager;
+ (BOOL)isLocationServicesEnabled;
- (void)startLoadUserLocation;
- (void)stopLoadUserLocation;
- (CLLocation *)getUserCurrentLocation;
- (void)getUserPermission;


@end
