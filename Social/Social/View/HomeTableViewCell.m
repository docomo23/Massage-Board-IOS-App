//
//  HomeTableViewCell.m
//  Social
//
//  Created by feng jiang on 10/8/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "Post.h"

@interface HomeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) Post *post;

@end

@implementation HomeTableViewCell


- (void)loadCellWithPost:(Post *)post {
    self.post = post;
    self.titleLabel.text = post.username;
    self.messageLabel.text = post.message;
}

+ (CGFloat)cellHeight {
    return 80.0;
}

@end
