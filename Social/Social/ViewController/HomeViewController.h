//
//  HomeViewController.h
//  Social
//
//  Created by feng jiang on 10/8/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
@class Post;
@interface HomeViewController : UIViewController 
- (void)loadResultPageWithPosts:(NSArray <Post *>*)posts;
@end
