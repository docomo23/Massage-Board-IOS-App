//
//  PostDetailViewController.m
//  Social
//
//  Created by feng jiang on 10/10/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import "PostDetailViewController.h"
#import "Post.h"
@interface PostDetailViewController ()
@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UITextView *postView;
@property (weak, nonatomic) IBOutlet UITextView *nameView;



@property (strong, nonatomic) Post *post;
@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];

    if (self.postView) {
        self.postView.text = [[[self.post.username
         stringByAppendingString: @"\n"]
            stringByAppendingString: @"\n"]
               stringByAppendingString:self.post.message];
    }
}

- (void)setupUI {
    self.title = NSLocalizedString(@"Detail", nil);
}

- (void)viewDidLayoutSubviews {
    [self.postView setContentOffset:CGPointZero animated:NO];

}

- (void)loadDetailViewWithPost:(Post *)post {
    self.post = post;
}

@end
