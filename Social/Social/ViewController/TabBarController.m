//
//  TabBarController.m
//  Social
//
//  Created by feng jiang on 10/8/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import "TabBarController.h"
#import "HomeViewController.h"
#import "ExploreViewController.h"
typedef NS_ENUM(NSInteger, TabBarType) {
    TabBarTypeHome,
    TabBarTypeExplor
};
@interface TabBarController ()

@end

@implementation TabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBarViewController];
}

#pragma mark - private methods

- (void)setupTabBarViewController
{
    self.viewControllers = [self tabBarControllers];
    
}

- (NSArray <UIViewController *>*)tabBarControllers
{
    NSArray *viewControllers = @[[self homeNavigationViewController], [self exploreNavigationViewController]];
    return viewControllers;
}

- (UIViewController *)homeNavigationViewController
{
    HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:NSStringFromClass([HomeViewController class]) bundle:nil];
    homeViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Home", nil) image:[UIImage imageNamed:@"HomeButton"] selectedImage:[UIImage imageNamed:@"HomeButton_selected"]];
    homeViewController.tabBarItem.tag = 0;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    return navigationController;
}

- (UIViewController *)exploreNavigationViewController
{
    ExploreViewController *exploreViewController = [[ExploreViewController alloc] initWithNibName:NSStringFromClass([ExploreViewController class]) bundle:nil];
    exploreViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Explore", nil) image:[UIImage imageNamed:@"ExploreButton"] selectedImage:[UIImage imageNamed:@"ExploreButton_selected"]];
    exploreViewController.tabBarItem.tag = 1;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:exploreViewController];
    return navigationController;
}

@end
