//
//  SignInViewController.m
//  Social
//
//  Created by feng jiang on 10/10/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//
#import "SignInViewController.h"
#import "User.h"


@interface SignInViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)userLogin
{
    User *user = [User new];
    user.userName = self.nameField.text;
    user.password = self.passwordField.text;
    // TODO move user data to server
    [User userLogInSuccess];
    [User saveDefaultUserName:user.userName];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UI

- (void)setupUI
{
    self.title = NSLocalizedString(@"Sign in", nil);
    [self.signInButton addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    self.signInButton.layer.contentsScale = 5;
    [self.signInButton setTitle:NSLocalizedString(@"Sign in", nil) forState:UIControlStateNormal];
    self.signInButton.backgroundColor = [UIColor colorWithRed:83.0 / 255.0 green:200.0 / 255.0 blue:118.0 / 255.0 alpha:1.0];
    [self.signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nameField.delegate = self;
    self.passwordField.delegate = self;
}

@end

