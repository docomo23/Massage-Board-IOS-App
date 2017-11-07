//
//  User.m
//  Social
//
//  Created by feng jiang on 10/1/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import "User.h"


static NSString * const UserName = @"UserName";
static NSString * const UserPassword = @"UserPassword";
static NSString * const DefaultUser = @"DefaultUser";
static NSString * const IsUserSignIn = @"IsUserSignIn";

@implementation User

+ (BOOL)isUserLogin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsUserSignIn];
}

+ (void)userLogInSuccess
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IsUserSignIn];
}

+ (NSString *)defaultUserName
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultUser];
    return userName;
}

+ (void)saveDefaultUserName:(NSString *)username
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:DefaultUser];
}

@end

