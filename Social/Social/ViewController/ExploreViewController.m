//
//  ExploreViewController.m
//  Social
//
//  Created by feng jiang on 10/9/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import "ExploreViewController.h"
#import <MapKit/MapKit.h>
#import "LocationManager.h"
#import "PostManager.h"
#import "Post.h"
#import "PostDetailViewController.h"
#import "HomeViewController.h"


static NSString * const AnnotationIdentifier = @"post.pin";


@interface ExploreViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;

@property (strong, nonatomic) NSArray <Post *>* posts;

@property (strong, nonatomic) CLLocation *center;
@property (assign, nonatomic) CLLocationDistance radius;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self reloadPosts];
}

- (void)setupUI {
    self.title = NSLocalizedString(@"Explore", nil);
    [self.reloadButton setTitle:NSLocalizedString(@"Search This Area", nil) forState:UIControlStateNormal];
    [self.reloadButton addTarget:self action:@selector(reloadPosts) forControlEvents:UIControlEventTouchUpInside];
        [self.reloadButton setBackgroundColor:[UIColor colorWithRed:83.0 / 255.0 green:200.0 / 255.0 blue:118.0 / 255.0 alpha:1.0]];
    [self.reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.reloadButton.layer.cornerRadius = 7;
    [self setupMap];
}

- (void)setupMap {
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    CLLocationCoordinate2D coordinate = [[LocationManager sharedManager] getUserCurrentLocation].coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(3.5, 3.5);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region];
}

- (void)updateMapWithPosts {
    for (Post *post in self.posts) {
        MKPointAnnotation *anotation = [MKPointAnnotation new];
        [anotation setCoordinate:post.location.coordinate];
        [self.mapView addAnnotation:anotation];
    }
}


- (NSArray<Post *> *)postInLocation:(CLLocationCoordinate2D)coordinate {
    NSMutableArray<Post *> *posts = [NSMutableArray new];
    for (Post *post in self.posts) {
        CLLocationCoordinate2D postCoordinate = post.location.coordinate;
        if ((fabs(postCoordinate.latitude - coordinate.latitude) <= 0.005) &&
            (fabs(postCoordinate.longitude - coordinate.longitude) <= 0.005)) {
            [posts addObject:post];
        }
    }
    return posts;
}

#pragma mark - action
- (void)reloadPosts {
    // coordinate of map center
    CLLocationCoordinate2D centerCoordinate = [self.mapView centerCoordinate];
    self.center = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    
    // cooridinate of top left conner of map
    CLLocationCoordinate2D topCenterCoordinate = [self.mapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:self.mapView];
    CLLocation *topCenter = [[CLLocation alloc] initWithLatitude:topCenterCoordinate.latitude longitude:topCenterCoordinate.longitude];
    self.radius = [self.center distanceFromLocation:topCenter];
    
    [self fetchPostsWithLocation:self.center];
}

- (void)fetchPostsWithLocation:(CLLocation *)location {
    __weak typeof (self) weakSelf = self;
    
    [PostManager getPostsWithLocation:location range:self.radius andCompletion:^(NSArray<Post *> *posts, NSError *error) {
        weakSelf.posts = posts;
        NSLog(@"posts count: %ld", (long)posts.count);
        [weakSelf updateMapWithPosts];
    }];
}

- (void)showPostsInMapWithLocation:(CLLocationCoordinate2D)coordinate {
    NSArray<Post *> *posts =[self postInLocation:coordinate];
    if (posts.count == 1) {
        PostDetailViewController *detailViewController = [[PostDetailViewController alloc] initWithNibName:NSStringFromClass([PostDetailViewController class]) bundle:nil];
        [detailViewController loadDetailViewWithPost:posts.firstObject];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if (posts.count > 1) {
        HomeViewController *postsViewController = [[HomeViewController alloc] initWithNibName:NSStringFromClass([HomeViewController class]) bundle:nil];
        [postsViewController loadResultPageWithPosts:posts];
        [self.navigationController pushViewController:postsViewController animated:YES];
    }
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [mapView deselectAnnotation:view.annotation animated:YES];
    [self showPostsInMapWithLocation:view.annotation.coordinate];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = nil;
    if (annotation != mapView.userLocation) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        annotationView.image = [UIImage imageNamed:@"Annotation"];
        annotationView.canShowCallout = NO;
    }

    return annotationView;
}


@end

