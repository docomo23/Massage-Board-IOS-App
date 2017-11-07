//
//  HomeViewController.m
//  Social
//
//  Created by feng jiang on 10/8/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//
#import "Post.h"
#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "SignInViewController.h"
#import "User.h"
#import "CreatePostViewController.h"
#import "AFNetworking.h"
#import "LocationManager.h"
#import "PostDetailViewController.h"
#import <MapKit/MapKit.h>
#import "PostManager.h"

static NSString * const HomeCellIdentifier = @"homeCellIdentifier";
@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Post *> *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL resultMode;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.resultMode) {
        [self setupTableView];
        return;
    }
    
    // load UI
    [self setupUI];
    
    // load Data
    [self loadPosts];
    
    // update location or request location access
    [self updateLocation];
    
    // add notification observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPosts) name:LocationUpdateNotification object:nil];
    
    //require for sign in
    [self userLoginIfRequire];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- public
- (void)loadResultPageWithPosts:(NSArray <Post *>*)posts
{
    self.posts = posts;
    self.resultMode = YES;
    [self.tableView reloadData];
}

#pragma mark -- private
- (void)updateLocation {
    if (![LocationManager isLocationServicesEnabled]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Location Required", nib) message:NSLocalizedString(@"Location is required for this APP", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"OK");
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        LocationManager *locationManager = [LocationManager sharedManager];
        [locationManager startLoadUserLocation];
    }
}

- (void)updateUserLocation {
    [self loadPosts];
}

- (void)userLoginIfRequire
{

        SignInViewController *signInViewController = [[SignInViewController alloc] initWithNibName:NSStringFromClass([SignInViewController class]) bundle:nil];
        [self presentViewController:signInViewController animated:YES completion:nil];
    
}

#pragma mark -- Setup UI
- (void)setupUI {
    [self setupTableView];
    [self setupNavigationBarUI];
    [self setupRefreshControlUI];
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeTableViewCell class]) bundle:nil] forCellReuseIdentifier:HomeCellIdentifier];
}

- (void)setupNavigationBarUI {
    self.title = NSLocalizedString(@"Home", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PostEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(showCreatePostPage)];
}

- (void)setupRefreshControlUI
{
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = [UIColor blueColor];
    [self.refreshControl addTarget:self action:@selector(loadPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark -- Action
- (void)showCreatePostPage {
    CreatePostViewController *createPostViewController = [[CreatePostViewController alloc] initWithNibName:NSStringFromClass([CreatePostViewController class]) bundle:nil];
    createPostViewController.delegate = self;
    [self.navigationController pushViewController:createPostViewController animated:YES];
}

#pragma mark -- Load data
- (void)loadPosts {
    __weak typeof(self) weakSelf = self;
    CLLocation *location = [[LocationManager sharedManager] getUserCurrentLocation];
    NSInteger range = 20000;
    [PostManager getPostsWithLocation:location range:range andCompletion:^(NSArray<Post *> *posts, NSError *error) {
        NSLog(@"try to get post");
        if (posts) {
            weakSelf.posts = posts;
            [weakSelf.tableView reloadData];
            NSLog(@"get posts count:%ld", (long)posts.count);
        } else {
            NSLog(@"no posts failure");
            NSLog(@"error: %@", error);
        }
    }];
    [self.refreshControl endRefreshing];
    
}

#pragma mark - CreatePostViewControllerDelegate
- (void)didCreatePost
{
    [self loadPosts];
}

#pragma mark -- UITableView Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:HomeCellIdentifier forIndexPath:indexPath];
    [cell loadCellWithPost:self.posts[indexPath.row]];
    return cell;
}

#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [HomeTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.posts.count > indexPath.row) {
        Post *post =[self.posts objectAtIndex:indexPath.row];
        PostDetailViewController *detailViewController = [[PostDetailViewController alloc] initWithNibName:NSStringFromClass([PostDetailViewController class]) bundle:nil];
        [detailViewController loadDetailViewWithPost:post];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
