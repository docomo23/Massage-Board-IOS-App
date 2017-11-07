//
//  User.h
//  Social
//
//  Created by feng jiang on 10/1/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;

+ (BOOL)isUserLogin;
+ (void)userLogInSuccess;
+ (NSString *)defaultUserName;
+ (void)saveDefaultUserName:(NSString *)username;
@end
