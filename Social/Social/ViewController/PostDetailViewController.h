//
//  PostDetailViewController.h
//  Social
//
//  Created by feng jiang on 10/10/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Post;
@interface PostDetailViewController : UIViewController
- (void)loadDetailViewWithPost:(Post *)post;
@end
