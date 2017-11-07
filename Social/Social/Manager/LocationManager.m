//
//  LocationManager.m
//  Social
//
//  Created by feng jiang on 10/9/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import "LocationManager.h"
#import <MapKit/MapKit.h>

NSString * const LocationUpdateNotification = @"LocationUpdateNotification";

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocationManager *CLManager;

@end

@implementation LocationManager

// singleton pattern
+ (instancetype)sharedManager {
    static LocationManager *locationManager = nil;
    @synchronized (self) {
        if (locationManager == nil) {
            locationManager = [LocationManager new];
            locationManager.CLManager = [CLLocationManager new];
            locationManager.CLManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            locationManager.CLManager.distanceFilter = 1000.0;
        }
    }
    return locationManager;
}

- (void)getUserPermission {
    if (([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) ||
        ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways)) {
        [self.CLManager requestWhenInUseAuthorization];
    }
}

+ (BOOL)isLocationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

- (CLLocation *)getUserCurrentLocation {
    return self.currentLocation;
}

- (void)stopLoadUserLocation {
    [self.CLManager stopUpdatingLocation];
}

- (void)startLoadUserLocation {
    self.CLManager.delegate = self;
    [self getUserPermission];
    [self.CLManager startMonitoringSignificantLocationChanges];
    [self.CLManager startUpdatingLocation];
}

- (BOOL)coordinateA:(CLLocationCoordinate2D)coordianteA isSameAsCoordinateB:(CLLocationCoordinate2D)coordinateB {
    if ((fabs(coordianteA.latitude - coordinateB.latitude) <= 0.005) &&
        (fabs(coordianteA.longitude - coordinateB.longitude) <= 0.005)) {
        return YES;
    }
    return NO;
}

- (BOOL)shouldUpdateLocationWithLastLocation:(CLLocationCoordinate2D)coordianteA andNewLocation:(CLLocationCoordinate2D)coordinateB
{
    if ((fabs(coordianteA.latitude - coordinateB.latitude) > 1) ||
        (fabs(coordianteA.longitude - coordinateB.longitude) > 1)) {
        return YES;
    }
    return NO;
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    BOOL shouldUpdateLocation = NO;
    if (!self.currentLocation && locations.lastObject) {
        shouldUpdateLocation = YES;
    }
    else if ([self shouldUpdateLocationWithLastLocation:self.currentLocation.coordinate andNewLocation:locations.lastObject.coordinate]) {
        shouldUpdateLocation = YES;
    }
    if (shouldUpdateLocation) {
        self.currentLocation = locations.lastObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdateNotification object:nil];
    }
}

@end


