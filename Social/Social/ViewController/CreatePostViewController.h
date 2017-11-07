//
//  CreatePostViewController.h
//  Social
//
//  Created by feng jiang on 10/9/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreatePostViewControllerDelegate <NSObject>

- (void)didCreatePost;

@end
@interface CreatePostViewController : UIViewController

@property (nonatomic, weak) id<CreatePostViewControllerDelegate> delegate;

@end

