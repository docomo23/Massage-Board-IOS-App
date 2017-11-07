//
//  HomeTableViewCell.h
//  Social
//
//  Created by feng jiang on 10/8/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Post;

@interface HomeTableViewCell : UITableViewCell
- (void)loadCellWithPost:(Post *)post;
+ (CGFloat)cellHeight;

@end
